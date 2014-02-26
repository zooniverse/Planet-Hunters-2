path = require 'path'
fs = require 'fs'
dotPrefix = require './dot-prefix'
wrench = require 'wrench'
glob = require 'glob'

removeOldBuildDirectory = (buildPath, options, callback) ->
  console.info "Deleting existing build directory #{dotPrefix buildPath}" unless options.quiet
  wrench.rmdirRecursive buildPath, (error) ->
    callback error, buildPath

makeBuildDirectory = (buildPath, options, callback) ->
  buildPath = path.resolve buildPath
  console.log "Will create build directory #{buildPath}" if options.verbose

  fs.exists buildPath, (exists) ->
    if exists
      console.log "#{buildPath} already exists" if options.verbose
      if options.force
        fs.stat buildPath, (error, stat) ->
          if error?
            callback error
          else if stat.isDirectory()
            removeOldBuildDirectory buildPath, options, (error, buildPath) ->
              if error?
                callback error
              else
                makeBuildDirectory buildPath, options, callback
          else
            callback "#{dotPrefix buildPath} should be a directory!"
      else
        callback "#{dotPrefix buildPath} already exists! Use --force to remove it."
    else
      console.info "Creating build directory #{dotPrefix buildPath}" unless options.quiet
      wrench.mkdirSyncRecursive buildPath
      callback null, buildPath

copyMounts = (root, build, toMount, options, callback) ->
  todo = 0
  mounted = []

  for source, destination of toMount then do (source, destination) ->
    source = path.resolve root, source
    destination = path.resolve build, "./#{destination}"
    console.log "Will copy mounted directory #{source} to #{destination}" if options.verbose

    fs.exists source, (exists) ->
      if exists
        todo += 1
        console.info "Copying #{dotPrefix source} to #{dotPrefix destination}" unless options.quiet

        wrench.copyDirRecursive source, destination, (error) ->
          if error?
            callback error
          else
            mounted.push destination

            todo -= 1
            console.log "#{todo} more to go..." if options.verbose
            if todo is 0
              callback null, mounted

generateFiles = (root, build, toGenerate, options, callback) ->
  todo = 0
  generated = []

  for generatedFile, sourceFile of toGenerate then do (generatedFile, sourceFile) ->
    generatedFile = path.resolve build, ".#{path.sep}#{generatedFile}"
    sourcePattern = path.resolve root, ".#{path.sep}#{sourceFile}"
    sourceFile = (glob.sync sourcePattern)[0]

    console.log "Will generate #{generatedFile} from #{sourceFile}" if options.verbose
    fs.exists sourceFile, (exists) ->
      if exists
        todo += 1
        console.info "Generating #{dotPrefix generatedFile} from #{dotPrefix sourceFile}" unless options.quiet

        sourceFileExt = path.extname sourceFile
        genFileExt = path.extname generatedFile

        compile = options.compile[sourceFileExt][genFileExt]

        if genFileExt is sourceFileExt or not compile?
          fs.readFile sourceFile, (error, content) ->
            if error?
              callback error
            else
              fs.writeFile generatedFile, content, (error) ->
                if error?
                  resume error
                else
                  generated.push generatedFile

                  todo -= 1
                  console.log "#{todo} more to go..." if options.verbose
                  if todo is 0
                    callback null, generated
        else
          compile sourceFile, options, (error, generatedContent) ->
            if error?
              callback error
            else
              fs.writeFile generatedFile, generatedContent, (error) ->
                if error?
                  callback error
                else
                  generated.push generatedFile

                  todo -= 1
                  console.log "#{todo} more to go..." if options.verbose
                  if todo is 0
                    callback null, generated

optimizeFiles = (build, toOptimize, options, callback) =>
  todo = 0
  optimized = []

  for pattern, optimizer of toOptimize then do (pattern, optimizer) ->
    glob (path.resolve build, "./#{pattern}"), (error, files) ->
      if error?
        callback error
      else
        console.log "Will optimize globbed pattern \"#{pattern}\" (#{files.length} files)" if options.verbose

        for file in files then do (file) ->
          todo += 1
          console.info "Optimizing #{dotPrefix file}" unless options.quiet

          optimizer file, options, (error) ->
            if error?
              callback error
            else
              optimized.push file

              todo -= 1
              console.log "#{todo} more to go..." if options.verbose

              if todo is 0
                callback error, optimized

renameTimestampedFiles = (files, options, callback) ->
  todo = 0
  renamed = []

  for oldPath, newPath of files then do (oldPath, newPath) ->
    console.log "Will rename #{oldPath}" if options.verbose

    fs.exists oldPath, (exists) ->
      if exists
        todo += 1

        console.info "Renaming #{dotPrefix oldPath}" unless options.quiet

        fs.rename oldPath, newPath, (error) ->
          if error?
            callback error
          else
            renamed.push newPath

            todo -= 1
            console.log "#{todo} more to go..." if options.verbose

            if todo is 0
              callback null, renamed

applyTimestamps = (build, referencers, options, callback) ->
  d = new Date
  now = ([d.getFullYear(), d.getMonth() + 1, d.getDate(),d.getHours(), d.getMinutes(), d.getSeconds()]).join '-'

  todo = 0
  modified = []
  renamed = []
  toRename = {}

  for referencer, references of referencers then do (referencer, references) ->
    referencer = path.resolve build, ".#{path.sep}#{referencer}"
    console.log "Will timestamp #{referencer} (#{references.length} references)" if options.verbose

    fs.exists referencer, (exists) ->
      if exists
        todo += 1
        console.info "Time-stamping #{dotPrefix referencer}" unless options.quiet

        fs.readFile referencer, (error, content) ->
          if error?
            callback error
          else
            content = "#{content}"
            for file in references
              ext = path.extname file
              newName = "#{file[...-ext.length]}-#{now}#{ext}"

              content = content.replace ///(src|href)="([^"]*)#{file}"///i, (totalMatch, ref, path) ->
                "#{ref}=\"#{path}#{newName}\""

              oldPath = path.resolve build, ".#{path.sep}#{file}"
              newPath = "#{oldPath[...-ext.length]}-#{now}#{ext}"

              toRename[oldPath] = newPath

            fs.writeFile referencer, content, (error) ->
              if error?
                callback error
              else
                modified.push referencer

                todo -= 1
                console.log "#{todo} more to go..." if options.verbose

                if todo is 0
                  renameTimestampedFiles toRename, options, (error, renamed) ->
                    if error?
                      callback error
                    else
                      callback null, {modified, renamed}

build = (output, options, callback) ->
  output ?= process.env.OUTPUT || options.output

  makeBuildDirectory output, options, (error, buildPath) =>
    callback? error if error?
    copyMounts options.root, buildPath, options.mount, options, (error, mounted) =>
      callback? error if error?
      generateFiles options.root, buildPath, options.generate, options, (error, generated) =>
        callback? error if error?
        optimizeFiles buildPath, options.optimize, options, (error, optimized) =>
          callback? error if error?
          applyTimestamps buildPath, options.timestamp, options, (error, changes) =>
            callback? error if error?
            console.info "Finished build in #{dotPrefix buildPath}" unless options.quiet
            callback null

module.exports = build
