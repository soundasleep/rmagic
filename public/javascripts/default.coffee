jquery = require('jquery')

jquery(document).ready ->
  alert "loaded"

window.dispatcher = new WebSocketRails('localhost:3000/websocket')
success = (x) ->
  alert "yeah: #{x.message}"
failure = (x) ->
  alert "oh no"

dispatcher.trigger('connect', { object: true }, success, failure)
