$ = require('jquery')
React = require("react")
Card = require("./card")

module.exports = Graveyard = React.createClass
  render: ->
    `<div className="graveyard">
      <h3>Graveyard ({this.props.graveyard.length} cards)</h3>
    </div>`
