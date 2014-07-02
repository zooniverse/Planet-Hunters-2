{Step} = require 'zootorial'
translate  = require 't7e'
# classifier = require "../controllers/classifier"

initialTutorialSteps =
  steps:
    # /// BEGIN TUTORIAL STEPS ///
    first: 
      # progress:    1
      header:      translate 'span', 'tutorial.first.header'
      content:     translate 'span', 'tutorial.first.content'
      attachment:  [0.5, 0.5, "#graph-container", 0.5, 0.5]
      next:        'theData1'

    theData1: 
      # progress:    2
      header:      translate 'span', 'tutorial.theData1.header'
      content:     translate 'span', 'tutorial.theData1.content'
      attachment:  [0.5, 0.5, "#graph-container", 0.5, 0.5]
      next:        'theData2'

    theData2: 
      # progress:    3
      header:      translate 'span', 'tutorial.theData2.header'
      content:     translate 'span', 'tutorial.theData2.content'
      attachment:  [0.5, 0.5, "#graph-container", 0.5, 0.5]
      # attachment:  [0.5, 1.20, "#slider-container", 0.5, 0.5]
      # arrow:       "bottom"
      next:        'transits'

    transits: 
      # progress:    4
      header:      translate 'span', 'tutorial.transits.header'
      content:     translate 'span', 'tutorial.transits.content'
      attachment:  [0.5, 0.5, "#graph-container", 0.5, 0.5]
      next:        'markingTransits'

    markingTransits:
      # progress:    5 
      header:      translate 'span', 'tutorial.markingTransits.header'
      content:     translate 'span', 'tutorial.markingTransits.content'
      attachment:  [0.5, 0.5, "#graph-container", 0.5, 0.5]
      next:        'spotTransits'

    spotTransits:
      # progress:    6 
      header:      translate 'span', 'tutorial.spotTransits.header'
      content:     translate 'span', 'tutorial.spotTransits.content'
      attachment:  [0.5, 0.5, "#graph-container", 0.5, 0.5]
      next:        'showTransits'

    showTransits:
      # progress:    7 
      header:      translate 'span', 'tutorial.showTransits.header'
      content:     translate 'span', 'tutorial.showTransits.content'
      attachment:  [0.5, 0.5, "#graph-container", 0.5, 0.5]
      next:        'zooming'
      instruction: ''

      demo: -> # TODO: Fix. This doesn't work!
        # modify this to fit the light curve
        window.classifier.canvasGraph.highlightCurve(1,2)
        window.classifier.canvasGraph.highlightCurve(4,5)
        window.classifier.canvasGraph.highlightCurve(8,9)
        window.classifier.canvasGraph.highlightCurve(10,11)
        window.classifier.canvasGraph.highlightCurve(12,13)

    zooming: 
      # progress:    8
      header:      translate 'span', 'tutorial.zooming.header'
      content:     translate 'span', 'tutorial.zooming.content'
      arrow:       'right'
      attachment:  [1.1, 0.5, "#zoom-button", 0.5, 0.5]
      actionable:  '[id="zoom-button"]'
      next:        'goodLuck'
      # next:        'click [id="zoom-button"]': 'goodLuck'

    goodLuck: 
      # progress:    9
      header:      translate 'span', 'tutorial.goodLuck.header'
      content:     translate 'span', 'tutorial.goodLuck.content'
      attachment:  [0.5, 0.5, "#graph-container", 0.5, 0.5]
    # /// END TUTORIAL STEPS /// 

module.exports = initialTutorialSteps