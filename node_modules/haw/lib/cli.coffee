optimist = require 'optimist'
defaultConfig = require './default-config'
path = require 'path'
dotPrefix = require './dot-prefix'

started = Date.now()

optimist.usage '''
  Usage:
    haw init
    haw init controller SomeController
    haw serve --port 1234
    haw build --config ./package.json --output ./build
'''

options = optimist.options({
  c: alias: 'config', description: 'Configuration file'
  r: alias: 'root', description: 'Root from which to look for files'
  p: alias: 'port', description: 'Port on which to run the server'
  o: alias: 'output', description: 'Directory in which to build the site'
  f: alias: 'force', description: 'Overwrite any existing output directory'
  q: alias: 'quiet', description: 'Don\'t show any working info'
  v: alias: 'verbose', description: 'Show lots of working info'
  h: alias: 'help', description: 'Print some help'
  version: description: 'Print the version number'
}).argv

configuration = {}
configuration[property] = value for property, value of defaultConfig

require 'coffee-script'

configFile = options.config || configuration.config

if configFile?
  try
    config = require configFile

  unless config?
    try
      config = require path.resolve configFile

  if typeof config is 'function'
    config.call configuration, configuration
  else
    configuration[property] = value for property, value of config

configuration[property] = value for property, value of options

[command, commandArgs...] = options._

command = 'help' if options.help
command = 'version' if options.version or (options.v and not command)

switch command
  when 's', 'serve', 'server'
    serve = require '../lib/serve'
    serve commandArgs[0], configuration

    # exec = require 'easy-exec'
    # console.log 'Hit "o" to open your browser.'
    # process.stdin.setRawMode true
    # process.stdin.resume()
    # process.stdin.on 'data', (data) ->
    #   switch "#{data}"
    #     when 'o' then exec "open http://localhost:#{configuration.port}"
    #     when '\u0003' then process.exit()

    process.on 'SIGINT', ->
      console.log ''
      process.exit()

  when 'i', 'init'
    init = require '../lib/init'
    type = commandArgs.shift()
    name = commandArgs.join ' '
    init type, name, configuration, (error, created) ->
      if error?
        console.log error
        process.exit 1

  when 'b', 'build', 'builder'
    build = require '../lib/build'
    build commandArgs[0], configuration, (error) ->
      if error?
        console.log error
        process.exit 1
      else
        console.log "Build took #{(Date.now() - started) / 1000} seconds"

  when 'h', 'help'
    optimist.showHelp()

  when 'v', 'version'
    console.log (require path.join __dirname, '..', 'package').version

  else
    optimist.showHelp()
    process.exit 1
