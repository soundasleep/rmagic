jquery = require('jquery')

socket = require('./dispatcher')

jquery(document).ready ->
  alert "loaded"

success = (x) ->
  alert "yeah: #{x.message}"
failure = (x) ->
  alert "oh no"

socket.trigger('connect', { object: true }, success, failure)
