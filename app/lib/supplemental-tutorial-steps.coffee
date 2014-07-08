{Step} = require 'zootorial'
translate  = require 't7e'

supplementalTutorialSteps =
  steps:
    # /// BEGIN TUTORIAL STEPS ///
    first: 
      count:       ''
      header:      ''
      content:     ''
      attachment:  ''


    # displayOn_1: 
    #   count:       1
    #   header:      translate 'span', 'supplementalTutorial.tutorial.header'
    #   content:     translate 'span', 'supplementalTutorial.tutorial.content'
    #   actionable:  '[id="tutorial"]'
    #   attachment:  [0.5, 0.5, "#graph-container", 0.5, 0.5]

    # displayOn_1: 
    #   count:       1
    #   header:      translate 'span', 'supplementalTutorial.talk.header'
    #   content:     translate 'span', 'supplementalTutorial.talk.content'
    #   attachment:  [0.5, 0.5, "#graph-container", 0.5, 0.5]

    displayOn_4: 
      count:       4
      header:      translate 'span', 'supplementalTutorial.dataGaps.header'
      content:     translate 'span', 'supplementalTutorial.dataGaps.content'
      attachment:  [0.5, 0.5, "#graph-container", 0.5, 0.5]


    displayOn_1:
      count:       7
      header:      translate 'span', 'supplementalTutorial.miniCourse_optOut.header'
      content:     translate 'span', 'supplementalTutorial.miniCourse_optOut.content'
      attachment:  [0.5, 0.5, "#graph-container", 0.5, 0.5]

    # displayOn_4: 
    #   count:       7
    #   header:      translate 'span', 'supplementalTutorial.dataGaps.header'
    #   content:     translate 'span', 'supplementalTutorial.dataGaps.content'
    #   attachment:  [0.5, 0.5, "#graph-container", 0.5, 0.5]

    # /// END TUTORIAL STEPS /// 

module.exports = supplementalTutorialSteps