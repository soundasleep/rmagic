React = require("react")
SubscribedPrivate = require("../../subscribed_private")
API = require("../../api")

module.exports = Graveyard = SubscribedPrivate.createClass
  propTypes:
    duel: React.PropTypes.number
    player: React.PropTypes.number

  load: ->
    API.getPlayerGraveyard(this.props.duel, this.props.player)

  publicChannel: ->
    "graveyard/#{this.props.player}"

  renderLoaded: ->
    `<div className="graveyard">
      <h3>Graveyard</h3>
      <h4>({this.state.graveyard.length} cards)</h4>
    </div>`
