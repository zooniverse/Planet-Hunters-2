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

  events:
    'click button[name="yes"]': 'onClickYesButton'
    'click button[name="no"]' : 'onClickNoButton'
    'click button[name="not-sure"]': 'onClickNotSureButton'

  constructor: ->
    super
    @canvas = @el.find('#verify-graph')[0]
    console.log @canvas
    @canvasGraph = new CanvasGraph(@canvas, light_curve_data)
    @canvasGraph.plotPoints()

  onClickYesButton: -> console.log "YES"

  onClickNoButton: -> console.log "NO"

  onClickNotSureButton: -> console.log "NOT SURE"

module.exports = Verification