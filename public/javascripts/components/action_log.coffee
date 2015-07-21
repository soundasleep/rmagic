$ = require('jquery')
React = require("react")
Subscribed = require("../subscribed")
API = require("../api")

module.exports = ActionLog = Subscribed.createClass
  propTypes:
    duel: React.PropTypes.string

  load: ->
    API.getActionLog(this.props.duel)

  channel: ->
    "action_logs/#{this.props.duel}"

  renderLoaded: ->
    duel = this.props.duel
    logs = this.state.logs.map (e) =>
      player_name = ""
      if e.player? and e.player.name?
        player_name = e.player.name
      `<li key={e.id}>[{duel}.{e.id}] {player_name} {e.action_text}</li>`

    `<div className="action-log">
      <h3>Action log</h3>

      <ul>
        {logs}
      </ul>
    </div>`
