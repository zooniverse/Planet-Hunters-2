BaseController = require 'zooniverse/controllers/base-controller'
FauxRangeInput = require 'faux-range-input'
User           = require 'zooniverse/models/user'


$ = window.jQuery
require '../lib/sample-data'

{CanvasGraph, Marks, Mark} = require "../lib/canvas-graph"

class Classifier extends BaseController
  className: 'classifier'
  template: require '../views/classifier'

  elements:
    '#toggle-zoom'                      : 'zoomButton'
    '#toggle-fav'                       : 'favButton'
    '#help'                             : 'helpButton'
    '#tutorial'                         : 'tutorialButton'
    'numbers-container'                 : 'numbersContainer'
    '#classify-summary'                 : 'classifySummary'
    '#comments'                         : 'comments'
    '#planet-num'                       : 'planetNum'
    '#alt-comments'                     : 'altComments'
    'button[name="no-transits"]'        : 'noTransitsButton'
    'button[name="finished"]'           : 'finishedButton'
    'button[name="next-subject"]'       : 'nextSubjectButton'
    'button[name="join-convo"]'         : 'joinConvoBtn'
    'button[name="alt-join-convo"]'     : 'altJoinConvoBtn'
    'textarea[name="talk-comment"]'     : 'talkComment'
    'textarea[name="alt-talk-comment"]' : 'altTalkComment'

  events:
    'click button[id="toggle-zoom"]'       : 'onToggleZoom'
    'click button[id="toggle-fav"]'        : 'onToggleFav'
    'click button[id="help"]'              : 'onClickHelp'
    'click button[id="tutorial"]'          : 'onClickTutorial'
    'click button[name="no-transits"]'     : 'onClickNoTransits'
    'click button[name="next-subject"]'    : 'onClickNextSubject'
    'click button[name="finished"]'        : 'onClickFinished'
    'click img[id="lesson-prompt-close"]'  : 'onClickLessonPromptClose'
    'change input[id="scale-slider"]'      : 'onChangeScaleSlider'
    'click button[name="join-convo"]'      : 'onClickJoinConvo'
    'click button[name="alt-join-convo"]'  : 'onClickAltJoinConvo'
    'click button[name="submit-talk"]'     : 'onClickSubmitTalk'
    'click button[name="alt-submit-talk"]' : 'onClickSubmitTalkAlt'
    'click button[name="lesson-yes"]'      : 'onClickLessonYes'
    'click button[name="lesson-no"]'       : 'onClickLessonNo'
    'click button[name="lesson-never"]'    : 'onClickLessonNever'
    'click button[name="lesson-close"]'    : 'onClickLessonClose'

  constructor: ->
    super
    window.classifier = @
    @zoomRange = 15.00

    @el.find('#lesson-container').hide() # hide lessonn
    @el.find('#lesson-prompt').hide()

    isZoomed: false
    ifFaved: false
    @scaleSlider = new FauxRangeInput('#scale-slider')
    @marksContainer = @el.find('#marks-container')[0]

    @loadSubject(sampleData[0])

    @el.find("#scale-slider").attr "max", @canvasGraph.largestX - @zoomRange
    @el.find("#scale-slider").attr "min", @canvasGraph.smallestX

    $(document).on 'mark-change', => @updateButtons()
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

    window.canvasGraph = @canvasGraph

  onChangeScaleSlider: ->
    val = +@el.find("#scale-slider").val()
    # @focusCenter = +@el.find('#scale-slider').val() + @zoomRange/2
    # xMin = @focusCenter-@zoomRange/2
    # xMax = @focusCenter+@zoomRange/2

    return unless @isZoomed

    @canvasGraph.plotPoints(val, (val + @zoomRange))

    # console.log "data center: ", @focusCenters
    # console.log 'data largestX : ', @canvasGraph.largestX
    # console.log 'data smallestX: ', @canvasGraph.smallestX
    # console.log 'Data domain  : [', @canvasGraph.toDataXCoord(xMin), ',', @canvasGraph.toDataXCoord(xMax), ']'
    # console.log 'Canvas domain: [', xMin, ',', xMax, ']'
    
  onToggleZoom: ->
    @isZoomed = !@isZoomed
    zoomButton = @el.find("#toggle-zoom")[0]
    if @isZoomed
      @canvasGraph.zoomInTo(0, @zoomRange)
      zoomButton.innerHTML = '<img src="images/icons/toolbar-zoomminus.png">Zoom'
      @el.find("#toggle-zoom").addClass("toggled")
      @el.find("#scale-slider").addClass("active").val(0)
      @el.find(".faux-range-thumb").fadeIn(150)
    else
      @canvasGraph.zoomOut()
      zoomButton.innerHTML = '<img src="images/icons/toolbar-zoomplus.png">Zoom'
      @el.find("#toggle-zoom").removeClass("toggled")
      @el.find("#scale-slider").removeClass("active").val(@canvasGraph.smallestX)
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
  

  # BEGIN LESSON METHODS >>> (eventually move to separate file?)
  onClickLessonYes: ->
    console.log "lesson: yes"
    console.log User.current.setPreference 'lesson', 'yes', true, @displayLesson()
    console.log 'preference: ', @userLessonPref
    console.log 'num. class: ', @userClassCount

  onClickLessonNo: ->
    console.log "lesson: no"
    console.log User.current.setPreference 'lesson', 'no', true
    console.log 'preference: ', @userLessonPref
    console.log 'num. class: ', @userClassCount

  onClickLessonNever: ->
    console.log "lesson: never"
    console.log User.current.setPreference 'lesson', 'never', true
    console.log 'preference: ', @userLessonPref
    console.log 'num. class: ', @userClassCount

  displayLesson: ->
    @el.find('#lesson-container').show()

  onClickLessonClose: ->
    console.log 'lessonClose()'
    @el.find('#lesson-container').hide()

  onClickLessonPromptClose: ->
    @el.find('#lesson-prompt').slideUp()

  getUserLessonPref: ->
    @userLessonPref = User.current?.preferences['lesson']
    return @userLessonPref
  
  getUserClassCount: ->
    @userClassCount = User.current?.classification_count
    return @userClassCount
  # <<< END LESSON METHODS

  onClickHelp: ->
    console.log 'onClickHelp()'
    console.log @el.find("#scale-slider")
    @el.find('#lesson-prompt').slideDown()

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

  # onClickLessonClose: ->
  #   console.log 'onClickLessonClose()'

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