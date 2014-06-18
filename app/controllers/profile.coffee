$ = window.jQuery

BaseController = require 'zooniverse/controllers/base-controller'
BaseProfile = require 'zooniverse/controllers/profile'
User = require 'zooniverse/models/user'

class Profile extends BaseController
  className: 'profile'
  template: require '../views/profile'
  elements:
    "#greeting": "greeting"

  constructor: ->
    super
    @profile = new BaseProfile
    @el.find('#secondary-white').append @profile.el
    @profile.el.addClass 'content-block content-container'
    setTimeout =>
      @greeting.html("Hello #{User.current.name}!") if User.current
    , 1000

module.exports = Profile