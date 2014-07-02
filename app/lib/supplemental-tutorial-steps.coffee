{Step} = require 'zootorial'
translate  = require 't7e'

supplementalTutorialSteps =
  steps:
    # /// BEGIN TUTORIAL STEPS ///
    first: 
      # progress:    1
      count:       1
      header:      translate 'span', 'supplementalTutorial.first.header'
      content:     translate 'span', 'supplementalTutorial.first.content'
      attachment:  [0.5, 0.5, "#graph-container", 0.5, 0.5]
      next:        'dataGaps'

    dataGaps: 
      # progress:    1
      count:       4
      header:      translate 'span', 'supplementalTutorial.dataGaps.header'
      content:     translate 'span', 'supplementalTutorial.dataGaps.content'
      attachment:  [0.5, 0.5, "#graph-container", 0.5, 0.5]
    # /// END TUTORIAL STEPS /// 

module.exports = supplementalTutorialSteps