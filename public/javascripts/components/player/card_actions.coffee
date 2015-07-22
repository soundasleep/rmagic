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
    card: React.PropTypes.string
    duel: React.PropTypes.string
    player: React.PropTypes.string

  load: ->
    API.getCardActions(this.props.duel, this.props.player, this.props.card)

  channel: ->
    "card_actions/#{this.props.card}"

  renderLoaded: ->
    `<div className="actions">
      <GameActions {...this.state} duel={this.props.duel} player={this.props.player} />
      <PlayActions {...this.state} duel={this.props.duel} player={this.props.player} />
      <AbilityActions {...this.state} duel={this.props.duel} player={this.props.player} />
      <AttackActions {...this.state} duel={this.props.duel} player={this.props.player} />
      <DefendActions {...this.state} duel={this.props.duel} player={this.props.player} />
    </div>`
