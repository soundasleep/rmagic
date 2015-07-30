$ = require("jquery")
React = require("react")
SubscribedPrivate = require("../../subscribed_private")
API = require("../../api")

Card = require("./card")

module.exports = Hand = SubscribedPrivate.createClass
  propTypes:
    duel: React.PropTypes.number
    player: React.PropTypes.number

  load: ->
    API.getPlayerHand(this.props.duel, this.props.player)

  channel: ->
    if @currentPlayer() == this.props.player
      "hand/#{this.props.player}/private/#{this.props.player}"
    else
      "hand/#{this.props.player}"

  renderLoaded: ->
    hand = this.state.hand.map (e) =>
      me = @
      `<Card zone="hand" key={e.id} duel={me.props.duel} player={me.props.player} {...e} />`

    `<div className="hand">
      <h3>Hand ({this.state.hand.length} cards)</h3>

      <ul>
        {hand}
      </ul>
    </div>`
