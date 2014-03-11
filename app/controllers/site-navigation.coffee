BaseController = require 'zooniverse/controllers/base-controller'
$ = window.jQuery

class SiteNavigation extends BaseController
  tagName: 'nav'
  className: 'site-navigation'
  template: require '../views/site-navigation'

  activeClass: 'active'

  elements:
    '.links': 'links'
    '.learn-more': 'learnMore'
    '#hamburger' : 'hamburger'
    '#user-icon' : 'userIcon'
    '#close'     : 'closeIcon'

  events:
    'click .learn-more': 'onClickLearnMore'
    'click #hamburger' : 'onClickHamburger'
    'click #user-icon' : 'onClickUserIcon'
    'click #close': 'onClickClose'

  constructor: ->
    super
    addEventListener 'hashchange', @onHashChange, false
    @onHashChange()

  onHashChange: =>
    @links.removeClass @activeClass
    @links.filter("[href='#{location.hash}']").addClass @activeClass

  onClickLearnMore: =>
    $("html, body").animate scrollTop: $("#home-main-content").offset().top, 350

  onClickHamburger: ->
    @hamburger.hide()
    @links.show()
    @closeIcon.show()

  onClickClose: ->
    @closeIcon.hide()
    @links.hide()
    @hamburger.show()

  onClickUserIcon: -> console.log "user icon"

module.exports = SiteNavigation
