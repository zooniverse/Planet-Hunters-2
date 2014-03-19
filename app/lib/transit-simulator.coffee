# 
# *  Based on Mandel & Agol's Model for Quadratic Limb Darkening
# *  Mandel K. & Agol E. 2002, ApJ, 580, L171; please cite this
# *  paper if you make use of this in your research.  Also, a
# *  thanks to Gil Nachmani who wrote this routine would be appreciated.
# * 
# *  [phi,F] are the observed phase and relative flux
# *  p is the planet's radius in units of the star's radius (Rs)
# *  ap is the planet's orbital radius in units of Rs, assuming zero eccentricity
# *  P is the planet's period in days
# *  incl is the inclination of the orbit in degrees
# *  gamma1, gamma2 are the Quadratic Limb Darkening coefficients:
# *  I(r) = 1-gamma1*(1-mu)-gamma2*(1-mu)^2, where: mu=cos(th)=sqrt(1-r^2);
# *  E.g. gamma1=0.296, gamma2=0.34 for HD209458
# *  n is the number of phase points in the resulting lightcurve
# *  percentOfOrbit is the percentage of orbital phase to be used for the flux
# *  calculations, e.g. for full orbit use 100(%).
# * 
# *  Gil Nachmani, April 2011
# *
# 
quadLimbDark = (p, ap, P, incl, gamma1, gamma2, n, percentOfOrbit) ->
  F = new Array(n)
  t = new Array(n)
  Z = new Array(n)
  phi = new Array(n)
  percentOfOrbit = 150 * (p + 1) / ap / 2 / pi  if nargin < 8
  
  # translate
  # t = linspace( -P*percentOfOrbit/100, P*percentOfOrbit/100, n );
  endVal = P * percentOfOrbit / 100
  step = (2 * endVal) / n
  i = 0
  t_val = -endVal

  while i < n and t_val <= endVal
    t[i] = t_val
    phi[i] = t[i] / P
    Z[i] = ap * (Math.pow(Math.sin(2 * pi / P * t[i]), 2) + Math.pow(Math.cos(pi / 180 * incl) * Math.cos(2 * pi / P * t[i]), 2))
    i++
    t_val = t_val + step
  c1 = 0
  c2 = gamma1 + 2 * gamma2
  c3 = 0
  c4 = -gamma2 # I(r) = 1-sum(cn*(1-mu^(n/2)))
  c0 = 1 - c1 - c2 - c3 - c4
  ohmega = c0 / (0 + 4) + c1 / (1 + 4) + c2 / (2 + 4) + c3 / (3 + 4) + c4 / (4 + 4)
  j = 0
  while j < n
    z = Z[j]
    a = Math.pow(z - p, 2)
    b = Math.pow(z + p, 2)
    k = Math.sqrt((1 - a) / 4 / z / p)
    q = Math.pow(p, 2) - Math.pow(z, 2)
    k1 = Math.acos((1 - Math.pow(p, 2) + Math.pow(z, 2)) / 2 / z)
    k0 = Math.acos((Math.pow(p, 2) + Math.pow(z, 2) - 1) / 2 / p / z)
    
    # Evaluating lam_e
    if 1 + p < z or Math.abs(phi(j)) > (p + 1) / ap / 2 / pi
      lam_e = 0
    else if Math.abs(1 - p) < z and z <= 1 + p
      lam_e = 1 / pi * (Math.pow(p, 2) * k0 + k1 - 1 / 2 * Math.sqrt(4 * Math.pow(z, 2) - Math.pow((1 + Math.pow(z, 2) - Math.pow(p, 2)), 2)))
    else if z <= 1 - p and z > p - 1
      lam_e = Math.pow(p, 2)
    else lam_e = 1  if z <= p - 1
    
    # Evaluating lam_d and eta_d
    if z >= 1 + p or p is 0 or Math.abs(phi(j)) > (p + 1) / ap / 2 / pi
      lam_d = 0
      eta_d = 0
    else if z >= 1 / 2 + Math.abs(p - 1 / 2) and z < 1 + p
      lam_d = lam1(p, z, a, b, k, q)
      eta_d = eta1(p, z, a, b, k1, k0)
    else if p < 0.5 and z > p and z < 1 - p
      lam_d = lam2(p, z, a, b, k, q)
      eta_d = eta2(p, z)
    else if p < 0.5 and z is 1 - p
      lam_d = lam5(p)
      eta_d = eta2(p, z)
    else if p < 0.5 and z is p
      lam_d = lam4(p)
      eta_d = eta2(p, z)
    else if p is 0.5 and z is 0.5
      lam_d = 1 / 3 - 4 / pi / 9
      eta_d = 3 / 32
    else if p > 0.5 and z is p
      lam_d = lam3(p)
      eta_d = eta1(p, z, a, b, k1, k0)
    else if p > 0.5 and z >= Math.abs(1 - p) and z < p
      lam_d = lam1(p, z, a, b, k, q)
      eta_d = eta1(p, z, a, b, k1, k0)
    else if p < 1 and z > 0 and z <= 1 / 2 - Math.abs(p - 1 / 2)
      lam_d = lam2(p, z, a, b, k, q)
      eta_d = eta2(p, z)
    else if p < 1 and z is 0
      lam_d = lam6(p)
      eta_d = eta2(p, z)
    else if p > 1 and z <= p - 1
      lam_d = 0
      eta_d = 1 / 2
    F(j) = 1 - 1 / (4 * ohmega) * ((1 - c2) * lam_e + c2 * (lam_d + 2 / 3 * heaviside(p - z)) - c4 * eta_d)
    j++
  F

# ----------------------------------------------------------------------- 
lam1 = (p, z, a, b, k, q) ->
  lam = 1 / 9 / pi / Math.sqrt(p * z) * (((1 - b) * (2 * b + a - 3) - 3 * q * (b - 2)) * K(k) + 4 * p * z * (Math.pow(z, 2) + 7 * Math.pow(p, 2) - 4) * E(k) - 3 * q / a * PI((a - 1) / a, k))
  lam
lam2 = (p, z, a, b, k, q) ->
  lam = 2 / 9 / pi / Math.sqrt(1 - a) * ((1 - 5 * Math.pow(z, 2) + Math.pow(p, 2) + Math.pow(q, 2)) * K(1 / k) + (1 - a) * (Math.pow(z, 2) + 7 * Math.pow(p, 2) - 4) * E(1 / k) - 3 * q / a * PI((a - b) / a, 1 / k))
  lam
lam3 = (p) ->
  lam = 1 / 3 + 16 * p / 9 / pi * (2 * Math.pow(p, 2) - 1) * E(1 / 2 / p) - (1 - 4 * Math.pow(p, 2)) * (3 - 8 * Math.pow(p, 2)) / 9 / pi / p * K(1 / 2 / p)
  lam
lam4 = (p) ->
  lam = 1 / 3 + 2 / 9 / pi * (4 * (2 * Math.pow(p, 2) - 1) * E(2 * p) + (1 - 4 * Math.pow(p, 2)) * K(2 * p))
  lam
lam5 = (p) ->
  lam = 2 / 3 / pi * Math.acos(1 - 2 * p) - 4 / 9 / pi * (3 + 2 * p - 8 * Math.pow(p, 2)) * Math.sqrt(p * (1 - p)) - 2 / 3 * heaviside(p - 1 / 2)
  lam
lam6 = (p) ->
  lam = -2 / 3 * Math.pow((1 - Math.pow(p, 2)), 3 / 2)
  lam
eta1 = (p, z, a, b, k1, k0) ->
  eta = 1 / 2 / pi * (k1 + 2 * eta2(p, z) * k0 - 1 / 4 * (1 + 5 * Math.pow(p, 2) + Math.pow(z, 2)) * Math.sqrt((1 - a) * (b - 1)))
  eta
eta2 = (p, z) ->
  eta = Math.pow(p, 2) / 2 * (Math.pow(p, 2) + 2 * Math.pow(z, 2))
  eta
heaviside = (x) ->
  if x < 0
    0
  else if x > 0
    1
  else
    1 / 2

#
# * Functions to evaluate elliptic ingegrals (adapted from Numerical Recipes)
# 

# first
K = (k) ->
  phi = pi / 2 # evaluate complete integral
  s = Math.sin(phi)
  result = s * RF(Math.pos(Math.cos(phi), 2), (1.0 - s * k) * (1.0 + s * k), 1.0)
  result

# second
E = (k) ->
  phi = pi / 2
  s = Math.sin(phi)
  cc = Math.pow(Math.cos(phi), 2)
  q = (1.0 - s * k) * (1.0 + s * k)
  result = s * (RF(cc, q, 1.0) - Math.pow(s * k, 2) * RD(cc, q, 1.0) / 3.0)
  result

# third
PI = (n, k) ->
  n = -n # sign convension opposite to Abramowitz and Stegun
  phi = pi / 2
  s = Math.sin(phi)
  enss = n * s * s
  cc = Math.pow(Math.cos(phi), 2)
  q = (1.0 - s * k) * (1.0 + s * k)
  result = s * (RF(cc, q, 1.0) - enss * RJ(cc, q, 1.0, 1.0 + enss) / 3.0)
  result

#
# * Computes Carlson?s elliptic integral of the first kind
# 
RF = (x, y, z) ->
  ERRTOL = 0.08
  TINY = 1.5e-38
  BIG = 3.0e37
  THIRD = (1.0 / 3.0)
  C1 = (1.0 / 24.0)
  C2 = 0.1
  C3 = (3.0 / 44.0)
  C4 = (1.0 / 14.0)
  
  #disp('invalid arguments in RF()')
  return  if Math.min(Math.min(x, y), z) < 0.0 or Math.min(Math.min(x + y, x + z), y + z) < TINY or Math.max(Math.max(x, y), z) > BIG
  xt = x
  yt = y
  zt = z
  sqrtx = Math.sqrt(xt)
  sqrty = Math.sqrt(yt)
  sqrtz = Math.sqrt(zt)
  alamb = sqrtx * (sqrty + sqrtz) + sqrty * sqrtz
  xt = 0.25 * (xt + alamb)
  yt = 0.25 * (yt + alamb)
  zt = 0.25 * (zt + alamb)
  ave = THIRD * (xt + yt + zt)
  delx = (ave - xt) / ave
  dely = (ave - yt) / ave
  delz = (ave - zt) / ave
  while Math.max(Math.max(Math.abs(delx), Math.abs(dely)), Math.abs(delz)) > ERRTOL
    sqrtx = Math.sqrt(xt)
    sqrty = Math.sqrt(yt)
    sqrtz = Math.sqrt(zt)
    alamb = sqrtx * (sqrty + sqrtz) + sqrty * sqrtz
    xt = 0.25 * (xt + alamb)
    yt = 0.25 * (yt + alamb)
    zt = 0.25 * (zt + alamb)
    ave = THIRD * (xt + yt + zt)
    delx = (ave - xt) / ave
    dely = (ave - yt) / ave
    delz = (ave - zt) / ave
  e2 = delx * dely - delz * delz
  e3 = delx * dely * delz
  result = (1.0 + (C1 * e2 - C2 - C3 * e3) * e2 + C4 * e3) / Math.sqrt(ave)
  result

#
# * Computes Carlson?s elliptic integral of the second kind
# 
RD = (x, y, z) ->
  ERRTOL = 0.05
  TINY = 1.0e-25
  BIG = 4.5e21
  C1 = 3 / 14
  C2 = 1 / 6
  C3 = 9 / 22
  C4 = 3 / 26
  C5 = 0.25 * C3
  C6 = 1.5 * C4
  
  #disp('invalid arguments in RD()')
  return  if Math.min(x, y) < 0.0 or Math.min(x + y, z) < TINY or Math.max(Math.max(x, y), z) > BIG
  xt = x
  yt = y
  zt = z
  sum = 0.0
  fac = 1.0
  sqrtx = Math.sqrt(xt)
  sqrty = Math.sqrt(yt)
  sqrtz = Math.sqrt(zt)
  alamb = sqrtx * (sqrty + sqrtz) + sqrty * sqrtz
  sum = sum + fac / (sqrtz * (zt + alamb))
  fac = 0.25 * fac
  xt = 0.25 * (xt + alamb)
  yt = 0.25 * (yt + alamb)
  zt = 0.25 * (zt + alamb)
  ave = 0.2 * (xt + yt + 3.0 * zt)
  delx = (ave - xt) / ave
  dely = (ave - yt) / ave
  delz = (ave - zt) / ave
  while Math.max(Math.max(Math.abs(delx), Math.abs(dely)), Math.abs(delz)) > ERRTOL
    sqrtx = Math.sqrt(xt)
    sqrty = Math.sqrt(yt)
    sqrtz = Math.sqrt(zt)
    alamb = sqrtx * (sqrty + sqrtz) + sqrty * sqrtz
    sum = sum + fac / (sqrtz * (zt + alamb))
    fac = 0.25 * fac
    xt = 0.25 * (xt + alamb)
    yt = 0.25 * (yt + alamb)
    zt = 0.25 * (zt + alamb)
    ave = 0.2 * (xt + yt + 3.0 * zt)
    delx = (ave - xt) / ave
    dely = (ave - yt) / ave
    delz = (ave - zt) / ave
  ea = delx * dely
  eb = delz * delz
  ec = ea - eb
  ed = ea - 6.0 * eb
  ee = ed + ec + ec
  result = 3.0 * sum + fac * (1.0 + ed * (-C1 + C5 * ed - C6 * delz * ee) + delz * (C2 * ee + delz * (-C3 * ec + delz * C4 * ea))) / (ave * Math.sqrt(ave))
  result

#
# * Computes Carlson?s elliptic integral of the third kind
# 
RJ = (x, y, z, p) ->
  ERRTOL = 0.05
  TINY = 2.5e-13
  BIG = 9.0e11
  C1 = (3.0 / 14.0)
  C2 = (1.0 / 3.0)
  C3 = (3.0 / 22.0)
  C4 = (3.0 / 26.0)
  C5 = (0.75 * C3)
  C6 = (1.5 * C4)
  C7 = (0.5 * C2)
  C8 = (C3 + C3)
  
  #disp('invalid arguments in RJ()')
  return  if Math.min(Math.min(x, y), z) < 0.0 or Math.min(Math.min(x + y, x + z), Math.min(y + z, Math.abs(p))) < TINY or Math.max(Math.max(x, y), Math.max(z, Math.abs(p))) > BIG
  sum = 0.0
  fac = 1.0
  if p > 0.0
    xt = x
    yt = y
    zt = z
    pt = p
  else
    xt = Math.min(Math.min(x, y), z)
    zt = Math.max(Math.max(x, y), z)
    yt = x + y + z - xt - zt
    a = 1.0 / (yt - p)
    b = a * (zt - yt) * (yt - xt)
    pt = yt + b
    rho = xt * zt / yt
    tau = p * pt / yt
    rcx = RC(rho, tau)
  sqrtx = Math.sqrt(xt)
  sqrty = Math.sqrt(yt)
  sqrtz = Math.sqrt(zt)
  alamb = sqrtx * (sqrty + sqrtz) + sqrty * sqrtz
  alpha = Math.pow((pt * (sqrtx + sqrty + sqrtz) + sqrtx * sqrty * sqrtz), 2)
  beta = pt * Math.pow((pt + alamb), 2)
  sum = sum + fac * RC(alpha, beta)
  fac = 0.25 * fac
  xt = 0.25 * (xt + alamb)
  yt = 0.25 * (yt + alamb)
  zt = 0.25 * (zt + alamb)
  pt = 0.25 * (pt + alamb)
  ave = 0.2 * (xt + yt + zt + pt + pt)
  delx = (ave - xt) / ave
  dely = (ave - yt) / ave
  delz = (ave - zt) / ave
  delp = (ave - pt) / ave
  while Math.max(Math.max(Math.abs(delx), Math.abs(dely)), Math.max(Math.abs(delz), Math.abs(delp))) > ERRTOL
    sqrtx = Math.sqrt(xt)
    sqrty = Math.sqrt(yt)
    sqrtz = Math.sqrt(zt)
    alamb = sqrtx * (sqrty + sqrtz) + sqrty * sqrtz
    alpha = Math.pow((pt * (sqrtx + sqrty + sqrtz) + sqrtx * sqrty * sqrtz), 2)
    beta = pt * Math.pow((pt + alamb), 2)
    sum = sum + fac * RC(alpha, beta)
    fac = 0.25 * fac
    xt = 0.25 * (xt + alamb)
    yt = 0.25 * (yt + alamb)
    zt = 0.25 * (zt + alamb)
    pt = 0.25 * (pt + alamb)
    ave = 0.2 * (xt + yt + zt + pt + pt)
    delx = (ave - xt) / ave
    dely = (ave - yt) / ave
    delz = (ave - zt) / ave
    delp = (ave - pt) / ave
  ea = delx * (dely + delz) + dely * delz
  eb = delx * dely * delz
  ec = delp * delp
  ed = ea - 3.0 * ec
  ee = eb + 2.0 * delp * (ea - ec)
  result = 3.0 * sum + fac * (1.0 + ed * (-C1 + C5 * ed - C6 * ee) + eb * (C7 + delp * (-C8 + delp * C4)) + delp * ea * (C2 - delp * C3) - C2 * delp * ec) / (ave * Math.sqrt(ave))
  result = a * (b * result + 3.0 * (rcx - RF(xt, yt, zt)))  if p <= 0.0
  result

#
# * Computes Carlson?s degenerate elliptic integral
# 
RC = (x, y) ->
  ERRTOL = 0.04
  TINY = 1.69e-38
  SQRTNY = 1.3e-19
  BIG = 3.e37
  TNBG = (TINY * BIG)
  COMP1 = (2.236 / SQRTNY)
  COMP2 = (TNBG * TNBG / 25.0)
  THIRD = (1.0 / 3.0)
  C1 = 0.3
  C2 = (1.0 / 7.0)
  C3 = 0.375
  C4 = (9.0 / 22.0)
  
  #disp('invalid arguments in RC()')
  return  if x < 0.0 or y is 0.0 or (x + Math.abs(y)) < TINY or (x + Math.abs(y)) > BIG or (y < -COMP1 and x > 0.0 and x < COMP2)
  if y > 0.0
    xt = x
    yt = y
    w = 1.0
  else
    xt = x - y
    yt = -y
    w = Math.sqrt(x) / Math.sqrt(xt)
  alamb = 2.0 * Math.sqrt(xt) * Math.sqrt(yt) + yt
  xt = 0.25 * (xt + alamb)
  yt = 0.25 * (yt + alamb)
  ave = THIRD * (xt + yt + yt)
  s = (yt - ave) / ave
  while Math.abs(s) > ERRTOL
    alamb = 2.0 * Math.sqrt(xt) * Math.sqrt(yt) + yt
    xt = 0.25 * (xt + alamb)
    yt = 0.25 * (yt + alamb)
    ave = THIRD * (xt + yt + yt)
    s = (yt - ave) / ave
  result = w * (1.0 + s * s * (C1 + s * (C2 + s * (C3 + s * C4)))) / Math.sqrt(ave)
  return