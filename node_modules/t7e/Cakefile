exec = require 'easy-exec'

task 'serve', (options) ->
  exec "silver server --port #{process.env.PORT || 7373}"
  exec 'coffee --watch --output . --compile ./src'
  exec 'stylus --import ./node_modules/nib --watch ./src --out .'
