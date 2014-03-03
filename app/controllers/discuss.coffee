BaseController = require 'zooniverse/controllers/base-controller'
$ = window.jQuery
class Discuss extends BaseController
  className: 'discuss'
  template: require '../views/discuss'
module.exports = Discuss
