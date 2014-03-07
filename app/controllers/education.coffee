BaseController = require 'zooniverse/controllers/base-controller'
$ = window.jQuery
class Education extends BaseController
  className: 'education'
  template: require '../views/education'
module.exports = Education