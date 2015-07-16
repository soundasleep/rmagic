API = require("../api")
Subscribed = require("../subscribed")

module.exports = Subscribed.createClass
  propTypes:
    duel: React.PropTypes.string

  load: ->
    API.getTurn(this.props.duel)

  channel: ->
    "duel/#{this.props.duel}"

  renderLoaded: ->
    `<div className="turnInformation">
      Turn {this.state.turn} ({this.state.phase}):
      Current player {this.state.current_player_number},
      Priority player {this.state.priority_player_number}
    </div>`
