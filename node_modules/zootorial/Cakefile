exec = require 'easy-exec'

task 'serve', ->
  exec 'coffee --watch --output ./ --compile ./src'
  exec 'stylus --import ./node_modules/nib --out ./ --watch ./src'
  exec "silver server --port #{process.env.PORT || 2007}"
