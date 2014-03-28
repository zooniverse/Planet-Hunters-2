User           = require 'zooniverse/models/user'
# BaseController = require 'zooniverse/controllers/base-controller'
$ = window.jQuery

class MiniCourse #extends BaseController
  constructor: ->
    # super
    console.log 'MiniCourse.constructor()'

    $(classifier.el).find("#course-prompt").hide()
    $(classifier.el).find("#course-container").hide()
    @rate = 10 # set default rate

    $(classifier.el).find("#course-prompt").on "click", "#course-yes", (e) => 
      @onClickCourseYes()

    $(classifier.el).find("#course-prompt").on "click", "#course-no", (e) => 
      @onClickCourseNo()

    $(classifier.el).find("#course-prompt").on "click", "#course-never", (e) => 
      @onClickCourseNever()      


  setRate: (rate) ->
    console.log 'setRate()'
    @rate = rate

  onClickCourseYes: ->
    console.log "onClickCourseYes()"

  onClickCourseNo: ->
    console.log "onClickCourseNo()"

  onClickCourseNever: ->
    console.log "onClickCourseNever()"

  displayCourse: ->
    console.log 'displayCourse()'

  onClickCourseClose: ->
    console.log 'courseClose()'

  onClickCoursePromptClose: ->
    console.log 'onClickCoursePromptClose()'
    
  hideCoursePrompt: ->
    console.log 'hideCoursePrompt()'

  showCoursePrompt: ->
    console.log 'showCoursePrompt()'

  getUserCoursePref: ->
    console.log 'getUserCoursePref()'

  getUserClassCount: ->
    console.log 'getUserClassCount()'

module.exports = MiniCourse