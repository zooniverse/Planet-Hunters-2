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

    console.log 'onSubjectSelect()'
    console.log 'window.zooniverse.models.Recent.instances: ', window.zooniverse.models.Recent.instances

    #  create canvas Elements
    @canvasElements = []
    @graphs = []
    # for recent, i in window.zooniverse.models.Recent.instances
    i = 0
    newElement = document.createElement('canvas')
    newElement.id     = "graph-#{i}"
    newElement.width  = 600
    newElement.height = 150
    newElement.setAttribute 'class', 'graph'

    @canvasElements.push(newElement)
    $('.items')[0].appendChild(@canvasElements[i])

    console.log "canvasElements[#{i}]: ", @canvasElements[i]

    # get data
    # jsonFile = "test_data/testLightCurve.json"
    jsonFile = window.zooniverse.models.Recent.instances[3].subjects[0].location
    console.log "JSON FILE:::::::::::::::::: #{jsonFile}"
    $.getJSON jsonFile, (data) =>
      console.log 
      console.log 'BLAH: ', @canvasElements[i]
      newGraph = new CanvasGraph(@canvasElements[i], data)
      newGraph.showAxes = false
      newGraph.leftPadding = 0
      newGraph.disableMarking()
      newGraph.plotPoints()
      @graphs.push(newGraph)


module.exports = Profile