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

    displayOn_1: 
      count:       1
      header:      translate 'span', 'supplementalTutorial.first.header'
      content:     translate 'span', 'supplementalTutorial.first.content'
      attachment:  [0.5, 0.5, "#graph-container", 0.5, 0.5]

    displayOn_4: 
      count:       4
      header:      translate 'span', 'supplementalTutorial.dataGaps.header'
      content:     translate 'span', 'supplementalTutorial.dataGaps.content'
      attachment:  [0.5, 0.5, "#graph-container", 0.5, 0.5]
    # /// END TUTORIAL STEPS /// 

module.exports = supplementalTutorialSteps