React = require("react")
Subscribed = require("../subscribed")
API = require("../api")

Deck = require("./player/deck")
Graveyard = require("./player/graveyard")
Hand = require("./player/hand")
Battlefield = require("./player/battlefield")

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

      <Deck {...this.state} />
      <Graveyard {...this.state} />
      <Hand {...this.state} />
      <Battlefield {...this.state} />
    </div>`
