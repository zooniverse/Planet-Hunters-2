zootorial

Tutorial
========

Constructor parameters
----------------------

* `parent`

    Element at which to insert the tutorial's elements

* `steps`

    Object of steps, see **Steps** below

* `first`

    The key of the first step

* `demoLabel`, `nextLabel`, `doneLabel`

    Default labels for the "demo", "next", and "done" buttons

Properties
----------

* `el`

    Contains all the tutorial content.

* `closeButton`

    Aborts the tutorial

* `header`, `content`

    Contains the `header` and `content` specified in the current step, if defined.

* `instruction`

    Includes the `instruction` property in the current step and a button to call the step's `demo` function if one is defined.

* `footer`

    Contains the "next" button.

Methods
-------

* `start()`

    Start the tutorial.

* `end()`

    End the tutorial.

* `goTo(step)`

    If it's a string, go to that step in the `steps` object.

    If it's a function, it's evaluated and the result is passed back to `goTo`.

    If it's `false`, the step will not change, but the `instruction` element will get a `data-zootorial-attention` attribute.

    If it's `null` or not defined, the tutorial will end.

Helpers
-------

* `triggerEvent(eventName)`

    Dispatch a custom event from the tutorial's `el` element.

* `createElement(tagAndClassNames, parent)`

    Create an element (e.g. "button.hello") at a parent.

* `current`

    The current step as it was passed into `steps`

Hooks
-----

* `onBeforeStart()`

* `onStart()`

* `onBeforeEnd()`

* `onEnd()`

* `onBeforeBeforeLoadStep()`

* `onLoadStep()`

* `onBeforeUnloadStep()`

* `onUnloadStep()`

Events
------

Dispatched from `el`. You should probably reference these, e.g. `addEventListener(tutorialInstance.startEvent, handler, false)`, in case the specific strings change

* `startEvent`

* `endEvent`

* `loadStepEvent`

* `unloadStepEvent`

* `abortEvent`


"Step" objects
==============

Parameters
----------

* `header`

    String of HTML for a header

* `content`

    String of HTML for content

* `instruction`

    String of HTML for instructional content

* `demo()`

    Function that shows the user what to do. Check out my `ghost-mouse` for a nice way to drive a dmeo.

* `attachment`

    An array `[X of tutorial, Y of tutorial, target selector, X of target, Y of target]`. The tutorial dialog will be positioned so that the X and Y defined will match up with the X and Y of the target. E.g. `[0, 0, '.target', 0, 0]` will align the top-left corners of the tutorial and the target, and `[0, 0.5, '.target', 1, 0.5]` will stick the tutorial to the right side of the target, cenetered vertically.

    If `attachment` is `false`, the dialog will not move from the last step's position.

* `progress`

    The number of progress dots to fill up

* `arrow`

    Set the `data-zootorial-position` property, which you can then style apropriately

* `block`

    A CSS selector; block clicks to the matched elements until the step is exited.

* `focus`

    A CSS selector; the matched element will be "highlighted" (everything around it will be dimmed).

* `actionable`

    A CSS selector; matched elements will be given a `data-zootorial-actionable` property.

* `next`

    If it's an object, keys are event/selector combos (e.g. `click button[name='complete-task']`) and values are passed to the tutorial's `goTo` method when that event is dispatched from that selector. No "next" button is drawn.

    If it's a string, function, `null`, or not defined, this is passed directly to the tutorial's `goTo` method and either a "next" or "done" button is drawn in the footer.

Hooks
-----

* `onBeforeLoad()`

* `onLoad()`

* `onBeforeUnload()`

* `onUnload()`
