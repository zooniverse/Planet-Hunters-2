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

    @targetCount = 5
    @count = 0

  onUserChange: (e, user) =>
    return unless window.app.stack.activePage.target.constructor.name is "Verification"
    # console.log 'verify: onUserChange()'
    Subject.next() unless @classification?

  onSubjectFetch: (e, user) =>
    return unless window.app.stack.activePage.target.constructor.name is "Verification"
    # console.log 'verify: onSubjectFetch()'

  onSubjectSelect: (e, subject) =>
    # return unless window.app.stack.activePage.target.constructor.name is "Verification"
    # console.log 'verify: onSubjectSelect()'
    @subject = subject
    @classification = new Classification {subject}
    @loadSubject()

  loadSubject: ->
    return # KEEP WHILE VERIFICATION NOT IN USE
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

    if window.location.origin != "http://planethunters.org"
      jsonFile = jsonFile.replace("http://www.planethunters.org/", "https://s3.amazonaws.com/zooniverse-static/planethunters.org/")

    $.getJSON jsonFile, (data) =>
      canvasGraph = new CanvasGraph(canvas, data)
      canvasGraph.disableMarking()
      canvasGraph.showAxes = false
      canvasGraph.leftPadding = 0
      canvasGraph.plotPoints(1,2)

    jsonFile = @subject.location['14-2'] # read actual subject

    if window.location.origin != "http://planethunters.org"
      jsonFile = jsonFile.replace("http://www.planethunters.org/", "https://s3.amazonaws.com/zooniverse-static/planethunters.org/")

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
    @count++
    console.log 'count: ', @count

    # back to marking
    if @count > @targetCount
      unless window.matchMedia("(min-device-width: 320px)").matches and window.matchMedia("(max-device-width: 480px)").matches
        @count = 0
        location.hash = "#/classify"

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

  onClickNotSureButton: ->
    # got to classify mode (for debug)
    location.hash = "#/classify"

  showSummary: ->
    @message.html "Ready to move on?"
    @summaryMessage.html("") # place a post classify message to users here if desired
    @summary.show()
    @showNextSubjectButton()

  showNextSubjectButton: ->
    @nextSubjectButton.show()
    button.hide() for button in [@yesButton, @noButton, @notSureButton]

module.exports = Verification
