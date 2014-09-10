BaseController = require 'zooniverse/controllers/base-controller'
SubNav = require '../lib/sub-nav'

$ = window.jQuery
class SciencePage extends BaseController
  className: 'science-page'
  template: require '../views/science-page'

  events:
    'click .faq.link': 'scrollToLink'
    'click .faq.up'  : 'scrollToTop'

  constructor: ->
    super
    activateSubNav = new SubNav("science")
    $('body').animate({scrollTop: 0})

  scrollToLink: (e) ->
    $('body').animate({
        scrollTop: $("##{e.target.getAttribute "target"}").offset().top
    }, 1000, 'easeInOutExpo');

module.exports = SciencePage