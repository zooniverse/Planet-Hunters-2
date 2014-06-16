BaseController = require 'zooniverse/controllers/base-controller'
Subject        = require 'zooniverse/models/subject'
Classification = require 'zooniverse/models/classification'
User           = require 'zooniverse/models/user'
{CanvasGraph, Marks, Mark} = require "../lib/canvas-graph"
require '../lib/sample-data'

$ = window.jQuery

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
    window.verification = @

    User.on 'change', @onUserChange
    Subject.on 'fetch', @onSubjectFetch
    Subject.on 'select', @onSubjectSelect
    @Subject = Subject

  onUserChange: (e, user) =>
    console.log 'verify: onUserChange()'
    Subject.next() unless @classification?

  onSubjectFetch: (e, user) =>
    console.log 'verify: onSubjectFetch()'

  onSubjectSelect: (e, subject) =>
    console.log 'verify: onSubjectSelect()'
    @subject = subject
    @classification = new Classification {subject}
    @loadSubject()
    
  loadSubject: ->
    middleStart = @el.find('#verify-main')[0] # TODO: index is annoying
    middleStart.width = 300
    middleStart.height = 300
    startCanvas = new CanvasGraph(middleStart, sampleData[3])
    startCanvas.plotPoints() # comment for now
    
    jsonFile = @subject.location['14-1'] # read actual subject
    canvas?.remove() # kill any previous canvas

    # @dataIndex ||= 0
    canvas = @el.find('#verify-done')[0]
    canvas.width = 300
    canvas.height = 300

    $.getJSON jsonFile, (data) =>
      # @canvasGraph?.marks.destroyAll()  
      @canvasGraph = new CanvasGraph(canvas, data)
      @canvasGraph.plotPoints()

    # @canvasGraph = new CanvasGraph(canvas, sampleData[@dataIndex])
    # console.log 'calling plotPoints()...'
    # @canvasGraph.plotPoints() # comment for now
    # console.log 'Done!'
    # @message.html "Is this a proper transit?"

  onClickYesButton: -> @showSummary()

  onClickNoButton: -> @showSummary()

  onClickNextSubject: ->
    button.show() for button in [@yesButton, @noButton, @notSureButton]
    @nextSubjectButton.hide()
    @summary.hide()
    @message.html "Is this a proper transit?"

    @dataIndex += 1

    canvasContainer = document.getElementById('canvas-container')
    firstChild = canvasContainer.children[0]
    canvasContainer.appendChild(firstChild)

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