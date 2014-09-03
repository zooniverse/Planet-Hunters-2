$ = window.jQuery
BaseController             = require 'zooniverse/controllers/base-controller'
Subject                    = require 'zooniverse/models/subject'
Recent                     = require 'zooniverse/models/recent'
Favorite                   = require 'zooniverse/models/favorite'
User                       = require 'zooniverse/models/user'
customItemTemplate         = require '../views/custom-profile-item'
{CanvasGraph, Marks, Mark} = require '../lib/canvas-graph'
LightcurveViewer           = require '../controllers/lightcurve-viewer'


getParameterByName = (name) ->
  name = name.replace(/[\[]/, "\\[").replace(/[\]]/, "\\]")
  regex = new RegExp("[\\?&]" + name + "=([^&#]*)")
  results = regex.exec(location.search)
  (if not results? then "" else decodeURIComponent(results[1].replace(/\+/g, " ")))

# Paginator::addItemToContainer = (item) ->
#   itemEl = @getItemEl item
#   itemEl.prependTo @itemsContainer

#   { subjects } = item
#   location = subjects[0].selected_light_curve?.location
#   location ?= subjects[0].location

#   itemEl.data "location", location

#   $.getJSON location, (data) =>
#     newCanvas = $("##{ subjects[0].id }")[0]
#     newCanvas.width = 1050
#     newCanvas.height = 158
#     newGraph = new CanvasGraph newCanvas, data
#     newGraph.showAxes = false
#     newGraph.leftPadding = 0
#     # newGraph.enableMarking()
#     newGraph.disableMarking()
#     newGraph.plotPoints()

#   itemEl

class ViewLightcurve extends BaseController
  className: 'view-lightcurve'
  template: require '../views/view-lightcurve'

  # @currElement = null

  # # use custom template for light curves
  # recentTemplate: customItemTemplate
  # favoriteTemplate: customItemTemplate
  
  # events:
  #   'click button[name="unfavorite"]': 'onClickUnfavorite'
  #   'click button[name="turn-page"]': 'onTurnPage'
  #   'click .item': 'onClickItem'
  #   'click button[class="lightcurve-viewer-close"]': 'onClickClose'

  # elements:
  #   "#greeting": "greeting"
  #   'nav': 'navigation'
  #   'button[name="turn-page"]': 'pageTurners'

  constructor: ->
    super
    location = "https://s3.amazonaws.com/demo.zooniverse.org/planet_hunter/beta_subjects/2423549_1-1.json"
    # location = "https://s3.amazonaws.com/demo.zooniverse.org/planet_hunter/beta_subjects/#{star_id}_#{quarter}.json"

    star_id = getParameterByName "star_id"
    quarter = getParameterByName "quarter"

    console.log 'star_id: ', star_id
    console.log 'quarter: ', quarter
    console.log "https://dev.zooniverse.org/projects/planet_hunter/subjects/?star_id=#{star_id}&quarter=#{quarter}"

    $.getJSON "https://dev.zooniverse.org/projects/planet_hunter/subjects/#{star_id}", (foo) =>
      location = foo.location["#{quarter}"]
      console.log 'location: ', location

      if location is undefined
        @el.find('.content').append '<p>LIGHT CURVE NOT FOUND</p>'
        return

      $.getJSON location, (data) =>

        newCanvas = document.createElement("canvas")
        newCanvas.width = 1050
        newCanvas.height = 158
        @el.find('.content').append newCanvas

        newGraph = new CanvasGraph newCanvas, data
        newGraph.showAxes = false
        newGraph.leftPadding = 0
        # newGraph.enableMarking()
        newGraph.disableMarking()
        newGraph.plotPoints()

        lightcurveViewer = new LightcurveViewer location
        lightcurveViewer.el.appendTo @el.find('.content')
        
        # temporary code
        @el.find('.lightcurve-viewer-close').hide()
        @el.find('#subject-container').show()

      # @currentItem.find('#subject-container').slideDown(300)
      # @currentItem.find('.graph-container').delay(300).slideUp(300)
      # @currentItem.find('.lightcurve-viewer-close').fadeIn(300)

  # onClickItem: (e) ->
  #   # console.log 'onClickItem(): '
  #   @currentItem = $(e.currentTarget)

  #   return if @currentItem.hasClass('viewing')
  #   @resetItems()

  #   for item in [ $('.item')... ]
  #     $(item).removeClass 'viewing'

  #   for viewer in [ $('.lightcurve-viewer')... ]
  #     viewer.remove()
  #   @currentItem.addClass 'viewing'

  #   lightcurveViewer = new LightcurveViewer @currentItem.data('location')
  #   lightcurveViewer.el.appendTo e.currentTarget
  #   @currentItem.find('#subject-container').slideDown(300)
  #   @currentItem.find('.graph-container').delay(300).slideUp(300)
  #   @currentItem.find('.lightcurve-viewer-close').fadeIn(300)

  #   $('html,body').animate({scrollTop: lightcurveViewer.el.offset().top-($(window).height()-502)/2}, 1000);

  # resetItems: ->
  #   # console.log 'resetItems(): '
  #   @el.find('.item .graph-container').fadeIn(300)
  #   @el.find('.lightcurve-viewer-close').hide()

  # onClickClose: (e) ->
  #   # console.log 'onClickClose(): '
  #   e.stopPropagation() # otherwise, lightcurve viewer reopens
  #   @resetItems()
  #   @currentItem.removeClass('viewing')

  #   # remove all previous lightcurve viewers
  #   viewer.remove() for viewer in [ $('.lightcurve-viewer')... ]
    
module.exports = ViewLightcurve
