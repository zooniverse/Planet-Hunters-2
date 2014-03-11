BaseController = require 'zooniverse/controllers/base-controller'
$ = window.jQuery

class Verification extends BaseController
  className: 'verification'
  template: require '../views/verification'

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

module.exports = Verification