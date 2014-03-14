BaseController = require 'zooniverse/controllers/base-controller'
SubNav = require "../lib/sub-nav"
$ = window.jQuery
class AboutPage extends BaseController
  className: 'about-page'
  template: require '../views/about-page'

  constructor: ->
    super
    activateSubNav = new SubNav("about")

module.exports = AboutPage