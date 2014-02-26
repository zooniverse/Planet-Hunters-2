T7e
===

Basic usage
-----------

```coffee
translate = require 't7e'
translate.load greetings: hello: 'Hello', hey: 'Hey, $name!'
```

```coffee
translate 'greetings.hello'
# 'Hello'
```

```coffee
translate 'span', 'greetings.hello'
# '<span data-t7e-key="greetings.hello">Hello</span>'

translate 'span', 'greetings.hey', $name: 'you'
# '<span data-t7e-key="greetings.hey" data-t7e-name="you">Hey, you!</span>'
```

```coffee
translate.load greetings: hey: '¡Hola, $name!'
translate.refresh()
```

Language-picker menu
--------------------

```coffee
new t7e.Menu
  languages:
    'en-US':
      label: 'U.S. English'
      value: {}
    'es-MX':
      label: 'Español mexicano'
      value: './es-mx.json'
```

Language codes should match the codes returned by `navigator.language`.
