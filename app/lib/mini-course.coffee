User = require 'zooniverse/models/user'
$ = window.jQuery

class MiniCourse

  constructor: ->

    # check previous courses taken
    User.on 'change', =>
      console.log 'FOO: ', User.current?.preferences.hasOwnProperty 'prev_course'
      @resetCourse() unless User.current?.preferences.hasOwnProperty 'prev_course'
      @prev = +User.current?.preferences['prev_course']
      @curr = +@prev + 1

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

    @loadCourseContent()

  loadCourseContent: ->
    # not working yet
    # @jsonFile = $.getJSON "./mini-course-content.json", @parseJSON()
    @parseJSON()

  parseJSON: ->
    jsonData = '
      [
        {
          "course_number": 1,
          "material":
          {
            "title": "The Kepler Mission",
            "text": "The Kepler space telescope was launched by NASA in 2009. It was named after German astronomer Johannes Kepler, who is best known for developing the laws of planetary motion in the 17th century. For 4 years it stared at a patch of sky 100 square degrees in area (500 times that of the full Moon) in the constellations Lyra, Cygnus and Draco, looking for the tell-tale dips in brightness caused when a planet passes in front of its host star. It is these brightness measurements you are looking at on Planet Hunters.",
            "figure": "./images/mini-course/01-KeplerHR_sm.jpg"
          }
        },
        {
          "course_number": 2,
          "material":
          {
            "title": "The Kepler Mission (Part 2)",
            "text": "Prepare to be schooled!",
            "figure": "./images/mini-course/01-KeplerHR_sm.jpg"
          }
        }
      ]'
    
    # not working yet
    # @content = $.parseJSON @jsonFile
    @content = $.parseJSON jsonData
    @num_courses = @content.length
    # @render()

  render: ->
    if @curr > @num_courses
      title  = "That\'s all, folks!"
      text   = "This concludes the mini-course series. Thanks for tuning in!"
      figure = ""
    else
      title  = @content[@curr-1].material.title
      text   = @content[@curr-1].material.text
      figure = @content[@curr-1].material.figure

    # DEBUG CODE
    console.log 'title:  ', title
    console.log 'text:   ', text
    console.log 'figure: ', figure

    @course_el.find("#course-header").html title
    @course_el.find("#course-text").html text
    @course_el.find("#course-figure").attr 'src', figure

  setRate: (rate) ->
    @rate = rate

  onClickCourseYes: ->
    console.log "onClickCourseYes()"
    unless User.current is null
      User.current.setPreference 'course', 'yes', false, @displayCourse()
    @hidePrompt()

  onClickCourseNo: ->
    console.log "onClickCourseNo()"
    unless User.current is null
      User.current.setPreference 'course', 'no', false
    @hidePrompt()

  onClickCourseNever: ->
    console.log "onClickCourseNever()"
    unless User.current is null
      User.current.setPreference 'course', 'never', false
    @hidePrompt()

  displayCourse: ->
    console.log 'displayCourse()'
    console.log 'CURRENT COURSE: ', @curr
    unless User.current is null
      User.current.setPreference 'prev_course', @curr, false
      @render()
      @prev = @curr
      @curr = +@curr + 1

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

  resetCourse: ->
    console.log 'resetting course'
    unless User.current is null
      User.current?.setPreference 'prev_course', 0, false
      @prev   = +prev.current?.preferences['prev_course']
      @curr = +@prev + 1


module.exports = MiniCourse