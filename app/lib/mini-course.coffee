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
            "figure": "01-KeplerHR_sm.jpg"
          }
        },
        {
          "course_number": 1,
          "material":
          {
            "title": "The Kepler Mission",
            "text": "The Kepler space telescope was launched by NASA in 2009. It was named after German astronomer Johannes Kepler, who is best known for developing the laws of planetary motion in the 17th century. For 4 years it stared at a patch of sky 100 square degrees in area (500 times that of the full Moon) in the constellations Lyra, Cygnus and Draco, looking for the tell-tale dips in brightness caused when a planet passes in front of its host star. It is these brightness measurements you are looking at on Planet Hunters.",
            "figure": "01-KeplerHR_sm.jpg"
          }
        }
      ]'
    
    # not working yet
    # @content = $.parseJSON @jsonFile
    @content = $.parseJSON jsonData
    
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