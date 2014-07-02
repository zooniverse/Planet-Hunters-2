User              = require 'zooniverse/models/user'
Api               = require 'zooniverse/lib/api'
loginDialog       = require 'zooniverse/controllers/login-dialog'
signupDialog      = require 'zooniverse/controllers/signup-dialog'
miniCourseContent = require '../lib/mini-course-content'
require '../lib/en-us'
$ = window.jQuery

class MiniCourse

  @transitionTime = 1000

  constructor: ->
    @prompt_el = $(classifier.el).find("#course-prompt")
    @course_el = $(classifier.el).find("#course-container")
    @subject_el = $(classifier.el).find("#subject-container")
    # @prompt_el.hide()
    # $(classifier.el).find('#course-interval-setter').toggleClass('visible')
    @course_el.hide()

    # get content
    @content = miniCourseContent
    
    # keep track of courses
    @count = 0 # fake classification counter
    @curr = 0
    @prev = 0

    User.on 'change', =>
      # needs to be changed to read user's last course number
      @resetCourse() #unless User.current?.preferences[Api.current.project]?.hasOwnProperty 'prev_course'
      if User.current?
        @prompt_el.toggleClass 'signed-in'
        @prompt_el.find('.course-button').show()
        @prompt_el.find('#course-message').html 'Mini-course available! Learn more about planet hunting. Interested?'
      else
        @prompt_el.toggleClass 'signed-in'
        @prompt_el.find('.course-button').hide()
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
    if @curr >= @content.length
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

  setRate: (rate) ->
    @rate = rate

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
    return if @curr > @num_courses
    unless User.current is null
      User.current.setPreference 'prev_course', @prev
      @loadContent()
      @course_el.fadeIn(@transitionTime)
      @subject_el.fadeOut(@transitionTime)
      @subject_el.toggleClass("hidden")
      @course_el.toggleClass("visible")
      @prev = @curr
      @curr = +@curr + 1

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
    @pref = User.current?.preferences[Api.current.project]['course']
    # console.log 'course preference: ', @pref # DEBUG CODE
    return @pref

  resetCourse: ->
    unless User.current is null
      User.current.setPreference 'course', 'yes'
      User.current.setPreference 'prev_course', 0
      @prev = User.current?.preferences[Api.current.project]['prev_course']
      @curr = 0

module.exports = MiniCourse
