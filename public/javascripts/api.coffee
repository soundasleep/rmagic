$ = require("jquery")

module.exports =
  getDuel: (duel) ->
    # TODO cache?
    new Promise (resolve, reject) ->
      $.getJSON("/duel/#{duel}.json")
        .success(resolve).fail(reject)
