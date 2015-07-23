BaseController = require 'zooniverse/controllers/base-controller'
$ = window.jQuery

SHEET_1 =  'https://spreadsheets.google.com/feeds/list/13FFu29q7aOVbVm8IIfNTzrhKDncXktSjjEzVBIacdww/1/public/values?alt=json'

SHEET_2 = 'https://spreadsheets.google.com/feeds/list/13FFu29q7aOVbVm8IIfNTzrhKDncXktSjjEzVBIacdww/2/public/values?alt=json'

class AckmowledgementsPage extends BaseController
  className: 'acknowledgements-page'
  template: require '../views/acknowledgements'

  elements:
    '#contributors-kic': 'contributorsKic'
    '#contributors-additional': 'contributorsAdditional'

  constructor: ->
    super

    $.getJSON SHEET_1, (data) =>
      for entry in data.feed.entry
        @contributorsKic.append require('../views/partials/acknowledgement-row')(entry)

    $.getJSON SHEET_2, (data) =>
      for entry in data.feed.entry
        @contributorsAdditional.append require('../views/partials/additional-row')(entry)

module.exports = AckmowledgementsPage
