BaseController             = require 'zooniverse/controllers/base-controller'
User                       = require 'zooniverse/models/user'
Subject                    = require 'zooniverse/models/subject'
Classification             = require 'zooniverse/models/classification'
MiniCourse                 = require '../lib/mini-course'
NoUiSlider                 = require '../lib/jquery.nouislider.min'
StackOfPages               = require 'stack-of-pages'
translate                  = require 't7e'
{Tutorial}                 = require 'zootorial'
{Step}                     = require 'zootorial'
initialTutorialSteps       = require '../lib/initial-tutorial-steps'
supplementalTutorialSteps  = require '../lib/supplemental-tutorial-steps'
{CanvasGraph, Marks, Mark} = require '../lib/canvas-graph'
{loadImage}                = require '../lib/utils'
Modal                      = require '../lib/modal'
Api                        = require 'zooniverse/lib/api'
GuestObsContent            = require '../lib/guest_obs_content'

$ = window.jQuery

class Classifier extends BaseController
  className: 'classifier'
  template: require '../views/classifier'

  elements:
    '#zoom-button'                      : 'zoomButton'
    '#help'                             : 'helpButton'
    '#tutorial'                         : 'tutorialButton'
    'numbers-container'                 : 'numbersContainer'
    '#classify-summary'                 : 'classifySummary'
    '#comments'                         : 'commentsContainer'
    '#planet-num'                       : 'planetNum'
    '#alt-comments'                     : 'altComments'
    'button[name="no-transits-button"]' : 'noTransitsButton'
    'button[name="finished-marking"]'   : 'finishedMarkingButton'
    'button[name="continue-button"]'    : 'continueButton'
    'button[name="finished-feedback"]'  : 'finishedFeedbackButton'
    'button[name="next-subject"]'       : 'nextSubjectButton'
    'button[name="join-convo"]'         : 'joinConvoBtn'
    'textarea[name="talk-comment"]'     : 'talkComment'
    '#spotters-guide'                   : 'spottersGuide'
    '.examples img'                     : 'exampleImages'

  events:
    'click button[id="zoom-button"]'          : 'onClickZoom'
    'click .toggle-fav'                       : 'onToggleFav'
    'click .talk-button'                      : 'onClickTalkButton'
    'click button[id="help"]'                 : 'onClickHelp'
    'click button[id="tutorial"]'             : 'onClickTutorial'
    'click button[name="no-transits-button"]' : 'onClickNoTransits'
    'click button[name="next-subject"]'       : 'onClickNextSubject'
    'click button[name="finished-marking"]'   : 'onClickFinished'
    'slide #ui-slider'                        : 'onChangeScaleSlider'
    'click button[name="join-convo"]'         : 'onClickJoinConvo'
    'click button[name="alt-join-convo"]'     : 'onClickAltJoinConvo'
    'click button[name="submit-talk"]'        : 'onClickSubmitTalk'
    'click button[name="alt-submit-talk"]'    : 'onClickSubmitTalkAlt'
    'change #course-interval'                 : 'onChangeCourseInterval'
    'change #course-interval-sup-tut'         : 'onChangeCourseIntervalViaSupTut'
    'change input[name="mini-course-option"]' : 'onChangeMiniCourseOption'
    'change input[name="course-opt-out"]'     : 'onChangeCourseOptOut'
    'click button[name="continue-button"]'    : 'onClickContinueButton'

    'click .arrow.left'  : 'onClickCourseBack'
    'click .arrow.right' : 'onClickCourseForward'

    # CODE FOR PROMPT (NOT CURRENTLY IN USE)
    # 'mouseenter #course-yes-container'        : 'onMouseoverCourseYes'
    # 'mouseleave  #course-yes-container'       : 'onMouseoutCourseYes'

  constructor: ->
    super

    # # if mobile device detected, go to verify mode
    # if window.matchMedia("(min-device-width: 320px)").matches and window.matchMedia("(max-device-width: 480px)").matches
    #   location.hash = "#/verify"

    Subject.group = "5417014a3ae7400bda000001"

    @loggedOutClassificationCount = 0

    window.classifier = @
    @recordedClickEvents = [] # array to store all click events

    # zoom levels [days]: 2x, 10x, 20x
    isZoomed: false
    ifFaved: false

    # classification counts at which to display supplementary tutorial
    @whenToDisplayTips = [1, 7] # TODO: don't forget to add 4 after beta version
    @splitDesignation = null

    @known_transits = ''

    @guideShowing = false

    User.on 'change', @onUserChange
    Subject.on 'fetch', @onSubjectFetch
    Subject.on 'select', @onSubjectSelect
    @Subject = Subject

    $(document).on 'mark-change', => @updateButtons()
    @marksContainer = @el.find('#marks-container')[0]

    @initialTutorial = new Tutorial
      parent: window.classifier.el.children()[0]
      steps: initialTutorialSteps.steps

    $(window).on "resize", =>
       @initialTutorial.attach()

    @supplementalTutorial = new Tutorial
      parent: window.classifier.el.children()[0]
      steps: supplementalTutorialSteps.steps

    # mini course
    @course = new MiniCourse
    @el.find('#course-interval-setter').hide()

    # @verifyRate = 20

    @el.find('#no-transits-button').hide() #prop('disabled',true)
    @el.find('#finished-marking').hide() #prop('disabled',true)
    @el.find('#finished-feedback').hide() #prop('disabled',true)

    @exampleImages.on 'click', (e) ->
      new Modal src: e.currentTarget.src

    @el.on StackOfPages::activateEvent, @activate

    show_all_courses = @getParameterByName("show_all_courses")

    if show_all_courses is "true"
      console.log "COURSE ADMIN MODE ENABLED"
      @course.ADMIN_MODE = true
    else
      @course.ADMIN_MODE = false

    # initialize buttons
    @continueButton.hide()


  # CODE FOR PROMPT (NOT CURRENTLY IN USE)
  # /////////////////////////////////////////////////
  # onMouseoverCourseYes: ->
  #   # console.log '*** ON ***'
  #   return unless User.current?
  #   return if @blockCourseIntervalDisplay
  #   @blockCourseIntervalDisplay = true
  #   @el.find('#course-interval-setter').show 400, =>
  #     @blockCourseIntervalHide = false

  # onMouseoutCourseYes: ->
  #   return unless User.current?
  #   # console.log '*** OUT ***'
  #   return if @blockCourseIntervalHide
  #   @blockCourseIntervalHide = true
  #   @el.find('#course-interval-setter').hide 400, =>
  #     @blockCourseIntervalDisplay = false
  # /////////////////////////////////////////////////

  getParameterByName: (name) ->
    name = name.replace(/[\[]/, "\\[").replace(/[\]]/, "\\]")
    regex = new RegExp("[\\?&]" + name + "=([^&#]*)")
    results = regex.exec(location.search)
    (if not results? then "" else decodeURIComponent(results[1].replace(/\+/g, " ")))

  onClickCourseBack: ->
    return unless @course.idx_curr >= 0
    @course.idx_curr = @course.idx_curr-1
    @course.display(@course.idx_curr)

  onClickCourseForward: ->
    return unless @course.idx_curr < @course.content.length
    @course.idx_curr = @course.idx_curr+1
    @course.display(@course.idx_curr)

  activate: ->
    @initialTutorial?.attach() if Subject.current?.tutorial?

  onChangeMiniCourseOption: ->
    # console.log 'onChangeMiniCourseOption(): '
    return unless User.current?

    @courseEnabled = not @courseEnabled

    if @courseEnabled
      User.current?.setPreference 'course', 'yes'
      $("[name='course-opt-out']").prop 'checked', false
    else
      User.current?.setPreference 'course', 'no'
      $("[name='course-opt-out']").prop 'checked', true

    clickEvent =
      event: 'courseEnabled'
      value: @courseEnabled
      timestamp: (new Date).toUTCString()
    @recordedClickEvents.push clickEvent

  onChangeCourseOptOut: ->
    # console.log 'onChangeCourseOptOut(): '
    return unless User.current?
    opt_out = $("[name='course-opt-out']").prop 'checked'
    if opt_out
      User.current?.setPreference 'course', 'no'
      @courseEnabled = false # TODO: needs work!
    else
      User.current?.setPreference 'course', 'yes'
      @courseEnabled = true

    clickEvent =
      event: 'courseOptedOut'
      value: opt_out
      timestamp: (new Date).toUTCString()
    @recordedClickEvents.push clickEvent

  # onChangeMiniCourseOption: ->
  #   console.log 'onChangeMiniCourseOption(): '
  #   return unless User.current?
  #   courseOption = User.current.preferences.planet_hunter.course

  #   # toggle course option
  #   if courseOption is 'yes'
  #     courseOption = 'no'
  #     # $("[name='course-opt-out']").prop 'checked', true
  #   else
  #     courseOption = 'yes'
  #     $("[name='course-opt-out']").prop 'checked', false

  #   clickEvent =
  #     event: 'miniCourseOptionChanged'
  #     value: courseOption
  #     timestamp: (new Date).toUTCString()
  #   @recordedClickEvents.push clickEvent

  #   User.current?.setPreference 'course', courseOption

  # CODE FOR PROMPT (NOT CURRENTLY BEING USED)
  # onChangeCourseInterval: ->
  #   # console.log 'VALUE: ', @el.find('#course-interval').val()
  #   defaultValue = 5
  #   value = +@el.find('#course-interval').val()

  #   # console.log 'VALUE IS NUMBER: ', (typeof value)

  #   # validate integer values
  #   unless (typeof value is 'number') and (value % 1 is 0) and value > 0 and value < 100
  #     value = defaultValue
  #     @el.find('#course-interval').val(value)
  #   else
  #     # console.log 'SETTING VALUE TO: ', value
  #     @course.setRate value

  onChangeCourseIntervalViaSupTut: ->
    # console.log 'onChangeCourseIntervalViaSupTut(): '
    defaultValue = 5
    value = +@el.find('#course-interval-sup-tut').val()

    # validate integer values
    unless (typeof value is 'number') and (value % 1 is 0) and value > 0 and value < 100
      value = defaultValue
      @el.find('#course-interval-sup-tut').val(value)
    else
      # console.log 'SETTING VALUE TO: ', value

    @course.setRate value

    clickEvent =
      event: 'courseIntervalChanged'
      value: value
      timestamp: (new Date).toUTCString()
    @recordedClickEvents.push clickEvent

  onUserChange: (e, user) =>

    @resetInterface()
    # @classifySummary.fadeOut(150)
    # @nextSubjectButton.hide()

    # console.log 'classify: onUserChange()'
    if User.current? # user logged in

      # hide tutorial
      @initialTutorial.end()

      # first visit, initialize preference
      unless User.current.preferences?.planet_hunter?.count?
        @initializeMiniCourse()
      else
        @course.count      = +User.current?.preferences?.planet_hunter?.count
        @course.idx_last   = +User.current?.preferences?.planet_hunter?.curr_course_id
      @handleSplitDesignation()

    # handle tutorial launch
    if @course.count is 0 or not User.current?
      @launchTutorial()
    else
      Subject.next() unless classification?

  initializeMiniCourse: ->
    return unless User.current?
    # console.log 'First visit. Initializing preferences...'
    User.current.setPreference 'count', 0
    User.current.setPreference 'curr_course_id', 0
    @course.count = 0
    @course.idx_last = 0

  handleSplitDesignation: ->
    if User.current.project.splits?.mini_course_sup_tutorial?
      # console.log 'SPLIT DESIGNATION ASSIGNED'
      @splitDesignation = User.current.project.splits.mini_course_sup_tutorial
    else
      # console.log 'NO SPLIT DESIGNATION ASSIGNED. USING DEFAULT.'
      @splitDesignation = 'a' # default split designation

    # @splitDesignation = 'a' # DEBUG CODE

    unless @getParameterByName("split") is ""
      @splitDesignation = @getParameterByName("split")

    console.log 'SPLIT DESIGNATION IS: ', @splitDesignation

    # SET MINI-COURSE INTERVAL
    if @splitDesignation in ['b', 'e']
      # console.log 'Setting mini-course interval to 10'
      @course.setRate 10
      $('#course-interval-setter').remove() # destroy custom course interval setter

    else if @splitDesignation in ['c', 'f']
      # console.log 'Setting mini-course interval to 25'
      @course.setRate 25
      $('#course-interval-setter').remove() # destroy custom course interval setter

    else if @splitDesignation in ['a', 'd']
      # console.log 'Setting mini-course interval to 5'
      # console.log 'Allowing custom course interval.'
      @course.setRate 5 # set default
      @allowCustomCourseInterval = true
    else
      # console.log 'Setting mini-course interval to 5 (default)'
      # console.log 'Allowing custom course interval.'
      @allowCustomCourseInterval = false
      @course.setRate 5 # set default

    # SET MINI-COURSE DEFAULT OPT-IN/OUT PREFS
    if @splitDesignation in ['a', 'b', 'c', 'g', 'h', 'i']
      @courseEnabled = false
      User.current.setPreference 'course', 'no'
      # initialize checkboxes
      $("[name='course-opt-out']").prop 'checked', true
      $("[name='mini-course-option']").prop 'checked', false
    else if @splitDesignation in ['d', 'e', 'f', 'j', 'k', 'l']
      @courseEnabled = true
      User.current.setPreference 'course', 'yes'
      # initialize checkboxes
      $("[name='course-opt-out']").prop 'checked', false
      $("[name='mini-course-option']").prop 'checked', false

  onSubjectSelect: (e, subject) =>
    # console.log 'onSubjectSelect(): '
    @subject = subject
    @classification = new Classification {subject}
    @loadSubjectData()
    @fetchComments()

  loadSubjectData: () ->
    # reset fav
    @el.find(".toggle-fav").removeClass("toggled")

    $('#graph-container').addClass 'loading-lightcurve'


    if window.location.origin != "http://planethunters.org"
      jsonFile = @subject.selected_light_curve.location.replace("http://www.planethunters.org/", "https://s3.amazonaws.com/zooniverse-static/planethunters.org/")
    else
      jsonFile = @subject.selected_light_curve.location

    # console.log 'jsonFile: ', jsonFile

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
      if data.metadata.known_transits
        @known_transits = data.metadata.known_transits

      @canvasGraph?.marks.destroyAll()
      @marksContainer.appendChild(@canvas)
      @canvasGraph = new CanvasGraph(@canvas, data)
      @zoomReset()
      @canvasGraph.plotPoints()
      @el.find('#loading-screen').fadeOut()
      $('#graph-container').removeClass 'loading-lightcurve'
      @canvasGraph.enableMarking()
      # @zoomRanges = [@canvasGraph.largestX, 10, 2]
      @magnification = [ '1x (all days)', '10 days', '2 days' ]
      # update ui elements
      @showZoomMessage(@magnification[@canvasGraph.zoomLevel])
      @el.find("#ui-slider").noUiSlider
        start: 0
        range:
          min: @canvasGraph.smallestX
          max: @canvasGraph.largestX #- @zoomRange
      @el.find(".noUi-handle").hide()

    @insertMetadata()
    # @el.find('.do-you-see-a-transit').fadeIn()
    # @el.find('#no-transits-button').fadeIn()

    # @el.find('#finished-marking').fadeIn()
    # @el.find('#finished-feedback').fadeIn()

  insertMetadata: ->
    # ukirt data
    @ra      = @subject.coords[0]
    @dec     = @subject.coords[1]
    ukirtUrl = "http://surveys.roe.ac.uk:8080/wsa/GetImage?ra=" + @ra + "&dec=" + @dec + "&database=wserv4v20101019&frameType=stack&obsType=object&programmeID=10209&mode=show&archive=%20wsa&project=wserv4"

    metadata = @Subject.current.metadata
    @el.find('#zooniverse-id').html @Subject.current.zooniverse_id
    @el.find('#kepler-id').html     metadata.kepler_id
    @el.find('#quarter').html @Subject.current.selected_light_curve.quarter
    @el.find('#star-type').html     (metadata.spec_type || "Dwarf")
    @el.find('#magnitude').html     metadata.magnitudes.kepler
    @el.find('#temperature').html   metadata.teff.toString().concat("(K)")
    @el.find('#radius').html        metadata.radius.toString().concat("x Sol")
    @el.find('#ukirt-url').attr("href", ukirtUrl)

  notify: (message) =>
    @course.hidePrompt(0) # get the prompt out of the way
    return if @el.find('#notification').hasClass('notifying')
    @el.find('#notification').addClass('notifying')
    @el.find('#notification-message').html(message).fadeIn(100).delay(2000).fadeOut( 400, 'swing', =>
      @el.find('#notification').removeClass('notifying') )

  onToggleFav: ->
    console.log 'fav toggled!'
    @classification.favorite = !@classification.favorite
    favButton = @el.find(".toggle-fav")[0]
    if @isFaved
      @isFaved = false
      @el.find(".toggle-fav").removeClass("toggled")
      @notify('Removed from Favorites.')
    else
      @isFaved = true
      @el.find(".toggle-fav").addClass("toggled")
      @notify('Added to Favorites.')

  onClickTalkButton: ->
    window.open "http://talk.planethunters.org/#/subjects/#{Subject.current?.zooniverse_id}", '_blank'

  onClickHelp: ->
    if @guideShowing
      @spottersGuide.slideUp()
    else
      @spottersGuide.slideDown()
      $("html, body").animate scrollTop: @spottersGuide.offset().top - 20, 500
      clickEvent = { event: 'guideActivated', timestamp: (new Date).toUTCString() }
      @recordedClickEvents.push clickEvent
    @guideShowing = !@guideShowing

  onClickTutorial: ->
    clickEvent = { event: 'tutorialClicked', timestamp: (new Date).toUTCString() }
    @recordedClickEvents.push clickEvent
    @canvasGraph.marks.destroyAll() # clear previous marks
    @updateButtons()
    @launchTutorial()

  launchTutorial: ->
    if $('#graph-container').hasClass 'loading-lightcurve'
      @notify 'Please wait until current lightcurve is loaded.'
      return
    # load training subject
    @notify('Loading tutorial...')
    tutorialSubject = @createTutorialSubject()
    tutorialSubject.select()
    # do stuff after tutorial complete/aborted
    addEventListener "zootorial-end", =>
      $('.tutorial-annotations.x-axis').removeClass('visible')
      $('.tutorial-annotations.y-axis').removeClass('visible')
      $('.mark').fadeIn()
    @initialTutorial.start()

  createTutorialSubject: ->
    # create tutorial subject
    tutorialSubject = new Subject
      id: 'TUTORIAL_SUBJECT'
      zooniverse_id: 'APH0000039'
      tutorial: true
      metadata:
        kepler_id: "9631995"
        logg: "4.493"
        magnitudes:
          kepler: "13.435"
        mass: ""
        radius: "0.966"
        teff: "6076"
      selected_light_curve:
        location: 'https://s3.amazonaws.com/demo.zooniverse.org/planet_hunter/subjects/09631995_16-3.json'
    tutorialSubject

  updateButtons: ->
    # console.log 'updateButtons()'
    if @canvasGraph.marks?.all.length > 0
      @noTransitsButton.hide()
      @finishedMarkingButton.show()
    else
      @finishedMarkingButton.hide()
      @noTransitsButton.show()

  #
  # BEGIN MARKING TRANSITIONS
  #

  onClickNoTransits: ->
    if @simulationsPresent()
      @evaluateMarks()
      @displayKnownTransits()
    else
      @showSummaryScreen()

  onClickFinished: ->
    if @simulationsPresent()
      @evaluateMarks()
      @displayKnownTransits()
    else
      @showSummaryScreen()

  onClickContinueButton: ->
    @hideMarkingButtons()
    @showSummaryScreen()

  onClickNextSubject: ->


    # # switch to verify mode
    # if @course.count % @verifyRate is 0
    #   location.hash = "#/verify"

    # if @course.getPref() isnt 'never' and @course.count % @course.rate is 0 and @course.coursesAvailable() and @course.count isnt 0
    #   @el.find('#notification-message').hide() # get any notification out of the way
    #   @course.showPrompt()

    if @course.getPref() is "yes" and @course.count % @course.rate is 0 and @course.coursesAvailable() and @course.count isnt 0
      @notify 'Loading mini-course...'
      @course.launch()

    # check to display supplemental tutorial
    @checkSupplementalTutorial()
    @sendClassification()
    @canvasGraph.marks.destroyAll() #clear old marks

    @sim_count ||= 0
    @sim_count +=1

    if @sim_count%2 == 0
      Subject.group = "5417014b3ae7400bda000002"
      Subject.fetch 1, (subjects) =>
        #console.log "got sim subjects ", subjects
    else
      Subject.group = "5417014a3ae7400bda000001"
      @Subject.next()

    @resetInterface()

  resetInterface: ->
    @el.find('.star-id').hide()
    @course.prompt_el.hide()
    @classifySummary.fadeOut(150)
    @hideMarkingButtons()
    @recordedClickEvents = []
    @noTransitsButton.show()

  #
  # END MARKING TRANSITIONS
  #



  hideMarkingButtons: ->
    @noTransitsButton.hide()
    @finishedMarkingButton.hide()
    @nextSubjectButton.hide()
    @continueButton.hide()

  showSummaryScreen: ->
    # reveal ids
    @el.find('.star-id').fadeIn()

    @commentsContainer.animate({ scrollTop: @commentsContainer.height()}, 1000)

    if not User.current?
      @el.find('.talk-pill-nologin').show()
      @el.find('.talk-pill').hide()
    else
      @el.find('.talk-pill-nologin').hide()
      @el.find('.talk-pill').show()

    if @classification.subject.id is 'TUTORIAL_SUBJECT'
      @onClickNextSubject()
    else
      @hideMarkingButtons()
      @nextSubjectButton.show()
      @setGuestObsContent()
      @classifySummary.fadeIn(150)

  checkSupplementalTutorial: ->
    for classification_count in @whenToDisplayTips
      if @course.count is classification_count
        # console.log "*** DISPLAY SUPPLEMENTAL TUTOTIAL # #{classification_count} *** "
        @supplementalTutorial.first = "displayOn_" + classification_count.toString()
        @supplementalTutorial.start()

        # prompt user to opt in/out of mini course
        if @course.count is 7
          newElement = document.createElement('div')
          newElement.setAttribute 'class', "supplemental-tutorial-option-container"
          newElement.setAttribute 'style', "padding: 20px;"
          newElement.innerHTML = """
            <input class=\"mini-course-option\" name=\"mini-course-option\" type=\"checkbox\"></input>
            <div id=\"course-opt-in-label\" style=\"float: left; font-style: italic; font-weight: 500;\"></div>
          """
          # inject custom element into zootorial
          @supplementalTutorial.container.getElementsByClassName('zootorial-content')[0].appendChild(newElement)

          if @allowCustomCourseInterval
            $('#course-opt-in-label').html """
              <!--<div id="course-interval-setter">-->
                <div class="course-interval-text">Launch mini-course every </div>
                <input type="number" id="course-interval-sup-tut" class="course-interval" name="course-interval-sup-tut" value="5"></input>
                <div class="course-interval-text"> classifications!</div>
              <!--</div>-->
            """
          else
            $('#course-opt-in-label').html "Yes, I want to learn more!"

          # check box only if mini-course enabled
          $('.mini-course-option').prop 'checked', @courseEnabled

  sendClassification: ->
    if User.current?
      @course.incrementCount()
    else
      @loggedOutClassificationCount += 1
      if @loggedOutClassificationCount%5 == 0
        @course.showPrompt()

    @classification.annotate
      classification_type: 'light_curve'
      selected_id:          @subject.selected_light_curve._id
      location:             @subject.selected_light_curve.location

    for mark in [@canvasGraph.marks.all...]
      @classification.annotate
        timestamp: mark.timestamp
        zoomLevel: mark.zoomLevelAtCreation
        xMinRelative: mark.dataXMinRel
        xMaxRelative: mark.dataXMaxRel
        xMinGlobal: mark.dataXMinGlobal
        xMaxGlobal: mark.dataXMaxGlobal
        score: mark.score
      console.log 'MARK SCORE: ', mark.score # DEBUG CODE

    @classification.annotate
      recordedClickEvents: [@recordedClickEvents...]

    console.log JSON.stringify( @classification ) # DEBUG CODE

    # send classification (except for tutorial subject)
    unless @classification.subject.id is 'TUTORIAL_SUBJECT'
      @classification.send()

  evaluateMarks: ->
    return unless User.current?
    for transit in @known_transits
      best_score = 0 # that's right, assume they got it WRONG!!!
      transitL = transit[0]
      transitR = transit[1]
      for mark in @canvasGraph.marks.all
        boundL = mark.dataXMinRel
        boundR = mark.dataXMaxRel
        score = @intersectionOverUnion(boundL, boundR, transitL, transitR)
        if score > best_score
          best_score = score
          mark.score = score
      #   console.log "INTERSECTION OVER UNION: ", score # DEBUG CODE
      # console.log "BEST SCORE: ", best_score

  intersectionOverUnion: (aL, aR, bL, bR) ->
    d = 0.001 # threshold
    cL = Math.max(aL, bL)
    cR = Math.min(aR, bR)
    lengthA = aR-aL
    lengthB = bR-bL

    if cL > cR - d
      lengthC = 0 # no overlap
    else
      lengthC = cR-cL
    return lengthC/(lengthA+lengthB-lengthC)

  displayKnownTransits: ->
    return unless @simulationsPresent()

    @hideMarkingButtons()
    @continueButton.show()

    for transit in @known_transits
      @canvasGraph.highlightCurve(transit[0],transit[1])

    @course.showPrompt()
    @course.prompt_el.find('#course-yes-container').hide()
    @course.prompt_el.find('#course-no').hide()
    @course.prompt_el.find('#course-never').hide()
    @course.prompt_el.find('#course-message').html "This light curve contains at least one simulated transit, highlighted in red."

    return

  simulationsPresent: ->
    if @known_transits.length > 0
      return true
    else
      return false

  setGuestObsContent:=>
    console.log GuestObsContent
    i = Math.floor(Math.random()*GuestObsContent.length)
    cont = GuestObsContent[i]
    $(".guest_obs .guest_obs_title").html(cont.title)
    $(".guest_obs .guest_obs_desc").html(cont.description)
    $(".guest_obs .guest_obs_img").attr("src",cont.example)

  onChangeScaleSlider: ->
    @canvasGraph.sliderValue = +@el.find("#ui-slider").val()
    @canvasGraph.plotPoints( @canvasGraph.sliderValue, @canvasGraph.sliderValue + @canvasGraph.zoomRanges[@canvasGraph.zoomLevel] )

    # update center point
    @canvasGraph.graphCenter = (@canvasGraph.zoomRanges[@canvasGraph.zoomLevel]/2)+@canvasGraph.sliderValue

  onClickZoom: ->
    # increment zoom level
    @canvasGraph.zoomLevel = @canvasGraph.zoomLevel + 1

    @canvasGraph.sliderValue = +@el.find("#ui-slider").val()
    offset = @canvasGraph.sliderValue

    # reset zoom
    if @canvasGraph.zoomLevel > 2
      @canvasGraph.zoomLevel = 0

    if @canvasGraph.zoomLevel is 0
      @zoomReset()
    else
      if offset is 0
        @canvasGraph.zoomToCenter( @canvasGraph.zoomRanges[@canvasGraph.zoomLevel]/2 )
      else
        @canvasGraph.zoomToCenter(@canvasGraph.graphCenter)

      # rebuild slider
      @el.find("#ui-slider").noUiSlider
        start: 0
        range:
          'min': @canvasGraph.smallestX,
          'max': @canvasGraph.largestX - @canvasGraph.zoomRanges[@canvasGraph.zoomLevel]
      , true

    @updateZoomButton(@canvasGraph.zoomLevel)
    @showZoomMessage(@magnification[@canvasGraph.zoomLevel])
    @recordedClickEvents.push { event: 'clickedZoomLevel'+@canvasGraph.zoomLevel, timestamp: (new Date).toUTCString() }

  updateZoomButton: (zoomLevel) ->
    if zoomLevel is 2
      @el.find('#ui-slider').removeAttr('disabled')
      @el.find("#zoom-button").addClass("zoomed")
      @el.find("#zoom-button").addClass("allowZoomOut")
    else if zoomLevel is 1
      @el.find('#ui-slider').removeAttr('disabled')
      @el.find("#zoom-button").addClass("zoomed")
      @el.find("#zoom-button").removeClass("allowZoomOut")
    else
      @el.find('#ui-slider').attr('disabled', true)
      @el.find("#zoom-button").removeClass("zoomed")

  zoomReset: =>
    @canvasGraph.zoomOut()
    @isZoomed = false

  showZoomMessage: (message) =>
    @el.find('#zoom-notification').html(message).fadeIn(100).delay(1000).fadeOut()


  #
  # BEGIN TALK COMMENT METHODS
  #

  onClickJoinConvo: ->
    @joinConvoBtn.hide().siblings().show()

  onClickSubmitTalk: ->
    return if @talkComment.val() is "" # reject empty comments
    @appendComment(@talkComment, @commentsContainer)
    @submitComment()
    @talkComment.val('')

  appendComment: (comment, container) ->
    container.append("""
      <div class="formatted-comment">
        <p>#{comment.val()}</p>
        <p>by <strong>You</strong></p>
      </div>
    """).animate({ scrollTop: container[0].scrollHeight}, 1000)

  onCommentsFetch: ({discussion}) =>
    @comments = discussion.comments

    if @comments.length <= 0
      @commentsContainer.prepend("""
        <div class="formatted-comment">
          <p>See anything interesting? Be the first to discuss this light curve!</p>
        </div>
      """)


    for comment in @comments
      date = new Date comment.created_at
      @commentsContainer.prepend("""
        <div class="formatted-comment">
          <p>#{comment.body}</p>
          <p class="comment-by">by <b>#{comment.user_name}</b>, #{date.toDateString()}</p>
        </div>
      """)#.animate({ scrollTop: container[0].scrollHeight}, 1000)

    #   comment.timeago = $.timeago comment.updated_at
    #   comment.date = DateWidget.formatDate 'd MM yy', new Date comment.updated_at
    # @render()

  fetchComments: =>
    commentsContainer = @el.find '#comments'
    commentsContainer.html "" # delete existing comments
    request = Api.current.get "/projects/#{Api.current.project}/talk/subjects/#{Subject.current?.zooniverse_id}"
    # request = Api.current.get "https://dev.zooniverse.org/projects/planet_hunter/talk/subjects/#{@subject.current.zooniverse_id}"
    request.done @onCommentsFetch

    clearTimeout @timeout if @timeout?

    @timeout = setTimeout =>
      @fetchComments()
    , @refresh * 1000 if @refresh?


  validateComment: (comment)=>
    is_valid = comment.length > 0 && comment.length <= 140

  submitComment: =>
    comment = @talkComment.val()
    is_valid = @validateComment comment
    return unless is_valid
    # request = Api.current.post "https://dev.zooniverse.org/projects/planet_hunter/talk/subjects/#{@subject.current.zooniverse_id}/comments", comment: comment
    request = Api.current.post "/projects/#{Api.current.project}/talk/subjects/#{Subject.current?.zooniverse_id}/comments", comment: comment

    # time = new Date

    # @comments.unshift
    #   user_name: User.current.name
    #   user_zooniverse_id: User.current.zooniverse_id
    #   body: comment
    #   timeago: $.timeago time
    #   date: DateWidget.formatDate 'd MM yy', time

    # @render()

    # clearTimeout @timeout if @timeout?

    # @timeout = setTimeout =>
    #   @fetchComments()
    # , @refresh * 1000 if @refresh?


  #
  # END TALK COMMENT METHODS
  #

module.exports = Classifier
