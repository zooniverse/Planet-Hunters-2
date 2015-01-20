BaseController = require 'zooniverse/controllers/base-controller'
$ = window.jQuery

class VotePage extends BaseController
  className: 'vote-page'
  template: require '../views/vote-page'

module.exports = VotePage
