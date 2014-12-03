calculateStar = (form) ->    
    # The method  for calculating mass uses a curve-fit to published M* and R* values for candidate host stars derived by the Kepler team2 and is
    # M* = 0.4472 logeR* + 1  
    radS = parseFloat(form.radS)
    mag = parseFloat(form.mag)
    temp = parseFloat(form.temp) / TeffSol
    massS = 0.4472 * Math.log(radS) + 1

    console.log 'massS = ', massS
    
    # distance to the Star in AU, assuming that radS is in solar radii and that temp is in Teffsol
    # L/Lsun = (R/Rsun)^2 x (T/Tsun)^4
    # m = msun - 2.5log(L/Lsun x (Dsun/D)^2)
    # msun = -26.73
    a = mag / 5
    b = radS * temp * temp
    c = log10(b)
    distS = Math.pow(10, (a + 5.346 + c))
    sp = document.getElementById("massS")
    sp.innerHTML = massS.toFixed(1) + "M<sub>&odot;</sub>"
    sp = document.getElementById("distS")
    sp.innerHTML = addCommas((distS / AUtoLY).toFixed(0)) + " LY"
    return

calculatePlanetCharacteristics = (form) ->
  radS = parseFloat(form.radS)
  mag = parseFloat(form.mag)
  temp = parseFloat(form.temp)
  actB = parseFloat(form.actB)
  estB = parseFloat(form.estB)
  period = parseFloat(form.period) / 365
  
  # Mass and Distance of Star
  massS = 0.4472 * Math.log(radS) + 1
  lum = radS * radS * Math.pow((temp / TeffSol), 4)
  
  # Radius of Planet
  dimm = radS * radS * Rsol * Rsol * (1 - actB / estB)
  radP = (Math.sqrt(dimm)) / Re
  sp = document.getElementById("radP")
  sp.innerHTML = addCommas((radP * Re).toFixed(0)) + " km" + " (" + radP.toFixed(1) + "R<sub>E</sub>)"
  
  # Volume of Planet
  volP = (4 / 3) * pi * radP * radP * radP
  sp = document.getElementById("volP")
  sp.innerHTML = volP.toFixed(1) + "V<sub>E</sub>"
  
  # Mass of Planet
  # radP must be in Earth radii
  massP = undefined
  if radP < 10
    if radP < 6
      massP = 0.9515 * Math.pow(radP, 3.1)
    else
      massP = 1.7013 * Math.pow(radP, 2.0383)
  else
    massP = 0.6631 * Math.pow(radP, 2.4191)
  sp = document.getElementById("massP")
  sp.innerHTML = massP.toFixed(1) + "M<sub>E</sub>"
  
  # Density of Planet
  rhoP = undefined
  radPcm = radP * Re * 1000 * 100
  volPcm = (4 / 3) * pi * radPcm * radPcm * radPcm
  massPg = massP * Me * 1000
  rhoP = (massPg / volPcm)
  sp = document.getElementById("rhoP")
  sp.innerHTML = rhoP.toFixed(1) + "g/cm<sup>3</sup>"
  
  # Orbital Distance of Planet
  distP = Math.pow((period * period * massS), 0.333)
  sp = document.getElementById("distP")
  sp.innerHTML = addCommas((distP * KMtoAU).toFixed(0)) + " km" + " (" + distP.toFixed(2) + " AU)"
  
  # Duration of Transit
  tdur = 13 * 2 * radS * Math.pow(distP / massS, 0.5)
  sp = document.getElementById("tdur")
  sp.innerHTML = tdur.toFixed(1) + "hrs"
  
  # Temperature Estimate
  albedo = 0.33
  beta = 1
  em = 0.9
  tempP = Math.pow(((1 - albedo) * radS * radS) / (4 * beta * em * distP * distP), 0.25) * temp / 15
  sp = document.getElementById("tempP")
  sp.innerHTML = tempP.toFixed(0) + "K"
  return

# CONSTANTS
TeffSol = 5780
Rsol = 695500
Rj = 71442
Re = 6371
Me = 5.97219 * Math.pow(10, 24)
pi = 3.14159
AUtoLY = 63240
AUtoPS = 206265
KMtoAU = 149598000

addCommas = (nStr) ->
  nStr += ""
  x = nStr.split(".")
  x1 = x[0]
  x2 = (if x.length > 1 then "." + x[1] else "")
  rgx = /(\d+)(\d{3})/
  x1 = x1.replace(rgx, "$1" + "," + "$2")  while rgx.test(x1)
  x1 + x2

log10 = (arg) ->
  Math.log(arg) / Math.LN10

ResetOK = ->
  resetyes = confirm("Are you sure that you want to reset the input fields?")
  if resetyes
    true
  else
    false

Number::toFullString = ->
  isDecimal = /\-/.test(this)
  if isDecimal
    @toFixed @toString().split("-")[1]
  else
    this


module.exports = calculateStar: calculateStar, calculatePlanetCharacteristics: calculatePlanetCharacteristics

