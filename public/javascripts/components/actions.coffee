React = require("react")
SubscribedPrivate = require("../subscribed_private")
API = require("../api")

GameActions = require("./actions/game_actions")
AttackActions = require("./actions/attack_actions")

module.exports = Actions = SubscribedPrivate.createClass
  propTypes:
    duel: React.PropTypes.number
    player: React.PropTypes.number

  load: ->
    API.getActions(this.props.duel, this.props.player)

  publicChannel: ->
    "actions/#{this.props.player}"

  renderLoaded: ->
    `<div className="actions">
      <GameActions {...this.state} duel={this.props.duel} player={this.props.player} />
      <AttackActions {...this.state} duel={this.props.duel} player={this.props.player} />
    </div>`
