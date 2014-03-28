User           = require 'zooniverse/models/user'
# BaseController = require 'zooniverse/controllers/base-controller'
$ = window.jQuery

class MiniCourse #extends BaseController
  constructor: ->
    # super
    console.log 'MiniCourse.constructor()'

    @rate = 10 # set default rate
    @prompt_el = $(classifier.el).find("#course-prompt")
    @course_el = $(classifier.el).find("#course-container")

    @prompt_el.hide()
    @course_el.hide()
    
    # event callbacks
    @prompt_el.on "click", "#course-yes", (e) => @onClickCourseYes()
    @prompt_el.on "click", "#course-no", (e) => @onClickCourseNo()
    @prompt_el.on "click", "#course-never", (e) => @onClickCourseNever()      
    @prompt_el.on "click", "#course-prompt-close", (e) => @onClickCoursePromptClose()  
    @course_el.on "click", "#course-close", (e) => @onClickCourseClose()


  setRate: (rate) ->
    console.log 'setRate()'
    @rate = rate

  onClickCourseYes: ->
    console.log "onClickCourseYes()"
    @displayCourse()

  onClickCourseNo: ->
    console.log "onClickCourseNo()"

  onClickCourseNever: ->
    console.log "onClickCourseNever()"

  displayCourse: ->
    console.log 'displayCourse()'
    @course_el.fadeIn()

  hideCourse: ->
    @course_el.fadeOut()

  onClickCourseClose: ->
    console.log 'courseClose()'
    @hideCourse()

  hidePrompt: ->
    @prompt_el.hide()

  onClickCoursePromptClose: ->
    console.log 'onClickCoursePromptClose()'
    @prompt_el.slideUp()

  showCoursePrompt: ->
    console.log 'showCoursePrompt()'

  getUserCoursePref: ->
    console.log 'getUserCoursePref()'

  getUserClassCount: ->
    console.log 'getUserClassCount()'

module.exports = MiniCourse