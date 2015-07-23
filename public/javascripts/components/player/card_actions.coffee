React = require("react")
Subscribed = require("../../subscribed")
API = require("../../api")

GameActions = require("../actions/game_actions")
PlayActions = require("../actions/play_actions")
AbilityActions = require("../actions/ability_actions")
AttackActions = require("../actions/attack_actions")
DefendActions = require("../actions/defend_actions")

module.exports = CardActions = Subscribed.createClass
  propTypes:
    card: React.PropTypes.number
    duel: React.PropTypes.number
    player: React.PropTypes.number

  load: ->
    API.getActions(this.props.duel, this.props.player)

  channel: ->
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

    result.play.forEach (e, i) ->
      output.play.push e if e.card_id == card
    result.ability.forEach (e, i) ->
      output.ability.push e if e.card_id == card
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
