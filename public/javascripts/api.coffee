$ = require("jquery")

get = (url) ->
  new Promise (resolve, reject) ->
    $.getJSON(url).success(resolve).fail(reject)

cachedActions = {}

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

  getCardActions: (duel, player, card) ->
    # TODO cache instead
    @getActions(duel, player).then (result) ->
      output = {
        play: []
        ability: []
        game: []
        attack: []
        defend: []
      }

      result.play.forEach (e, i) ->
        output.play.push e if e.card_id == card
      result.ability.forEach (e, i) ->
        output.ability.push e if e.card_id == card
      result.defend.forEach (e, i) ->
        output.defend.push e if e.card_id == card

      output
