React = require("react")
Subscribed = require("../subscribed")
API = require("../api")

Deck = require("./player/deck")
Graveyard = require("./player/graveyard")
Hand = require("./player/hand")
Battlefield = require("./player/battlefield")

module.exports = Player = Subscribed.createClass
  propTypes:
    duel: React.PropTypes.string
    player: React.PropTypes.string

  load: ->
    API.getPlayer(this.props.duel, this.props.player)

  channel: ->
    "player/#{this.props.player}"

  renderLoaded: ->
    `<div className="player">
      <div className="info">
        <div className="player-box">
          <h2>
            {this.state.name}
          </h2>

          <h3 className="life">
            {this.state.life} life
          </h3>

          <h3 className="mana">
            {this.state.mana_string}
          </h3>
        </div>

        <Deck {...this.props} />
        <Graveyard {...this.props} />
      </div>

      <div className="battlefield">
        <Battlefield {...this.props} />
      </div>

      <div className="hand">
        <Hand {...this.props} />
      </div>
    </div>`
