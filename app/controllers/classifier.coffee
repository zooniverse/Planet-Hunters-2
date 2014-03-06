BaseController = require 'zooniverse/controllers/base-controller'
FauxRangeInput = require 'faux-range-input'

$ = window.jQuery
require '../lib/sample-data'

{CanvasGraph, Marks, Mark} = require "../lib/canvas-graph"

class Classifier extends BaseController
  className: 'classifier'
  template: require '../views/classifier'

  elements:
    '#toggle-zoom'      : 'zoomButton'
    '#toggle-fav'       : 'favButton'
    '#help'             : 'helpButton'
    '#tutorial'         : 'tutorialButton'
    '#scale-slider'     : 'scaleSlider'

  events:
    'click button[id="toggle-zoom"]' : 'onToggleZoom'
    'click button[id="toggle-fav"]'  : 'onToggleFav'
    'click button[id="help"]'        : 'onClickHelp'
    'click button[id="tutorial"]'    : 'onClickTutorial'
    'click button[id="no-transits"]' : 'onClickNoTransits'
    'click img[id="lesson-close"]'   : 'onClickLessonClose'
    'change input[id="scale-slider"]': 'onChangeScaleSlider'
  
  constructor: ->
    super
    isZoomed: false
    ifFaved: false
    @scaleSlider = new FauxRangeInput('#scale-slider')

    @canvas = @el.find('#graph')[0]
    @zoomBtn = @el.find('#toggle-zoom')[0]
    @marksContainer = @el.find('#marks-container')[0]
    @zoomBtn = @el.find('#toggle-zoom')[0]

    @canvasState = new CanvasGraph(@canvas, light_curve_data)
    @canvasState.plotPoints()

    console.log @canvasState.largestX
    @el.find("#scale-slider").attr "max", @canvasState.largestX
    @el.find("#scale-slider").attr "min", @canvasState.smallestX

  onChangeScaleSlider: ->
    @zoomRange = 15
    @focusCenter = +@el.find('#scale-slider').val() + @zoomRange/2
    
    xMin = @focusCenter-@zoomRange/2
    xMax = @focusCenter+@zoomRange/2

    return unless @isZoomed
    @canvasState.plotPoints(xMin,xMax)

    console.log "data center: ", @focusCenter
    # console.log 'data largestX : ', @canvasState.largestX
    # console.log 'data smallestX: ', @canvasState.smallestX
    # console.log 'Data domain  : [', @canvasState.toDataXCoord(xMin), ',', @canvasState.toDataXCoord(xMax), ']'
    # console.log 'Canvas domain: [', xMin, ',', xMax, ']'
    
  onToggleZoom: ->
    @isZoomed = !@isZoomed
    zoomButton = @el.find("#toggle-zoom")[0]
    if @isZoomed
      @canvasState.plotPoints(@focusCenter-@zoomRange/2,@focusCenter+@zoomRange/2)
      zoomButton.innerHTML = '<img src="images/icons/toolbar-zoomminus.png">Zoom'
      @el.find("#toggle-zoom").addClass("toggled")
      @el.find("#scale-slider").addClass("active")
    else
      @canvasState.plotPoints()
      zoomButton.innerHTML = '<img src="images/icons/toolbar-zoomplus.png">Zoom'
      @el.find("#toggle-zoom").removeClass("toggled")
      @el.find("#scale-slider").removeClass("active")


  onToggleFav: ->
    favButton = @el.find("#toggle-fav")[0]
    if @isFaved
      @isFaved = false
      favButton.innerHTML = '<img src="images/icons/toolbar-fav-empty.png">+Fav'
      @el.find("#toggle-fav").removeClass("toggled")
    else
      @isFaved = true
      favButton.innerHTML = '<img src="images/icons/toolbar-fav-filled.png">+Fav'
      @el.find("#toggle-fav").addClass("toggled")
    
  onClickHelp: ->
    console.log 'onClickHelp()'
    console.log @el.find("#scale-slider")

  onClickTutorial: ->
    console.log 'onClickTutorial()'

  onClickNoTransits: ->
    console.log 'onClickNoTransits()'

  onClickLessonClose: ->
    console.log 'onClickLessonClose()'


module.exports = Classifier