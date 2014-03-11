BaseController = require 'zooniverse/controllers/base-controller'
$ = window.jQuery
class MobileClassify extends BaseController
  className: 'mobile-classify'
  template: require '../views/mobile-classify'

  elements:
    'button[name="yes"]': 'yesButton'
    'button[name="no"]' : 'noButton'
    'button[name="not-sure"]': 'notSureButton'

  events:
    'click button[name="yes"]': 'onClickYesButton'
    'click button[name="no"]' : 'onClickNoButton'
    'click button[name="not-sure"]': 'onClickNotSureButton'

  constructor: ->
    super

  onClickYesButton: -> console.log "YES"

  onClickNoButton: -> console.log "NO"

  onClickNotSureButton: -> console.log "NOT SURE"


module.exports = MobileClassify