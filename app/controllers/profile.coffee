$ = window.jQuery

BaseController = require 'zooniverse/controllers/base-controller'
BaseProfile = require 'zooniverse/controllers/profile'
User = require 'zooniverse/models/user'
customItemTemplate = require '../views/custom-profile-item'

class Profile extends BaseController
  className: 'profile'
  template: require '../views/profile'
  elements:
    "#greeting": "greeting"

  constructor: ->
    super
    console.log customItemTemplate
    BaseProfile::recentTemplate = customItemTemplate
    # BaseProfile::favoriteTemplate = -> customItemTemplate
    @profile = new BaseProfile


    @el.find('#secondary-white').append @profile.el
    @profile.el.addClass 'content-block content-container'
    setTimeout =>
      @greeting.html("Hello #{User.current.name}!") if User.current
    , 1000

module.exports = Profile