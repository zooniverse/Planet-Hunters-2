{Step} = require 'zootorial'
translate  = require 't7e'
# classifier = require "../controllers/classifier"

tutorialSteps =
  welcome: new Step
    header:      translate 'span', 'tutorial.first.header'
    details:     translate 'span', 'tutorial.first.details'
    attachment: 'center center #graph-container center center'
    next: 'theData1'

module.exports = tutorialSteps