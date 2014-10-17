module.exports =
  siteNavigation:
    projectName: 'Web-App-Template'
    home:        'Home'
    classify:    'Classify'
    science:     'Science'
    about:       'About'
    profile:     'Profile'
    education:   'Education'
    talk:        'Talk'
    blog:        'Blog'

  home:
    header:
      title            : ''
      content          : ''
      start            : ''
      callToAction     : 'Ready to discover new worlds?'
      description      : 'Join the search for exoplanets with Planet Hunters'
      beginClassifying : 'Start Classifying'
      learnMore        : 'Learn More'
    whatDo:
      title            : ''
      content          : ''

  course:
    prompt:
      login_message    : 'Mini-course available! Learn more about planet hunting. Interested?'
      nologin_message  : 'Please sign in to receive credit for your discoveries and to participate in the Planet Hunters mini-course.'
      yes              : 'Yes'
      no               : 'No'
      never            : 'Never'


  initialTutorial:
    first:
      header: 'Welcome!'
      content: 'This short tutorial will show you how to find undiscovered planets by looking at how the brightness of a star changes over time.'

    theData:
      header: 'The Data'
      content:  'Each point on the light curve represents one measurement of a star\'s brightness taken by NASA’s Kepler Space Telescope. These measurements are taken approximately every 30 minutes. The higher the dot, the brighter the star appears.' 

    xAxis:
      header: 'The Data'
      content: 'The x-axis represents the time spent observing the star. Usually each graph shows about 30 days of observations.'

    # removed: This part of the light curve shows the time spent observing the star.

    yAxis:
      header: 'The Data'
      content: 'The y-axis of the light curve shows the star\'s observed brightness.'

    transits:
      header: 'Transits'
      content: 'As the planet passes in front of (or transits) a star, it blocks out a small amount of the star’s light, making the star appear a little bit dimmer. You’re looking for points on the light curve that appear lower than the rest. When you spot a potential transit, mark each one on the light curve.'

    markingTransits:
      header: 'Marking Transits'
      content: 'Try marking this transit (highlighted in red). Click and then drag left or right to highlight the transit points. Release the mouse button when you\'re done. You can go back and adjust the box width by selecting the transit box and using the handles.'

    spotTransits:
      header: 'Can you spot the transits?'
      content: 'Depending on how far the planet is from the star, you may see one or many dips in the light curve. Most transits that you’ll typically see span a few hours to a day. Try marking the remaining transits in this example light curve.'
    
    showTransits:
      header: 'Did you spot them?'
      content: 'The remaining transits have been highlighted in red. Each light curve is reviewed by several volunteers so don\'t be discouraged if you missed a hard to spot transit. Transit hunting can be tricky and requires practice. Just do your best.'

    zooming:
      header: 'Zoom'
      content: 'You can use the zoom tool to look at the light curve in more detail. When zoomed in, you can use the slider along the bottom of the light curve to scroll through. You can toggle the scale of the zoom by clicking the magnifying glass here.'
    
    talk:
      header: 'Talk'
      content: 'Sometimes you might see something interesting or have a question. TALK is a tool where you can join Planet Hunters project scientists and volunteers to observe, collect, share, and discuss Planet Hunters data.'

    goodLuck:
      header: 'Good luck!'
      content: 'Now you\’re ready to begin hunting for planets! Over the next few classifications we\’ll provide some additional information that will be useful as you search for new worlds. Click "Finished" to move on to a new light curve.'

  supplementalTutorial:

    tutorial:
      header: 'Having Trouble?'
      content: 'You can start the tutorial at any time by clicking on the highlighted button to the right.'

    talk:
      header: 'Discuss your work with Talk'
      content: 'Sometimes you might see something interesting or have a question. TALK is a tool where you can join Planet Hunters project scientists and volunteers to observe, collect, share, and discuss Planet Hunters data.'
      
    dataGaps: 
      header: 'Gaps in the Data'
      content: 'Sometimes you might see gaps in the data. This means that Kepler was either turned off or not pointing at the star.'

    miniCourse_optOut:
      header: 'Want to learn more?'
      content: 'There\’s a lot of interesting science behind discovering exoplanets. We’ve put together a mini-course so you can learn more as you hunt.'

    miniCourse_optIn:
      header: 'Want to learn more?'
      content: 'There\’s a lot of interesting science behind discovering exoplanets. We’ve put together a mini-course so you can learn more as you hunt. Check the box below and you’ll learn as you hunt for new planets! You can opt out at anytime.'