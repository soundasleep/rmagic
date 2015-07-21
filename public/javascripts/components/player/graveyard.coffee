React = require("react")
Subscribed = require("../../subscribed")
API = require("../../api")

module.exports = Graveyard = Subscribed.createClass
  propTypes:
    duel: React.PropTypes.string

  load: ->
    API.getPlayerGraveyard(this.props.duel, this.props.player)

  channel: ->
    "graveyard/#{this.props.player}"

  renderLoaded: ->
    `<div className="graveyard">
      <h3>Graveyard ({this.state.graveyard.length} cards)</h3>
    </div>`
