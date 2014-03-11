BaseController = require 'zooniverse/controllers/base-controller'
$ = window.jQuery

class SiteNavigation extends BaseController
  tagName: 'nav'
  className: 'site-navigation'
  template: require '../views/site-navigation'

  activeClass: 'active'

  elements:
    '.link'      : 'link'
    '.links'     : 'links'
    '.learn-more': 'learnMore'
    '#hamburger' : 'hamburger'
    '#user-icon' : 'userIcon'
    '#close'     : 'closeIcon'

  events:
    'click .learn-more': 'onClickLearnMore'
    'click #hamburger' : 'onClickHamburger'
    'click #user-icon' : 'onClickUserIcon'
    'click #close'     : 'onClickClose'
    'click .link'      : 'onClickLink'

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
    @mobileNav = true
    @hamburger.hide()
    @links.slideDown(250)
    @closeIcon.show()

  onClickClose: ->
    @mobileNav = false
    @closeIcon.hide()
    @links.slideUp(250)
    @hamburger.show()

  onClickLink: -> @onClickClose() if @mobileNav

  onClickUserIcon: -> console.log "user icon"

module.exports = SiteNavigation
