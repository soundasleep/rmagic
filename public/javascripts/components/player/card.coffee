$ = require('jquery')
React = require("react")

module.exports = Card = React.createClass
  render: ->
    card_link = "/cards/#{this.props.card.card_type.metaverse_id}"
    power = ""
    if this.props.card.card_type.is_creature
      power = `<span className="power">({this.props.card.power} / {this.props.card.toughness})</span>`

    `<li className="card" key={this.props.id}>
      <a href={card_link}>{this.props.card.card_type.name} {this.props.card.card_type.mana_cost}</a>
      {power}
      <small>{this.props.card.id}</small>
    </li>`
