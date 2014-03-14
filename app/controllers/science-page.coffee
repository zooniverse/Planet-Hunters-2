BaseController = require 'zooniverse/controllers/base-controller'
SubNav = require '../lib/sub-nav'

$ = window.jQuery
class SciencePage extends BaseController
  className: 'science-page'
  template: require '../views/science-page'

  constructor: ->
    super
    activateSubNav = new SubNav("science")

module.exports = SciencePage