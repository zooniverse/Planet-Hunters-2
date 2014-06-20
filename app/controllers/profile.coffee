$ = window.jQuery

BaseController     = require 'zooniverse/controllers/base-controller'
BaseProfile        = require 'zooniverse/controllers/profile'
User               = require 'zooniverse/models/user'
customItemTemplate = require '../views/custom-profile-item'
# CanvasGraph        = require '../lib/canvas-graph'

class Profile extends BaseController
  className: 'profile'
  template: require '../views/profile'
  elements:
    "#greeting": "greeting"

  constructor: ->
    super

    # use custom template for light curves
    BaseProfile::recentTemplate = customItemTemplate
    BaseProfile::favoriteTemplate = customItemTemplate
    @profile = new BaseProfile

    # console.log 'JSON FILE: ', subjects[0].location['14-1']

    @el.find('#secondary-white').append @profile.el
    @profile.el.addClass 'content-block content-container'
    setTimeout =>
      @greeting.html("Hello #{User.current.name}!") if User.current
    , 1000

module.exports = Profile