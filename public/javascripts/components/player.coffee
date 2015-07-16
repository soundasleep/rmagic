React = require("react")
Subscribed = require("../subscribed")
API = require("../api")
Hand = require("./player/hand")

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
      <h2>
        Player {this.state.name}<sup>{this.state.id}</sup>: {this.state.life} life, {this.state.mana_string}
      </h2>

      <Hand {...this.state} />
    </div>`
