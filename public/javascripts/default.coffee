$ = require("jquery")
socket = require("./dispatcher")

success = (x) ->
  console.log "yeah: #{x.message}"
failure = (x) ->
  console.log "oh no"

socket.trigger("connect", { object: true }, success, failure)

React = require("react")
App = require('./components/app')

$(document).ready ->
  if $("#app").length
    e = $("#app")[0]

    React.render(React.createElement(App, e.dataset), e)
