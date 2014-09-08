content = [
  {
    course_number: 1
    material:
      title: "The Kepler Mission"
      text: "The Kepler space telescope was launched by NASA in 2009. It was named after German astronomer Johannes Kepler, who is best known for developing the laws of planetary motion in the 17th century. For 4 years it stared at a patch of sky 100 square degrees in area (500 times that of the full Moon) in the constellations Lyra, Cygnus and Draco, looking for the tell-tale dips in brightness caused when a planet passes in front of its host star. It is these brightness measurements you are looking at on Planet Hunters."
      figure: "./images/mini-course/01-KeplerHR_sm.jpg"
      figure_credits: "Image courtesy of NASA"
  }
  {
    course_number: 2
    material:
      title: "How a lightcurve is formed"
      text: "<p>A lightcurve is formed by taking regular observations of a star’s brightness and plotting them over time. When a planet passes over the stellar disc it blocks some of the light from the star. This is called a transit. Above you can see an example of a transit lightcurve.</p>"
      figure: "./images/mini-course/ph-transit-070214.gif"
      figure_credits: ""
  }
  {
    course_number: 3
    material:
      title: "What can we learn from a lightcurve? (Part 1)"
      text: """
        <p>
          A lightcurve can tell us a lot about a planetary system. If multiple transits are observed then we have a measurement of the orbital period, P, as it is just the time interval between each transit. Astronomer Johannes Kepler showed that orbital period is proportional to orbital seperation &alpha;,
        </p>
        <div style=\"text-align: center;\">
          <img style=\"width: 75px; padding: 20px\" src=\"./images/mini-course/keplers-third-law.png\"/>
        </div>
      """
      figure: "./images/mini-course/light-curve-period.png"
      figure_credits: ""
  }
  {
    course_number: 4
    material:
      title: "What can we learn from a lightcurve? (Part 2)"
      text: """
        <p>
          The other most important piece of information a transit lightcurve gives us is an estimate of the size of the planet. The larger the planet is in relation to the star, the more light is blocked by the planet and the deeper the transit. So the transit depth, d, is proportional to the radius of the planet,
        </p>
        <div style=\"text-align: center;\">
          <img style=\"width: 75px; padding: 20px\" src=\"./images/mini-course/transit-depth.png\"/>
        </div>
        """
      figure: "./images/mini-course/lightcurve-transit-depth.png"
      figure_credits: ""
  }
  {

    course_number: 5
    material:
      title: "False-positives - Variable stars"
      text: """
        <p>Not all changes in a star’s brightness are caused by transiting planets. There are a few other things we have to rule out first. These are called false-positives.</p>
        <p>Some stars intrinsically vary in brightness on a level that is comparable to that of a planetary transit. However, if the star is observed for a long period of time, the pattern of the variation can be easily differentiated from that of a planet transit. These variations normally happen over a much longer time than a planet transit.</p>
        """
      figure: "./images/mini-course/5-FalsePositives.png"
      figure_credits: ""

  }

  {

    course_number: 6
    material:
      title: "False-positives - Eclipsing binary stars"
      text: """
        One of the most common false-positives we have to deal with are eclipsing binary stars. This is when another star is transiting, rather than a planet. These tend to produce much deeper transits due to stars being much larger than planets, and they also show secondary eclipses (when the smaller star passes behind the larger star). However, if the second star is only partially transiting the disc of the first star then the amount of light blocked is smaller and the depth of the transit may be similar to that caused by a planet. This is called a ‘grazing eclipsing binary’. Light from other stars can also dilute the light from an eclipsing binary system, producing the illusion of a smaller transit depth. This is called a ‘blended eclipsing binary’.
        """
      figure: "missing"
      figure_credits: ""

  }

  {
    course_number: 7
    material:
      title: "Other features in the lightcurves - flares"
      text: """
        Stellar flares may be spotted in the lightcurves on Planet Hunters. They are characterised by rapid spikes in brightness. These are large explosions from the surface of the star, just like solar flares that we observe on our star the Sun. Below is an example of a lightcurve with flare features.
        """
      figure: "./images/mini-course/7-Flares.png"
      figure_credits: ""

  }

  {
    course_number: 8
    material:
      title: "A brief history of Exoplanets"
      text: """
        The idea of planets orbiting other stars in our galaxy has been around for hundreds of years (in fact 16th century Italian astronomer Giordano Bruno was burnt at the stake at least in part for his beliefs on the matter!). However, it was not until 1992 that the first exoplanet was confirmed. It was found orbiting a pulsar, the rapidly-spinning, dense core of a dead star. The first confirmed planet orbiting a Sun-like star, 51 Pegesi b, was announced in 1995. Since then over one thousand exoplanets have been confirmed and many more candidates identified. The graph below shows the distribution of planet candidates discovered by the Kepler mission as of November 2013.
        """
      figure: "./images/mini-course/8-size-candidates.jpg"
      figure_credits: "NASA"

  }

  {
    course_number: 9
    material:
      title: "The first Planet Hunters planet"
      text: """
        The first confirmed planet discovered by volunteers, like you, on Planet Hunters was PH1b (also known as Kepler-64b). It is a Neptune-sized giant planet with a radius 6 times greater than that of the Earth. The really interesting thing about PH1b is that it’s a circumbinary planet, meaning it orbits around two stars! Those two stars are also in orbit around another binary star system, which makes PH1b the first planet ever discovered in a quadruple star system.
        """
      figure: "./images/mini-course/9-FirstPlanet.png"
      figure_credits: "NASA"

  }

  {
    course_number: 10
    material:
      title: "Planet Hunters 2b"
      text: """
        PH2b is the second planet discovered by volunteers on Planet Hunters. It is a Jupiter-sized, gas giant planet in orbit around a star very similar to our Sun. It’s orbit is only 17% smaller than that of the Earth, putting it in a region known as the habitable zone, the distance from a star where the conditions may be right for life. You will learn more about the habitable zone later.
        """
      figure: "./images/mini-course/10-2b.png"
      figure_credits: "NASA"

  }

  {
    course_number: 11
    material:
      title: "Kepler-90"
      text: """
        The third confirmed exoplanet discovered by volunteers on Planet Hunters is in a system known as Kepler-90 and now has the designation Kepler-90h. This system already had six confirmed exoplanets and the discovery of the seventh bu Planet Hunters volunteers made it the most populous planetary system known apart from our own.
        """
      figure: "./images/mini-course/11-kepler90.png"
      figure_credits: "NASA"

  }

  {
    course_number: 12
    material:
      title: "Star vs Planet"
      text: """
        Stars are mostly made of hydrogen, which is also true for some gas giant planets such as Jupiter. The difference is that stars are massive enough to ignite nuclear fusion of hydrogen into helium in their cores. The smallest stars are roughly 75 times more massive than Jupiter, and the largest planets are about 13 times more massive than Jupiter.
        """
      figure: "./images/mini-course/12-star-v-planet.jpg"
      figure_credits: "NASA"

  }

  {
    course_number: 13
    material:
      title: "Types of stars - main sequence"
      text: """
        A star spends the majority of its active life burning the hydrogen in its core. Stars that are in this phase are known as main sequence stars. Main sequence stars are split into 7 main groups named O, B, A, F, G, K and M in order from hottest to coolest. Our Sun is a G-type star but the vast majority of stars in our galaxy are smaller, cooler M-type stars.
        """
      figure: "./images/mini-course/13-spectral-chart.jpg"
      figure_credits: "NASA"

  }

  {
    course_number: 14
    material:
      title: "The Habitable Zone"
      text: """
        There exists a region around a star inside which a planet may be considered habitable by life as we understand it. Habitability can depend on many factors but the main one is the potential for liquid water to exist on the surface of a planet. This therefore depends primarily on the distance of the planet from its host star. Too close and the water will boil, too far and it will freeze. Stars that are smaller and cooler than our Sun (such as M-dwarfs) will have habitable zones that are much closer in, which means potentially habitable planets around them will have shorter orbital periods than a year.
        """
      figure: "./images/mini-course/14-HabitableZone.png"
      figure_credits: "NASA"

  }

  {
    course_number: 15
    material:
      title: "How else can we discover planets?"
      text: """
        <p>The transit method is a very simple and effective method for discovering planets, but it is not the only one used by astronomers. Let’s have a look at some of the other methods:</p>
        <h2>THE RADIAL VELOCITY METHOD</h2>
        <p>As a planet orbits a star its gravitational pull moves the star around. Therefore at some points the star is moving towards us (the observer) and at other points it is moving away from us. We can measure the speed of this movement by looking at the spectrum of light from the star. When moving towards us the star’s light becomes more blue, and when moving away its light becomes more red. The faster the star is moving, the more massive the planet. For example, Jupiter moves the Sun at 12.7 m/s (slightly faster than Usain Bolt can run), whereas the effect from Earth is over 100 times smaller, making it much easier to detect larger planets.</p>
        """
      figure: "missing"
      figure_credits: "NASA"

  }

  {
    course_number: 16
    material:
      title: "How else can we discover planets? - Radial Velocity"
      text: """
        The radial velocity method has been used to discover hundreds of exoplanets to date, however it has one major disadvantage; it cannot be used to determine the angle of the planetary system to our line-of-sight, so perhaps we are only seeing a small fraction of the star’s movement? This means that only a minimum measurement of the star’s speed can be calculated, leading to only a minimum possible value for the mass of the exoplanet.
        """
      figure: "./images/mini-course/16-radial-velocity.jpg"
      figure_credits: "NASA"

  }

  {
    course_number: 17
    material:
      title: "How else can we discover planets? - Gravitational Microlensing"
      text: """
        The gravitational field of a star is strong enough to noticeably bend light. When one star passes directly in front of a more distant star as seen from Earth it can bend and focus the light of the distant star causing it to appear brighter for a short period of time. This is known as gravitational microlensing and the closer star is called the lens. If there is a planet orbiting the lens it will sometimes add a noticeable component to the lens effect allowing us to confirm its existence.
        """
      figure: "./images/mini-course/17-micro-lensing.jpg"
      figure_credits: "NASA"

  }

  {
    course_number: 18
    material:
      title: "How else can we discover planets? - Pulsar Timing"
      text: """
        The first ever confirmed exoplanet was not actually discovered orbiting a Sun-like star. It was found around an object known as a pulsar. Pulsars are the extremely dense, rapidly spinning cores of dead stars which have beams of radiation that sweep out like an interstellar lighthouse. The rotation-rate of pulsars is extremely reliable and can be measured to very high accuracy. However, if a planet in in orbit its gravitational pull on the pulsar will manipulate the rotation-rate in a way that allows its existence to be inferred.
        """
      figure: "missing"
      figure_credits: "NASA"

  }

  {
    course_number: 19
    material:
      title: "How else can we discover planets? - Transit Timing Variations"
      text: """
        In a similar way to pulsar timing, the timing of exoplanet transits can be used to infer the existence of other planets in the same system. If there were just one planet orbiting the star, the time interval between each transit would be exactly the same. However, if there is more than one planet the gravitational pull from other planets will cause regular variations in the time at which the transiting planet actually passes in front of the star. The size of the timing variation is used to measure the mass of the unseen planet.
        """
      figure: "missing"
      figure_credits: "NASA"

  }

  {
    course_number: 20
    material:
      title: "How else can we discover planets? - Astrometry"
      text: """
        As described before for the radial velocity method, stars are pulled around by the gravitation force from their orbiting planets. Therefore, if the position of a star can be measured accurately, this movement can be observed and the existence of the planet can be confirmed. These movements are extremely small and to-date very few exoplanet candidates have been discovered in this way, however the recently launch Gaia spacecraft plans to utilise this method as part of its mission.
        """
      figure: "missing"
      figure_credits: "NASA"

  }

  {
    course_number: 21
    material:
      title: "How else can we discover planets? - Direct Imaging"
      text: """
        <p>The separation and extreme difference in brightness between exoplanets and their host stars makes it very difficult to image them directly. However, there are a handful of exoplanet candidates  that have been discovered this way. All of them have very large radii and lie in distant orbits.</p>
        <p>Below is an image showing the directly imaged exoplanet candidate orbiting in the debris disk around the star Formalhaut.</p>
        """
      figure: "./images/mini-course/21-DirectImaging.png"
      figure_credits: "NASA"

  }

  {
    course_number: 22
    material:
      title: "Hot Jupiters"
      text: """
        The first planets discovered using the transit method were very strange. They are the same size as Jupiter but so close to their star that they only take a few days to complete one orbit! We knew of nothing like this in our Solar System and theories suggest it is impossible for a Jupiter-sized planet to form in the high temperature environment that close to a star.
        """
      figure: "./images/mini-course/22-HotJupiters.png"
      figure_credits: "NASA"

  }

  {
    course_number: 23
    material:
      title: "Hot Jupiters - Migration"
      text: """
        For the Hot Jupiters to have gotten to their observed location they would have to have first formed much farther out where it was colder and then migrated inwards through the system. Multiple theories on how this migration occurs have been proposed, including interactions with other material orbiting the star in the early stages of the system and gravitational scattering involving other large bodies.
        """
      figure: "./images/mini-course/23-HotJupiters.png"
      figure_credits: "NASA"

  }
]

module.exports = content
