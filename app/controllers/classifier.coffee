BaseController = require 'zooniverse/controllers/base-controller'
$ = window.jQuery
class Classifier extends BaseController
  className: 'classifier'
  template: require '../views/classifier'
module.exports = Classifier