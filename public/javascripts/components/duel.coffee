React = require("react")
Subscribed = require("../subscribed")
API = require("../api")
Turn = require("./duel/turn")
Player = require("./player")
Actions = require("./actions")

module.exports = Duel = Subscribed.createClass
  propTypes:
    duel: React.PropTypes.string

  load: ->
    API.getDuel(this.props.duel)

  channel: ->
    "duel/#{this.props.duel}"

  renderLoaded: ->
    `<div className="duel">
      <Turn {...this.state} />
      <Actions duel={this.state.id} player={this.props.player} />
      <Player duel={this.state.id} player={this.state.player1_id} />
      <Player duel={this.state.id} player={this.state.player2_id} />
    </div>`