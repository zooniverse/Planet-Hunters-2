BaseController = require 'zooniverse/controllers/base-controller'
$ = window.jQuery

SubNav = require "../lib/sub-nav"

class Education extends BaseController
  className: 'education'
  template: require '../views/education'

  constructor: ->
    super
    activateSubNav = new SubNav("education")
module.exports = Education