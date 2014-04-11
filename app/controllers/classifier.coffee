BaseController = require 'zooniverse/controllers/base-controller'
User           = require 'zooniverse/models/user'
Subject        = require 'zooniverse/models/subject'
Classification = require 'zooniverse/models/classification'
MiniCourse     = require '../lib/mini-course'
NoUiSlider     = require "../lib/jquery.nouislider.min"

$ = window.jQuery

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
    'slide #ui-slider'                     : 'onChangeScaleSlider'
    'click button[name="join-convo"]'      : 'onClickJoinConvo'
    'click button[name="alt-join-convo"]'  : 'onClickAltJoinConvo'
    'click button[name="submit-talk"]'     : 'onClickSubmitTalk'
    'click button[name="alt-submit-talk"]' : 'onClickSubmitTalkAlt'

  constructor: ->
    super    
    window.classifier = @
    @zoomRange = 15.00
    isZoomed: false
    ifFaved: false

    User.on 'change', @onUserChange
    Subject.on 'fetch', @onSubjectFetch
    Subject.on 'select', @onSubjectSelect
    @Subject = Subject

    # create canvas
    @canvas = document.createElement('canvas')
    @canvas.id = 'graph'
    @canvas.width = 1024
    @canvas.height = 420

    $(document).on 'mark-change', => @updateButtons()
    @marksContainer = @el.find('#marks-container')[0]

    # mini course
    @course = new MiniCourse
    @course.setRate 3

  onUserChange: (e, user) =>
    Subject.next() unless @classification?

  onSubjectFetch: (e, user) =>
    console.log 'onSubjectFetch()'

  onSubjectSelect: (e, subject) =>
    console.log 'onSubjectSelect()'
    @subject = subject
    @classification = new Classification {subject}
    # console.log 'subject: ', subject
    @loadSubjectData()

  loadSubjectData: ->
    console.log 'loading subject...'
    jsonFile = @subject.location['14-1'] # read actual subject
    # jsonFile = './offline/subject.json' # for debug only
    
    $.getJSON jsonFile, (data) =>
      if @canvas?
        @canvas.remove()
        # @canvasGraph.marks.remove()

        # @el.find("#ui-slider").remove()
      @marksContainer.appendChild(@canvas)
      @canvasGraph = new CanvasGraph(@canvas, data)
      @canvasGraph.plotPoints()
      @canvasGraph.enableMarking()
      @drawSliderAxisNums()

      @el.find("#ui-slider").noUiSlider
        start: 0
        range:
          "min": @canvasGraph.smallestX
          "max": @canvasGraph.largestX - @zoomRange
      
  onChangeScaleSlider: ->
    val = +@el.find("#ui-slider").val()
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
    if @isZoomed
      @canvasGraph.zoomInTo(0, @zoomRange)
      @el.find("#toggle-zoom").addClass("toggled")
      @el.find("#ui-slider").val(0)
      @el.find(".noUi-handle").fadeIn(150)
    else
      @canvasGraph.zoomOut()
      @el.find("#toggle-zoom").removeClass("toggled")
      @el.find("#ui-slider").val(@canvasGraph.smallestX)
      @el.find(".noUi-handle").fadeOut(150)

  onToggleFav: ->
    favButton = @el.find("#toggle-fav")[0]
    if @isFaved
      @isFaved = false
      @el.find("#toggle-fav").removeClass("toggled")
    else
      @isFaved = true
      @el.find("#toggle-fav").addClass("toggled")

  onClickHelp: ->
    console.log 'onClickHelp()'
    @el.find('#course-prompt').slideDown()

  onClickTutorial: ->
    console.log 'onClickTutorial()'

  updateButtons: ->
    if @canvasGraph.marks.all.length > 0
      @noTransitsButton.hide()
      @finishedButton.show()
    else
      @finishedButton.hide()
      @noTransitsButton.show()

  onClickNoTransits: ->
    @finishSubject()

  onClickFinished: ->
    @finishSubject()

  onClickNextSubject: ->
    @noTransitsButton.show()
    @classifySummary.fadeOut(150)
    @nextSubjectButton.hide()
    @canvasGraph.marks.destroyAll() #clear old marks
    @canvas.outerHTML = ""

    @resetTalkComment @talkComment
    @resetTalkComment @altTalkComment

    # show courses
    @course.showPrompt() if @course.getPref() isnt 'never' and @course.count % @course.rate is 0

    @Subject.next()
    # @loadSubjectData()
    
  finishSubject: ->
    # fake classification counter
    @course.count = @course.count + 1
    console.log 'YOU\'VE MARKED ', @course.count, ' LIGHT CURVES!'
    
    # TODO: fix this!!! why is there a circular reference? and where?
    # for mark, i in [@canvasGraph.marks.all...]
    #   console.log 'mark: ', mark
    #   @classification.annotations[i] = mark

    console.log JSON.stringify( @classification )

    @classification.send()
    @showSummary()
    @el.find("#toggle-zoom").removeClass("toggled")
    @el.find(".noUi-handle").hide()
    @isZoomed = false
    
  showSummary: ->
    @classifySummary.fadeIn(150)
    @nextSubjectButton.show()
    @planetNum.html @canvasGraph.marks.all.length # number of marks
    @noTransitsButton.hide()
    @finishedButton.hide()

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
    @el.find("#numbers-container").html sliderNums

module.exports = Classifier
