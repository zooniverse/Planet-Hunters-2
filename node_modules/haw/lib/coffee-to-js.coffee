webmake = require 'webmake'
webmakeEco = require './webmake-eco'
path = require 'path'
fs = require 'fs'

coffeeToJs = (sourceFile, options, callback) ->
  # TODO: Check to see if there are any `require`ments.
  # If so, pass it into webmake.
  # If not, compile straight with CoffeeScript.

  webmake sourceFile,
    ext: ['coffee', webmakeEco]
    sourceMap: true unless options.webmake?.sourceMap is false
    ignoreErrors: true unless options.webmake?.ignoreErrors is false
    callback

module.exports = coffeeToJs
