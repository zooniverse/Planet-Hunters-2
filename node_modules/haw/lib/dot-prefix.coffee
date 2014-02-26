path = require 'path'

dotPrefix = (file) ->
  ".#{path.sep}#{path.relative process.cwd(), file}"

module.exports = dotPrefix
