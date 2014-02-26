t7e = window.t7e || require './t7e'

class t7e.Menu
  languages: null
  defaultLanguage: 'en-US'

  select: null
  className: 't7e-menu'

  constructor: (params = {}) ->
    @[property] = value for property, value of params

    @languages ?= {}

    @select ?= document.createElement 'select'
    @select.className = @className

    if 'addEventListener' of @select
      @select.addEventListener 'change', @onChange, false
    else if 'attachEvent' of @select
      @select.attachEvent 'onchange', @onChange

    @add language, label, value for language, {label, value} of @languages

    preferredLanguage = localStorage.getItem 't7e-preferred-language'
    preferredLanguage ||= navigator.language
    preferredLanguage ||= navigator.userLanguage.replace /([a-z]+$)/, (cc) -> cc.toUpperCase()

    @set preferredLanguage

  add: (code, label, value, index = NaN) ->
    @languages[code] = {label, value}

    option = document.createElement 'option'
    option.innerHTML = label
    option.value = code

    if isNaN index
      @select.appendChild option
    else
      @select.insertBefore option, @select.children[index]

    null

  onChange: (e) =>
    @select.value = @defaultLanguage unless @select.value of @languages
    localStorage.setItem 't7e-preferred-language', @select.value

    language = @languages[@select.value]

    if typeof language.value is 'string'
      @select.setAttribute 'loading', 'loading'
      @request language.value, (response) =>
        language.value = response
        @set @select.value

    else
      t7e.load language.value
      t7e.refresh()
      document.body.parentNode.setAttribute 'lang', @select.value
      @select.removeAttribute 'loading'

    null

  set: (language) ->
    @select.value = language
    @onChange()
    null

  request: (url, callback) ->
    xhr = new XMLHttpRequest
    xhr.onreadystatechange = ->
      callback JSON.parse xhr.responseText if xhr.readyState is 4

    xhr.open 'GET', url, true
    xhr.send null
    null

module?.exports = t7e.Menu
