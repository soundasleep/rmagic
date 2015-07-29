React = require("react")
Subscribed = require("../../subscribed")
API = require("../../api")

Card = require("../player/card")

module.exports = Stack = Subscribed.createClass
  propTypes:
    duel: React.PropTypes.number

  load: ->
    API.getStack(this.props.duel)

  channel: ->
    "stack/#{this.props.duel}"

  renderLoaded: ->
    stack = this.state.stack.map (e) =>
      me = @
      `<Card zone="stack" {...e} key={e.order} duel={me.props.duel} player={e.player.id} />`

    `<div className="stack-list">
      <h3>Stack ({this.state.stack.length} cards)</h3>

      <ul>
        {stack}
      </ul>
    </div>`
