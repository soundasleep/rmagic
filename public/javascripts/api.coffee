$ = require("jquery")

get = (url) ->
  new Promise (resolve, reject) ->
    $.getJSON(url).success(resolve).fail(reject)

module.exports = API =
  getDuel: (duel) ->
    get "/duel/#{duel}.json"

  getActionLog: (duel) ->
    get "/duel/#{duel}/action_log.json"

  getPlayer: (duel, player) ->
    get "/duel/#{duel}/player/#{player}.json"

  getPlayerDeck: (duel, player) ->
    get "/duel/#{duel}/player/#{player}/deck.json"

  getPlayerBattlefield: (duel, player) ->
    get "/duel/#{duel}/player/#{player}/battlefield.json"

  getPlayerHand: (duel, player) ->
    get "/duel/#{duel}/player/#{player}/hand.json"

  getPlayerGraveyard: (duel, player) ->
    get "/duel/#{duel}/player/#{player}/graveyard.json"

  getActions: (duel, player) ->
    get "/duel/#{duel}/player/#{player}/actions.json"
