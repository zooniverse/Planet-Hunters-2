strings = {}

dataSet = (el, key, value) ->
  el.setAttribute "data-t7e-#{key.toLowerCase()}", value

dataGet = (el, key) ->
  el.getAttribute "data-t7e-#{key.toLowerCase()}"

dataAll = (el) ->
  data = {}

  for attr in el.attributes
    continue unless (attr.name.indexOf 'data-t7e-') is 0
    data[attr.name['data-t7e-'.length...]] = attr.value

  data

defaultOptions =
  raw: false # Return an actual element, not its markup
  literal: false # Don't interpolate $-variables
  fallback: null # Or a string

translate = (args...) ->
  # TODO: This is pretty nasty, eh?
  typesOfArgs = (typeof arg for arg in args).join ' '
  [tag, key, options, transform] = switch typesOfArgs
    when 'string string object function' then args
    when 'string string object' then [args..., null]
    when 'string string function' then [args[0], args[1], {}, args[2]]
    when 'string object function' then [null, args...]
    when 'string string' then [args..., {}, null]
    when 'string object' then [null, args..., null]
    when 'string function' then [null, args[0], {}, args[1]]
    when 'string' then [null, args..., {}, null]
    else throw new Error "Couldn't unpack translate args (#{typesOfArgs})"

  if tag?
    [tag, classNames...] = tag.split '.'

    element = document.createElement tag
    element.className = classNames.join ' '

    dataSet element, 'key', key

    for property, value of options
      dataAttribute = if (property.charAt 0) is '$'
        "var-#{property[1...]}"
      else if property not of defaultOptions
        "attr-#{property}"
      else
        "opt-#{property}"

      dataSet element, dataAttribute, value

    if transform?
      dataSet element, 'transform', transform.toString()

    translate.refresh element

    raw = if 'raw' of options then options.raw else defaultOptions.raw

    if raw
      element
    else
      outer = document.createElement 'div'
      outer.appendChild element
      outer.innerHTML

  else
    segments = key.split '.'

    object = strings
    for segment in segments
      object = object[segment] if object?

    object = object.join '\n' if object instanceof Array
    result = object || options.fallback || key

    literal = if options.literal? then options.literal else defaultOptions.literal
    unless literal
      for variable, value of options when (variable.charAt 0) is '$'
        result = result.replace variable, value, 'gi'

    if transform
      result = transform result

    result

translate.refresh = (root = document.body, givenOptions = {}) ->
  keyedElements = (element for element in root.querySelectorAll '[data-t7e-key]')
  keyedElements.unshift root if (dataGet root, 'key')?

  for element in keyedElements
    options = {}
    options[property] = value for property, value of givenOptions

    key = dataGet element, 'key'

    for dataAttr, value of dataAll element
      if (dataAttr.indexOf 'var-') is 0
        varName = dataAttr['var-'.length...]
        options["$#{varName}"] = value

      else if (dataAttr.indexOf 'attr-') is 0
        attrName = dataAttr['attr-'.length...]
        options[attrName] = value

      else if (dataAttr.indexOf 'opt-') is 0
        optName = dataAttr['opt-'.length...]
        options[optName] = value

    transform = eval "(#{dataGet element, 'transform'})"

    try
      element.innerHTML = if transform?
        translate key, options, transform
      else
        translate key, options

    for property, value of options
      continue if (property.charAt 0) is '$'
      continue if property of defaultOptions
      element.setAttribute property, translate value, options

  null

translate.load = (newStringSet, _base = strings) ->
  for own key, value of newStringSet
    if (typeof value is 'string') or (value instanceof Array)
      _base[key] = value
    else
      _base[key] = {} unless key of _base
      translate.load value, _base[key]

translate.strings = strings
translate.dataGet = dataGet
translate.dataSet = dataSet
translate.dataAll = dataAll

window?.t7e = translate
module?.exports = translate
