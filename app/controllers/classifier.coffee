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
    # 'change input[id="scale-slider"]': 'onChangeScaleSlider'
  
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
    @el.find("#scale-slider").attr "max", 1077 # should eventually be dynamic
    @el.find("#scale-slider").attr "min", 0

  onChangeScaleSlider: ->
    thumbWid = 256
    focusCenter = +@el.find('#scale-slider').val() + thumbWid/2
    console.log "onChangeScaleSlider()"
    console.log " value: ", focusCenter

    xMin = @canvasState.toCanvasXCoord(focusCenter-thumbWid/2)
    xMax = @canvasState.toCanvasXCoord(focusCenter+thumbWid/2)
    @canvasState.plotPoints(xMin,xMax)
  
  onToggleZoom: ->
    @isZoomed = !@isZoomed
    zoomButton = @el.find("#toggle-zoom")[0]
    if @isZoomed
      @canvasState.plotPoints(5,20)
      zoomButton.innerHTML = '<img src="images/icons/toolbar-zoomminus.png">Zoom'
      @el.find("#toggle-zoom").addClass("toggled")
    else
      @canvasState.plotPoints()
      zoomButton.innerHTML = '<img src="images/icons/toolbar-zoomplus.png">Zoom'
      @el.find("#toggle-zoom").removeClass("toggled")

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