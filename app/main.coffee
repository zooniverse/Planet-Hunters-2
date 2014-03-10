$ = window.jQuery
# jQuery.noConflict()  //REMEMBER ME!!!!!!

# language manager
t7e = require 't7e'
enUs = require './lib/en-us'
t7e.load enUs
LanguageManager = require 'zooniverse/lib/language-manager'
languageManager = new LanguageManager
  translations:
    en: label: 'English', strings: enUs
    # es: label: 'Español', strings: './dev-translations/es.json'
languageManager.on 'change-language', (e, code, strings) ->
  t7e.load strings
  t7e.refresh()

# api
Api = require 'zooniverse/lib/api'
api = new Api project: 'asteroid'

# site navigation
SiteNavigation = require './controllers/site-navigation'
siteNavigation = new SiteNavigation
siteNavigation.el.appendTo document.body

# router
StackOfPages = require 'stack-of-pages/src/stack-of-pages'
stack = new StackOfPages
  '#/': require './controllers/home-page'
  '#/about': require './controllers/about-page'
  '#/classify': require './controllers/classifier'
  '#/science': require './controllers/science-page'  
  '#/profile': require './controllers/profile'
  '#/education': require './controllers/education'
  '#/discuss': require './controllers/discuss'
  '#/blog': require './controllers/blog'

  NOT_FOUND: '<div class="content-block"><div class="content-container"><h1>Page not found!</h1></div></div>'
  ERROR: '<div class="content-block"><div class="content-container"><h1>There was an error!</h1></div></div>'
document.body.appendChild stack.el

# top bar
TopBar = require 'zooniverse/controllers/top-bar'
topBar = new TopBar
topBar.el.appendTo document.body

browserDialog = require 'zooniverse/controllers/browser-dialog'
browserDialog.check msie: 9

# get user
User = require 'zooniverse/models/user'
u = User.fetch()

# footer
footerContainer = document.createElement 'div'
footerContainer.className = 'footer-container'
Footer = require 'zooniverse/controllers/footer'
footer = new Footer
document.body.appendChild footerContainer
footer.el.appendTo footerContainer


# planet-time
# refreshTime = ->
#   setTimeout displayTime(), 100000

movePlanet = ->
  date = new Date
  # planet = document.getElementsByClassName "bg-planet"

  for planet of @el.find(".bg-planet")
    console.log  planet
  # planet.attr 'left' date.getSeconds()

  console.log planet

  console.log 'DATE/TIME: '
  console.log " date, hour: ", date.getHours()
  console.log " date, minute: ", date.getMinutes()
  console.log " date, second: ", date.getSeconds()
  # setTimeout( movePlanet, 1000 )

# movePlanet()

# bind app to window
window.app = {api, siteNavigation, stack, topBar}
module.exports = window.app