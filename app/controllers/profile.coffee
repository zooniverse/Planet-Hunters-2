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

# class ProfilePaginator extends Paginator
#   typeCount: ->
#     count = if @type is Recent
#       User.current?.project?.classification_count
#     else if @type is Favorite
#       User.current?.project?.favorite_count
#     else
#       super

#     count || 0

class Profile extends BaseController
  className: 'profile'
  template: require '../views/profile'
  elements:
    "#greeting": "greeting"

  constructor: ->
    super
    className: 'profile'

    # use custom template for light curves
    BaseProfile::recentTemplate = customItemTemplate
    BaseProfile::favoriteTemplate = customItemTemplate
    @profile = new BaseProfile

    # @profile.el.addClass 'content-block content-container' # doesn't seem to do anything
    @el.find('#secondary-white').append @profile.el
    
    setTimeout =>
      @greeting.html("Hello #{User.current.name}!") if User.current
    , 1000

module.exports = Profile