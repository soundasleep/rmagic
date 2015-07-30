React = require("react")
Subscribed = require("../../subscribed")
API = require("../../api")

Card = require("./card")

module.exports = Battlefield = Subscribed.createClass
  propTypes:
    duel: React.PropTypes.number
    player: React.PropTypes.number

  load: ->
    API.getPlayerBattlefield(this.props.duel, this.props.player)

  channel: ->
    "battlefield/#{this.props.player}"

  renderLoaded: ->
    battlefield = this.state.battlefield.map (e) =>
      me = @

      if !(e.visible && e.card.card_type.is_enchantment)
        `<Card zone="battlefield" key={e.id} duel={me.props.duel} player={me.props.player} {...e} />`

    `<div className="battlefield">
      <h3>Battlefield ({this.state.battlefield.length} cards)</h3>

      <ul>
        {battlefield}
      </ul>
    </div>`
