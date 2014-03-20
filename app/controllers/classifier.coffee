BaseController = require 'zooniverse/controllers/base-controller'
FauxRangeInput = require 'faux-range-input'

$ = window.jQuery
require '../lib/sample-data'

{CanvasGraph, Marks, Mark} = require "../lib/canvas-graph"

class Classifier extends BaseController
  className: 'classifier'
  template: require '../views/classifier'

  elements:
    '#toggle-zoom'      : 'zoomButton'
    '#toggle-fav'       : 'favButton'
    '#help'             : 'helpButton'
    '#tutorial'         : 'tutorialButton'
    '#scale-slider'     : 'scaleSlider'
    'numbers-container' : 'numbersContainer'
    '#classify-summary' : 'classifySummary'
    '#comments'         : 'comments'
    '#planet-num'       : 'planetNum'
    '#alt-comments'         : 'altComments'
    'button[name="no-transits"]' : 'noTransitsButton'
    'button[name="finished"]' : 'finishedButton'
    'button[name="next-subject"]' :'nextSubjectButton'
    'button[name="join-convo"]' : 'joinConvoBtn'
    'button[name="alt-join-convo"]' : 'altJoinConvoBtn'
    'textarea[name="talk-comment"]' : 'talkComment'
    'textarea[name="alt-talk-comment"]' : 'altTalkComment'

  events:
    'click button[id="toggle-zoom"]' : 'onToggleZoom'
    'click button[id="toggle-fav"]'  : 'onToggleFav'
    'click button[id="help"]'        : 'onClickHelp'
    'click button[id="tutorial"]'    : 'onClickTutorial'
    'click button[name="no-transits"]' : 'onClickNoTransits'
    'click button[name="next-subject"]' : 'onClickNextSubject'
    'click button[name="finished"]' : 'onClickFinished'
    'click img[id="lesson-close"]'   : 'onClickLessonClose'
    'change input[id="scale-slider"]': 'onChangeScaleSlider'
    'click button[name="join-convo"]': 'onClickJoinConvo'
    'click button[name="alt-join-convo"]' : 'onClickAltJoinConvo'
    'click button[name="submit-talk"]' : 'onClickSubmitTalk'
    'click button[name="alt-submit-talk"]' :'onClickSubmitTalkAlt'

  constructor: ->
    super
    isZoomed: false
    ifFaved: false
    @scaleSlider = new FauxRangeInput('#scale-slider')
    @marksContainer = @el.find('#marks-container')[0]

    @loadSubject(sampleData[0])

    console.log @canvasGraph.largestX
    @el.find("#scale-slider").attr "max", @canvasGraph.largestX
    @el.find("#scale-slider").attr "min", @canvasGraph.smallestX

    $(document).on 'mark-change', => @updateButtons()
    setTimeout => @el.find(".faux-range-thumb").hide()
    @drawSliderAxisNums()

  loadSubject: (data) ->
    # create a new canvas
    @canvas = document.createElement('canvas')
    @canvas.id = 'graph'
    @canvas.width = 1024
    @canvas.height = 420

    @marksContainer.appendChild(@canvas)
    @canvasGraph = new CanvasGraph(@canvas, data)
    @canvasGraph.plotPoints()
    @canvasGraph.enableMarking()

  onChangeScaleSlider: ->
    @zoomRange = 15
    @focusCenter = +@el.find('#scale-slider').val() + @zoomRange/2
    
    xMin = @focusCenter-@zoomRange/2
    xMax = @focusCenter+@zoomRange/2

    return unless @isZoomed
    @canvasGraph.plotPoints(xMin,xMax)

    console.log "data center: ", @focusCenter
    # console.log 'data largestX : ', @canvasGraph.largestX
    # console.log 'data smallestX: ', @canvasGraph.smallestX
    # console.log 'Data domain  : [', @canvasGraph.toDataXCoord(xMin), ',', @canvasGraph.toDataXCoord(xMax), ']'
    # console.log 'Canvas domain: [', xMin, ',', xMax, ']'
    
  onToggleZoom: ->
    @isZoomed = !@isZoomed
    zoomButton = @el.find("#toggle-zoom")[0]
    if @isZoomed
      @canvasGraph.plotPoints(@focusCenter-@zoomRange/2,@focusCenter+@zoomRange/2)
      zoomButton.innerHTML = '<img src="images/icons/toolbar-zoomminus.png">Zoom'
      @el.find("#toggle-zoom").addClass("toggled")
      @el.find("#scale-slider").addClass("active")
      @el.find(".faux-range-thumb").fadeIn(150)
    else
      @canvasGraph.plotPoints()
      zoomButton.innerHTML = '<img src="images/icons/toolbar-zoomplus.png">Zoom'
      @el.find("#toggle-zoom").removeClass("toggled")
      @el.find("#scale-slider").removeClass("active")
      @el.find(".faux-range-thumb").fadeOut(150)

  onToggleFav: ->
    favButton = @el.find("#toggle-fav")[0]
    if @isFaved
      @isFaved = false
      favButton.innerHTML = '<img src="images/icons/toolbar-fav-empty.png">+Fav'
      @el.find("#toggle-fav").removeClass("toggled")
    else
      @isFaved = true
      favButton.innerHTML = '<img src="images/icons/toolbar-fav-filled.png">+Fav'
      @el.find("#toggle-fav").addClass("toggled")
    
  onClickHelp: ->
    console.log 'onClickHelp()'
    console.log @el.find("#scale-slider")

  onClickTutorial: ->
    console.log 'onClickTutorial()'

  updateButtons: ->
    if @canvasGraph.marks.all.length > 0
      @noTransitsButton.hide()
      @finishedButton.show()
    else
      @finishedButton.hide()
      @noTransitsButton.show()

  onClickNoTransits: -> @finishSubject()

  onClickFinished: -> @finishSubject()

  onClickNextSubject: ->
    @noTransitsButton.show()
    @classifySummary.fadeOut(150)
    @nextSubjectButton.hide()
    @canvasGraph.marks.destroyAll() #clear old marks
    @canvas.outerHTML = ""

    @resetTalkComment @talkComment
    @resetTalkComment @altTalkComment

    console.log "LOAD NEW SUBJECT HERE"
    #fake it for now...
    @loadSubject(sampleData[Math.round Math.random()*(sampleData.length-1)])

  finishSubject: ->
    @showSummary()
    console.log "SEND CLASSIFICATION HERE"

  showSummary: ->
    @classifySummary.fadeIn(150)
    @nextSubjectButton.show()
    @planetNum.html @canvasGraph.marks.all.length # number of marks
    @noTransitsButton.hide()
    @finishedButton.hide()

  onClickLessonClose: ->
    console.log 'onClickLessonClose()'

  onClickJoinConvo: -> @joinConvoBtn.hide().siblings().show()

  onClickAltJoinConvo: -> @altJoinConvoBtn.hide().siblings().show()

  onClickSubmitTalk: ->
    console.log "SEND THIS TO MAIN TALK DISCUSSION", @talkComment.val()
    @appendComment(@talkComment, @comments)

  onClickSubmitTalkAlt: ->
    console.log "SEND THIS TO ANOTHER TALK DISCUSSION", @altTalkComment.val()
    @appendComment(@altTalkComment, @altComments)

  resetTalkComment: (talkComment) -> talkComment.val("").parent().hide().siblings().show()

  appendComment: (comment, container) ->
    container.append("""
      <div class="formatted-comment">
        <p>#{comment.val()}</p>
        <p>by <strong>#{'currentUser'}</strong> 0 minutes ago</p>
      </div>
    """).animate({ scrollTop: container[0].scrollHeight}, 1000)
    @resetTalkComment comment

  drawSliderAxisNums: ->
    sliderNums = ""
    for num in [(Math.round @canvasGraph.smallestX + 1)..(Math.round @canvasGraph.largestX)]
      sliderNums += if num%2 is 0 then "<span class='slider-num'>#{num}</span>" else "<span class='slider-num'>&#x2022</span>"
    @el.find("#numbers-container").append(sliderNums)

module.exports = Classifier