$ = require("jquery")

React = require("react")
App = require('./components/app')

initialize_react = () ->
  if $("#app").length
    e = $("#app")[0]

    parsed = {
      player: parseInt(e.dataset["player"], 10)
      duel: parseInt(e.dataset["duel"], 10)
    }

    React.render(React.createElement(App, parsed), e)

$(document).ready initialize_react
$(document).on "page:load", initialize_react

pending = 0

updateAjax = ->
  if pending > 0
    $(".ajax-pending").show()
  else
    $(".ajax-pending").hide()

$(document).ajaxStart () ->
  pending += 1
  updateAjax()

$(document).ajaxStop () ->
  pending -= 1
  updateAjax()

$(document).ready updateAjax
$(document).on "page:load", updateAjax
