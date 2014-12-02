BaseController = require 'zooniverse/controllers/base-controller'
{calculateStar, calculatePlanetCharacteristics} = require '../lib/calculator'
$ = window.jQuery

SubNav = require "../lib/sub-nav"


class Education extends BaseController
  className: 'education'
  template: require '../views/education'

  events:
    'click button[name="calculate-star"]'         : 'onClickCalculateStar'
    'click button[name="calculate-planet"]'       : 'onClickCalculatePlanet'
    'click button[name="calculate-planet-reset"]' : 'onClickCalculatePlanetReset'


  constructor: ->
    super
    activateSubNav = new SubNav("education")

  onClickCalculateStar: (e) =>
    e.preventDefault()
    data = 
      mag:  $('[name="mag"').val()
      temp: $('[name="temp"').val()
      radS: $('[name="radS"').val()
    calculateStar(data)

  onClickCalculatePlanet: (e) =>
    e.preventDefault()
    data = 
      mag:    $('[name="mag"').val()
      temp:   $('[name="temp"').val()
      radS:   $('[name="radS"').val()
      actB:   $('[name="actB"').val()
      estB:   $('[name="estB"').val()
      period: $('[name="period"').val()
    calculatePlanetCharacteristics(data)

  onClickCalculatePlanetReset: (e) =>
    e.preventDefault()
    
    $('[name="mag"').val(0)
    $('[name="temp"').val(0)
    $('[name="radS"').val(0)
    $('[name="actB"').val(0)
    $('[name="estB"').val(0)
    $('[name="period"').val(0)

module.exports = Education