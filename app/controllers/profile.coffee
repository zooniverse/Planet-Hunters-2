$ = window.jQuery

BaseController     = require 'zooniverse/controllers/base-controller'
BaseProfile        = require 'zooniverse/controllers/profile'
Subject            = require 'zooniverse/models/subject'
Recent             = require 'zooniverse/models/recent'
Favorite           = require 'zooniverse/models/favorite'
User               = require 'zooniverse/models/user'
customItemTemplate = require '../views/custom-profile-item'
CanvasGraph        = require '../lib/canvas-graph'

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

    for recent, i in window.zooniverse.models.Recent.instances
      location = recent.subjects[0].location
      $('.items').prepend """
        <div class='item' json-file=\"#{location}\">
          <a href=\"#{location}\">
            <img src=\"http://lorempixel.com/600/150/\" />
            <div class=\"graph-container\">

            </div>
          </a>
        </div>
      """

  loadSubjectData: (location) ->
    jsonFile = location

    # create new canvas
    @canvas = document.createElement('canvas')
    @canvas.id = 'graph'
    @canvas.width = 600
    @canvas.height = 150
    
    $.getJSON jsonFile, (data) =>
      @canvasGraph = new CanvasGraph(@canvas, data)
      @canvasGraph.plotPoints()
      

module.exports = Profile