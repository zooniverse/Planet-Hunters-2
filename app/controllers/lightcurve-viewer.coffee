BaseController             = require 'zooniverse/controllers/base-controller'
User                       = require 'zooniverse/models/user'
Subject                    = require 'zooniverse/models/subject'
NoUiSlider                 = require '../lib/jquery.nouislider.min'
translate                  = require 't7e'
{CanvasGraph, Marks, Mark} = require "../lib/canvas-graph"
$ = window.jQuery


getParameterByName = (name) ->
  name = name.replace(/[\[]/, "\\[").replace(/[\]]/, "\\]")
  regex = new RegExp("[\\?&]" + name + "=([^&#]*)")
  results = regex.exec(location.search)
  (if not results? then "" else decodeURIComponent(results[1].replace(/\+/g, " ")))

JSON_FILE = getParameterByName "JsonFile"
console.log 'JSON_FILE: ', JSON_FILE

class LightcurveViewer extends BaseController
  className: 'lightcurve-viewer'
  template: require '../views/lightcurve-viewer'

  events:
    'click button[id="zoom-button"]'          : 'onClickZoom'
    'slide #ui-slider'                        : 'onChangeScaleSlider'
    
  constructor: ->
    super    
    window.viewer = @

    isZoomed: false
    ifFaved: false

    User.on 'change', @onUserChange
    Subject.on 'fetch', @onSubjectFetch
    Subject.on 'select', @onSubjectSelect
    @Subject = Subject
    @marksContainer = @el.find('#marks-container')[0]

  onUserChange: (e, user) =>
    # if User.current? # user logged in
    #   # do something

  onSubjectFetch: (e, user) =>

  onSubjectSelect: (e, subject) =>
    @subject = subject
    # @classification = new Classification {subject}
    @loadSubjectData()

  loadSubjectData: () ->
    $('#graph-container').addClass 'loading-lightcurve'
    jsonFile = JSON_FILE #@subject.selected_light_curve.location
    # console.log 'jsonFile: ', jsonFile # DEBUG CODE

    # handle ui elements
    @el.find('#loading-screen').fadeIn()
    @el.find('.star-id').hide()
    @el.find('#ui-slider').attr('disabled',true)
    @el.find(".noUi-handle").fadeOut(150)
    
    # remove any previous canvas; create new one
    @canvas?.remove()
    @canvas = document.createElement('canvas')
    @canvas.id = 'graph'
    @canvas.width = 1024
    @canvas.height = 420

    # read json data
    $.getJSON jsonFile, (data) =>
      @marksContainer.appendChild(@canvas)
      @canvasGraph = new CanvasGraph(@canvas, data)
      @zoomReset()
      @canvasGraph.plotPoints()
      @el.find('#loading-screen').fadeOut()
      $('#graph-container').removeClass 'loading-lightcurve'
      @canvasGraph.enableMarking()
      @magnification = [ '1x (all days)', '10 days', '2 days' ]
      @showZoomMessage(@magnification[@canvasGraph.zoomLevel])
      @el.find("#ui-slider").noUiSlider
        start: 0
        range:
          min: @canvasGraph.smallestX
          max: @canvasGraph.largestX #- @zoomRange
      @el.find(".noUi-handle").hide()
    @insertMetadata()

  insertMetadata: ->
    # ukirt data
    @ra      = @subject.coords[0]
    @dec     = @subject.coords[1]
    ukirtUrl = "http://surveys.roe.ac.uk:8080/wsa/GetImage?ra=" + @ra + "&dec=" + @dec + "&database=wserv4v20101019&frameType=stack&obsType=object&programmeID=10209&mode=show&archive=%20wsa&project=wserv4"
    
    metadata = @Subject.current.metadata
    @el.find('#zooniverse-id').html @Subject.current.zooniverse_id 
    @el.find('#kepler-id').html     metadata.kepler_id
    @el.find('#star-type').html     metadata.spec_type
    @el.find('#magnitude').html     metadata.magnitudes.kepler
    @el.find('#temperature').html   metadata.teff.toString().concat("(K)")
    @el.find('#radius').html        metadata.radius.toString().concat("x Sol")
    @el.find('#ukirt-url').attr("href", ukirtUrl)

  onChangeScaleSlider: ->
    val = +@el.find("#ui-slider").val()    
    @canvasGraph.plotPoints( val, val + @canvasGraph.zoomRanges[@canvasGraph.zoomLevel] )

  onClickZoom: ->    
    val = +@el.find("#ui-slider").val()
    @canvasGraph.zoomLevel = @canvasGraph.zoomLevel + 1
    if @canvasGraph.zoomLevel > 2
      @canvasGraph.zoomLevel = 0
    if @canvasGraph.zoomLevel is 0
      @zoomReset()
    else 
      @canvasGraph.zoomInTo(val, val+@canvasGraph.zoomRanges[@canvasGraph.zoomLevel])
      # rebuild slider
      @el.find("#ui-slider").noUiSlider
        start: 0 #+@el.find("#ui-slider").val()
        range:
          'min': @canvasGraph.smallestX,
          'max': @canvasGraph.largestX - @canvasGraph.zoomRanges[@canvasGraph.zoomLevel]
      , true
      
      # update attributes/properties
      @el.find('#ui-slider').removeAttr('disabled')
      @el.find("#zoom-button").addClass("zoomed")
      if @canvasGraph.zoomLevel is 2
        @el.find("#zoom-button").addClass("allowZoomOut")
      else
        @el.find("#zoom-button").removeClass("allowZoomOut")
    @showZoomMessage(@magnification[@canvasGraph.zoomLevel])
  
  zoomReset: =>
    # reset slider value
    @el.find('#ui-slider').val(0)

    # don't need slider when zoomed out
    @el.find('#ui-slider').attr('disabled',true)
    @el.find(".noUi-handle").fadeOut(150)

    @canvasGraph.zoomOut()
    @isZoomed = false
    @canvasGraph.zoomLevel = 0

    # update buttons
    @el.find("#zoom-button").removeClass("zoomed")
    @el.find("#zoom-button").removeClass("allowZoomOut")
    @el.find("#toggle-fav").removeClass("toggled")

  showZoomMessage: (message) =>
    @el.find('#zoom-notification').html(message).fadeIn(100).delay(1000).fadeOut()
    
  notify: (message) =>
    @course.hidePrompt(0) # get the prompt out of the way
    return if @el.find('#notification').hasClass('notifying')
    @el.find('#notification').addClass('notifying')
    @el.find('#notification-message').html(message).fadeIn(100).delay(2000).fadeOut( 400, 'swing', =>
      @el.find('#notification').removeClass('notifying') )

module.exports = LightcurveViewer
