BaseController = require 'zooniverse/controllers/base-controller'
{ loadImage } = require './utils'

class Modal extends BaseController
  template: require '../views/widgets/modal'

  src: null

  constructor: (params) ->
    @[key] = value for own key, value of params when key of @

    @render()

    @modal.on 'click', @close

  render: =>
    $('body').append @template @

    @modal = $('#modal')
    @modalImage = $('#modal-image')

    @modal.fadeIn()

    loadImage @src, (img) =>
      @modalImage.attr 'src', img.src
      @modalImage.fadeIn()
      @modalImage.css
        top: -(@modalImage.height() / 2)
        left: -(@modalImage.width() / 2)

  close: =>
    @modal.fadeOut =>
      @modal.remove()

  reset: =>
    @eolMediaURL = ''

    @rightsHolder = null
    @license = null
    @agents = []

module.exports = Modal