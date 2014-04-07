BaseController = require 'zooniverse/controllers/base-controller'
$ = window.jQuery
class HomePage extends BaseController
  className: 'home-page'
  template: require '../views/home-page'

  constructor: ->
    super

  activate: -> $('.site-navigation').addClass("home")

  deactivate: -> $('.site-navigation').removeClass("home")

module.exports = HomePage
