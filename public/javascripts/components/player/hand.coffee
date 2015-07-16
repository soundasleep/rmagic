$ = require('jquery')
React = require("react")
Card = require("./card")

module.exports = Hand = React.createClass
  render: ->
    hand = this.props.hand.map (e) ->
      `<Card key={e.id} {...e} />`

    `<div className="hand">
      <h3>Hand ({this.props.hand.length} cards)</h3>

      <ul>
        {hand}
      </ul>
    </div>`
