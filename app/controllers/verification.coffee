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
    '#summary' :  'summary'
    '#user-message' : 'message'
    '#summary-message': 'summaryMessage'

  events:
    'click button[name="yes"]': 'onClickYesButton'
    'click button[name="no"]' : 'onClickNoButton'
    'click button[name="not-sure"]': 'onClickNotSureButton'
    'click button[name="next-subject"]': 'onClickNextSubject'

  constructor: ->
    super
    @loadSubject()

  loadSubject: ->
    @dataIndex ||= 0
    @canvas = @el.find('#verify-graph')[0]

    # sampleData[@dataIndex] will become a subjects data from the server
    # plotPoints will take in the minX and maxX of that subject
    @canvasGraph = new CanvasGraph(@canvas, sampleData[@dataIndex]).plotPoints(2,4)

    @message.html "Is this a proper transit?"

    # sampleData[@dataIndex+1] will become the next subject after that's data
    # plotPoints will take in the minX and maxX of that subject
    upcomingSubject = new CanvasGraph(@el.find("#left-graph")[0], sampleData[@dataIndex+1]).plotPoints(2,4)

  onClickYesButton: -> @showSummary()

  onClickNoButton: -> @showSummary()

  onClickNextSubject: ->
    button.show() for button in [@yesButton, @noButton, @notSureButton]
    @nextSubjectButton.hide()
    @summary.hide()
    @message.html "Is this a proper transit?"

    oldSubject = new CanvasGraph(@el.find("#right-graph")[0], sampleData[@dataIndex]).plotPoints(2,4)

    @dataIndex += 1
    @loadSubject()

  onClickNotSureButton: -> console.log "NOT SURE"

  showSummary: -> 
    @message.html "Ready to move on?"
    @summaryMessage.html("") # place a post classify message to users here if desired
    @summary.show()
    @showNextSubjectButton()

  showNextSubjectButton: ->
    console.log "call @loadSubject(NEXT_SUBJECTS_DATA) here)"
    @nextSubjectButton.show()
    button.hide() for button in [@yesButton, @noButton, @notSureButton]


module.exports = Verification