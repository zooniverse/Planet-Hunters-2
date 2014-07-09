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

class ProfilePaginator extends Paginator
  typeCount: ->
    count = if @type is Recent
      User.current?.project?.classification_count
    else if @type is Favorite
      User.current?.project?.favorite_count
    else
      super

    count || 0

class Profile extends BaseProfile
  className: 'profile'
  template: require '../views/profile'

  # use custom template for light curves
  recentTemplate: customItemTemplate
  favoriteTemplate: customItemTemplate
  
  events:
    'click button[name="unfavorite"]': 'onClickUnfavorite'
    'click button[name="turn-page"]': 'onTurnPage'

  elements:
    "#greeting": "greeting"
    'nav': 'navigation'
    'button[name="turn-page"]': 'pageTurners'

  constructor: ->
    super
    # @profile = new BaseProfile
    # @el.find('#secondary-white').append @profile.el
    setTimeout =>
      @greeting.html("Hello #{User.current.name}!") if User.current
    , 1000

module.exports = Profile