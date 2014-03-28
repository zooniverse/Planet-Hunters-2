User = require 'zooniverse/models/user'
$ = window.jQuery

class MiniCourse

  constructor: ->
    @prompt_el = $(classifier.el).find("#course-prompt")
    @course_el = $(classifier.el).find("#course-container")

    @count = 0 # fake classification counter

    @prompt_el.hide()
    @course_el.hide()
    
    # event callbacks
    @prompt_el.on "click", "#course-yes", (e) => @onClickCourseYes()
    @prompt_el.on "click", "#course-no", (e) => @onClickCourseNo()
    @prompt_el.on "click", "#course-never", (e) => @onClickCourseNever()      
    @prompt_el.on "click", "#course-prompt-close", (e) => @hidePrompt()  
    @course_el.on "click", "#course-close", (e) => @hideCourse()

  setRate: (rate) ->
    console.log 'setRate()'
    @rate = rate

  onClickCourseYes: ->
    console.log "onClickCourseYes()"
    User.current.setPreference 'course', 'yes', true, @displayCourse()
    @hidePrompt()

  onClickCourseNo: ->
    console.log "onClickCourseNo()"
    User.current.setPreference 'course', 'no', true
    @hidePrompt()

  onClickCourseNever: ->
    console.log "onClickCourseNever()"
    User.current.setPreference 'course', 'never', true
    @hidePrompt()

  displayCourse: ->
    console.log 'displayCourse()'
    @course_el.fadeIn()

  hideCourse: ->
    @course_el.fadeOut()

  showPrompt: ->
    @prompt_el.slideDown()

  hidePrompt: ->
    @prompt_el.slideUp()

  getPref: ->
    @pref = User.current?.preferences['course']

  getNumClass: ->
    # fake it for not
    # @count = User.current?.classification_count 

module.exports = MiniCourse