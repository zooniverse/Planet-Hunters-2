User           = require 'zooniverse/models/user'
BaseController = require 'zooniverse/controllers/base-controller'
$ = window.jQuery

class MiniCourse extends BaseController
  className: 'mini-course'
  template: require '../views/classifier'

  events:
    'click img[id="course-prompt-close"]'  : 'onClickCoursePromptClose'
    'click button[name="course-yes"]'      : 'onClickCourseYes'
    'click button[name="course-no"]'       : 'onClickCourseNo'
    'click button[name="course-never"]'    : 'onClickCourseNever'
    'click button[name="course-close"]'    : 'onClickCourseClose'

  # console.log events

  # constructor: (el) ->
  constructor: ->
    super
    console.log 'MiniCourse.constructor()'

    console.log $('classifier').find("#course-prompt")
    @rate = 10 # set default rate


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