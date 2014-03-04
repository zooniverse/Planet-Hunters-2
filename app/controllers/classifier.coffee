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

  events:
    'click button[id="toggle-zoom"]' : 'onToggleZoom'
    'click button[id="toggle-fav"]'  : 'onToggleFav'
    'click button[id="help"]'        : 'onClickHelp'
    'click button[id="tutorial"]'    : 'onClickTutorial'
    'click button[id="no-transits"]' : 'onClickNoTransits'
      
  
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

    @zoomBtn.addEventListener 'click', (e) => @onClickZoom()

  onClickZoom: ->
    @zoomed = !@zoomed
    if @zoomed then @canvasState.plotZoomedPoints(5,20) else @canvasState.rescale()

  onToggleZoom: ->
    zoomButton = @el.find("#toggle-zoom")[0]
    if @isZoomed
      @isZoomed = false
      zoomButton.innerHTML = '<img src="images/icons/toolbar-zoomplus.png">Zoom'
      @el.find("#toggle-zoom").removeClass("toggled")
    else
      @isZoomed = true
      zoomButton.innerHTML = '<img src="images/icons/toolbar-zoomminus.png">Zoom'
      @el.find("#toggle-zoom").addClass("toggled")

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

  onClickTutorial: ->
    console.log 'onClickTutorial()'

  onClickNoTransits: ->
    console.log 'onClickNoTransits()'


module.exports = Classifier