BaseController = require 'zooniverse/controllers/base-controller'
SubNav = require '../lib/sub-nav'

$ = window.jQuery
class K2Page extends BaseController
    className: 'k2-page'
    template: require '../views/k2-page'

    constructor: ->
      super

module.exports = K2Page
