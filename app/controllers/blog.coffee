BaseController = require 'zooniverse/controllers/base-controller'
$ = window.jQuery
class Blog extends BaseController
  className: 'blog'
  template: require '../views/blog'
module.exports = Blog