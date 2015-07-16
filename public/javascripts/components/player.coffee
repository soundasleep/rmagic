React = require("react")
Subscribed = require("../subscribed")
API = require("../api")

module.exports = Subscribed.createClass
  propTypes:
    duel: React.PropTypes.string
    player: React.PropTypes.string

  load: ->
    API.getPlayer(this.props.duel, this.props.player)

  channel: ->
    "player/#{this.props.player}"

  renderLoaded: ->
    `<div className="player">
      Player {this.state.id} {this.state.name}: {this.state.life} life, {this.state.mana_string}
    </div>`
