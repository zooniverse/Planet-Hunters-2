BaseController = require 'zooniverse/controllers/base-controller'
calculateStar = require '../lib/calculator'
$ = window.jQuery

SubNav = require "../lib/sub-nav"


class Education extends BaseController
  className: 'education'
  template: require '../views/education'

  events:
    'click button[name="calculate-star"]'  : 'calculateStar'
    'click button[name="calculate-planet"]': 'calculatePlanet'

  constructor: ->
    super
    activateSubNav = new SubNav("education")

  calculateStar: (e) =>
    console.log 'calculating mass...', e
    e.preventDefault()
    data = 
      mag:  $('[name="mag"').val()
      temp: $('[name="temp"').val()
      radS: $('[name="radS"').val()

    calculateStar(data)



module.exports = Education