$ = require('jquery')
React = require("react")
Card = require("./card")

module.exports = Deck = React.createClass
  render: ->
    `<div className="deck">
      <h3>Deck ({this.props.deck.length} cards)</h3>
    </div>`
