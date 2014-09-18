BaseController    = require 'zooniverse/controllers/base-controller'
User              = require 'zooniverse/models/user'
Api               = require 'zooniverse/lib/api'
loginDialog       = require 'zooniverse/controllers/login-dialog'
signupDialog      = require 'zooniverse/controllers/signup-dialog'
miniCourseContent = require '../lib/mini-course-content'
require '../lib/en-us'
$ = window.jQuery

class MiniCourse extends BaseController
  className: 'mini-course'
  template: require '../views/mini-course'

  @transitionTime = 1000

  constructor: ->
    super
    @prompt_el = $(classifier.el).find("#course-prompt")
    @course_el = $(classifier.el).find("#course-container")
    @subject_el = $(classifier.el).find("#subject-container")
    @prompt_el.hide()
    @course_el.hide()

    @idx_curr = 0

    @ADMIN_MODE = false


    # get content
    @content = miniCourseContent # TODO: remove (unnecessary?)

    User.on 'change', =>
      if User.current?
        if @prompt_el.hasClass 'show-login-prompt'
          @hidePrompt()
    #   if User.current?
    #     @prompt_el.addClass 'signed-in'
    #     @prompt_el.find('.course-button').show()
    #     @prompt_el.find('#course-yes-container').show()
    #     @prompt_el.find('#course-message').html 'Mini-course available! Learn more about planet hunting. Interested?'
    #   else
    #     console.log 'PLEASE LOGIN!'
    #     @prompt_el.removeClass 'signed-in'
    #     @prompt_el.find('.course-button').hide()
    #     @prompt_el.find('#course-yes-container').hide()
    #     @prompt_el.find('#course-message').html 'Please <button style="text-decoration: underline" class="sign-in">sign in</button> or <button style="text-decoration: underline" class="sign-up">sign up</button> to receive credit for your discoveries and to participate in the Planet Hunters mini-course.'

    # event callbacks
    @prompt_el.on "click", "#course-yes", (e) => @onClickCourseYes()
    @prompt_el.on "click", "#course-no", (e) => @onClickCourseNo()
    @prompt_el.on "click", "#course-never", (e) => @onClickCourseNever()
    @prompt_el.on "click", "#course-prompt-close", (e) => @hidePrompt()
    @course_el.on "click", ".course-close", (e) => @hideCourse()
    $(classifier.el).on "click", ".sign-in", (e) => loginDialog.show()
    $(classifier.el).on "click", ".sign-up", (e) => signupDialog.show()

  onClickCourseYes: ->
    unless User.current is null
      User.current.setPreference 'course', 'yes'
      $('.course-button').removeClass('selected')
      $('#course-yes').addClass('selected')
      @prompt_el.fadeOut(0)
      # @displayLatest() # THIS NEEDS TO CHANGE

  onClickCourseNo: ->
    unless User.current is null
      User.current.setPreference 'course', 'no'
      $('.course-button').removeClass('selected')
      $('#course-no').addClass('selected')
      @hidePrompt()

  onClickCourseNever: ->
    unless User.current is null
      User.current.setPreference 'course', 'never'
      $('.course-button').removeClass('selected')
      $('#course-never').addClass('selected')
      @hidePrompt()

  incrementCount: ->
    return unless User.current?
    @count = @count + 1
    User.current.setPreference 'count', @count

  setRate: (rate) ->
    @rate = rate
    $('#course-interval').val(@rate)

  coursesAvailable: ->
    if @idx_last >= @content.length
      return false
    else
      return true

  launch: ->
    # console.log "idx_curr: ", @idx_curr
    # console.log "idx_last: ", @idx_last
    return unless User.current?
    return unless @coursesAvailable()
    @idx_curr = @idx_last
    @display(@idx_last)
    @toggleInterface()
    @unlockNext()

  toggleInterface: ->
    @course_el.fadeIn(@transitionTime)
    @subject_el.fadeOut(@transitionTime)
    @subject_el.toggleClass("hidden")
    @course_el.toggleClass("visible")

  display: (index) ->
    prevBtn = $('.arrow.left')
    nextBtn = $('.arrow.right')

    if index > @idx_last
      # console.log "You cannot view this course yet!"
      unless @ADMIN_MODE
        nextBtn.hide()
        return
    else
      @idx_curr = +index

    unless @ADMIN_MODE
      # hide arrows at ends
      if index is 0
        prevBtn.hide() # already at first course
      else
        prevBtn.show()

      if index >= @idx_last
        nextBtn.hide()
      else
        nextBtn.show()

    @loadContent(@idx_curr)

  unlockNext: ->
    return unless @coursesAvailable()
    return unless User.current?
    @idx_curr = @idx_last
    @idx_last = @idx_last + 1
    User.current.setPreference 'curr_course_id', @idx_last
    console.log 'NEXT MINI-COURSE WILL BE: ', @idx_last

  loadContent: (index) ->
    console.log "LOADING CONTENT FOR LESSON: ", index
    # if typeof index is undefined
    #   index = @idx_last # default to latest

    unless @coursesAvailable()
      title  = "That\'s all, folks!"
      text   = "This concludes the mini-course series. Thanks for tuning in!"
      figure = ""
      # TODO: maybe set preference to "never" after this?
    else
      title          = @content[index].material.title
      text           = @content[index].material.text
      figure         = @content[index].material.figure
      video          = @content[index].material.video
      figure_credits = @content[index].material.figure_credits

    @course_el.find("#course-title").html title
    @course_el.find(".course-text").html text
    if video?
      @course_el.find("#course-figure").hide()
      @course_el.find("#course-video").show()
      @course_el.find("#course-video").html video
    else
      @course_el.find("#course-figure").show()
      @course_el.find("#course-video").hide()
      @course_el.find("#course-figure").attr 'src', figure

    @course_el.find(".course-figure-credits").html figure_credits

  hideCourse: ->
    @subject_el.fadeIn(@transitionTime)
    @course_el.fadeOut(@transitionTime)
    @subject_el.toggleClass("hidden")
    @course_el.toggleClass("visible")

  showPrompt: ->
    @prompt_el.fadeIn(@transitionTime)

  hidePrompt: (delay) ->
    @prompt_el.fadeOut(delay)

  getPref: ->
    return unless User.current?
    @pref = User.current?.preferences?.planet_hunter?.course
    return @pref

  resetCourse: ->
    return unless User.current?
    console.log 'initializing mini-course...'
    # User.current.setPreference 'course', 'yes'
    User.current.setPreference 'count', 0
    User.current.setPreference 'curr_course_id', 0
    # User.current.setPreference 'supplemental_option', true
    @count = 0
    @idx_last = +0
    @idx_curr = +0
    console.log """
    idx_curr = #{@idx_curr}
    idx_last = #{@idx_last}
    """

module.exports = MiniCourse
