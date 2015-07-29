$ = require("jquery")

get = (url) ->
  new Promise (resolve, reject) ->
    $.getJSON(url).success(resolve).fail(reject)

check = (s) ->
  if typeof s != "string" && typeof s != "number"
    console.error "Parameter is not a string or number:", s
    throw new Error("Parameter '#{s}' is not a valid type")

module.exports = API =
  getDuel: (duel) ->
    check duel
    get "/duel/#{duel}.json"

  getStack: (duel) ->
    check duel
    get "/duel/#{duel}/stack.json"

  getActionLog: (duel) ->
    check duel
    get "/duel/#{duel}/action_log.json"

  getPlayer: (duel, player) ->
    check duel
    check player
    get "/duel/#{duel}/player/#{player}.json"

  getPlayerDeck: (duel, player) ->
    check duel
    check player
    get "/duel/#{duel}/player/#{player}/deck.json"

  getPlayerBattlefield: (duel, player) ->
    check duel
    check player
    get "/duel/#{duel}/player/#{player}/battlefield.json"

  getPlayerHand: (duel, player) ->
    check duel
    check player
    get "/duel/#{duel}/player/#{player}/hand.json"

  getPlayerGraveyard: (duel, player) ->
    check duel
    check player
    get "/duel/#{duel}/player/#{player}/graveyard.json"

  getActions: (duel, player) ->
    check duel
    check player
    get "/duel/#{duel}/player/#{player}/actions.json"
