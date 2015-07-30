React = require("react")
SubscribedPrivate = require("../../subscribed_private")
API = require("../../api")

GameActions = require("../actions/game_actions")
PlayActions = require("../actions/play_actions")
AbilityActions = require("../actions/ability_actions")
AttackActions = require("../actions/attack_actions")
DefendActions = require("../actions/defend_actions")

module.exports = CardActions = SubscribedPrivate.createClass
  propTypes:
    card: React.PropTypes.number
    duel: React.PropTypes.number
    player: React.PropTypes.number

  load: ->
    API.getActions(this.props.duel, this.props.player)

  publicChannel: ->
    "actions/#{this.props.player}"

  # we filter here instead of in the API
  filter: (result) ->
    card = this.props.card

    output = {
      play: []
      ability: []
      game: []
      attack: []
      defend: []
    }

    if result.play?
      result.play.forEach (e, i) ->
        output.play.push e if e.card_id == card
    if result.ability?
      result.ability.forEach (e, i) ->
        output.ability.push e if e.card_id == card
    if result.defend?
      result.defend.forEach (e, i) ->
        output.defend.push e if e.card_id == card

    output

  renderLoaded: ->
    `<div className="actions">
      <GameActions {...this.state} duel={this.props.duel} player={this.props.player} />
      <PlayActions {...this.state} duel={this.props.duel} player={this.props.player} />
      <AbilityActions {...this.state} duel={this.props.duel} player={this.props.player} />
      <AttackActions {...this.state} duel={this.props.duel} player={this.props.player} />
      <DefendActions {...this.state} duel={this.props.duel} player={this.props.player} />
    </div>`
