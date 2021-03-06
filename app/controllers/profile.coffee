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
translate                  = require 't7e'

Paginator::addItemToContainer = (item) ->
  itemEl = @getItemEl item
  itemEl.prependTo @itemsContainer

  { subjects } = item
  location = subjects[0].selected_light_curve?.location
  location ?= subjects[0].location

  if window.location.origin != "http://planethunters.org"  and window.location.origin != "http://www.planethunters.org" and window.location.origin != "https://www.planethunters.org"
    location = location.replace("http://www.planethunters.org/", "https://s3.amazonaws.com/zooniverse-static/planethunters.org/")

  location = location.replace("http://www.planethunters.org/", "https://www.planethunters.org/")

  itemEl.data "location", location


  $.getJSON location, (data) =>
    newCanvas = $("##{ subjects[0].id }")[0]
    newCanvas.width = 1050
    newCanvas.height = 158
    newGraph = new CanvasGraph newCanvas, data
    newGraph.showAxes = false
    newGraph.leftPadding = 0
    # newGraph.enableMarking()
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
    'click .mini-course-trigge'    : 'onMiniCourseTrigger'

  elements:
    "#greeting": "greeting"
    'nav': 'navigation'
    'button[name="turn-page"]': 'pageTurners'

  constructor: ->
    super
    setTimeout =>
      @greeting.html("Hello, #{User.current.name}!") if User.current
      @onNavLoad =>
        $(".profile nav").append("<button style='float:right;width:156px' class='mini-course-trigger'><span>#{translate 'profile.launchMiniCourse'}</span></button>")
        $(".profile nav .mini-course-trigger ").on "click", @onMiniCourseTrigger

        # $(".profile nav").append("<button style='float:right;width:156px' class='mini-course-reset'><span>Reset Mini Course</span></button>")
        # $(".profile nav .mini-course-reset").on "click", @reset

    , 1000

  onNavLoad:(task)=>
    # console.log @, @nav
    if $(".profile nav")
      # console.log "appending"
      task()
    else
      # console.log "waiting"
      setTimeout @onNavLoad, 200

  reset: ->
    classifier.course.resetCourse()

  onMiniCourseTrigger:->
    window.location = '/#/classify'
    classifier.course.launch()

  onClickItem: (e) ->
    # console.log 'onClickItem(): '
    @currentItem = $(e.currentTarget)

    return if @currentItem.hasClass('viewing')
    @resetItems()

    for item in [ $('.item')... ]
      $(item).removeClass 'viewing'

    for viewer in [ $('.lightcurve-viewer')... ]
      viewer.remove()
    @currentItem.addClass 'viewing'

    lightcurveViewer = new LightcurveViewer @currentItem.data('location')
    lightcurveViewer.el.appendTo e.currentTarget
    @currentItem.find('#subject-container').slideDown(300)
    @currentItem.find('.graph-container').delay(300).slideUp(300)
    @currentItem.find('.lightcurve-viewer-close').fadeIn(300)

    $('html,body').animate({scrollTop: lightcurveViewer.el.offset().top-($(window).height()-502)/2}, 1000);

  resetItems: ->
    # console.log 'resetItems(): '
    @el.find('.item .graph-container').fadeIn(300)
    @el.find('.lightcurve-viewer-close').hide()

  onClickClose: (e) ->
    # console.log 'onClickClose(): '
    e.stopPropagation() # otherwise, lightcurve viewer reopens
    @resetItems()
    @currentItem.removeClass('viewing')

    # remove all previous lightcurve viewers
    viewer.remove() for viewer in [ $('.lightcurve-viewer')... ]

module.exports = Profile
