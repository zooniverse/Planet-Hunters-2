Handlebars = require 'handlebars'
path = require 'path'
fs = require 'fs'

split = (string) ->
  parts = string.split /\W+|([A-Z][a-z]+)/
  part for part in parts when !!part

Handlebars.registerHelper 'camelCase', (string) ->
  parts = split string

  parts = for part, i in parts
    if i is 0
      part.toLowerCase()
    else
      part.charAt(0).toUpperCase() + part[1...].toLowerCase()

  parts.join ''

Handlebars.registerHelper 'classCase', (string) ->
  parts = split string

  parts = for part, i in parts
    part.charAt(0).toUpperCase() + part[1...].toLowerCase()

  parts.join ''

Handlebars.registerHelper 'dashed', (string) ->
  parts = split string
  parts.join('-').toLowerCase()

makeStructure = (dirs, structure, context) ->
  for name, value of structure
    name = (Handlebars.compile name) context
    if typeof value is 'string'
      filename = path.resolve dirs..., name
      value = ((Handlebars.compile value) context)
      value += '\n' if value
      console.log 'Write', filename
      if fs.existsSync filename
        console.log "Already exists, skipped #{filename}"
      else
        fs.writeFileSync filename, value
    else
      dirs.push name
      dirpath = path.resolve dirs...
      console.log 'Mkdir', dirpath
      try fs.mkdirSync dirpath
      makeStructure dirs, value, context
      dirs.pop()

init = (type = 'default', name, options, callback) ->
  if type of options.init
    try fs.mkdirSync path.resolve options.root
    makeStructure [options.root], options.init[type], {name, options}

  else
    callback "No initializer found for \"#{type}\""

module.exports = init
