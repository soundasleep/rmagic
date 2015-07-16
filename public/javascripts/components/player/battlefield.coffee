$ = require('jquery')
React = require("react")
Card = require("./card")

module.exports = React.createClass
  render: ->
    battlefield = this.props.battlefield.map (e) ->
      `<Card {...e} />`

    `<div className="battlefield">
      <h3>Battlefield ({this.props.battlefield.length} cards)</h3>

      <ul>
        {battlefield}
      </ul>
    </div>`
