fs = require 'fs'
cleanCSS = require 'clean-css'

optimizeCss = (file, options, callback) ->
  fs.readFile file, (error, content) ->
    if error?
      callback error
    else
      min = cleanCSS.process "#{content}", keepBreaks: true
      fs.writeFile file, min, callback

module.exports = optimizeCss
