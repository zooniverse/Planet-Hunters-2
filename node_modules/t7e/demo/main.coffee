translate = window.t7e

# Set up the menu.

window.menu = new t7e.Menu
  languages:
    'en-US':
      label: 'U.S. English'
      value:
        hello: 'Hello'
        helloFriend: 'Hello, $friend!'
        goodbye: 'Goodbye'
        goodbyeTitle: 'See you soon'
        flag: 'http://upload.wikimedia.org/wikipedia/en/thumb/a/a4/Flag_of_the_United_States.svg/125px-Flag_of_the_United_States.svg.png'
        flagTitle: 'The Flag of the USA'
        outLink: 'http://www.google.com/'

    'es-MX':
      label: 'Español mexicano'
      value: './es-mx.json'

document.body.appendChild menu.select

# Add some translated content.

container = document.createElement 'div'

container.innerHTML += translate 'div.foo', 'hello', (val) -> val.toUpperCase()
container.innerHTML += translate 'div.foo.bar', 'helloFriend', $friend: 'Aaron'
container.innerHTML += translate 'div', 'goodbye', title: 'goodbyeTitle'
container.innerHTML += translate 'img', '', src: 'flag', title: 'flagTitle'
container.innerHTML += '<br />'
container.innerHTML += translate 'a', 'goodbye', href: 'outLink', title: 'Title not translated'

document.body.appendChild container

# Initialize the editor UI.

window.editor = t7e.Editor.init()
