React = require("react")
Subscribed = require("../subscribed")
API = require("../api")

Turn = require("./duel/turn")
Player = require("./player")
Actions = require("./actions")
ActionLog = require("./action_log")

module.exports = Duel = Subscribed.createClass
  propTypes:
    duel: React.PropTypes.string

  load: ->
    API.getDuel(this.props.duel)

  channel: ->
    "duel/#{this.props.duel}"

  renderLoaded: ->
    `<div className="duel">
      <div className="boards">
        <div className="board">
          <Player duel={this.state.id} player={this.state.player2_id} />
        </div>
        <div className="turn">
          <Turn {...this.state} />
        </div>
        <div className="board my-board">
          <Player duel={this.state.id} player={this.state.player1_id} />
          <Actions duel={this.state.id} player={this.props.player} />
        </div>
      </div>
      <div className="logs">
        <ActionLog duel={this.state.id} />
      </div>
    </div>`
