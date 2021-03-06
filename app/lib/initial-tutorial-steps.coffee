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
      instruction: translate 'span', 'initialTutorial.transits.content'
      attachment:  [0.5, 0.5, "#graph-container", 0.5, 0.5]
      next: ->
        window.classifier.canvasGraph.highlightCurve(5.14, 5.32)
        return 'markingTransits'

    markingTransits:
      header:      translate 'span', 'initialTutorial.markingTransits.header'
      instruction: translate 'span', 'initialTutorial.markingTransits.content'
      attachment:  [0.0, 0.5, "#graph-container", 0.25, 0.2]
      arrow:       'left'

      onBeforeLoad: ->
        @el.style.setProperty("width", "170px") # narrow element
        window.classifier.canvasGraph.highlightCurve(5.14, 5.32)

      next:
        'mouseup #marks-container': 'spotTransits'

    spotTransits:
      # progress:    6
      header:      translate 'span', 'initialTutorial.spotTransits.header'
      content:     translate 'span', 'initialTutorial.spotTransits.content'
      attachment:  [0.0, 0.5, "#graph-container", 0.0, 0.5]
      next: ->
        @el.style.setProperty("width", "170px") # narrow element
        window.classifier.canvasGraph.highlightCurve(5.14, 5.32)
        window.classifier.canvasGraph.highlightCurve(13.027,13.208)
        window.classifier.canvasGraph.highlightCurve(20.91933566343474,21.09933566343474)
        # window.classifier.canvasGraph.highlightCurve(12.60,12.85)
        # window.classifier.canvasGraph.highlightCurve(15.80,16.12)
        # window.classifier.canvasGraph.highlightCurve(19.15,19.45)
        # window.classifier.canvasGraph.highlightCurve(22.48,22.75)
        # window.classifier.canvasGraph.highlightCurve(25.72,26.00)
        # window.classifier.canvasGraph.highlightCurve(29.00,29.34)
        # window.classifier.canvasGraph.highlightCurve(32.34,32.60)
        return 'showTransits'

    showTransits:
      # progress:    7
      header:      translate 'span', 'initialTutorial.showTransits.header'
      instruction: translate 'span', 'initialTutorial.showTransits.content'
      attachment:  [0.0, 0.5, "#graph-container", 0.0, 0.5]

      # demo: -> # TODO: Fix. This doesn't work!
      #   # modify this to fit the light curve
      #   window.classifier.canvasGraph.highlightCurve(2.75,3.00)
      #   window.classifier.canvasGraph.highlightCurve(6.00,6.30)
      #   window.classifier.canvasGraph.highlightCurve(9.25,9.50)
      #   window.classifier.canvasGraph.highlightCurve(12.60,12.85)
      #   window.classifier.canvasGraph.highlightCurve(15.80,16.12)
      #   window.classifier.canvasGraph.highlightCurve(19.15,19.45)
      #   window.classifier.canvasGraph.highlightCurve(22.48,22.75)
      #   window.classifier.canvasGraph.highlightCurve(25.72,26.00)
      #   window.classifier.canvasGraph.highlightCurve(29.00,29.34)
      #   window.classifier.canvasGraph.highlightCurve(32.34,32.60)
      #   $('.mark').fadeOut(600)

      next: ->
        @el.style.setProperty("width", "35%") # reset element width
        'zooming'


    zooming:
      # progress:    8
      header:      translate 'span', 'initialTutorial.zooming.header'
      content:     translate 'span', 'initialTutorial.zooming.content'
      arrow:       'right'
      attachment:  [1.1, 0.5, "#zoom-button", 0.5, 0.5]
      actionable:  '[id="zoom-button"]'
      next: ->

        if window.classifier.splitDesignation in ['a', 'b', 'c', 'd', 'e', 'f']
          return 'talk'
        else
          return 'goodLuck'
          
    talk:
      # progress:    9
      header:      translate 'span', 'initialTutorial.talk.header'
      content:     translate 'span', 'initialTutorial.talk.content'
      attachment:  [0.5, 0.5, "#graph-container", 0.5, 0.5]
      next: 'goodLuck'

    goodLuck:
      # progress:    9
      header:      translate 'span', 'initialTutorial.goodLuck.header'
      content:     translate 'span', 'initialTutorial.goodLuck.content'
      attachment:  [0.5, 0.5, "#graph-container", 0.5, 0.5]
      next: ->
    # /// END TUTORIAL STEPS ///

module.exports = initialTutorialSteps
