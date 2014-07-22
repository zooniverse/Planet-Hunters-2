$ = window.jQuery

BaseController             = require 'zooniverse/controllers/base-controller'
BaseProfile                = require 'zooniverse/controllers/profile'
Subject                    = require 'zooniverse/models/subject'
Recent                     = require 'zooniverse/models/recent'
Favorite                   = require 'zooniverse/models/favorite'
User                       = require 'zooniverse/models/user'
customItemTemplate         = require '../views/custom-profile-item'
Paginator                  = require 'zooniverse/controllers/paginator'
{CanvasGraph, Marks, Mark} = require '../lib/canvas-graph'
LightcurveViewer           = require '../controllers/lightcurve-viewer'

Paginator::addItemToContainer = (item) ->
  itemEl = @getItemEl item
  itemEl.prependTo @itemsContainer

  { subjects } = item
  location = subjects[0].selected_light_curve?.location
  location ?= subjects[0].location

  $.getJSON location, (data) =>
    newCanvas = $("##{ subjects[0].id }")[0]
    newCanvas.width = 1050
    newCanvas.height = 158
    newGraph = new CanvasGraph newCanvas, data
    newGraph.showAxes = false
    newGraph.leftPadding = 0
    newGraph.disableMarking()
    newGraph.plotPoints()

  itemEl

class Profile extends BaseProfile
  className: 'profile'
  template: require '../views/profile'

  @currElement = null

  # use custom template for light curves
  recentTemplate: customItemTemplate
  favoriteTemplate: customItemTemplate
  
  events:
    'click button[name="unfavorite"]': 'onClickUnfavorite'
    'click button[name="turn-page"]': 'onTurnPage'
    'click .item': 'onClickItem'
    'click button[class="lightcurve-viewer-close"]': 'onClickClose'

  elements:
    "#greeting": "greeting"
    'nav': 'navigation'
    'button[name="turn-page"]': 'pageTurners'

  onClickItem: (e) ->
    console.log 'onClickItem(): '

    @currentElement = $(e.currentTarget)
    
    if $(e.currentTarget).hasClass('viewing')
      console.log 'ALREADY VIEWING'
      return

    for item in [ $('.item')... ]
      $(item).removeClass 'viewing'

    # $(e.target).find('.graph-container').hide()

    for viewer in [ $('.lightcurve-viewer')... ]
      viewer.remove()
    lightcurveViewer = new LightcurveViewer
    
    $(e.currentTarget).addClass('viewing')
    # lightcurveViewer.hide()
    lightcurveViewer.el.appendTo e.currentTarget
    $(e.currentTarget).find('#subject-container').slideDown()
    $(e.currentTarget).find('.graph-container').hide()

    $('html,body').animate({scrollTop: lightcurveViewer.el.offset().top-200});

  constructor: ->
    super
    setTimeout =>
      @greeting.html("Hello, #{User.current.name}!") if User.current
    , 1000

  onClickClose: (e) ->
    console.log 'onClickClose(): '
    @currentElement.find('.graph-container').fadeIn()

    
    # remove all previous lightcurve viewers
    viewer.remove() for viewer in [ $('.lightcurve-viewer')... ]
    $(e.currentTarget).removeClass('viewing')

    console.log 'GRAPH CONTAINERS: ', $(e.currentTarget).find('.graph-container')

module.exports = Profile
