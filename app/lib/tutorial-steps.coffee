{Step} = require 'zootorial'
t = require 't7e'

tutorialSteps = ''
  welcome: new Step
    header: t 'span', 'tutorial.welcome.header'
    details: t 'span', 'tutorial.welcome.details'
    attachment: 'center center #surfaces-container center center'
    next: 'overview'  

  overview: new Step
    header: t 'span', 'tutorial.overview.header'
    details: t 'span', 'tutorial.overview.details'
    focus: '#left-panel'
    attachment: 'left center #left-panel right center'
    next: 'tools'

  # TODO: allow multiple focus (add surfaces-container to focus)
  tools: new Step
    header: t 'span', 'tutorial.tools.header'
    details: t 'span', 'tutorial.tools.details'
    className: "arrow-left"
    focus: '#tools'
    attachment: 'left center #tools right center'
    next: 'view'

  # TODO: allow multiple focus (add surfaces-container to focus)
  view: new Step
    header: t 'span', 'tutorial.view.header'
    details: t 'span', 'tutorial.view.details'
    className: "arrow-left"
    focus: '#views'
    attachment: 'left center #views right center'
    next: 'guide'
    onExit: ->
      window.classifier.onClickFlicker()

  guide: new Step
    header: t 'span', 'tutorial.guide.header'
    details: t 'span', 'tutorial.guide.details'
    className: "arrow-left"
    focus: '#guide-button'
    attachment: 'left center #guide-button right center'
    next: 'beginWorkflow'

  beginWorkflow: new Step
    header: t 'span', 'tutorial.beginWorkflow.header'
    details: t 'span', 'tutorial.beginWorkflow.details'
    attachment: 'center center #surfaces-container center center'
    next: 'cycle'

  cycle: new Step
    header: t 'span', 'tutorial.cycle.header'
    details: t 'span', 'tutorial.cycle.details'
    instruction: t 'span', 'tutorial.cycle.instruction'
    className: "arrow-bottom"
    focus: '[name="cycle-channels"]'
    attachment: 'center bottom [name="cycle-channels"] center top'
    next: 'click [name="cycle-channels"]': 'stopCycle'

  stopCycle: new Step
    header: t 'span', 'tutorial.cycle.header'
    instruction: t 'span', 'tutorial.cycle.turnOff'
    attachment: 'center bottom [name="cycle-channels"] center top'
    className: "arrow-bottom"
    next: 'play'

  play: new Step
    header: t 'span', 'tutorial.play.header'
    details: t 'span', 'tutorial.play.details'
    instruction: t 'span', 'tutorial.play.instruction'
    className: "arrow-bottom"
    attachment: 'center bottom #play-button center top'
    next: 'click [name="play-frames"]': 'observe'

  observe: new Step
    header: t 'span', 'tutorial.observe.header'
    details: t 'span', 'tutorial.observe.details'
    instruction: t 'span', 'tutorial.observe.instruction'
    attachment: 'center center #right-panel center center'
    next: 'firstAsteroid'

    demo: ->
      for surface in [window.classifier.markingSurfaceList...]
        surface.addShape 'circle',
        class: 'tutorial-demo-mark'
        r: 20
        cx: 1
        cy: 1
        fill: 'none'
        stroke: 'rgb(0,200,0)'
        opacity: 1
        'stroke-width': 4
        transform: 'translate(468,46)'

        surface.addShape 'circle',
        class: 'tutorial-demo-mark'
        r: 20
        cx: 1
        cy: 1
        fill: 'none'
        stroke: 'rgb(0,200,0)'
        opacity: 1
        'stroke-width': 4
        transform: 'translate(90,170)'

        surface.addShape 'circle',
        class: 'tutorial-demo-mark'
        r: 20
        cx: 1
        cy: 1
        fill: 'none'
        stroke: 'rgb(0,200,0)'
        opacity: 1
        'stroke-width': 4
        transform: 'translate(132,228)'

    onExit: ->
      window.classifier.removeElementsOfClass('.tutorial-demo-mark')

  firstAsteroid: new Step
    header: t 'span', 'tutorial.firstAsteroid.header'
    details: t 'span', 'tutorial.firstAsteroid.details'
    attachment: 'center center #surfaces-container center center'
    next: 'selectAsteroid'

  # add intermediate step: play frames, move textbox to right panel, add "Don't see an asteroid? Hint."
  selectAsteroid: new Step
    header: t 'span', 'tutorial.selectAsteroid.header'
    instruction: t 'span', 'tutorial.selectAsteroid.instruction'
    className: "arrow-right"
    attachment: 'right bottom #asteroid-button left bottom'
    next: 'click [id="asteroid-button"]': 'asteroid_1'

  asteroid_1: new Step
    header: t 'span', 'tutorial.asteroid_1.header'
    instruction: t 'span', 'tutorial.asteroid_1.instruction'
    next: 'click [id="surfaces-container"]': 'nextFrame'
    attachment: 'center bottom #surfaces-container center bottom'

  nextFrame: new Step
    header: t 'span', 'tutorial.nextFrame.header'
    instruction: t 'span', 'tutorial.nextFrame.instruction'
    className: "arrow-right"
    attachment: 'right center [name="next-frame"] left center'
    next: 'click [name="next-frame"]': 'continueMarkingAsteroids'

  continueMarkingAsteroids: new Step
    header: t 'span', 'tutorial.continueMarkingAsteroids.header'
    details: t 'span', 'tutorial.continueMarkingAsteroids.details'
    instruction: t 'span', 'tutorial.continueMarkingAsteroids.instruction'
    attachment: 'center bottom #surfaces-container center bottom'
    next: 'click [id="asteroid-done"]':'markArtifacts'

  # TODO: mark artifacts on the image 
  markArtifacts: new Step
    header: t 'span', 'tutorial.markArtifacts.header'
    details: t 'span', 'tutorial.markArtifacts.details'
    attachment: 'center center #surfaces-container center center'
    next: 'finished'

  finished: new Step
    header: t 'span', 'tutorial.finished.header'
    details: t 'span', 'tutorial.finished.details'
    attachment: 'center center #surfaces-container center center'

module.exports = tutorialSteps