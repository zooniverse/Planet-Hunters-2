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
]

module.exports = content