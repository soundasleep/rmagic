React = require("react")
Subscribed = require("../../subscribed")
API = require("../../api")

module.exports = Deck = Subscribed.createClass
  propTypes:
    duel: React.PropTypes.number
    player: React.PropTypes.number

  load: ->
    API.getPlayerDeck(this.props.duel, this.props.player)

  channel: ->
    "deck/#{this.props.player}"

  renderLoaded: ->
    `<div className="deck">
      <h3>Deck</h3>
      <h4>({this.state.deck.length} cards)</h4>
    </div>`
