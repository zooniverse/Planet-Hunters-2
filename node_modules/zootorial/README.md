This is a library for making totally radical inline tutorials.

The Tutorial class
==================

```coffee
new Tutorial
  id: 'some_tutorial'

  steps:
    welcome: new Step
      # ...

  firstStep: ''
```

`id` is a unique identifier for this tutorial. It should be alphanumeric.

`steps` is an object mapping keys to **Step** instances. The `length` property determines the number of steps in the tutorial. This can also be an array of **Step** instances, if the tutorial is to be linear.

`firstStep` is the a reference to or key of the first step. If `steps` is an array, this is automatically the first member.

The Step class
==============

```coffee
new Step
  className: 'some-class'
  number: 3
```

`className` is applied to the tutorial dialog when this step is active.

`number` is used to update the progress bars. The first step should be `1`. The last step should be the same as the `length` property of the tutorial's `steps` property.

```coffee
new Step
  header: 'Welcome'
  details: 'This is a tutorial.'
  nextButton: 'Next!'
```

`header` and `details` are just normal content.

`nextButton` is the label of the button that moves to the next step.

```coffee
new Step
  instruction: 'Click the red button'
  next: 'afterClick'
```

`instructions` should describe a task that must be preformed to move on to the next step.

`next` is used to determine the next step. See **Determining the next step** below.

```coffee
new Step
  demo: (callback) ->
    drawAnExample()
    callback()

  demoButton: 'Show an example'
```

`demo` is a function that runs when the user clicks the demo button.

`demoButton` is the label on the button that runs the demo if `demo` is defined.

```coffee
new Step
  attachment: ''
```

`attachment` is a string that positions the tutorial dialog relative to another element. The format is `"DIALOG_X DIALOG_Y TARGET_SELECTOR TARGET_X TARGET_Y"`

E.g. to attach the top-right corned of the tutorial dialog to the bottom-right corner of the `#something` element, it would be `left top #something right bottom`.

```coffee
new Step
  block: ''
  focus: ''
  actionable: ''
```

`block` is a CSS selector matching elements to block mouse interaction with.

`focus` is a CSS selector (matching one element only) around which the screen will be dimmed. All elements around it will be blocked.

`actionable` is a CSS selector whose elements will be given an "actionable" class.

```coffee
new Step
  onEnter: -> foo()
  onExit: -> bar()
```

`onEnter` and `onExit` functions run when entering and exiting a step, respectively.

Determining the next step
=========================

The `next` property of a step is flexible:

If it's `true`, `null` or `undefined`, and the tutorial's `steps` property is an array, it moves on the the next logical step. If it's not an array, the tutorial ends.

If it's `false`, The step does not change, and the `instruction` is given an "attention" class.

If it's a string, the next step will be the step that has that key in the tutorial's `steps` object.

If it's a function, the function is run in the context of the tutorial. The returned value is then run through this logic.

If it's an object, mapping event strings to values, the values are run through this logic when the event is triggered. E.g.:

```coffee
next:
  'click button[name="gray"]': 'whatever'
  'click button[name="red"]': true
  'click button[name="blue"]': false
  'click button[name="purple"]': -> !!(Math.random() < 0.5)
```

Here, clicking the gray button will go directly to the "whatever" step, the red button will move on the next step, the blue button will call attention to the instruction, and the purple one will randomly either go to the next step or call attention to the instruction.

The default `nextButton`-labelled button will not be drawn if `next` is an object of events.
