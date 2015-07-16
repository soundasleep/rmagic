$ = require("jquery")

module.exports =
  getDuel: (duel) ->
    # TODO cache?
    new Promise (resolve, reject) ->
      $.getJSON("/duel/#{duel}.json")
        .success(resolve).fail(reject)

  getPlayer: (duel, player) ->
    # TODO cache?
    new Promise (resolve, reject) ->
      $.getJSON("/duel/#{duel}/player/#{player}.json")
        .success(resolve).fail(reject)
