BaseController = require 'zooniverse/controllers/base-controller'
User           = require 'zooniverse/models/user'
Subject        = require 'zooniverse/models/subject'
Classification = require 'zooniverse/models/classification'
MiniCourse     = require '../lib/mini-course'
NoUiSlider     = require '../lib/jquery.nouislider.min'
translate      = require 't7e'
{Tutorial}     = require 'zootorial'
{Step}         = require 'zootorial'
tutorialSteps  = require '../lib/tutorial-steps'
$ = window.jQuery
{CanvasGraph, Marks, Mark} = require "../lib/canvas-graph"

class Classifier extends BaseController
  className: 'classifier'
  template: require '../views/classifier'

  elements:
    '#zoom-button'                      : 'zoomButton'
    '#toggle-fav'                       : 'favButton'
    '#help'                             : 'helpButton'
    '#tutorial'                         : 'tutorialButton'
    'numbers-container'                 : 'numbersContainer'
    '#classify-summary'                 : 'classifySummary'
    '#comments'                         : 'comments'
    '#planet-num'                       : 'planetNum'
    '#alt-comments'                     : 'altComments'
    'button[name="no-transits"]'        : 'noTransitsButton'
    'button[name="finished-marking"]'   : 'finishedMarkingButton'
    'button[name="finished-feedback"]'  : 'finishedFeedbackButton'
    'button[name="next-subject"]'       : 'nextSubjectButton'
    'button[name="join-convo"]'         : 'joinConvoBtn'
    'button[name="alt-join-convo"]'     : 'altJoinConvoBtn'
    'textarea[name="talk-comment"]'     : 'talkComment'
    'textarea[name="alt-talk-comment"]' : 'altTalkComment'

  events:
    'click button[id="zoom-button"]'         : 'onClickZoom'
    'click button[id="toggle-fav"]'          : 'onToggleFav'
    'click button[id="help"]'                : 'onClickHelp'
    'click button[id="tutorial"]'            : 'onClickTutorial'
    'click button[name="no-transits"]'       : 'onClickNoTransits'
    'click button[name="next-subject"]'      : 'onClickNextSubject'
    'click button[name="finished-marking"]'  : 'onClickFinishedMarking'
    'click button[name="finished-feedback"]' : 'onClickFinishedFeedback'
    'slide #ui-slider'                       : 'onChangeScaleSlider'
    'click button[name="join-convo"]'        : 'onClickJoinConvo'
    'click button[name="alt-join-convo"]'    : 'onClickAltJoinConvo'
    'click button[name="submit-talk"]'       : 'onClickSubmitTalk'
    'click button[name="alt-submit-talk"]'   : 'onClickSubmitTalkAlt'

  constructor: ->
    super    
    window.classifier = @
    
    @el.find('#star-id').hide()

    # zoom levels [days]: 2x, 10x, 20x
    @zoomRange = 15
    @zoomRanges = []
    @zoomLevel = 0
    isZoomed: false
    ifFaved: false

    User.on 'change', @onUserChange
    Subject.on 'fetch', @onSubjectFetch
    Subject.on 'select', @onSubjectSelect
    @Subject = Subject

    $(document).on 'mark-change', => @updateButtons()
    @marksContainer = @el.find('#marks-container')[0]

    @tutorial = new Tutorial
      steps: tutorialSteps
      firstStep: 'welcome'

    # mini course
    @course = new MiniCourse
    @course.setRate 3

    @recordedClickEvents = []

    @el.find('#no-transits').hide() #prop('disabled',true)
    @el.find('#finished-marking').hide() #prop('disabled',true)
    @el.find('#finished-feedback').hide() #prop('disabled',true)
    console.log '*** DISABLED ***'

  onUserChange: (e, user) =>
    Subject.next() unless @classification?

  onSubjectFetch: (e, user) =>
    console.log 'onSubjectFetch()'

  onSubjectSelect: (e, subject) =>
    @el.find('#loading-screen').show() # TODO: uncomment
    @el.find('#star-id').hide()
    console.log 'onSubjectSelect()'
    @subject = subject
    @classification = new Classification {subject}
    @loadSubjectData()
    @el.find('#loading-screen').hide() # TODO: uncomment


  loadSubjectData: ->
    @el.find('#ui-slider').attr('disabled',true)
    @el.find(".noUi-handle").fadeOut(150)


    # TODO: use Subject data to choose the right lightcurve
    jsonFile = @subject.location['14-1'] # read actual subject

    # DEBUG CODE
    # jsonFile = './offline/subject.json' # for debug only
    console.log 'json_file: ', jsonFile
    
    @canvas?.remove() # kill any previous canvas

    # create new canvas
    @canvas = document.createElement('canvas')
    @canvas.id = 'graph'
    @canvas.width = 1024
    @canvas.height = 420
    
    $.getJSON jsonFile, (data) =>
      @canvasGraph?.marks.destroyAll()  
      @marksContainer.appendChild(@canvas)
      @canvasGraph = new CanvasGraph(@canvas, data)
      @canvasGraph.plotPoints()
      @canvasGraph.enableMarking()
      @zoomRanges = [15, 10, 2]
      @magnification = [ '1x (all days)', '10 days', '2 days' ]
      @showZoomMessage(@magnification[@zoomLevel])
      @el.find("#ui-slider").noUiSlider
        start: 0
        range:
          min: @canvasGraph.smallestX
          max: @canvasGraph.largestX #- @zoomRange
    
    @el.find(".noUi-handle").hide()
    @insertMetadata()
    @el.find('.do-you-see-a-transit').fadeIn()
    @el.find('#no-transits').fadeIn() #prop('disabled',false)
    @el.find('#finished-marking').fadeIn() #prop('disabled',false)
    @el.find('#finished-feedback').fadeIn() #prop('disabled',false)
    console.log '*** ENABLED ***'

  insertMetadata: ->
    @ra      = @subject.coords[0]
    @dec     = @subject.coords[1]
    ukirtUrl = "http://surveys.roe.ac.uk:8080/wsa/GetImage?ra=" + @ra + "&dec=" + @dec + "&database=wserv4v20101019&frameType=stack&obsType=object&programmeID=10209&mode=show&archive=%20wsa&project=wserv4"
    # console.log 'ukirtUrl: ', ukirtUrl
    metadata = @Subject.current.metadata.magnitudes
    @el.find('#star-id').html( @Subject.current.location['14-1'].split("\/").pop().split(".")[0].concat(" Information") )
    @el.find('#star-type').html(metadata.spec_type)
    @el.find('#magnitude').html(metadata.kepler)
    @el.find('#temperature').html metadata.eff_temp.toString().concat("(K)")
    @el.find('#radius').html metadata.stellar_rad.toString().concat("x Sol")
    @el.find('#ukirt-url').attr("href", ukirtUrl)

  onChangeScaleSlider: ->
    val = +@el.find("#ui-slider").val()
    return if @zoomLevel is 0 or @zoomLevel > @zoomRanges.length
    @canvasGraph.plotPoints( val, val + @zoomRanges[@zoomLevel] )
    console.log 'SLIDER VALUE: ', val
    console.log 'PLOT RANGE [',val,',',val+@zoomRanges[@zoomLevel],']'
    console.log 'LIGHTCURVE LIMITS [',@canvasGraph.smallestX,',',@canvasGraph.largestX,']'
    console.log '---------------------------------------------'

  onClickZoom: ->
    @zoomLevel = @zoomLevel + 1
    if @zoomLevel is 0 or @zoomLevel > @zoomRanges.length-1 # no zoom
      @canvasGraph.zoomOut()
      @el.find("#zoom-button").removeClass("zoomed")
      @el.find("#ui-slider").val(0)
      @el.find(".noUi-handle").fadeOut(150)
      @zoomLevel = 0
      @el.find('#ui-slider').attr('disabled',true)
      @el.find("#zoom-button").removeClass("allowZoomOut")
    else 
      @el.find('#ui-slider').removeAttr('disabled')
      @canvasGraph.zoomInTo(0, @zoomRanges[@zoomLevel])
      @el.find("#zoom-button").addClass("zoomed")
      @el.find("#ui-slider").val(0)

      # rebuild slider
      @el.find("#ui-slider").noUiSlider
        start: 0 #+@el.find("#ui-slider").val()
        range:
          'min': @canvasGraph.smallestX,
          'max': @canvasGraph.largestX #- @zoomRanges[@zoomLevel]
      , true
      if @zoomLevel is @zoomRanges.length-1
        @el.find("#zoom-button").addClass("allowZoomOut")
      else
        @el.find("#zoom-button").removeClass("allowZoomOut")
    @showZoomMessage(@magnification[@zoomLevel])
    @recordedClickEvents.push { event: 'clickedZoomLevel'+@zoomLevel, timestamp: (new Date).toUTCString() }
  
  showZoomMessage: (message) =>
    @el.find('#zoom-notification').html(message).fadeIn(100).delay(1000).fadeOut()
    
  notify: (message) =>
    @course.hidePrompt(0) # get the prompt out of the way
    return if @el.find('#notification').hasClass('notifying')
    @el.find('#notification').addClass('notifying')
    @el.find('#notification-message').html(message).fadeIn(100).delay(2000).fadeOut( 400, 'swing', =>
      @el.find('#notification').removeClass('notifying') )

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
    @el.find('#notification-message').hide() # get any notification out of the way
    # @el.find('#course-prompt').slideDown()
    @course.showPrompt()
    
  onClickTutorial: ->
    console.log 'onClickTutorial()'
    @notify('Loading tutorial...')
    @tutorial.start()

  updateButtons: ->
    # console.log 'updateButtons()'
    if @canvasGraph.marks.all.length > 0
      @noTransitsButton.hide()
      @finishedMarkingButton.show()
    else
      @finishedMarkingButton.hide()
      @noTransitsButton.show()

  onClickNoTransits: ->
    # console.log 'onClickNoTransits()'
    # giveFeedback() 
    @finishSubject()

  onClickFinishedMarking: ->
    # console.log 'onClickFinishedMarking()'
    @finishedMarkingButton.hide()
    @giveFeedback()
    
  giveFeedback: ->
    # console.log 'giveFeedback()'
    @finishedFeedbackButton.show()
    @canvasGraph.disableMarking()
    @canvasGraph.showFakePrevMarks()
    # numMarksGenerated = @canvasGraph.showFakePrevMarks()
    # console.log 'found ', numMarksGenerated, ' previous marks'
    # if numMarksGenerated <= 0 # no marks generated
    #   @notify('Loading summary page...')
    #   @finishedFeedbackButton.hide()
    #   @finishSubject()
    # else
    #   @notify('Here\'s what others have marked...')
    #   @el.find(".mark").fadeOut(1000)
    @notify('Here\'s what others have marked...')
    @el.find(".mark").fadeOut(1000)

  onClickFinishedFeedback: ->
    # console.log 'onClickFinishedFeedback()'
    # @finishedFeedbackButton.hide()
    @finishSubject()

  onClickNextSubject: ->
    # console.log 'onClickNextSubject()'
    # @noTransitsButton.show()
    @classifySummary.fadeOut(150)
    @nextSubjectButton.hide()
    @canvasGraph.marks.destroyAll() #clear old marks
    @canvas.outerHTML = ""
    @resetTalkComment @talkComment
    @resetTalkComment @altTalkComment
    # show courses
    if @course.getPref() isnt 'never' and @course.count % @course.rate is 0
      @el.find('#notification-message').hide() # get any notification out of the way
      @course.showPrompt() 
    @el.find('#loading-screen').show() # TODO: uncomment
    @Subject.next()

  finishSubject: ->
    # console.log 'finishSubject()'
    @finishedFeedbackButton.hide()
    # fake classification counter
    @course.count = @course.count + 1
    console.log 'YOU\'VE MARKED ', @course.count, ' LIGHT CURVES!'
    @classification.set 'recordedClickEvents', [@recordedClickEvents...]
    for mark, i in [@canvasGraph.marks.all...]
      @classification.annotations[i] =
        xMinRelative: mark.dataXMinRel
        xMaxRelative: mark.dataXMaxRel
        xMinGlobal: mark.dataXMinGlobal
        xMaxGlobal: mark.dataXMaxGlobal
    # DEBUG CODE
    # console.log JSON.stringify( @classification )
    @classification.send()
    console.log '********************************************'

    # disable buttons until next lightcurve is loaded
    @el.find('#no-transits').hide() #prop('disabled',true)
    @el.find('#finished-marking').hide() #prop('disabled',true)
    @el.find('#finished-feedback').hide() #prop('disabled',true)
    console.log '*** DISABLED ***'

    # show summary
    @el.find('.do-you-see-a-transit').fadeOut()
    @el.find('#star-id').fadeIn()
    @classifySummary.fadeIn(150)
    @nextSubjectButton.show()
    @planetNum.html @canvasGraph.marks.all.length # number of marks
    # @noTransitsButton.hide()
    @finishedMarkingButton.hide()

    @el.find("#zoom-button").removeClass("zoomed")
    @el.find("#toggle-fav").removeClass("toggled")
    
    @isZoomed = false
    @zoomLevel = 0
    @recordedClickEvents = []
    
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

module.exports = Classifier
