React = require("react")
Subscribed = require("../subscribed")
API = require("../api")

PlayActions = require("./actions/play_actions")
AbilityActions = require("./actions/ability_actions")
GameActions = require("./actions/game_actions")
AttackActions = require("./actions/attack_actions")

module.exports = Actions = Subscribed.createClass
  propTypes:
    duel: React.PropTypes.string
    player: React.PropTypes.string

  load: ->
    API.getActions(this.props.duel, this.props.player)

  channel: ->
    "actions/#{this.props.player}"

  renderLoaded: ->
    `<div className="actions">
      <h2>Actions</h2>

      <PlayActions {...this.state} duel={this.props.duel} player={this.props.player} />
      <AbilityActions {...this.state} duel={this.props.duel} player={this.props.player} />
      <GameActions {...this.state} duel={this.props.duel} player={this.props.player} />
      <AttackActions {...this.state} duel={this.props.duel} player={this.props.player} />
    </div>`
