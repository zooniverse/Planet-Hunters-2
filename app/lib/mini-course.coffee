User           = require 'zooniverse/models/user'
BaseController = require 'zooniverse/controllers/base-controller'
$ = window.jQuery

class MiniCourse extends BaseController

	constructor: (el) ->
		console.log 'MiniCourse.constructor()'

		@el = el
		console.log @el.find("#course-prompt")
		@rate = 10 # set default rate

	setRate: (rate) ->
		@rate = rate

  onClickCourseYes: ->
    console.log "course: yes"
    User.current.setPreference 'course', 'yes', true, @displayCourse()
    @onClickCoursePromptClose()

  onClickCourseNo: ->
    console.log "course: no"
    User.current.setPreference 'course', 'no', true
    @onClickCoursePromptClose()

  onClickCourseNever: ->
    console.log "course: never"
    User.current.setPreference 'course', 'never', true
    @onClickCoursePromptClose()

  displayCourse: ->
    @el.find('#course-container').fadeIn('fast')

  onClickCourseClose: ->
    console.log 'courseClose()'
    @el.find('#course-container').fadeOut('fast')

  onClickCoursePromptClose: ->
    @hideCoursePrompt()
    
  hideCoursePrompt: ->
    @el.find('#course-prompt').slideUp()

  showCoursePrompt: ->
    console.log 'course prompt!'
    @el.find('#course-prompt').slideDown()

  getUserCoursePref: ->
    @userCoursePref = User.current?.preferences['course']
    return @userCoursePref
  
  getUserClassCount: ->
    # @userClassCount = User.current?.classification_count 
    # not live, so use faux counter
    return @userClassCount

module.exports = MiniCourse