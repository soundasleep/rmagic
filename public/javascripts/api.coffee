$ = require("jquery")

module.exports =
  getTurn: (duel) ->
    # TODO cache?
    new Promise (resolve, reject) ->
      $.getJSON("/duel/#{duel}.json")
        .success(resolve).fail(reject)
