BaseController = require 'zooniverse/controllers/base-controller'
{CanvasGraph, Marks, Mark} = require "../lib/canvas-graph"
$ = window.jQuery
require '../lib/sample-data'

class Verification extends BaseController
  className: 'verification'
  template: require '../views/verification'

  elements:
    'button[name="yes"]': 'yesButton'
    'button[name="no"]' : 'noButton'
    'button[name="not-sure"]': 'notSureButton'
    'button[name="next-subject"]': 'nextSubjectButton'
    '#summary'       : 'summary'
    '#user-message' : 'message'
    '#summary-message': 'summaryMessage'

  events:
    'click button[name="yes"]': 'onClickYesButton'
    'click button[name="no"]' : 'onClickNoButton'
    'click button[name="not-sure"]': 'onClickNotSureButton'
    'click button[name="next-subject"]': 'onClickNextSubject'

  constructor: ->
    super
    @loadSubject(light_curve_data)

  loadSubject: (data) ->
    @canvas = @el.find('#verify-graph')[0]
    @canvasGraph = new CanvasGraph(@canvas, data)
    @canvasGraph.plotPoints()
    @message.html "Is this a proper transit?"

  onClickYesButton: -> @showSummary()

  onClickNoButton: -> @showSummary()

  onClickNextSubject: ->
    button.show() for button in [@yesButton, @noButton, @notSureButton]
    @nextSubjectButton.hide()
    @summary.hide()
    @message.html "Is this a proper transit?"

  onClickNotSureButton: -> console.log "NOT SURE"

  showSummary: -> 
    @message.html "Ready to move on?"
    @summaryMessage.html("#{num = Math.round Math.random()*100 + 1} other user#{if num > 1 then 's' else ''} agree")
    @summary.show()
    @showNextSubjectButton()

  showNextSubjectButton: ->
    console.log "call @loadSubject(NEXT_SUBJECTS_DATA) here)"
    @nextSubjectButton.show()
    button.hide() for button in [@yesButton, @noButton, @notSureButton]




module.exports = Verification