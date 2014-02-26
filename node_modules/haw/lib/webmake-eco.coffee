eco = require 'eco'

module.exports =
  extension: 'eco'

  compile: (src, options) ->
    code: "module.exports = #{eco.precompile src};\n"
