$ = require("jquery")

socket = require("./dispatcher")

$(document).ready ->
  alert "loaded"

success = (x) ->
  console.log "yeah: #{x.message}"
failure = (x) ->
  console.log "oh no"

socket.trigger("connect", { object: true }, success, failure)

React = require("react")
App = require('./components/app')

$(document).ready ->
  if $("#app").length
    React.render(React.createElement(App), $("#app")[0])
