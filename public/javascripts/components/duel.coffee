React = require("react")
Subscribed = require("../subscribed")
API = require("../api")
Turn = require("./duel/turn")

module.exports = Subscribed.createClass
  propTypes:
    duel: React.PropTypes.string

  load: ->
    API.getDuel(this.props.duel)

  channel: ->
    "duel/#{this.props.duel}"

  renderLoaded: ->
    `<div className="duel">
      <Turn {...this.state} />
    </div>`
