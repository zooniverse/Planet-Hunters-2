BaseController = require 'zooniverse/controllers/base-controller'
Subject        = require 'zooniverse/models/subject'
Classification = require 'zooniverse/models/classification'
User           = require 'zooniverse/models/user'
StackOfPages   = require 'stack-of-pages'
{CanvasGraph, Marks, Mark} = require "../lib/canvas-graph"
require '../lib/sample-data'

$ = window.jQuery

class Verification extends BaseController
  className: 'verification'
  template: require '../views/verification'

  elements:
    'button[name="yes"]'          : 'yesButton'
    'button[name="no"]'           : 'noButton'
    'button[name="not-sure"]'     : 'notSureButton'
    'button[name="next-subject"]' : 'nextSubjectButton'
    '#summary'                    : 'summary'
    '#user-message'               : 'message'
    '#summary-message'            : 'summaryMessage'

  events:
    'click button[name="yes"]'          : 'onClickYesButton'
    'click button[name="no"]'           : 'onClickNoButton'
    'click button[name="not-sure"]'     : 'onClickNotSureButton'
    'click button[name="next-subject"]' : 'onClickNextSubject'

  constructor: ->
    super
    window.verification = @
    @message.html "Is this a proper transit?"

    User.on 'change', @onUserChange
    Subject.on 'fetch', @onSubjectFetch
    Subject.on 'select', @onSubjectSelect
    @Subject = Subject

  onUserChange: (e, user) =>
    return unless window.app.stack.activePage.target.constructor.name is "Verification"
    console.log 'verify: onUserChange()'
    Subject.next() unless @classification?

  onSubjectFetch: (e, user) =>
    return unless window.app.stack.activePage.target.constructor.name is "Verification"
    console.log 'verify: onSubjectFetch()'

  onSubjectSelect: (e, subject) =>
    # return unless window.app.stack.activePage.target.constructor.name is "Verification"
    console.log 'verify: onSubjectSelect()'
    @subject = subject
    @classification = new Classification {subject}
    @loadSubject()

  loadSubject: ->
    # return unless window.app.stack.activePage.target.constructor.name is "Verification"

    # @dataIndex ||= 0
    # canvas = @el.find('#verify-done')[0]
    
    canvas = @el.find('.verify-canvas:nth-child(3)')[0]
    canvas.width = 300
    canvas.height = 300

    # middleStart = @el.find('#verify-main')[0] # TODO: index is annoying
    middleStart = @el.find('.verify-canvas:nth-child(2)')[0]
    middleStart.width = 300
    middleStart.height = 300
    
    jsonFile = @subject.location['14-1'] # read actual subject
    $.getJSON jsonFile, (data) =>
      canvasGraph = new CanvasGraph(canvas, data)
      canvasGraph.disableMarking()
      canvasGraph.showAxes = false
      canvasGraph.leftPadding = 0
      canvasGraph.plotPoints(1,2)

    jsonFile = @subject.location['14-2'] # read actual subject
    $.getJSON jsonFile, (data) =>
      startCanvas = new CanvasGraph(middleStart, data)
      startCanvas.disableMarking()
      startCanvas.showAxes = false
      startCanvas.leftPadding = 0
      startCanvas.plotPoints(1,2) # comment for now
    
    @message.html "Is this a proper transit?"
    return

  onClickYesButton: -> @showSummary()

  onClickNoButton: -> @showSummary()

  onClickNextSubject: ->
    button.show() for button in [@yesButton, @noButton, @notSureButton]
    @nextSubjectButton.hide()
    @summary.hide()
    # @message.html "Is this a proper transit?"
    @dataIndex += 1
    canvasContainer = document.getElementById('canvas-container')
    firstChild = canvasContainer.children[0]
    canvasContainer.appendChild(firstChild)
    @loadSubject()
    @Subject.next()

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