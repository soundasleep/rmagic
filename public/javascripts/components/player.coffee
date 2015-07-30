React = require("react")
Subscribed = require("../subscribed")
API = require("../api")

Deck = require("./player/deck")
Graveyard = require("./player/graveyard")
Hand = require("./player/hand")
Battlefield = require("./player/battlefield")

module.exports = Player = Subscribed.createClass
  propTypes:
    duel: React.PropTypes.number
    player: React.PropTypes.number

  load: ->
    API.getPlayer(this.props.duel, this.props.player)

  channel: ->
    "player/#{this.props.player}"

  renderLoaded: ->
    playerClasses = "player player-#{this.props.player}"

    `<div className={playerClasses}>
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
