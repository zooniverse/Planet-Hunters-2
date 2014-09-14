$ = window.jQuery
BaseController             = require 'zooniverse/controllers/base-controller'
Subject                    = require 'zooniverse/models/subject'
Recent                     = require 'zooniverse/models/recent'
Favorite                   = require 'zooniverse/models/favorite'
User                       = require 'zooniverse/models/user'
customItemTemplate         = require '../views/custom-profile-item'
{CanvasGraph, Marks, Mark} = require '../lib/canvas-graph'
LightcurveViewer           = require '../controllers/lightcurve-viewer'

class ViewLightcurve extends BaseController
  className: 'view-lightcurve'
  template: require '../views/view-lightcurve'

  constructor: ->
    super
    location = "https://s3.amazonaws.com/demo.zooniverse.org/planet_hunter/beta_subjects/2423549_1-1.json"
    # location = "https://s3.amazonaws.com/demo.zooniverse.org/planet_hunter/beta_subjects/#{star_id}_#{quarter}.json"

    star_id = @getParameterByName "star_id"
    quarter = @getParameterByName "quarter"

    console.log 'star_id: ', star_id
    console.log 'quarter: ', quarter

    if star_id is "" or quarter is ""
      @el.find('.content').append '<p style="color: #fc4541; margin: 20px;">You must enter both the STAR_ID and QUARTER</p>'
      return

    # console.log "https://dev.zooniverse.org/projects/planet_hunter/subjects/?star_id=#{star_id}&quarter=#{quarter}"

    $.getJSON "https://dev.zooniverse.org/projects/planet_hunter/subjects/#{star_id}", (subjectJson) =>

      location = subjectJson.location["#{quarter}"]

      if location is undefined or location is ""
        @el.find('.content').append '<p style="color: #fc4541; margin: 20px;">LIGHT CURVE NOT FOUND</p>'
        return

      $.getJSON location, (data) =>

        newCanvas = document.createElement("canvas")
        newCanvas.width = 1050
        newCanvas.height = 158
        # @el.find('.content').append newCanvas

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

  getParameterByName: (name) ->
    name = name.replace(/[\[]/, "\\[").replace(/[\]]/, "\\]")
    regex = new RegExp("[\\?&]" + name + "=([^&#]*)")
    results = regex.exec(location.search)
    (if not results? then "" else decodeURIComponent(results[1].replace(/\+/g, " ")))


    
module.exports = ViewLightcurve
