express = require 'express'
require 'express-prettylogger'
dotPrefix = require './dot-prefix'
path = require 'path'
url = require 'url'
fs = require 'fs'
glob = require 'glob'
mime = require 'mime'

serve = (port, options) ->
  port ?= process.env.PORT || options.port

  console.info "Haw starting a server on port #{port}." unless options.quiet
  server = express()
  server.use express.logger 'pretty' unless options.quiet

  for local, mount of options.mount
    console.info "Will mount #{dotPrefix local} at \"#{mount}\" " unless options.quiet

  for requested, provided of options.generate
    console.info "Will generate #{requested} from \"#{dotPrefix provided}\"" unless options.quiet

  server.get '*', (req, res, next) =>
    console.log "Request made for #{req.url}" if options.verbose

    reqUrl = (url.parse req.url).pathname

    if reqUrl of options.generate
      console.log "#{reqUrl} to be generated from \"#{options.generate[reqUrl]}\"" if options.verbose
      source = (glob.sync path.resolve options.root, options.generate[reqUrl])[0]
      if source
        localFile = path.resolve options.root, source
      else
        console.log "No matches for #{options.generate[reqUrl]}" if options.verbose

    unless localFile?
      for local, mount of options.mount when reqUrl[...mount.length] is mount
        possibleLocalFile = path.resolve options.root, local, ".#{path.sep}#{reqUrl}"
        if fs.existsSync possibleLocalFile
          console.log "Found #{possibleLocalFile}" if options.verbose
          localFile = possibleLocalFile

    if localFile? and (fs.statSync localFile).isDirectory()
      console.log "Checking for index (#{options.directoryIndex}) in directory #{localFile}" if options.verbose
      localFile = (glob.sync path.resolve localFile, options.directoryIndex)[0] || null
      if options.verbose
        if localFile?
          console.log "Found #{localFile}"
        else
          console.log 'No index found'

    if localFile?
      requestExt = path.extname reqUrl
      localExt = path.extname localFile

      unless requestExt is localExt
        console.log "Request (#{requestExt}) and local (#{localExt}) extensions don't match" if options.verbose
        compile = options.compile[localExt]?[requestExt]

      if compile?
        console.log "Compiling #{localFile} (#{localExt}->#{requestExt})}" if options.verbose

        compile localFile, options, (error, content) ->
          if error?
            console.error "#{error}"
            res.send 500, error
          else
            res.contentType mime.lookup reqUrl
            res.send content

      else
        fs.readFile localFile, (error, content) =>
          if error?
            res.send 500, error
          else
            res.contentType mime.lookup localFile
            res.send content

    else
      console.log "No suitable file found for #{reqUrl}" if options.verbose
      res.send 404

  server.listen port
  server

module.exports = serve
