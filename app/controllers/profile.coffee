BaseController = require 'zooniverse/controllers/base-controller'
$ = window.jQuery
class Profile extends BaseController
  className: 'profile'
  template: require '../views/profile'
module.exports = Profile