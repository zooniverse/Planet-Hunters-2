fs = require 'fs'
path = require 'path'
stylus = require 'stylus'
nib = require 'nib'

stylToCss = (sourceFile, options, callback) ->
  fs.readFile sourceFile, (error, content) ->
    unless error?
      styl = stylus "#{content}"
      styl.include path.dirname sourceFile

      unless options.stylus?.nib is false
        styl.include nib.path
        styl.import 'nib'

      unless options.stylus?.includeCss is false
        styl.set 'include css', true

      styl.set 'compress', false

      styl.set 'sourcemaps', true

      try
        css = styl.render()
      catch e
        error = e

    callback error, css

module.exports = stylToCss
