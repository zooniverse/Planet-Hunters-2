which = require 'which'
exec = require 'easy-exec'

which 'optipng', (error) ->
  console.error 'Missing optipng! Try `brew install optipng`.' if error

optimizePng = (file, options, callback) ->
  exec "optipng -strip all -o7 -quiet #{file}", callback

module.exports = optimizePng
