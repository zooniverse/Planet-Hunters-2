Subject = require 'zooniverse/models/subject'
module.exports =  
  createTutorialSubject: ->
    tutorialSubject = new Subject
      id: 'TUTORIAL_SUBJECT'
      zooniverse_id: 'APH0000039'
      tutorial: true
      metadata:
        kepler_id: "9631995"
        logg: "4.493"
        magnitudes:
          kepler: "13.435"
        mass: ""
        radius: "0.966"
        teff: "6076"
      selected_light_curve:
        location: 'https://s3.amazonaws.com/demo.zooniverse.org/planet_hunter/subjects/09631995_16-3.json'
    tutorialSubject