BaseController = require 'zooniverse/controllers/base-controller'
$ = window.jQuery

class SiteNavigation extends BaseController
  tagName: 'nav'
  className: 'site-navigation'
  template: require '../views/site-navigation'

  activeClass: 'active'

  elements:
    'a': 'links'
    '.learn-more': 'learnMore'

  events:
    'click .learn-more': 'onClickLearnMore'

  constructor: ->
    super
    addEventListener 'hashchange', @onHashChange, false
    @onHashChange()

  onHashChange: =>
    @links.removeClass @activeClass
    @links.filter("[href='#{location.hash}']").addClass @activeClass

  onClickLearnMore: =>
    $("html, body").animate scrollTop: $("#home-main-content").offset().top, 350

module.exports = SiteNavigation
