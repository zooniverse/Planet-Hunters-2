defaultConfig =
  config: 'slug'

  root: process.cwd()

  port: 2217

  directoryIndex: 'index.{html,htm}'

  output: 'build'
  force: false

  quiet: false
  verbose: false

  # (Local directory): (Mount point)
  mount:
    './public': '/'

  # (Generated file path): (Source file)
  generate:
    '/main.js': './app/main.{js,coffee}'
    '/main.css': './css/main.{css,styl}'

  # Compile based on extensions.
  compile:
    '.coffee': '.js': require './coffee-to-js'
    '.styl': '.css': require './styl-to-css'

  # Optimize files after a build
  # Paths are rooted at the build directory.
  optimize:
    '/main.js': require './optimize-js'
    '/main.css': require './optimize-css'
    '{*,**/*}.jpg': require './optimize-jpg'
    '{*,**/*}.png': require './optimize-png'

  # Modify file names, update references to them
  # (File with references): (Files to timestamp)
  timestamp:
    'index.html': ['main.js', 'main.css']

  init: require './default-inits'

module.exports = defaultConfig
