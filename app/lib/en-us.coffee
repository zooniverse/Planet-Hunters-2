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

  # Home Page
  home:
    header:
      title            : ''
      content          : ''
      start            : ''
      callToAction     : 'Ready to discover new worlds?'
      description      : 'Join the search for exoplanets with Planet Hunters'
      beginClassifying : 'Start Classifying'
    whatDo:
      title            : ''
      content          : ''

  classify:
    instructionHeader  : 'Do you see a transit?'
    instruction        : 'If so, highlight it on the light curve below!'
    loadingMessage     : 'Loading...'
    buttons:
      finished         : 'Finished'
      continue         : 'Continue'
      nextSubject      : 'Next Subject'
      noTransits       : 'No Transits'
    tools:
      header           : 'TOOLS'
      zoom             : 'Zoom'
      favorite         : '+Fav'
      help             : 'Help'
      tutorial         : 'Tutorial'
    starInformation:
      header           : 'Star Information'
      zooniverseId     : 'Zooniverse Id'
      keplerId         : 'Kepler Id'
      quarter          : 'Quarter'
      type             : 'Type'
      magnitude        : 'Magnitude'
      temperature      : 'Temp'
      radius           : 'Radius'
      notAvailable     : 'N/A'
    summaryScreen:
      feedback         : 'Nice Work!'
      guestObserver:
        instructions   : 'While you are classifying keep an eye out for unusual lightcurves and tag them with a hash tag on talk!'
        hashtag        : 'Use the tag:'
        enlargeImage   : 'Click on image to enlarge'
      discussion: 
        header         : 'Discussions about this star'
        commentBox     : 'Make a comment, or mark with a hashtag...'
        submitComment  : 'Submit'
      talk:
        header         : 'Join the conversation on Talk'
        instruction    : 'There\'s a lot more to discuss on Talk! Ask the science team a question, get help, or just comment on an interesting subject.'
        talkButton     : 'Discuss on Talk'
        addFavButton   : 'Add to Favorites'
        remFavButton   : 'Remove Favorite'
      simulation:
        header         : 'Simulation details'
        radius         : 'Planet Radius: '
        period         : 'Planet Period: '
      knownPlanet:
        header         : 'Planet details'
        radius         : 'Planet Radius: '
        period         : 'Planet Period: '

  profile:
    header             : 'Your Profile'
    launchMiniCourse   : 'Launch Mini Course'

  spottersGuide:
    header             : 'Spotter\'s Guide'
    clickToEnlarge     : 'Click on image examples to enlarge'
    transits:
      header           : 'Transits'
      longPeriodTitle  : 'Long Period Planet/Single Transit'
      longPeriodInfo   : 'One transit visible in the light curve'
      shortPeriodTitle : 'Short Period Planet/Many Transits'
      shortPeriodInfo  : 'Many transist from the same planet visible'
      multiPlanetTitle : 'Multi-planet Systems'
      multiTitleInfo   : 'Transits from more than one planet'
      moreExamples     : 'More Example Planet Transits'
      eclipsingTitle   : 'Eclipsing Binaries'
      eclipsingInfo    : 'Two stars transiting in front and behind each other'
      nonTransitsTitle : 'Non-Transits'
      gaps             : 'Gaps'
      pulsatingStars   : 'Pulsating Stars'
      starspots        : 'Starspots'

  # GET INVOLVED: located in right panel
  getInvolved:
    header             : 'Get Involved'
    callToAction       : 'Join us in finsing the many worlds out there. Are you ready?'
    getStarted         : 'Get Started'
    connect            : 'Connect'
    socialMediaLinks   : 'Follow the <a href="http://blog.planethunters.org">Planet Hunters Blog</a>, <a href="https://twitter.com/planethunters">@planethunters</a>, and the <a href="http://www.facebook.com/planethunters">Facebook Page</a> to keep current with the latest findings. Share and discuss your work with others with <a href="http://talk.planethunters.org">Planet Hunters Talk</a>.'

  course:
    prompt:
      login_message    : 'Mini-course available! Learn more about planet hunting. Interested?'
      nologin_message  : 'Please sign in to receive credit for your discoveries and to participate in the Planet Hunters mini-course.'
      yes              : 'Yes'
      no               : 'No'
      never            : 'Never'
      doNotShow        : 'Do not show mini-course in the future.'
    closeButton        : 'Close'


  # SCIENCE PAGE
  sciencePage:
    mainHeader         : 'The Science'
    tabs:
      mission          : 'Our Mission'
      task             : 'Your Task'
      transits         : 'Transits'
      lightCurves      : 'Light Curves'
      simulations      : 'Simulations'
      faq              : 'FAQ'
      publications     : 'Discoveries &amp; Papers'
    section:
      mission:
        header         : '<h1>Our Mission</h1>'
        content        : 
          '''
          <p>Welcome to Planet Hunters. With your help, we are looking for planets around other stars.</p>
          <p>NASA's Kepler spacecraft is one of the most powerful tools in the search for extrasolar planets (exoplanets), planets orbiting stars outside of our own Solar System, and its discoveries continue to revolutionize our understanding of how planetary systems grow and evolve. Approximately every 30 minutes, Kepler monitors the brightness of many thousands of stars simultaneously for the signature of exoplanets via the transit technique. When an exoplanet passes or transits in front of its parent star, the star momentarily dims. This decrease in brightness is detectable by Kepler and lasts for a few hours or more and repeats once per orbit of the planet.</p>
          <p>The time series of brightness measurements for a star is called a light curve. Automated computers are sifting through the Kepler light curves looking for the repeating signal of a planet transit, but we think there will be planets which can only be found via the innate human ability for pattern recognition. At Planet Hunters we are enlisting the public's help to inspect the Kepler light curves and find these planets missed by automated detection algorithms. No training required! All you need is your keen eyes and a web browser to join the hunt.</p>
          <p>It's just possible that you might be the first to know that a star somewhere out there in the Milky Way has a companion, just as our Sun does. Fancy giving it a try?</p>
          '''
      task:
        header         : '<h1>Your Task</h1>'
        content        :
          '''
          <h2>What am I looking for?</h2>
          <p>A small portion of a star's light is blocked out when an exoplanet passes or transits in front of it. The star winks and this dimming of starlight lasts for a few hours or more, repeating once per orbit of the planet. Visitors to the Planet Hunters' website are asked to draw boxes to mark the locations of these dips on the star's light curve (measurements of the the star's brightness over time). The depth of the transit and how often it repeats tells us about the relative size of the planet and its orbital period (how long the planet's year is).</p>
          <h2>Computers vs. Humans: Why do we need your help?</h2>
          <p>The Kepler team and other astronomers have developed automated computer algorithms to search the Kepler light curves, for the repeated signal of exoplanet transits. To date over 3000 confirmed planets and planet candidates have been discovered with Kepler, but the Kepler light curves are complex, many exhibiting short-lived changes in brightnesss that are often difficult to characterize. Despite the impressive success of the computers, they may miss transits dominated by the star’s natural variability. The human brain excels at pattern recognition and easily recognizes transits that sophisticated automated routines may miss, and that is where you come in.</p>
          <p>Automated routines have been very successful and many planets and planet candidates have been found, but not all. While we expect computer programs to robustly identify things that they are trained to find, we know there are surprises in the data that the computer algorithms will miss. It is impossible for a single person to review all of the Kepler observations, and  experiments have shown that when many people work together, the collective wisdom of the crowds can be better than an expert. With the Internet we can gather the help of hundreds of thousands of people to hunt for exoplanets. The original Planet Hunters proved that this citizen science approach to exoplanets works with over 30 planet candidates and several confirmed planet discoveries.</p>
          '''
      transits:
        header         : '<h1>Transits</h1>'
        content        :
          '''
          <h2>The Transit Technique for Hunting Planets</h2>

            <p>Transits occur when a planet passes in front of its host star as viewed from the Earth. A portion of the star's light is blocked out, and the brightness observed decreases.The Kepler mission measures the brightness of stars with such incredible precision that it is sensitive enough to detect transits of planets approaching the size of the Earth. At Planet Hunters, we need your help in the hunt for extrasolar planets (exoplanets) by highlight potential transits in a star's light curve, the time series measurements of the star's brightness, in the web interface. We use the combined assessment of several volunteers reviewing the same 30-day segment of a Kepler star's light curve to identify transits.</p>
            <img src="images/phtransit.png"><br>

            <p>Not all planets will transit their host stars. A special orientation of the orbit is required. Because the technique looks for a dimming in the brightness of the star, all of the planets with orbits that don’t pass between the star and our line of sight will be missed. For those planets that due transit, a transit will occur once every orbit.</p>

            <img src="images/transit_edges.png"/>

            <p>The bigger the planet, the more starlight that is blocked out and the bigger the transit dip. Below we’ve taken a Kepler light curve from a star that’s about the same size as the Sun and have simulated what the effects would be if a few different types of planets were to transit. A Jupiter-sized planet produces a large 1% drop in light as it transits across a Sun-like star. Rocky planets generate a much smaller dimming, with the Earth only producing a 0.01% drop in our Sun's light! Larger planets around same-sized stars will be easier to detect than those of terrestrial planets with the transit method.</p>

            <img src="images/enj_example.png">
            <p class="image-caption">Credit: M. Giguere (Yale)</p>

            <p>The size of the star matters too. The same planet transiting a smaller star will have a larger transit depth. Earth-sized planets orbiting cool small M dwarfs, have the similar transit depths to giant planets around Sun-like stars.</p>

            <img src="images/learn-lightcurve.png ">

            <p>Given that our own Solar System has eight planets, it should come as no surprise that we may find other stars with multiple planets around them lurking in the Kepler data. These light curves would look exactly as one might guess, showing multiple patterns of transits.</p>

            <p>We can see that there must be multiple transiting objects because the timing between the transits is not constant due to the overlapping of two different periods. If you encounter a light curve that looks like it may be from a multiplanet system, mark the transits as usual. With your markings we’ll be able to identify there is more than one planet present.</p>

            <img src="images/multitransits.png">

          <h2>Starspots</h2>

            <p>Like our Sun, many stars have cooler and fainter blotches on their surface. These starspots (or sunspots in case of the Sun) rotate with the star and cause relatively slow changes in the brightness of the light curve. Starspots cause most of the smooth and slowly varying brightness seen in stars typically over periods of days. Transiting planets cause produce changes in a star’s brightness over much shorter timescales.  Planets will transit the star in  a few to tens of hours, causing quick dips in the star's brightness. Below is a light curve of a star with starspots and a transiting exoplanet. The transits are denoted by red boxes.</p>

            <img src="images/guide/more_examples4.png"><br>
            <h2>Planet Candidates vs Confirmed Planet</h2>

            <p>I spotted a transit, is it a planet? Maybe. There are several astrophysical scenarios not involving planets that can produce transit-like events in a Kepler light curve. So more checks first need to be done before we can confidently say the event is likely due a transiting planet.</p>

            <p>The first check is to see if the event repeats. Typically 2-3 transits must be spotted before the star is considered to harbor possible planets. A planet that orbits in one year, like the Earth, requires three years of data for detection, while planets that orbit in ten days can be detected with just thirty days of data. If the planet orbits longer than the ~30 day intervals we show on the Planet Hunters classification interface, you might only see one transit. If the event is real then other volunteers will have seen and marked the repeat events in other light curve sections, flagging the star as likely having transits.</p>

            <p>The transit technique measures the radius of the transiting body. If we know the size of the star, from the transit depth we know the size of the object. If there are repeat events and the size of the object is planetary in size, roughly Jupiter-sized (10 Earth radii) or smaller, we then call this a planet candidate.</p>

            <p>The reason for planet candidate and not confirmed planet is because we don't have the mass of the body. Brown dwarfs, low-mass stars that burned deuterium but not hydrogen in their cores, have similar radii to Jupiter but much heavier masses. From the radius alone you can't distinguish the two. Also Kepler has very precise but blurry vision. There are many background stars that contribute to a target star's  light curve, so we're seeing the combined light of all those sources. If background stars are bright enough they can dilute the transit signal making us think the body is smaller such than an eclipsing binary, where two stars transit in front and behind each other, can have measured depths that look like planet transits. A mass estimate will distinguish between an orbiting star and a planet.</p>

            <p>If a statistical analysis can rule out possible astrophysical false positives for the transit-like signal or a mass is measured, than the planet candidate gets promoted to confirmed planet. Most stars that Kepler observes are too faint or the planet candidates are too small to currently measure masses with ground-based radial velocity techniques. Therefore most planet candidates found in the Kepler light curves will remain candidates, but Kepler's aim was to be a statistical mission.</p>
          '''

      lightCurves:
        header        : '<h1>Where do light curves come from?</h1>'
        content       :
          '''
          <p>The light curves, time series of brightness measurements, we ask you to inspect for planet transits come from the publicly released observations from NASA's <a href="http://kepler.nasa.gov/">Kepler mission</a>. On Planet Hunters, we show data obtained during two different phases of the Kepler mission:  </p>

          <h2>The Kepler Field</h2>
            <p>Kepler has spent four years staring at a single patch of sky, simultaneously monitoring a collection of stars for the tell tale signatures of transiting exoplanets. From May 2009-May 2013, Kepler observed nearly the same ~170,000 stars in the Kepler field located in the constellations of Cygnus and Lyra. Kepler suffered a mechanical failure that now prevents it from being able to point at the Kepler field, ending this period of its main mission.</p>

            <p>We have still have much of the four years of Kepler field data to search through. The original Planet Hunters project barely scratched the surface of the Kepler field observations. We think there is still much to be learned from the original Kepler data and likely to be unknown planets lurking in the light curves missed by the computers waiting to discovered.</p>

            <img src="images/Keplerfield.jpg"/>
            <p class="image-caption">Image Credit: Carter Roberts/NASA Kepler Mission</p>

          <h2>K2</h2>
            <p>The Kepler spacecraft has been repurposed for the <a href="http://keplerscience.arc.nasa.gov/K2/">K2 mission</a>. For the next several years, Kepler will be observing a new patch of sky every 75 days in the ecliptic plane. In each of these fields, Kepler will monitor brand new sets of 10,000-20,000 stars. These stars are different from the sources that Kepler had been monitoring in the past in the Kepler field. K2 observations will be made available to the entire astronomical community and the public shortly after being transmitted to Earth and processed.Your eyes will be one of the first to gaze upon these observations. Most of the K2 target stars will have never before been searched for planets, providing a new opportunity to find distant worlds.</p>

            <img src="images/K2.jpg"/>
            <p class="image-caption">Image Credit: ESO/S. Brunier/NASA Kepler Mission/Wendy Stenzel</p>
          '''

      simulations:
        header         : '<h1>Simulations</h1>'
        content        :
          '''
          <p>One of the goals of Planet Hunters is to explore the diversity of the terrestrial and giant planet populations and begin to understand the spectrum of solar systems. With just the planet discoveries alone you can't answer these questions because you don't know how complete the sample is. In order to understand how well different kinds of transiting planets can be found with Planet Hunters, we also show light curves with simulated transits, spanning the range of exoplanet radii and orbits.</p>

          <p>It might seem like we're testing you or trying to train you to identify transits, but we're really testing the project. The simulations are critical for determining the statistical completeness for planets as a function of size (depth of the transit event) and orbital period (number of transits). This is a really vital part of the project, with these simulated transits we can answer interesting and fundamental questions about how solar systems and planets form. Some of the simulated planets like large Jupiter-sized planets will be really easy to spot while others will be near impossible to identify especially for the extremely small planets, but don’t be discouraged if you didn’t find the simulated transit. That’s okay, that's part of the experiment.</p>

          <p>If you encounter a simulation, we will always identify the simulated transit points in red after you’ve classified the star and list the properties of the simulated planet we injected into the light curve. The reason we don’t identify the simulated data first, is that if you knew the light curve had simulated events you might look at it differently. To be able to use the data from the simulated transits accurately, we need them to be examined in exactly the same conditions as the real light curves.</p>
          '''

      faq:
        header         : '<h1>Frequently Asked Questions</h1>'
        content        :
          '''
          <h2 class="faq link" target="faq-data">Where does the data come from?</h2>
          <h2 class="faq link" target="faq-talk">I have a question or I found something interesting, who should I talk to?</h2>
          <h2 class="faq link" target="faq-classification">What happens to my classification after I submit it?</h2>
          <h2 class="faq link" target="faq-mistake">I made a mistake, can I got back and edit my classification?</h2>
          <h2 class="faq link" target="faq-correct">How do I know if I'm doing this right?</h2>
          <h2 class="faq link" target="faq-discoveries">Do I get credit for my discoveries?</h2>
          <h2 class="faq link" target="faq-login">Do I have to log in to get credit for my discoveries?</h2>
          <h2 class="faq link" target="faq-name">Do I get to name the exoplanet I found?</h2>
          <h2 class="faq link" target="faq-candidate">Why can't you say the transits I spotted are a bonafied planet? What is a planet candidate?</h2>
          <h2 class="faq link" target="faq-known">Why do some light curves already have known planet candidates?</h2>
          <h2 class="faq link" target="faq-gaps">Why are there gaps in the light curves?</h2>
          <h2 class="faq link" target="faq-simulations">Why are there simulated transits?</h2>
          <h2 class="faq link" target="faq-news">How do I keep up to date on the latest Planet Hunters news?</h2>
          <hr class="faq hr">

          <h2 id="faq-data">Where does the data come from?<img class="faq up-image link" target="faq-top" src="images/icons/faq-up.png"/></h2>
          <p>The observations we show on Planet Hunters come from the NASA Kepler spacecraft. They are brightness measurements of stars in the Kepler field during the main Kepler mission and from fields observed in the K2 phase. You can learn more about the Kepler field and K2 on the science page. NASA is archiving the Kepler data products and resulting catalogs at the <a href="http://archive.stsci.edu/kepler">Mikulski Archive for Space Telescopes (MAST)</a> and the <a href="http://exoplanetarchive.ipac.caltech.edu/docs/KeplerMission.html">NASA Exoplanet Archive</a></p>
          
          <h2 id="faq-talk">I have a question or I found something interesting, who should I talk to?<img class="faq up-image link" target="faq-top" src="images/icons/faq-up.png"/></h2>
          <p>You can go to the star's Planet Hunters Talk page and make a 140 character comment, label the star with a hashtag, start a side discussion, or post a new thread in Talk's message board forum. On Talk you can discuss and further analyze the available data for the star as well as interact with the rest the Planet Hunters community including members of the science team. You can directly access Talk after classifying a star's light curve or at <a href="http://talk.planethunters.org">http://talk.planethunters.org</a></p>
          
          <h2 id="faq-classification">What happens to my classification after I submit it?<img class="faq up-image link" target="faq-top" src="images/icons/faq-up.png"/></h2>
          <p>It is stored in the Zooniverse's database with everyone else’s classifications from Planet Hunters. The Planet Hunters science team then will combine and analyze the results to identify planet candidates and estimate the occurrence of different types and kinds of planets and solar systems. Keep an eye on the <a href="http://blog.planethunters.org">Planet Hunters blog</a> for updates.</p>
          
          <h2 id="faq-mistake">I made a mistake, can I got back and edit my classification?<img class="faq up-image link" target="faq-top" src="images/icons/faq-up.png"/></h2>
          <p>Once you've finished reviewing a specific light curve and your classification has been submitted to our database, you can’t go back and change it. Don't worry too much. Just try to do your best when reviewing the light curves. We combine the assessments from multiple volunteers to identify transits, so chances are if one person missed a transit by mistake the other classifiers will likely have marked it.</p>
          
          <h2 id="faq-correct">How do I know if I'm doing this right?<img class="faq up-image link" target="faq-top" src="images/icons/faq-up.png"/></h2>
          <p>We don't know where all the planet transits are, otherwise we wouldn't be asking for your help. Several Planet Hunters volunteers review each light curve and the results are then combined to identify transits. Chances are if you think a feature in a light curve is a transit and it is real, the other volunteers will have marked it too. You may come across a light curve with known planet candidates in it or a simulation. You can check if you identify those transits, but don't worry too much. Just use your best judgment when classifying.</p>
          
          <h2 id="faq-discoveries">Do I get credit for my discoveries?<img class="faq up-image link" target="faq-top" src="images/icons/faq-up.png"/></h2>
          <p>Yes, everyone who contributed to discovering an exoplanet is acknowledged in some way. If you are the first person to flag a particular transit as a potential exoplanet, and we can confirm that it is real or it is a focus of a paper, then we will offer to make you a co-author of the discovery paper. All others after the first will be acknowledged for their contribution on the website and in the paper.</p>
          
          <h2 id="faq-login">Do I have to log in to get credit for my discoveries?<img class="faq up-image link" target="faq-top" src="images/icons/faq-up.png"/></h2>
          <p>Yes, you do need to register and log in when classifying to get credit for your discoveries. It's the only way we know for sure that you were the one that marked the transit and will be able to contact you about the discovery.</p>
          
          <h2 id="faq-name">Do I get to name the exoplanet I found?<img class="faq up-image link" target="faq-top" src="images/icons/faq-up.png"/></h2>
          <p>Not yet, but maybe one day in the future you will be able help name your discovery. The International Astronomical Union (IAU) has enacted a plan for the public naming of extrasolar planets (exoplanets). The first set of exoplanets will be officially bestowed names in August 2015. You can find out more about the IAU's naming process at the <a href="http://nameexoworlds.org">Name ExoWorlds</a> website.</p>
          
          <h2 id="faq-candidate">Why can't you say the transits I spotted are a bonafied planet? What is a planet candidate?<img class="faq up-image link" target="faq-top" src="images/icons/faq-up.png"/></h2>
          <p>With the Kepler light curve alone, we can't be 100% certain that a transit-like feature is produced by an orbiting planet. There are many astrophysical false positives that can mimic a transit signature. Therefore we call discoveries planet candidates. A lot of effort and follow-up is required to confirm a planet candidate. To validate a planet candidate as a true planet, an estimate of the mass of the transiting body is needed. The transit method only gives an estimate of the size of the body, not its mass. Through statistical means or if a mass measurement is obtained and confirmed to be planetary, then the planet candidate gets promoted to a confirmed planet. To measure the mass typically radial velocity observations are used, where you measure the wobble of the star due to the slight gravitational tug due of the orbiting body. Most of the stars Kepler observes are either too faint or the planet orbiting is too small to have a radial velocity signal detectable by today's best ground-based telescopes and instruments. The majority of planet candidates found in the Kepler data will remain candidates.</p>
          
          <h2 id="faq-known">Why do some light curves already have known planet candidates?<img class="faq up-image link" target="faq-top" src="images/icons/faq-up.png"/></h2>
          <p>The Kepler team, other astronomers, and the original Planet Hunters project have been searching the Kepler field data for several years. There are many known transiting planet candidates discovered during this period. We highlight the known planet candidates in the Kepler field data after you finish your classification, so you know if you are finding a new discovery. Even if there is a known planet candidate found by others, we need to know if Planet Hunters can find it in order to be able to do accurate planet frequencies, so your clicks on these stars are just as useful as on stars without known planets. Even though a light curve may contain the transits of a known planet candidate, there might also be transits from an additional previously undetected planet.</p>
          
          <h2 id="faq-gaps">Why are there gaps in the light curves?<img class="faq up-image link" target="faq-top" src="images/icons/faq-up.png"/></h2>
          <p>The gaps in the data are typically due to the Kepler spacecraft not observing or the data quality is bad typically such as a cosmic ray hitting the detector.</p>
          
          <h2 id="faq-simulations">Why are there simulated transits?<img class="faq up-image link" target="faq-top" src="images/icons/faq-up.png"/></h2>
          <p>The simulated transits will enable the science team to understand exactly what kinds of planets the project can find and which ones are difficult for humans to spot by eye in the light curves. We will use this information to estimate the abundance of planets in our Galaxy. You can learn more about the simulations on the Science Page.</p>
          
          <h2 id="faq-news">How do I keep up to date on the latest Planet Hunters news?<img class="faq up-image link" target="faq-top" src="images/icons/faq-up.png"/></h2>
          <p>Keep an eye on the <a href="http://blog.planethunters.org">Planet Hunters blog</a>. We frequently post science results and site news there as well have posts discussing the science behind the project. You can also receive updates on Planet Hunters through the project's <a href="https://plus.google.com/109754226869605076230/posts">Twitter</a>, and <a href="https://plus.google.com/109754226869605076230/posts">Google+</a> accounts.</p>
          
          <p><strong>Didn't find an answer to your question? Visit <a href="http://talk.planethunters.org">Planet Hunters Talk</a> and ask the Planet Hunters community.</strong></p>
          '''

  aboutPage:
      mainHeader         : 'About Planet Hunters'
      tabs:
        about            : 'About'
        teams            : 'Teams'
        organizations    : 'Organizations'
      section:
        about:
          header         : '<h1>The Story So Far...</h1>'
          content        : 
            '''
            <p>On December 16, 2010, the <a href="http://www.zooniverse.org">Zooniverse</a> launched the original Planet Hunters to enlist the public's help to search data from the NASA's <a href="http://kepler.nasa.gov">Kepler</a> spacecraft for the characteristic drop in light due to an orbiting extrasolar planets (exoplanets) crossing in front of their parent stars.</p>

            <p>Back then we didn't know what we would find. The project was a gamble on the ability of human pattern recognition to beat machines just occasionally and spot the telltale dip from a transiting planet that was missed by automated routines looking for repeating patterns. It may have been the case that no new planets were discovered and that computers had the job down to a fine art.</p>

            <p>The gamble paid off. The original Planet Hunters project discovered a bounty of unknown planet candidates and several confirmed planets, resulting from the efforts of nearly 300,000 volunteers worldwide. You can learn more about the discoveries and scientific results from the first iteration of Planet Hunters with our <a href="https://www.zooniverse.org/publications?project=planethunters">list of published papers</a> and the <a href="http://blog.planethunters.org">project blog</a>.</p>

            <p>Nearly 4 years after the launch of the original Planet Hunters, the current phase (version 2.0) of the Planet Hunters project has been built with the Zooniverse's latest technology. You can learn more about the project on the <a href="#/science">Science page</a>. Like the original site, you'll be shown ~30 days worth of Kepler observations to review in the main classification interface. If you spot a transit-like feature in the light curve, mark its location. Other citizen scientists will be shown the same light curve and we'll combine the assessments to identify possible planet candidates for follow-up. In the Round 2 review phase of the project, you'll help inspect and confirm possible transit candidates identified in the main classification interface for further follow-up and inspection by the Planet Hunters science team.</p>

            <p>Who knows what we'll find? If the original Planet Hunters is any indication, then we're in for a surprise or two!</p>
            '''

        teams:
          header         : '<h1>Teams</h1>'
          content        : 
            '''
            <h2>Science Team</h2>
              <div class="team-members">
                <div class="team-member">
                  <img src="./images/people/debraf.jpg">
                  <div class="name">Debra Fischer</div>
                  <div class="location">Yale University (USA)</div>
                  <div class="bio">Debra is a Professor of Astronomy at Yale University, with a joint appointment in Geology &amp; Geophysics. She has been on the hunt for extra solar planets since 1997 - just after the first planet outside our solar system was discovered - and she searches out answers (and more good questions!) about the mysteries of exoplanets, their location, and their composition night and day.</div>
                </div>
                <div class="team-member">
                  <img src="./images/people/tabetha.jpg">
                  <div class="name">Tabetha Boyajian</div>
                  <div class="location">Yale University (USA)</div>
                  <div class="bio">Tabetha is a postdoctoral fellow in the exoplanets group at Yale. She is interested in exoplanet detection, the precise characterization of exoplanets and their host stars, and the fundamental properties of eclipsing binaries and nearby single stars.</div>
                </div>
                <div class="team-member">
                  <img src="./images/people/mattg.jpg">
                  <div class="name">Matt Giguere</div>
                  <div class="location">Yale University (USA)</div>
                  <div class="bio">Matt is a graduate student studying astronomy at Yale and is one of the original co-founders of Planet Hunters. Matt also studies stellar activity and searches for planets using the radial velocity technique.</div>
                </div>
                <div class="team-member">
                  <img src="./images/people/chrislint.jpg">
                  <div class="name">Chris Lintott<p><a href="http://www.twitter.com/chrislintott">@chrislintott</a></p></div>
                  <div class="location">University of Oxford (UK)</div>
                  <div class="bio">Chris runs the Zooniverse collaboration and works on how galaxies form and evolve; particularly interested in the effects of active galactic nuclei and mergers. In his 'spare' time, he hunts for planets, presents the BBC's long-running Sky at Night program and cooks.</div>
                </div>
                <div class="team-member">
                  <img src="./images/people/joeys.jpg">
                  <div class="name">Joey Schmitt</div>
                  <div class="location">Yale University (USA)</div>
                  <div class="bio">Joey is a third year graduate student at Yale University. He's originally from Iowa and received his B.S. at the University of Iowa. Joey now works on detecting and characterizing exoplanets and their atmospheres.  </div>
                </div>
                <div class="team-member">
                  <img src="./images/people/meg.jpg">
                  <div class="name">Meg Schwamb <p><a href="http://www.twitter.com/megschwamb">@megschwamb</a></p></div>
                  <div class="location">Institute of Astronomy and Astrophysics, Academia Sinica (Taiwan)</div>
                  <div class="bio">Meg is a planetary scientist and astronomer interested in how planets and solar systems form and evolve. In addition to working on exoplanets, she explores the small bodies residing in the outer Solar System and dabbles in the study of the Martian climate with the Planet Four project. Meg has a fondness for baking, soccer, and champagne. </div>
                </div>
                <div class="team-member">
                  <img src="./images/people/jiwang.jpg">
                  <div class="name">Ji Wang</div>
                  <div class="location">Yale University (USA)</div>
                  <div class="bio">Ji is Postdoc at Yale University. He is interested in finding Tatooines, planets in binary stars. He is an ultimate sports fan in his spare time.</div>
                </div>
              </div>

              <h2>Moderators</h2>
              <div class="team-members">
                <div class="team-member">
                  <img src="./images/people/tonyhoffman.jpg">
                  <div class="name">Tony Hoffman</div>
                  <div class="location">Username: TonyJHoffman</div>
                  <div class="bio">Tony is a technology analyst for PCMag.com. A director of the Amateur Astronomers Association of New York, Tony has participated in the SOHO comets program, Spacewatch FMO Project, and several Zooniverse citizen science projects in addition to Planet Hunters.</div>
                </div>
                <div class="team-member">
                  <img src="./images/people/joec.jpg">
                  <div class="name">Joe Constant</div>
                  <div class="location">Username: constovich</div>
                  <div class="bio">Joe is a Corrective Action Program Specialist at Catawba Nuclear Station. Science and science fiction have always appealed to him and being a citizen-scientist on PH has allowed him to virtually explore the cosmos.</div>
                </div>
                <div class="team-member">
                  <img src="./images/people/joechosyan.jpg">
                  <div class="name">Jo Echo Syan</div>
                  <div class="location">Username: echo-lily-mai</div>
                  <div class="bio">Jo has been a member of the Zooniverse since 2009 and is also a Merger Zoo moderator over on the Galaxy Zoo forum. Completing a 1st class degree in fine art is currently exploring how art and science can fuse together with Enjoy Chaos.</div>
                </div>
              </div>
            
              <h2>Development Team</h2>
              <div class="team-members">
               <div class="team-member">
                  <img src="./images/people/kelly.jpg">
                  <div class="name">Kelly Borden</div>
                  <div class="location">Adler Planetarium (USA)</div>
                  <div class="position">Education Lead</div>
                </div>
                <div class="team-member">
                  <img src="./images/people/julie.jpg">
                  <div class="name">Julie Feldt</div>
                  <div class="location">Adler Planetarium (USA)</div>
                  <div class="position">Educator</div>
                </div>
                <div class="team-member">
                  <img src="./images/people/sascha.jpg">
                  <div class="name">Sascha T. Ishikawa</div>
                  <div class="location">Adler Planetarium (USA)</div>
                  <div class="position">Frontend Developer</div>
                </div>
                <div class="team-member">
                  <img src="./images/people/chrislintott-grayscale.png">
                  <div class="name">Chris Lintott</div>
                  <div class="location">Oxford University (UK)</div>
                  <div class="position">PI of Zooniverse</div>
                </div>
                <div class="team-member">
                  <img src="./images/people/stuart.jpg">
                  <div class="name">Stuart Lynn</div>
                  <div class="location">Adler Planetarium (USA)</div>
                  <div class="position">Technical Lead</div>
                </div>
                 <div class="team-member">
                  <img src="./images/people/grant.jpg">
                  <div class="name">Grant Miller</div>
                  <div class="location">Oxford University (UK)</div>
                  <div class="position">Community Manager</div>
                </div>
                <div class="team-member">
                  <img src="./images/people/michael.jpg">
                  <div class="name">Michael Parrish</div>
                  <div class="location">Adler Planetarium (USA)</div>
                  <div class="position">Backend Developer</div>
                </div>
                <div class="team-member">
                  <img src="./images/people/heath.jpg">
                  <div class="name">Heath Van Singel</div>
                  <div class="location">Adler Planetarium (USA)</div>
                  <div class="position">Designer</div>
                </div>
                <div class="team-member">
                  <img src="./images/people/chriss.jpg">
                  <div class="name">Chris Snyder</div>
                  <div class="location">Adler Planetarium (USA)</div>
                  <div class="position">Project Manager</div>
                </div>
                <div class="team-member">
                  <img src="./images/people/alex.jpg">
                  <div class="name">Alex Weiksnar</div>
                  <div class="location">Adler Planetarium (USA)</div>
                  <div class="position">Frontend Developer</div>
                </div>
                <div class="team-member">
                  <img src="./images/people/laura.jpg">
                  <div class="name">Laura Whyte</div>
                  <div class="location">Adler Planetarium (USA)</div>
                  <div class="position">Director of Citizen Science</div>
                </div>
              </div>

            '''

        organizations:
          header         : '<h1>Organization</h1>'
          content        : 
            '''
            <div class="organization">
              <h2>The Adler Planetarium</h2>
              <p><img style="padding-bottom: 70px;" src="./images/logos/adler.png" class="logo"><a href="http://www.adlerplanetarium.org">The Adler Planetarium</a> - America's First Planetarium - was founded in 1930 by Chicago business leader Max Adler. The Adler is a recognized leader in science education, with a focus on inspiring young people to pursue careers in science, technology, engineering and math. Throughout 80 years, the Adler has inspired the next generation of explorers by sharing the personal stories of space exploration and America’s space heroes.</p>
            </div>

            <div class="organization">
              <h2>The University of Oxford</h2>
              <p><img src="./images/logos/oxford.png" class="logo"><a href="http://www.ox.ac.uk/">The University of Oxford</a> is the oldest in the English-speaking world having been founded in the 11th or 12th centuries. Today, it combines research in the humanities with major effort in the natural sciences and medicine. Citizen science is supported by the Department of Physics, the Division of Mathematics, Physical and Life Sciences, and the Oxford Martin Schools.</p>
            </div>

            <div class="organization">
              <h2>Yale University</h2>
              <p><img src="./images/logos/yale.png" class="logo"><a href="http://exoplanets.astro.yale.edu/">The Exoplanets group at Yale</a> is headed by Professor Debra Fischer. The group's research projects include Doppler planet searches, analysis of the properties of planet-hosting stars, and instrumentation and software development to investigate novel designs needed for achieving better Doppler precision.</p>
            </div>

            <div class="organization">
              <h2>NASA's Exoplanet Exploration Program</h2>
              <p><img src="./images/logos/nasa.png" class="logo">Headquartered at the Jet Propulsion Laboratory in California, the <a href="http://exep.jpl.nasa.gov/">Exoplanet Exploration Program</a> is dedicated to the development of technology and programs (including the Kepler mission) to detect and characterize planets that orbit other stars. The public PlanetQuest site is a one-stop shop for NASA exoplanet news, educational articles, and interactive features.</p>
            </div>

            <h2>Zooniverse</h2>
            <p><img src="./images/logos/zooniverse.png" class="logo"><a href="http://www.zooniverse.org/">The Zooniverse</a> is home to the internet’s largest, most popular and most successful citizen science projects. The Zooniverse and the suite of projects it contains is produced, maintained and developed by the Citizen Science Alliance. The member institutions of the CSA work with many academic and other partners around the world to produce projects that use the efforts and ability of volunteers to help scientists and researchers.</p>
            '''

  educationPage:
    mainHeader         : 'Education'
    tabs:
      classroom        : 'Classroom'

    section:
      classroom:
        header         : '<h1>In the Classroom</h1>'
        content        : 
          '''
          <h2>Can I use Planet Hunters 2 in the classroom?</h2>
            <p>Yes! Planet Hunters, like all the Zooniverse projects, offers students a unique opportunity to explore real scientific data while making a contribution to cutting edge research! We would like to stress that it's okay if students don't mark all the features correctly since each light curve is seen by multiple volunteers.  The task itself is simple enough that we believe most people can take part and make a worthwhile contribution regardless of age.</p>
         
          <!-- </div>
          <div class="content sub-nav-education-resources">-->
            <h1>Resources</h1>

            <h2>How can you help scientists discover distant planets?</h2>
            <p>Watch our step-by-step tour of Planet Hunters with this instructional video:</p>
            <iframe src="//player.vimeo.com/video/110148951" width="640" height="480" frameborder="0" webkitallowfullscreen mozallowfullscreen allowfullscreen></iframe>

            <h2>What resources are available for the classroom?</h2>

            <p>
              Here are some resources that can be great tools for introducing students to Planet Hunters. Here are a couple of our favorites:
              <ul>
                <li>
                  NASA Kepler Missions website: 
                  <a href="http://kepler.nasa.gov">http://kepler.nasa.gov</a>
                </li>
                <li>
                  NASA Planet Quest website: 
                  <a href="http://planetquest.jpl.nasa.gov">http://planetquest.jpl.nasa.gov</a>
                </li>
                <li>
                  <a href="http://astro.unl.edu/naap/esp/animations/transitSimulator.html">Exoplanet Transit Simulator</a> by The Astronomy Department at University of Nebraska
                </li>
                <li>
                  National Science Foundation's <a href="https://www.youtube.com/watch?v=0WatNUka7OA">Science Behind The News: Extrasolar Planets</a>, describes the Transit and Doppler methods.
                </li>
                <li>
                  NASA has also provided tools you can use in the classroom related to Exoplanets:
                  <a href="http://planetquest.jpl.nasa.gov/interactives">https://www.youtube.com/watch?v=0WatNUka7OA</a>
                </li>
              </ul>
            </p>

            <p>
              Educators Guides, here are lessons that are focused on exoplanets:
              <ul>
                <li>
                  Coming Fall 2014, Planet Hunters Educators Guide! Zooniverse educators have developed lessons to show you how you can best utilize Planet Hunters in your classroom.
                </li>
                <li>
                  Educator Resource Guide provided by NASA: 
                  <a href="http://astrobiology.nasa.gov/media/medialibrary/2013/10/Astrobiology-Educator-Guide-2007.pdf">Astrobiology in Your Classroom, Life on Earth …and elsewhere?</a>
                </li>
                <li>
                  <a href="http://www.lpi.usra.edu/education/explore/our_place">Our Place in Space</a> 
                  activities produced by the Lunar and Planetary Institute
                </li>
              </ul>
            </p>

            <p>The Zooniverse has launched <a href="http://www.zooteach.org">ZooTeach</a> where educators can find and share educational resources relating to Planet Hunters and the other Zooniverse citizen science projects. Check out resources created for Planet Hunters at <a href="http://www.zooteach.org/zoo/planet_hunters">http://www.zooteach.org/zoo/planet_hunters</a>. Have any ideas for how to use the project in the classroom? Please share your lesson ideas or resources on ZooTeach!</p>

            <h2>How can I keep up to date with education and Planet Hunters?</h2>
            <p>The Planet Hunters blog is a great place to keep up to date with the latests science result.  FInd the latest education resources and news on the <a href="http://education.zooniverse.org">Zooniverse Education Blog</a> as well as the <a href="https://twitter.com/ZooTeach">@ZooTeach</a> Twitter feed.</p>
          '''

  # INITIAL TUTORIAL
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
      caption: 'This part of the light curve shows the time spent observing the star.'

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