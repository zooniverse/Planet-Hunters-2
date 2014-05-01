{Step} = require 'zootorial'
translate = require 't7e'

tutorialSteps =
  welcome: new Step
    header:      translate 'span', 'tutorial.welcome.header'
    details:     translate 'span', 'tutorial.welcome.details'
    attachment: 'center center #graph-container center center'
    next: 'theData1'

  theData1: new Step
    header:      translate 'span', 'tutorial.theData1.header'
    details:     translate 'span', 'tutorial.theData1.details'
    attachment: 'center center #graph-container center center'
    next: 'theData2'

  theData2: new Step
    header:      translate 'span', 'tutorial.theData2.header'
    details:     translate 'span', 'tutorial.theData2.details'
    attachment: 'center center #graph-container center center'
    next: 'theData3'

  theData3: new Step
    header:      translate 'span', 'tutorial.theData3.header'
    details:     translate 'span', 'tutorial.theData3.details'
    attachment: 'center center #graph-container center center'
    next: 'transits1'

  transits1: new Step
    header:      translate 'span', 'tutorial.transits1.header'
    details:     translate 'span', 'tutorial.transits1.details'
    attachment: 'center center #graph-container center center'
    next: 'transits2'

  transits2: new Step
    header:      translate 'span', 'tutorial.transits2.header'
    details:     translate 'span', 'tutorial.transits2.details'
    attachment: 'center center #graph-container center center'
    next: 'findingTransits'

  findingTransits: new Step
    header:      translate 'span', 'tutorial.findingTransits.header'
    details:     translate 'span', 'tutorial.findingTransits.details'
    attachment: 'center center #graph-container center center'
    next: 'markingTransits1'

  markingTransits1: new Step
    header:      translate 'span', 'tutorial.markingTransits1.header'
    details:     translate 'span', 'tutorial.markingTransits1.details'
    attachment: 'center center #graph-container center center'
    next: 'markingTransits2'

  markingTransits2: new Step
    header:      translate 'span', 'tutorial.markingTransits2.header'
    details:     translate 'span', 'tutorial.markingTransits2.details'
    attachment: 'center center #graph-container center center'
    next: 'spotThem'

  spotThem: new Step
    header:      translate 'span', 'tutorial.spotThem.header'
    details:     translate 'span', 'tutorial.spotThem.details'
    attachment: 'center center #graph-container center center'
    next: 'thanks'

  thanks: new Step
    header:      translate 'span', 'tutorial.thanks.header'
    details:     translate 'span', 'tutorial.thanks.details'
    attachment: 'center center #graph-container center center'

module.exports = tutorialSteps