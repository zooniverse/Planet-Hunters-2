$ = window.jQuery

BaseController     = require 'zooniverse/controllers/base-controller'
BaseProfile        = require 'zooniverse/controllers/profile'
Subject            = require 'zooniverse/models/subject'
Recent             = require 'zooniverse/models/recent'
Favorite           = require 'zooniverse/models/favorite'
User               = require 'zooniverse/models/user'
customItemTemplate = require '../views/custom-profile-item'
{CanvasGraph, Marks, Mark} = require '../lib/canvas-graph'

class Profile extends BaseController
  className: 'profile'
  template: require '../views/profile'
  elements:
    "#greeting": "greeting"

  constructor: ->
    super
    className: 'profile'
      
    Subject.on 'select', @onSubjectSelect
    window.profile = @

    # use custom template for light curves
    BaseProfile::recentTemplate = customItemTemplate
    BaseProfile::favoriteTemplate = customItemTemplate
    @profile = new BaseProfile

    # @profile.el.addClass 'content-block content-container' # doesn't seem to do anything
    @el.find('#secondary-white').append @profile.el
    
    setTimeout =>
      @greeting.html("Hello #{User.current.name}!") if User.current
    , 1000

  onSubjectSelect: ->
    #  create canvas Elements
    @canvasElements = []
    @graphs = []
    for recent, i in window.zooniverse.models.Recent.instances
      newCanvasElement = document.createElement('canvas')
      newCanvasElement.id  = "graph-#{i}"
      newCanvasElement.setAttribute 'width','inherit'
      newCanvasElement.setAttribute 'height','inherit'
      newCanvasElement.setAttribute 'class', 'graph'
      newItem = document.createElement('div')
      newItem.setAttribute 'class', 'item'
      newItem.innerHTML = """
          <div id="graph-#{i}-container">
          </div>
        <p class=\"caption\">#{recent.subjects[0].zooniverse_id}</p>
      """
      @canvasElements[i] = newCanvasElement
      $('.items').append newItem
      $("#graph-#{i}-container").append newCanvasElement

      # get data
      # jsonFile = "test_data/testLightCurve.json"
      jsonFile = recent.subjects[0].location
      do(i) =>
        $.getJSON jsonFile, (data) =>
          canvas = $(".graph")[i]
          newGraph = new CanvasGraph( canvas, data )
          newGraph.showAxes = false
          newGraph.leftPadding = 0
          newGraph.disableMarking()
          # debugger
          newGraph.plotPoints()
          @graphs[i] = newGraph

module.exports = Profile