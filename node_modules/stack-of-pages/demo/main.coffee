StackOfPages = window.StackOfPages

aboutBarEl = document.createElement 'div'
aboutBarEl.innerHTML = 'About bar'

class DemoPage extends StackOfPages._GenericPage
  content: ''
  constructor: ->
    super @content

class ClassifyPage extends DemoPage
  content: 'This is the classify page.'

class ProfilePage extends DemoPage
  content: 'This is the profile.'

class ThrowAnErrorPage extends DemoPage
  activate: ->
    throw new Error "This is an error thrown from the `activate` method (#{new Date})."

class DisplayErrorPage extends DemoPage
  activate: (params) ->
    @el.innerHTML = """
      There was an error.<br />
      Params were: <code>#{JSON.stringify params}</code><br />
      Error was <code>#{params.error}</code>
    """

window.stack = new StackOfPages
  '#/': ('Home'.split '').join '<br />' # Given a string
  '#/about/*': new StackOfPages # Given another instance of StackOfPages
    '#/about/foo': 'About foo'
    '#/about/bar': aboutBarEl # Given an HTML element
    DEFAULT: '#/about/foo'
  '#/classify': ClassifyPage # Given a class
  '#/profile': new ProfilePage # Given an instance of a class
  '#/throw-an-error': ThrowAnErrorPage # Test errors
  NOT_FOUND: 'Not found!'
  ERROR: DisplayErrorPage

document.body.appendChild window.stack.el
