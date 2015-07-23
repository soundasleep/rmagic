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

  playerClassNames: (id) ->
    result = ["board"]
    if this.state.current_player.id == id
      result.push "current-player"
    if this.state.first_player.id == id
      result.push "first-player"
    if this.state.priority_player.id == id
      result.push "priority-player"
    result.join(" ")

  renderLoaded: ->
    player1classes = @playerClassNames(this.state.player1_id) + " my-board"
    player2classes = @playerClassNames(this.state.player2_id)

    `<div className="duel">
      <div className="duel-boards">
        <div className={player2classes}>
          <Player duel={this.state.id} player={this.state.player2_id} />
        </div>
        <div className="turn">
          <Turn {...this.state} />
          <Actions duel={this.state.id} player={this.props.player} />
        </div>
        <div className={player1classes}>
          <Player duel={this.state.id} player={this.state.player1_id} />
        </div>
      </div>
      <div className="logs">
        <ActionLog duel={this.state.id} />
      </div>
    </div>`
