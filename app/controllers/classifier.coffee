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

{createTutorialSubject}    = require '../lib/create-tutorial-subject'
{createKnownPlanetSubject} = require '../lib/create-known-planet-subject'

$ = window.jQuery

K1_SUBJECT_GROUP   = "5417014a3ae7400bda000001"
K2_0_SUBJECT_GROUP = "547d05ce415ac13139000001"
K2_1_SUBJECT_GROUP = "54f4c5ab8f165b6e85000001"
MAIN_SUBJECT_GROUP = K2_1_SUBJECT_GROUP
SIMULATION_GROUP   = "5417014b3ae7400bda000002"

USERS_OPT_IN = ['a', 'b', 'c', 'g', 'h', 'i']
USERS_OPT_OUT = ['d', 'e', 'f', 'j', 'k', 'l']

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
    'click button.submit-talk'                : 'onClickSubmitTalk'
    'click button.alt-submit-talk'            : 'onClickSubmitTalkAlt'
    'change #course-interval'                 : 'onChangeCourseInterval'
    'change #course-interval-sup-tut'         : 'onChangeCourseIntervalViaSupTut'
    'change input[name="mini-course-option"]' : 'onChangeMiniCourseOption'
    'change input[name="course-opt-out"]'     : 'onChangeCourseOptOut'
    'click button[name="continue-button"]'    : 'onClickContinueButton'
    'keyup textarea[name="talk-comment"]'     : 'onKeyupTalkComment'
    'focus textarea[name="talk-comment"]'     : 'onFocusTalkComment'


    'click .arrow.left'  : 'onClickCourseBack'
    'click .arrow.right' : 'onClickCourseForward'

    'click button[name="populate-hashtag"]'   : 'onClickPopulateHashtag'

    # CODE FOR PROMPT (NOT CURRENTLY IN USE)
    # 'mouseenter #course-yes-container'        : 'onMouseoverCourseYes'
    # 'mouseleave  #course-yes-container'       : 'onMouseoutCourseYes'

  constructor: ->
    super

    # # if mobile device detected, go to verify mode
    # if window.matchMedia("(min-device-width: 320px)").matches and window.matchMedia("(max-device-width: 480px)").matches
    #   location.hash = "#/verify"

    Subject.group = MAIN_SUBJECT_GROUP

    @loggedOutClassificationCount = 0

    window.classifier = @
    @recordedClickEvents = [] # array to store all click events

    # zoom levels [days]: 2x, 10x, 20x
    isZoomed: false
    ifFaved: false

    # classification counts at which to display supplementary tutorial
    @supTutIntervals = [1, 2, 3] # TODO: don't forget to add 4 after beta version
    @splitDesignation = null

    @known_transits = ''

    @guideShowing = false

    # @hideMarkingButtons()
    @noTransitsButton.attr 'disabled', true


    User.on 'change', @onUserChange
    Subject.on 'no-more', @onNoMoreSubjects
    Subject.on 'fetch', @onSubjectFetch
    Subject.on 'select', @onSubjectSelect

    @Subject = Subject

    $(document).on 'mark-change', =>
      if @canvasGraph.marks?.all.length > 0
        @noTransitsButton.hide()
        @finishedMarkingButton.show()
      else
        @finishedMarkingButton.hide()


        @noTransitsButton.show()

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

    # hide metadata portion
    @el.find('.k1-metadata').hide()
    @el.find('.k2-metadata').hide()

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
    console.log 'onChangeMiniCourseOption()'
    return unless User.current?
    showMiniCourse = $("[name='mini-course-option']").prop 'checked'

    if showMiniCourse
      User.current?.setPreference 'course', 'yes'
      @courseEnabled = true
    else
      User.current?.setPreference 'course', 'no'
      @courseEnabled = false

    clickEvent =
      event: 'course-enabled'
      value: @courseEnabled
      timestamp: (new Date).toUTCString()
    @recordedClickEvents.push clickEvent
    console.log '  course-enabled: ', @courseEnabled

  onChangeCourseOptOut: ->
    console.log 'onChangeCourseOptOut()'
    return unless User.current?
    optOut = $("[name='course-opt-out']").prop 'checked'

    if optOut
      User.current?.setPreference 'course', 'no'
      @courseEnabled = false
    else
      User.current?.setPreference 'course', 'yes'
      @courseEnabled = true

    clickEvent =
      event: 'course-opted-out'
      value: optOut
      timestamp: (new Date).toUTCString()
    @recordedClickEvents.push clickEvent
    console.log '  course-enabled: ', @courseEnabled


  onKeyupTalkComment:(e)->
    characters = @talkComment.val().length
    $(".too-long-warning").html( "#{ 140 - characters} left" )



  onChangeCourseIntervalViaSupTut: ->
    defaultValue = 5
    value = +@el.find('#course-interval-sup-tut').val()

    # validate integer values
    unless (typeof value is 'number') and (value % 1 is 0) and value > 0 and value < 100
      value = defaultValue
      @el.find('#course-interval-sup-tut').val(value)
    # else
    #   console.log 'SETTING VALUE TO: ', value

    @course.setRate value

    clickEvent =
      event: 'course-interval-changed'
      value: value
      timestamp: (new Date).toUTCString()
    @recordedClickEvents.push clickEvent

  onUserChange: (e, user) =>
    @classifySummary.fadeOut(150)
    @nextSubjectButton.hide()

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

  onNoMoreSubjects: ->
    $('#all-done-message').html 'Wow! It appears you\'ve done all there is to do for now. Thanks for your work and check back soon.'

  initializeMiniCourse: ->
    return unless User.current?
    User.current.setPreference 'count', 0
    User.current.setPreference 'curr_course_id', 0
    @course.count = 0
    @course.idx_last = 0

  handleSplitDesignation: ->
    # console.log '*** SETTING UP SPLIT DESIGNATION ***'
    if User.current.project.splits?.mini_course_sup_tutorial?
      @splitDesignation = User.current.project.splits.mini_course_sup_tutorial
    else
      console.log 'WARNING: No split designation detected! Using default.'
      @splitDesignation = 'a' # default split designation

    unless @getParameterByName("split") is ""
      @splitDesignation = @getParameterByName("split")

    # console.log '    SPLIT DESIGNATION IS: ', @splitDesignation

    # SET MINI-COURSE INTERVAL
    if @splitDesignation in ['b', 'e', 'h', 'k']
      # console.log '    Setting mini-course interval to 5'
      @course.setRate 5
      $('#course-interval-setter').remove() # destroy custom course interval setter

    else if @splitDesignation in ['c', 'f', 'i', 'l']
      # console.log '    Setting mini-course interval to 10'
      @course.setRate 10
      $('#course-interval-setter').remove() # destroy custom course interval setter

    else if @splitDesignation in ['a', 'd', 'g', 'j']
      # console.log '    Setting mini-course interval to 5'
      # console.log 'Allowing custom course interval.'
      @course.setRate 5 # set default
      @allowCustomCourseInterval = true
    else
      # console.log '    Setting mini-course interval to 5 (default)'
      @allowCustomCourseInterval = false
      @course.setRate 5 # set default

    # SET MINI-COURSE DEFAULT OPT-IN/OUT PREFS
    if @splitDesignation in USERS_OPT_IN
      @courseEnabled = false
      User.current.setPreference 'course', 'no'
      # initialize checkboxes
      $("[name='course-opt-out']").prop 'checked', true
      $("[name='mini-course-option']").prop 'checked', false
    else if @splitDesignation in USERS_OPT_OUT
      @courseEnabled = true
      User.current.setPreference 'course', 'yes'
      # initialize checkboxes
      $("[name='course-opt-out']").prop 'checked', false
      $("[name='mini-course-option']").prop 'checked', false

  onSubjectSelect: (e, subject) =>
    # console.log 'onSubjectSelect(): '
    # console.log "selecting subject #{subject.zooniverse_id}"
    @subject = subject
    @classification = new Classification {subject}
    @loadSubjectData()
    @fetchComments()

  loadSubjectData: () ->
    # reset fav
    @el.find(".toggle-fav").removeClass("toggled")

    if window.location.origin != "http://planethunters.org"  and window.location.origin != "http://www.planethunters.org"
      jsonFile = @subject.selected_light_curve.location.replace("http://www.planethunters.org/", "https://s3.amazonaws.com/zooniverse-static/planethunters.org/")
    else
      jsonFile = @subject.selected_light_curve.location

    # handle ui elements
    $('#graph-container').addClass 'loading-lightcurve'
    @el.find('#loading-screen').fadeIn()
    @el.find('.star-id').hide()
    # @el.find('#ui-slider').attr('disabled',true)
    # @el.find(".noUi-handle").fadeOut(150)

    # remove any previous canvas; create new one
    @canvas?.parentNode.removeChild(@canvas)
    @canvas = document.createElement('canvas')
    @canvas.id = 'graph'
    @canvas.width = 1024
    @canvas.height = 420

    # read json data
    $.getJSON jsonFile, (data) =>

      if data.metadata.known_transits
        @known_transits = data.metadata.known_transits
        @planet_rad    = data.metadata.planet_rad
        @planet_period = data.metadata.planet_period
        @start_time     = data.x[0]
      else
        @known_transits = ''

      @canvasGraph?.marks.destroyAll()
      @marksContainer.appendChild(@canvas)
      @canvasGraph = new CanvasGraph(@canvas, data)
      @zoomReset()
      @canvasGraph.plotPoints()
      @el.find('#loading-screen').fadeOut()
      @canvasGraph.enableMarking()
      @magnification = [ '1x (all days)', '10 days', '2 days' ]
      @showZoomMessage(@magnification[@canvasGraph.zoomLevel])

      $('#graph-container').removeClass 'loading-lightcurve'
      # @noTransitsButton.fadeIn(150)
      @noTransitsButton.attr 'disabled', false

      $("#ui-slider").noUiSlider
        start: 0
        range:
          min: @canvasGraph.smallestX
          max: @canvasGraph.largestX
      , true


      # @el.find(".noUi-handle").hide()
      @canvasGraph.zoomOut()
      return

    @insertMetadata()

  insertMetadata: ->
    # ukirt data
    @ra      = @subject.coords[0]
    @dec     = @subject.coords[1]
    ukirtUrl = "http://surveys.roe.ac.uk:8080/wsa/GetImage?ra=" + @ra + "&dec=" + @dec + "&database=wserv4v20101019&frameType=stack&obsType=object&programmeID=10209&mode=show&archive=%20wsa&project=wserv4"

    metadata = @Subject.current.metadata

    @el.find('#zooniverse-id').html @Subject.current.zooniverse_id
    @el.find('#kepler-id').html     metadata.kepler_id
    @el.find('#quarter').html @Subject.current.selected_light_curve.quarter

    if MAIN_SUBJECT_GROUP == K1_SUBJECT_GROUP
      @el.find('#star-type').html     (metadata.spec_type || "Dwarf")
      @el.find('#magnitude').html     metadata.magnitudes.kepler
      @el.find('#temperature').html   metadata.teff.toString().concat("(K)")
      @el.find('#radius').html        metadata.radius.toString().concat("x Sol")
      @el.find('#ukirt-url').attr("href", ukirtUrl)
      @el.find(".k1-metadata").fadeIn()
      @el.find(".k2-metadata").hide()
    else
      @el.find('#manitude').html   (metadata.magnitudes["kepler"])
      @el.find(".k1-metadata").hide()
      @el.find(".k2-metadata").fadeIn()

  notify: (message) =>
    @course.hidePrompt(0) # get the prompt out of the way
    return if @el.find('#notification').hasClass('notifying')
    @el.find('#notification').addClass('notifying')
    @el.find('#notification-message').html(message).fadeIn(100).delay(2000).fadeOut( 400, 'swing', =>
      @el.find('#notification').removeClass('notifying') )

  onToggleFav: ->
    isFaved = @classification.favorite
    if isFaved
      @classification.favorite = false
      @el.find(".toggle-fav").removeClass("toggled")
      @notify('Removed from Favorites.')
    else
      @classification.favorite = true
      @el.find(".toggle-fav").addClass("toggled")
      @notify('Added to Favorites.')

  onClickTalkButton: ->
    window.open "http://talk.planethunters.org/#/subjects/#{Subject.current?.zooniverse_id}?quarter=#{@Subject.current.selected_light_curve.quarter}", '_blank'

  onClickHelp: ->
    if @guideShowing
      @spottersGuide.slideUp()
    else
      @spottersGuide.slideDown()
      $("html, body").animate scrollTop: @spottersGuide.offset().top - 20, 500
      clickEvent = { event: 'spotters-guide-pressed', timestamp: (new Date).toUTCString() }
      @recordedClickEvents.push clickEvent
    @guideShowing = !@guideShowing

  onClickTutorial: ->
    clickEvent = { event: 'tutorial-clicked', timestamp: (new Date).toUTCString() }
    @recordedClickEvents.push clickEvent
    @canvasGraph.marks.destroyAll() # clear previous marks

    @finishedMarkingButton.hide()
    # @noTransitsButton.show()

    @launchTutorial()

  launchTutorial: ->
    # @noTransitsButton.hide()
    @noTransitsButton.attr 'disabled', true

    if $('#graph-container').hasClass 'loading-lightcurve'
      @notify 'Please wait until current lightcurve is loaded.'
      return
    # load training subject
    # @notify('Loading tutorial...')
    tutorialSubject = createTutorialSubject()
    tutorialSubject.select()
    # do stuff after tutorial complete/aborted
    addEventListener "zootorial-end", =>
      $('.tutorial-annotations.x-axis').removeClass('visible')
      $('.tutorial-annotations.y-axis').removeClass('visible')
      $('.mark').fadeIn()
    @initialTutorial.start()

  #
  # BEGIN MARKING TRANSITIONS
  #

  onClickNoTransits: ->

    if @simulationsPresent() or @knownPlanetPresent()
      @evaluateMarks()
      @displayKnownTransits()
      @noTransitsButton.hide()
      @finishedMarkingButton.hide()
    else
      @noTransitsButton.hide()
      @finishedMarkingButton.hide()
      @showSummaryScreen()

  onClickFinished: ->
    if @simulationsPresent() or @knownPlanetPresent()
      @evaluateMarks()
      @displayKnownTransits()
    else
      @showSummaryScreen()

  onClickContinueButton: ->
    @hideMarkingButtons()
    @showSummaryScreen()

  onClickNextSubject: ->
    # console.log 'COUNT: ', @course.count # DEBUG CODE
    # console.log 'SIM COUNT: ', @sim_count
    @hideMarkingButtons()
    @noTransitsButton.show()
    @noTransitsButton.attr 'disabled', true
    @course.prompt_el.hide()
    @classifySummary.fadeOut(150)

    # # switch to verify mode
    # if @course.count % @verifyRate is 0
    #   location.hash = "#/verify"

    # if @course.getPref() isnt 'never' and @course.count % @course.rate is 0 and @course.coursesAvailable() and @course.count isnt 0
    #   @el.find('#notification-message').hide() # get any notification out of the way
    #   @course.showPrompt()

    if @course.getPref() is "yes" and @course.count % @course.rate is 0 and @course.coursesAvailable() and @course.count isnt 0
      @notify 'Loading mini-course...'
      @course.launch()

    if @splitDesignation in ['a', 'b', 'c', 'd', 'e', 'f']
      @supTutIntervals = [3]
    @checkSupplementalTutorial()

    @sendClassification()
    @canvasGraph.marks.destroyAll() #clear old marks
    @recordedClickEvents = []
    @talkComment.val('')

    @sim_count ||= 0
    @sim_count +=1


    @sim_rate = 0.125

    sim_roll = Math.random()
    # console.log "sim roll #{sim_roll} rate #{@sim_rate}"

    if Math.random() < @sim_rate
      # console.log "fetching sim subject..."

      Subject.group = SIMULATION_GROUP
      Subject.fetch limit: 1, (subjects) ->
        Subject.current?.destroy()

        # select sim subject
        unless subjects.length is 0
          subjects[0].select()
        else
          # console.log 'no more sims; selecting next subject instead...'
          # if no sims, revert to regular subjects
          Subject.group = MAIN_SUBJECT_GROUP
          @Subject.next()

        Subject.group = MAIN_SUBJECT_GROUP # reset to regular subjects

    else
      @Subject.next()

    # # DEBUG CODE
    # @Subject.current?.destroy()
    # test_subject = createKnownPlanetSubject()
    # test_subject.select()

    # @noTransitsButton.show()

  #
  # END MARKING TRANSITIONS
  #

  hideMarkingButtons: ->
    @noTransitsButton.hide()
    @finishedMarkingButton.hide()
    @nextSubjectButton.hide()
    @continueButton.hide()

  showSummaryScreen: ->
    @el.find('.too-long-warning').html("140 left") # reset char count
    @el.find('.star-id').fadeIn() # reveal ids

    if @classification.subject.id is 'TUTORIAL_SUBJECT'
      # console.log 'TUTORIAL SUBJECT'
      @hideMarkingButtons()
      @onClickNextSubject()
    else
      if not User.current?
        @el.find('.talk-pill-nologin').show()
        @el.find('.talk-pill').hide()
      else
        @el.find('.talk-pill-nologin').hide()
        @el.find('.talk-pill').show()

      if @knownPlanetPresent()
        @showPlanetDetails()
      else if @simulationsPresent()
        @showSimDetails()
      else
        $(".planet_details").hide()
        $(".sim_details").hide()

      @hideMarkingButtons()
      @nextSubjectButton.show()
      @setGuestObsContent()
      @classifySummary.fadeIn(150)

  showSimDetails:=>
    $(".planet_details").hide()
    $(".sim_details").show()
    $(".sim_details .planet-rad").html(@planet_rad + " Earth Radii")
    $(".sim_details .planet-period").html(@planet_period + " days")

  showPlanetDetails:=>
    $(".sim_details").hide()
    $(".planet_details").show()
    $(".planet_details .planet-rad").html( @subject.metadata.planet_rad + " Earth Radii" )
    $(".planet_details .planet-period").html( @subject.metadata.planet_period + " days" )

  checkSupplementalTutorial: ->
    for classification_count in @supTutIntervals
      if @course.count is classification_count
        # console.log "*** DISPLAY SUPPLEMENTAL TUTOTIAL # #{classification_count} *** "
        @supplementalTutorial.first = "displayOn_" + classification_count.toString()
        @supplementalTutorial.start()

        # prompt user to opt in/out of mini course
        if @course.count is 3
          @renderSupTutPrompt() # inject HTML into tutorial
          if @allowCustomCourseInterval
            @el.find('.allow-custom-interval').show()
            @el.find('.disallow-custom-interval').hide()
          else
            @el.find('.allow-custom-interval').hide()
            @el.find('.disallow-custom-interval').show()

          if @courseEnabled
            @el.find('[name="mini-course-option"]').prop 'checked', true
            @el.find('[name="course-opt-out"]').prop 'checked', false
            $('.zootorial-content')[1].getElementsByTagName("span")[0].insertAdjacentHTML('afterend',' Uncheck the box below to opt-out of this mini-course.')
          else
            @el.find('[name="mini-course-option"]').prop 'checked', false
            @el.find('[name="course-opt-out"]').prop 'checked', false
            $('.zootorial-content')[1].getElementsByTagName("span")[0].insertAdjacentHTML('afterend',' Check the box below to opt-in to the mini-course.')


  renderSupTutPrompt: ->
    newElement = document.createElement('div')
    newElement.setAttribute 'class', "supplemental-tutorial-option-container"
    newElement.setAttribute 'style', "padding: 20px;"
    newElement.innerHTML = """
      <input class="mini-course-option" name="mini-course-option" type="checkbox"></input>
      <div id="course-opt-in-label" style="float: left; font-style: italic; font-weight: 500;">

        <div class="allow-custom-interval">
          <div class="course-interval-text">Launch mini-course every </div>
          <input type="number" id="course-interval-sup-tut" class="course-interval" name="course-interval-sup-tut" value="5" />
          <div class="course-interval-text"> light curves!</div>
        </div>

        <div class="disallow-custom-interval">
          <p>Yes, I'd like to participate in the mini-course!</p>
        </div>

      </div>
    """
    # inject custom element into zootorial
    @supplementalTutorial.container.getElementsByClassName('zootorial-content')[0].appendChild(newElement)

  sendClassification: ->
    if User.current?
      @course.incrementCount()
      @course.hidePrompt()
    else
      # prompt users to sign
      if +@loggedOutClassificationCount % 5 is 0
        promptElement = @el.find('#course-prompt')
        promptElement.removeClass 'signed-in'
        promptElement.addClass 'show-login-prompt'
        promptElement.find('.course-button').hide()
        promptElement.find('#course-yes-container').hide()
        promptElement.find('#course-message').html 'Please <button style="text-decoration: underline" class="sign-in">sign in</button> or <button style="text-decoration: underline" class="sign-up">sign up</button> to receive credit for your discoveries and to participate in the Planet Hunters mini-course.'
        @course.showPrompt()
      @loggedOutClassificationCount += 1

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
      # console.log 'MARK SCORE: ', mark.score # DEBUG CODE

    @classification.annotate
      recordedClickEvents: [@recordedClickEvents...]

    # console.log JSON.stringify( @classification ) # DEBUG CODE

    # send classification (except for tutorial subject)
    unless @classification.subject.id is 'TUTORIAL_SUBJECT'
      @classification.send()

  evaluateMarks: ->
    return unless User.current?
    for transit in @known_transits
      best_score = 0 # that's right, assume they got it WRONG!!!
      transitL = transit[0] - @start_time
      transitR = transit[1] - @start_time
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
    # console.log 'displayKnownTransits() '
    return unless @simulationsPresent() or @knownPlanetPresent()
    # console.log 'found transits'
    @canvasGraph.disableMarking()
    @hideMarkingButtons()
    @continueButton.show()

    if @knownPlanetPresent()
      @known_transits = @Subject.current.metadata.known_transits

    start_time = @Subject.current.selected_light_curve.start_time

    for transit, i in @known_transits
      @canvasGraph.highlightCurve(transit[0] - start_time, transit[1]- start_time)

    @course.showPrompt()
    @course.prompt_el.find('#course-yes-container').hide()
    @course.prompt_el.find('#course-no').hide()
    @course.prompt_el.find('#course-never').hide()
    if @knownPlanetPresent()
      @course.prompt_el.find('#course-message').html "This light curve contains a known kepler planet. Transits in this quarter (if any) are highlighted in red."
    else
      @course.prompt_el.find('#course-message').html "This light curve contains at least one simulated transit, highlighted in red."

    return

  simulationsPresent: ->
    if @known_transits.length > 0
      return true
    else
      return false

  knownPlanetPresent:->
    @subject.metadata.known_planet?

  setGuestObsContent:=>
    # console.log GuestObsContent
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
      $("#ui-slider").noUiSlider
        start: 0
        range:
          min: @canvasGraph.smallestX
          max: @canvasGraph.largestX - @canvasGraph.zoomRanges[@canvasGraph.zoomLevel]
      , true

    @updateZoomButton(@canvasGraph.zoomLevel)
    @showZoomMessage(@magnification[@canvasGraph.zoomLevel])
    @recordedClickEvents.push { event: 'clicked-zoom-level'+@canvasGraph.zoomLevel, timestamp: (new Date).toUTCString() }

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

  onClickSubmitTalk: =>
    console.log("triggering")
    return if @talkComment.val() is "" # reject empty comments

    @appendComment(@talkComment, @commentsContainer)
    @submitComment()
    @talkComment.val('')

  onFocusTalkComment: ->
    return unless @talkComment.val() is ""
    quarter = @subject.selected_light_curve.quarter
    @talkComment.val('Q'+quarter+' ')
    @onKeyupTalkComment()

  onClickPopulateHashtag: ->
    hashtag = @el.find('.guest_obs_title').html()
    unless @talkComment.val().length + hashtag.length <= 140
      @notify("You've exceeded the 140 character limit.")
      return
    hashtag = @el.find('.guest_obs_title').html()
    @talkComment.val( @talkComment.val() + ' ' + hashtag )

  appendComment: (comment, container) ->
    container.append("""
        <div class="comment formatted">
          <p class="comment body">#{comment.val()}</p>
          <div class="comment info">
            <span class="comment comment-by">by</span>
            <span class="comment username">You</span>
            <span class="comment comment-by">#{new Date().toDateString()}</span>
          <div>
        </div>
      """).animate({ scrollTop: container[0].scrollHeight}, 1000)

  onCommentsFetch: ({discussion}) =>
    @comments = discussion.comments

    if @comments.length <= 0
      @commentsContainer.prepend("""
        <div class="formatted-comment">
          <p class="comment default-text">See anything interesting? Be the first to discuss this light curve!</p>
        </div>
      """)

    for comment in @comments
      date = new Date comment.created_at
      @commentsContainer.prepend("""
        <div class="comment formatted">
          <p class="comment body">#{comment.body}</p>
          <div class="comment info">
            <span class="comment comment-by">by</span>
            <span class="comment username">#{comment.user_name}</span>
            <span class="comment comment-by">#{date.toDateString()}</span>
          <div>
        </div>
      """)

    setTimeout =>
      @commentsContainer.animate({ scrollTop: $('#comments')[0].scrollHeight}, 1000)
    , 2000

  fetchComments: =>
    commentsContainer = @el.find '#comments'
    commentsContainer.html "" # delete existing comments
    # request = Api.current.get "https://dev.zooniverse.org/projects/planet_hunter/talk/subjects/APH000001x" # DEBUG CODE
    request = Api.current.get "/projects/#{Api.current.project}/talk/subjects/#{Subject.current?.zooniverse_id}"
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
    unless is_valid
      @notify("You've exceeded the 140 character limit.")
      return
    request = Api.current.post "/projects/#{Api.current.project}/talk/subjects/#{Subject.current?.zooniverse_id}/comments", comment: comment

  #
  # END TALK COMMENT METHODS
  #

module.exports = Classifier
