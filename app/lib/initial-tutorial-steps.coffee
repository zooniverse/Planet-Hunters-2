{Step} = require 'zootorial'
translate  = require 't7e'
# classifier = require "../controllers/classifier"

initialTutorialSteps =
  steps:
    # /// BEGIN TUTORIAL STEPS ///
    first: 
      # progress:    1
      header:      translate 'span', 'initialTutorial.first.header'
      content:     translate 'span', 'initialTutorial.first.content'
      attachment:  [0.5, 0.5, "#graph-container", 0.5, 0.5]
      next:        'theData'

    theData: 
      # progress:    2
      header:      translate 'span', 'initialTutorial.theData.header'
      content:     translate 'span', 'initialTutorial.theData.content'
      attachment:  [0.5, 0.5, "#graph-container", 0.5, 0.5]
      next: ->
        $('.tutorial-annotations.x-axis').addClass('visible')
        return 'xAxis' # go on to next step

    xAxis: 
      # progress:    3
      header:      translate 'span', 'initialTutorial.xAxis.header'
      content:     translate 'span', 'initialTutorial.xAxis.content'
      attachment:  [0.5, 1.40, "#slider-container", 0.5, 0.5]
      arrow:       'bottom'
      next: ->
        $('.tutorial-annotations.x-axis').removeClass('visible')
        $('.tutorial-annotations.y-axis').addClass('visible')
        return 'yAxis'

    yAxis: 
      # progress:    3
      header:      translate 'span', 'initialTutorial.yAxis.header'
      content:     translate 'span', 'initialTutorial.yAxis.content'
      attachment:  [0.0, 0.5, "#graph-container", 0.08, 0.5]
      arrow:       'left'
      next: ->       
        $('.tutorial-annotations.y-axis').removeClass('visible')
        return 'transits'

    transits: 
      # progress:    4
      header:      translate 'span', 'initialTutorial.transits.header'
      content:     translate 'span', 'initialTutorial.transits.content'
      attachment:  [0.5, 0.5, "#graph-container", 0.5, 0.5]
      next:        'markingTransits'

    markingTransits:
      # progress:    5 
      header:      translate 'span', 'initialTutorial.markingTransits.header'
      content:     translate 'span', 'initialTutorial.markingTransits.content'
      attachment:  [0.5, 0.5, "#graph-container", 0.5, 0.5]
      next:        'spotTransits'

    spotTransits:
      # progress:    6 
      header:      translate 'span', 'initialTutorial.spotTransits.header'
      content:     translate 'span', 'initialTutorial.spotTransits.content'
      attachment:  [0.5, 0.5, "#graph-container", 0.5, 0.5]
      next:        'showTransits'

    showTransits:
      # progress:    7 
      header:      translate 'span', 'initialTutorial.showTransits.header'
      instruction: translate 'span', 'initialTutorial.showTransits.content'
      attachment:  [0.5, 0.5, "#graph-container", 0.5, 0.5]
      next:        'zooming'

      demo: -> # TODO: Fix. This doesn't work!
        # modify this to fit the light curve
        window.classifier.canvasGraph.highlightCurve(1,2)
        window.classifier.canvasGraph.highlightCurve(4,5)
        window.classifier.canvasGraph.highlightCurve(8,9)
        window.classifier.canvasGraph.highlightCurve(10,11)
        window.classifier.canvasGraph.highlightCurve(12,13)

    zooming: 
      # progress:    8
      header:      translate 'span', 'initialTutorial.zooming.header'
      content:     translate 'span', 'initialTutorial.zooming.content'
      arrow:       'right'
      attachment:  [1.1, 0.5, "#zoom-button", 0.5, 0.5]
      actionable:  '[id="zoom-button"]'
      next:        'goodLuck'
      # next:        'click [id="zoom-button"]': 'goodLuck'

    goodLuck: 
      # progress:    9
      header:      translate 'span', 'initialTutorial.goodLuck.header'
      content:     translate 'span', 'initialTutorial.goodLuck.content'
      attachment:  [0.5, 0.5, "#graph-container", 0.5, 0.5]
    # /// END TUTORIAL STEPS /// 

module.exports = initialTutorialSteps