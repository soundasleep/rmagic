$ = require("jquery")

module.exports = API =
  getDuel: (duel) ->
    new Promise (resolve, reject) ->
      $.getJSON("/duel/#{duel}.json")
        .success(resolve).fail(reject)

  getActionLog: (duel) ->
    new Promise (resolve, reject) ->
      $.getJSON("/duel/#{duel}/action_log.json")
        .success(resolve).fail(reject)

  getPlayer: (duel, player) ->
    new Promise (resolve, reject) ->
      $.getJSON("/duel/#{duel}/player/#{player}.json")
        .success(resolve).fail(reject)

  getPlayerDeck: (duel, player) ->
    new Promise (resolve, reject) ->
      $.getJSON("/duel/#{duel}/player/#{player}/deck.json")
        .success(resolve).fail(reject)

  getPlayerBattlefield: (duel, player) ->
    new Promise (resolve, reject) ->
      $.getJSON("/duel/#{duel}/player/#{player}/battlefield.json")
        .success(resolve).fail(reject)

  getPlayerHand: (duel, player) ->
    new Promise (resolve, reject) ->
      $.getJSON("/duel/#{duel}/player/#{player}/hand.json")
        .success(resolve).fail(reject)

  getPlayerGraveyard: (duel, player) ->
    new Promise (resolve, reject) ->
      $.getJSON("/duel/#{duel}/player/#{player}/graveyard.json")
        .success(resolve).fail(reject)

  getActions: (duel, player) ->
    new Promise (resolve, reject) ->
      $.getJSON("/duel/#{duel}/player/#{player}/actions.json")
        .success(resolve).fail(reject)
