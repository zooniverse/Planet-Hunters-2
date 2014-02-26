AWS = require 'aws-sdk'
path = require 'path'
fs = require 'fs'
colors = require 'colors'
wrench = require 'wrench'
async = require 'async'
crypto = require 'crypto'
mime = require 'mime'
zlib = require 'zlib'

class Publisher
  local: ''
  bucket: ''
  prefix: ''
  options: null # key, secret, quiet, verbose, remove, ignore, dry-run

  dontCache: [/\.html$/]
  gzip: [/\.html$/, /\.css$/, /\.js$/, /\.csv$/]

  delay: 3000

  s3: null
  toAdd: null
  toUpdate: null
  toSkip: null
  toRemove: null
  progress: 0
  total: 0

  constructor: (params = {}) ->
    @[property] = value for property, value of params

    if 'key' of @options and 'secret' of @options
      @detail "Using key #{@options.key} and secret #{@options.secret}"

      AWS.config.update
        accessKeyId: @options.key
        secretAccessKey: @options.secret

    @s3 = new AWS.S3

  log: (args...) ->
    if typeof args[args.length - 1] is 'boolean'
      suppressLineBreak = args.pop()

    args.push '\n' unless suppressLineBreak

    process.stdout.write args.join(' ') unless @options.quiet

  detail: ->
    @log '>', arguments... if @options.verbose

  publish: ->
    @log """
      Local: .#{path.sep}#{path.relative process.cwd(), @local}
      Bucket: #{@bucket}
      Prefix: #{@prefix || '(root)'}
    """

    fs.stat @local, (error, data) =>
      throw error if error?

      if data.isDirectory()
        @publishDir()
      else
        throw 'TODO: Publish individual files'

  publishDir: ->
    async.parallel [
      => @getLocalFiles arguments...
      => @getRemoteFiles arguments...
    ], (error, [localFiles, remoteFiles]) =>
      throw error if error?
      @detail 'Got local and remote files'
      @separateFiles localFiles, remoteFiles, (error, toAdd, toUpdate, toSkip, toRemove) =>
        throw error if error?
        @detail 'Separated files'
        @printThePlan toAdd, toUpdate, toSkip, toRemove, (error) =>
          throw error if error?
          @detail 'Printed the plan'
          @progress = 0
          @total = toAdd.length + toUpdate.length + toRemove.length
          async.series [
            => async.each toAdd, ((file, fileCallback) => @add file, localFiles[file], fileCallback), arguments...
            => async.each toUpdate, ((file, fileCallback) => @update file, localFiles[file], fileCallback), arguments...
            => async.each toRemove, ((file, fileCallback) => @remove file, fileCallback), arguments...
          ], (error) =>
            throw error if error?
            @detail 'Added, updated, and removed appropriate files'
            @finishUp arguments...

  getLocalFiles: (callback) ->
    @detail 'Getting local files'
    @localFiles = {}

    wrench.readdirRecursive @local, (error, currentFiles) =>
      throw error if error?

      if currentFiles?
        @detail 'Reading local files...'
        @localFiles[file] = null for file in currentFiles
      else
        @detail '...read local files'
        callback null, @localFiles

  getRemoteFiles: (callback) ->
    @detail 'Getting remote files'
    @remoteFiles = {}

    @s3.listObjects
      Bucket: @bucket
      Prefix: @prefix
      (error, {Contents, IsTruncated}) =>
        throw error if error?
        @detail 'Got remote files'

        for object in Contents
          @remoteFiles[object.Key[(@prefix.length || -1) + 1...]] = hash: object.ETag[1...-1]

        if IsTruncated
          @log colors.yellow 'Warning: Remote file list truncated'

        callback null, @remoteFiles

  separateFiles: (localFiles, remoteFiles, callback) ->
    @detail 'Separating files'
    toAdd = []
    toUpdate = []
    toSkip = []
    toRemove = []

    async.parallel [
      (localCallback) =>
        async.each (localFile for localFile of localFiles),
          (localFile, localFileCallback) =>
            return localFileCallback() if localFile.match (@options.ignore || null)

            fullLocalPath = path.resolve @local, localFile

            fs.stat fullLocalPath, (error, data) =>
              if data.isDirectory()
                # S3 returns directories with a trailing slash.
                delete localFiles[localFile]
                localFiles[localFile + path.sep] = null
                return localFileCallback()
              else
                @getFile fullLocalPath, (error, fileData) =>
                  return localFileCallback error if error?
                  localFiles[localFile] = fileData

                  if localFile of remoteFiles
                    if fileData.hash is remoteFiles[localFile].hash
                      toSkip.push localFile
                    else
                      toUpdate.push localFile
                    localFileCallback null, localFile
                  else
                    toAdd.push localFile
                    localFileCallback null, localFile

          => localCallback arguments...

      (remoteCallback) =>
        async.each (remoteFile for remoteFile of remoteFiles),
          (remoteFile, remoteFileCallback) =>
            return remoteFileCallback() unless @options.remove

            return remoteFileCallback() if remoteFile is '' # Skip root prefix directory
            return remoteFileCallback() if remoteFile.match (@options.ignore || null)
            return remoteFileCallback() if remoteFile of localFiles

            toRemove.push remoteFile
            remoteFileCallback null, remoteFile

          => remoteCallback arguments...
    ], (error) =>
      callback error, toAdd, toUpdate, toSkip, toRemove

  getFile: (file, callback) ->
    gzip = (true for expression in @gzip when file.match expression).length > 0
    mimeType = mime.lookup file

    fs.readFile file, (error, content) =>
      return callback error if error?

      if gzip
        zlib.gzip content, (error, content) ->
          return callback error if error?

          hash = crypto.createHash('md5').update(content).digest 'hex'
          callback null, {hash, content, mimeType, gzip}

      else
        hash = crypto.createHash('md5').update(content).digest 'hex'
        callback null, {hash, content, mimeType, gzip}

  printThePlan: (toAdd, toUpdate, toSkip, toRemove, callback) ->
    thePlan = []
    thePlan.push "adding #{toAdd.length}" unless toAdd.length is 0
    thePlan.push "updating #{toUpdate.length}" unless toUpdate.length is 0
    thePlan.push "skipping #{toSkip.length}" unless toSkip.length is 0
    thePlan.push "removing #{toRemove.length}" unless toRemove.length is 0
    thePlan = thePlan.join ', '
    thePlan = thePlan.charAt(0).toUpperCase() + thePlan[1...]

    @log thePlan, true
    setTimeout (=> @log '.', true), (@delay / 4) * 1
    setTimeout (=> @log '.', true), (@delay / 4) * 2
    setTimeout (=> @log '.', false), (@delay / 4) * 3

    setTimeout (=> callback null, toAdd, toUpdate, toSkip, toRemove), @delay

  add: (file, fileInfo, callback) =>
    @progress += 1
    @log "(#{@progress}/#{@total}) #{colors.green '+'} #{file}"
    @upload arguments...

  update: (file, fileInfo, callback) =>
    @progress += 1
    @log "(#{@progress}/#{@total}) #{colors.yellow 'Δ'} #{file}"
    @upload arguments...

  upload: (file, fileInfo, callback) ->
    shouldntCache = (true for expression in @dontCache when expression.test file).length > 0

    if @options['dry-run']
      callback()
    else
      @s3.putObject
        Bucket: @bucket
        Key: path.join @prefix, file
        Body: fileInfo.content
        ContentLength: fileInfo.content.length
        ContentType: fileInfo.mimeType
        ContentEncoding: if fileInfo.gzip then 'gzip' else ''
        CacheControl: if shouldntCache then 'no-cache, must-revalidate' else ''
        ACL: 'public-read'
        callback

  remove: (file, callback) =>
    @progress += 1
    @log "(#{@progress}/#{@total}) #{colors.red '×'} #{file}"

    if @options['dry-run']
      callback()
    else
      @s3.deleteObject
        Bucket: @bucket
        Key: path.join @prefix, file
        callback

  finishUp: =>
    @detail 'Finishing up'
    @log colors.green 'Finished.'
    @log 'This was a dry run. No changes have been made remotely.' if @options['dry-run']

module.exports = Publisher
