$ = require("jquery")
socket = require("./dispatcher")

success = (x) ->
  console.log "yeah: #{x.message}"
failure = (x) ->
  console.log "oh no"

socket.trigger("connect", { object: true }, success, failure)

React = require("react")
App = require('./components/app')

initialize_react = ->
  if $("#app").length
    e = $("#app")[0]

    React.render(React.createElement(App, e.dataset), e)

$(document).ready initialize_react
$(document).on "page:load", initialize_react

