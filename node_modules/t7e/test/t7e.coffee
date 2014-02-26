{describe, it} = window
translate = window.t7e

enUs =
  hello: 'Hello'
  helloFriend: 'Hello, $friend'

esMx =
  hello: 'Hola'
  helloFriend: 'Hola, $friend'

placeholder = document.createElement 'div'

describe 'translate', ->
  it 'loads new strings', (done) ->
    translate.load enUs
    done() if translate.strings.hello is 'Hello'

  it 'translates', (done) ->
    done() if (translate 'hello') is 'Hello'

  it 'transforms with a function', (done) ->
    done() if (translate 'hello', (s) -> s.toUpperCase()) is 'HELLO'

  it 'interpolates $-prefixed words', (done) ->
    done() if (translate 'helloFriend', $friend: 'dude') is 'Hello, dude'

  it 'doesn\'t interpolate $-prefixed words with the "literal" option', (done) ->
    done() if (translate 'helloFriend', $friend: 'dude', literal: true) is 'Hello, $friend'

  it 'translates into an element', (done) ->
    placeholder.innerHTML = translate 'span', 'hello'
    done() if placeholder.children[0].innerHTML is 'Hello'

  it 'transforms into an element', (done) ->
    placeholder.innerHTML = translate 'span', 'hello', (value) -> value.toUpperCase()
    done() if placeholder.children[0].innerHTML is 'HELLO'

  it 'translates attributes into an element', (done) ->
    placeholder.innerHTML = translate 'span', '', title: 'hello'
    done() if placeholder.children[0].title is 'Hello'
