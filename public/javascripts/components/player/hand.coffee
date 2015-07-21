React = require("react")
Subscribed = require("../../subscribed")
API = require("../../api")

Card = require("./card")

module.exports = Hand = Subscribed.createClass
  propTypes:
    duel: React.PropTypes.string

  load: ->
    API.getPlayerHand(this.props.duel, this.props.player)

  channel: ->
    "hand/#{this.props.player}"

  renderLoaded: ->
    hand = this.state.hand.map (e) ->
      `<Card key={e.id} {...e} />`

    `<div className="hand">
      <h3>Hand ({this.state.hand.length} cards)</h3>

      <ul>
        {hand}
      </ul>
    </div>`
