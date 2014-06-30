{Step} = require 'zootorial'
translate  = require 't7e'

supplementalTutorialSteps =
  steps:
    # /// BEGIN TUTORIAL STEPS ///
    first: 
      # progress:    1
      header:      translate 'span', 'tutorial.first.header'
      content:     translate 'span', 'tutorial.first.content'
      attachment:  [0.5, 0.5, "#graph-container", 0.5, 0.5]
      next:        'theData1'

    # /// END TUTORIAL STEPS /// 

module.exports = supplementalTutorialSteps