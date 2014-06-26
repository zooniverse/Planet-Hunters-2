{Step} = require 'zootorial'
translate  = require 't7e'
# classifier = require "../controllers/classifier"

tutorialSteps =
  welcome: new Step
    header:      translate 'span', 'tutorial.welcome.header'
    details:     translate 'span', 'tutorial.welcome.details'
    attachment: 'center center #graph-container center center'
    next: 'theData1'

  theData1: new Step
    header:      translate 'span', 'tutorial.theData1.header'
    details:     translate 'span', 'tutorial.theData1.details'
    attachment: 'center center #graph-container center center'
    next: 'theData2'

  theData2: new Step
    header:      translate 'span', 'tutorial.theData2.header'
    details:     translate 'span', 'tutorial.theData2.details'
    attachment: 'center center #graph-container center center'
    next: 'transits'

  transits: new Step
    header:      translate 'span', 'tutorial.transits.header'
    details:     translate 'span', 'tutorial.transits.details'
    attachment: 'center center #graph-container center center'
    next: 'markingTransits'

  markingTransits: new Step
    header:      translate 'span', 'tutorial.markingTransits.header'
    details:     translate 'span', 'tutorial.markingTransits.details'
    attachment: 'center center #graph-container center center'
    next: 'spotTransits'

  spotTransits: new Step
    header:      translate 'span', 'tutorial.spotTransits.header'
    details:     translate 'span', 'tutorial.spotTransits.details'
    attachment: 'center center #graph-container center center'
    next: 'showTransits'

  showTransits: new Step
    onEnter: ->
      window.classifier.canvasGraph.highlightCurve(8,10)
    header:      translate 'span', 'tutorial.showTransits.header'
    details:     translate 'span', 'tutorial.showTransits.details'
    attachment: 'center center #graph-container center center'
    next: 'zooming'

  zooming: new Step
    header:      translate 'span', 'tutorial.zooming.header'
    details:     translate 'span', 'tutorial.zooming.details'
    attachment: 'center center #graph-container center center'
    next: 'goodLuck'

  goodLuck: new Step
    header:      translate 'span', 'tutorial.goodLuck.header'
    details:     translate 'span', 'tutorial.goodLuck.details'
    attachment: 'center center #graph-container center center'

module.exports = tutorialSteps