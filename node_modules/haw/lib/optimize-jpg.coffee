which = require 'which'
path = require 'path'
exec = require 'easy-exec'
fs = require 'fs'

which 'jpegtran', (error) ->
  console.error 'Missing jpegtran! Try `brew install jpeg`.' if error

optimizeJpg = (file, options, callback) ->
  tempFile = path.resolve ".TEMP.#{Math.random().toString().split('.')[1]}.jpg"

  exec "jpegtran -copy none -progressive -outfile #{tempFile} #{file}", (error) ->
    if error?
      callback error
    else
      fs.unlink file, (error) ->
          if error?
            callback error
          else
            fs.rename tempFile, file, (error) ->
              if error?
                callback error
              else
                  callback(null)

module.exports = optimizeJpg
