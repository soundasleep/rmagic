React = require("react")
Subscribed = require("../../subscribed")
API = require("../../api")

Card = require("./card")

module.exports = Battlefield = Subscribed.createClass
  propTypes:
    duel: React.PropTypes.string

  load: ->
    API.getPlayerBattlefield(this.props.duel, this.props.player)

  channel: ->
    "battlefield/#{this.props.player}"

  renderLoaded: ->
    battlefield = this.state.battlefield.map (e) ->
      `<Card key={e.id} {...e} />`

    `<div className="battlefield">
      <h3>Battlefield ({this.state.battlefield.length} cards)</h3>

      <ul>
        {battlefield}
      </ul>
    </div>`
