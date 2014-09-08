User              = require 'zooniverse/models/user'
Api               = require 'zooniverse/lib/api'
loginDialog       = require 'zooniverse/controllers/login-dialog'
signupDialog      = require 'zooniverse/controllers/signup-dialog'
miniCourseContent = require '../lib/mini-course-content'
require '../lib/en-us'
$ = window.jQuery

class MiniCourse
  className: 'mini-course'
  template: require '../views/mini-course'
  
  @transitionTime = 1000
  constructor: ->
    @prompt_el = $(classifier.el).find("#course-prompt")
    @course_el = $(classifier.el).find("#course-container")
    @subject_el = $(classifier.el).find("#subject-container")
    @prompt_el.hide()
    @course_el.hide()

    # get content
    @content = miniCourseContent # TODO: remove (unnecessary?)
    
    User.on 'change', =>
      if User.current?
        @prompt_el.toggleClass 'signed-in'
        @prompt_el.find('.course-button').show()
        @prompt_el.find('#course-yes-container').show()
        @prompt_el.find('#course-message').html 'Mini-course available! Learn more about planet hunting. Interested?'
      else
        @prompt_el.toggleClass 'signed-in'
        @prompt_el.find('.course-button').hide()
        @prompt_el.find('#course-yes-container').hide()
        @prompt_el.find('#course-message').html 'Please <button style="text-decoration: underline" class="sign-in">sign in</button> or <button style="text-decoration: underline" class="sign-up">sign up</button> to receive credit for your discoveries and to participate in the Planet Hunters mini-course.'

    # event callbacks
    @prompt_el.on "click", "#course-yes", (e) => @onClickCourseYes()
    @prompt_el.on "click", "#course-no", (e) => @onClickCourseNo()
    @prompt_el.on "click", "#course-never", (e) => @onClickCourseNever()
    @prompt_el.on "click", "#course-prompt-close", (e) => @hidePrompt()
    @course_el.on "click", ".course-close", (e) => @hideCourse()
    $(classifier.el).on "click", ".sign-in", (e) => loginDialog.show() 
    $(classifier.el).on "click", ".sign-up", (e) => signupDialog.show() 

  loadContent: ->
    unless @coursesAvailable()
      title  = "That\'s all, folks!"
      text   = "This concludes the mini-course series. Thanks for tuning in!"
      figure = ""
      # TODO: maybe set preference to "never" after this?
    else
      title          = @content[@curr].material.title
      text           = @content[@curr].material.text
      figure         = @content[@curr].material.figure
      figure_credits = @content[@curr].material.figure_credits

    # # DEBUG CODE
    # console.log 'title         : ', title
    # console.log 'text          : ', text
    # console.log 'figure        : ', figure
    # console.log 'figure_credits: ', figure_credits

    @course_el.find("#course-title").html title
    @course_el.find(".course-text").html text
    @course_el.find("#course-figure").attr 'src', figure
    @course_el.find(".course-figure-credits").html figure_credits

  incrementCount: ->
    return unless User.current?
    @count = @count + 1
    User.current.setPreference 'count', @count

  setRate: (rate) ->
    @rate = rate
    $('#course-interval').val(@rate)

  coursesAvailable: ->
    if @curr >= @content.length
      # console.log 'WARNING: COURSES NOT AVAILABLE!!!'
      return false
    else
      # console.log 'AWESOME. COURSES AVAILABLE!!!'
      return true

  onClickCourseYes: ->
    unless User.current is null
      User.current.setPreference 'course', 'yes'
      $('.course-button').removeClass('selected')
      $('#course-yes').addClass('selected')
      @prompt_el.fadeOut(0)
      @displayCourse()

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

  displayCourse: ->
    # console.log "@curr: #{@curr}, @num_courses: #{@num_courses}"
    return unless @coursesAvailable()
    return unless User.current?
    @loadContent()
    @curr = +@curr + 1
    # console.log 'SETTING CURRENT COURSE ID TO: ', @curr
    User.current.setPreference 'curr_course_id', @curr
    @course_el.fadeIn(@transitionTime)
    @subject_el.fadeOut(@transitionTime)
    @subject_el.toggleClass("hidden")
    @course_el.toggleClass("visible")

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
    # console.log 'initializing mini-course...'
    # User.current.setPreference 'course', 'yes'
    User.current.setPreference 'count', 0
    User.current.setPreference 'curr_course_id', 0 
    # User.current.setPreference 'supplemental_option', true
    @count = 0
    @curr  = 0

module.exports = MiniCourse
