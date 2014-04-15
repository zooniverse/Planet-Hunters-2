User = require 'zooniverse/models/user'
Api  = require 'zooniverse/lib/api'
require '../lib/en-us'
$ = window.jQuery

jsonData = '
      [
        {
          "course_number": 1,
          "material":
          {
            "title": "The Kepler Mission",
            "text": "The Kepler space telescope was launched by NASA in 2009. It was named after German astronomer Johannes Kepler, who is best known for developing the laws of planetary motion in the 17th century. For 4 years it stared at a patch of sky 100 square degrees in area (500 times that of the full Moon) in the constellations Lyra, Cygnus and Draco, looking for the tell-tale dips in brightness caused when a planet passes in front of its host star. It is these brightness measurements you are looking at on Planet Hunters.",
            "figure": "./images/mini-course/01-KeplerHR_sm.jpg",
            "figure_credits": "Image courtesy of NASA"
          }
        },
        {
          "course_number": 2,
          "material":
          {
            "title": "The First \'People\'s Planet\'",
            "text": "<p>The first confirmed planet discovered by volunteers, like you, on Planet Hunters was PH1b (also known as Kepler-64b). It is a Neptune-sized giant planet with a radius 6 times greater than that of the Earth. The really interesting thing about PH1b is that it\’s a circumbinary planet, meaning it orbits around two stars! Those two stars are also in orbit around another binary star system, which makes PH1b the first planet ever discovered in a quadruple star system. Below you can see the original lightcurve seen by volunteers on Planet Hunters. The coloured region shows where separate volunteers marked the dip.</p>",
            "figure": "./images/mini-course/02-ph1fig1.jpg",
            "figure_credits": "Image courtesy of NASA"
          }
        },
        {
          "course_number": 3,
          "material":
          {
            "title": "How else can we discover planets? (Part 1)",
            "text": "<p>The transit method is a very simple and effective method for discovering planets, but it is not the only one used by astronomers. Let’s have a look at some of the other methods.</p><p><b>The radial velocity method</b>: As a planet orbits a star its gravitational pull moves the star around. Therefore at some points the star is moving towards us (the observer) and at other it is moving away. We can measure the speed of this movement by looking at the spectrum of light from the star. When moving towards us its light becomes more blue, and when moving away its light becomes more red. The faster the star is moving, the more massive the planet. For example, Jupiter makes our Sun move at 12.7 m/s, whereas the Earth only makes it move at 0.09 m/s.</p>",
            "figure": "./images/mini-course/03-transit.jpg",
            "figure_credits": "Image courtesy of NASA"
          }
        },
        {
          "course_number": 4,
          "material":
          {
            "title": "How else can we discover planets? (Part 2)",
            "text": "The radial velocity method has been used to discover the majority of exoplanets to date, however it has one major disadvantage; it cannot be used to determine the angle of the planetary system to our line-of-sight. This means that only a minimum measurement of the star’s speed can be calculated, leading to only a minimum possible value for the mass of the exoplanet.",
            "figure": "./images/mini-course/04-doppler.jpg",
            "figure_credits": "Image courtesy of NASA"
          }
        }
      ]'

class MiniCourse

  constructor: ->
    @prompt_el = $(classifier.el).find("#course-prompt")
    @course_el = $(classifier.el).find("#course-container")
    @subject_el = $(classifier.el).find("#subject-container")
    @prompt_el.hide()

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
        @prompt_el.find('#course-message').html 'Please sign in to participate in the Planet Hunters mini-course.'

    # event callbacks
    @prompt_el.on "click", "#course-yes", (e) => @onClickCourseYes()
    @prompt_el.on "click", "#course-no", (e) => @onClickCourseNo()
    @prompt_el.on "click", "#course-never", (e) => @onClickCourseNever()
    @prompt_el.on "click", "#course-prompt-close", (e) => @hidePrompt()
    @course_el.on "click", ".course-close", (e) => @hideCourse()
    @loadCourseContent()

  loadCourseContent: ->
    # not working yet
    # @jsonFile = $.getJSON "./mini-course-content.json", @parseJSON()
    @parseJSON()

  parseJSON: ->
    # not working yet
    # @content = $.parseJSON @jsonFile
    @content = $.parseJSON jsonData
    @num_courses = @content.length

  loadContent: ->
    if @curr >= @num_courses
      title  = "That\'s all, folks!"
      text   = "This concludes the mini-course series. Thanks for tuning in!"
      figure = ""
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
      @hidePrompt()
      @displayCourse()

  onClickCourseNo: ->
    unless User.current is null
      User.current.setPreference 'course', 'no'
      @hidePrompt()

  onClickCourseNever: ->
    unless User.current is null
      User.current.setPreference 'course', 'never'
      @hidePrompt()

  displayCourse: ->
    unless User.current is null
      User.current.setPreference 'prev_course', @prev
      @loadContent()
      # @subject_el.fadeOut()
      # @course_el.slideDown()
      @subject_el.toggleClass("hidden")
      @course_el.toggleClass("visible")
      @prev = @curr
      @curr = +@curr + 1

  hideCourse: ->
    # @course_el.slideUp()
    @course_el.toggleClass("visible")
    @subject_el.toggleClass("hidden")
    
    # @subject_el.fadeIn()

  showPrompt: ->
    @prompt_el.slideDown()

  hidePrompt: ->
    @prompt_el.slideUp()

  getPref: ->
    @pref = User.current?.preferences[Api.current.project]['course']
    console.log 'course preference: ', @pref
    return @pref

  resetCourse: ->
    unless User.current is null
      User.current.setPreference 'course', 'yes'
      User.current.setPreference 'prev_course', 0
      @prev = User.current?.preferences[Api.current.project]['prev_course']
      @curr = 0

module.exports = MiniCourse
