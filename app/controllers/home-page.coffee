BaseController = require 'zooniverse/controllers/base-controller'
$ = window.jQuery
class HomePage extends BaseController
  className: 'home-page'
  template: require '../views/home-page'
module.exports = HomePage