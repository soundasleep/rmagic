React = require("react")
Subscribed = require("../../subscribed")
API = require("../../api")

module.exports = Deck = Subscribed.createClass
  propTypes:
    duel: React.PropTypes.string

  load: ->
    API.getPlayerDeck(this.props.duel, this.props.player)

  channel: ->
    "deck/#{this.props.player}"

  renderLoaded: ->
    `<div className="deck">
      <h3>Deck ({this.state.deck.length} cards)</h3>
    </div>`
