BaseController = require 'zooniverse/controllers/base-controller'
$ = window.jQuery
class AboutPage extends BaseController
  className: 'about-page'
  template: require '../views/about-page'
module.exports = AboutPage