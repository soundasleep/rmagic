React = require("react")
SubscribedPrivate = require("../../subscribed_private")
API = require("../../api")

module.exports = Deck = SubscribedPrivate.createClass
  propTypes:
    duel: React.PropTypes.number
    player: React.PropTypes.number

  load: ->
    API.getPlayerDeck(this.props.duel, this.props.player)

  publicChannel: ->
    "deck/#{this.props.player}"

  renderLoaded: ->
    `<div className="deck">
      <h3>Deck</h3>
      <h4>({this.state.deck.length} cards)</h4>
    </div>`
