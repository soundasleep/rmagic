$ = require('jquery')
React = require("react")

module.exports = Card = React.createClass
  render: ->
    card_link = "/cards/#{this.props.card.card_type.metaverse_id}"
    power = ""
    if this.props.card.card_type.is_creature
      power = `<span className="power">({this.props.card.power} / {this.props.card.toughness})</span>`

    classes = "card metaverse-#{this.props.card.card_type.metaverse_id}"
    if this.props.card.is_tapped
      classes += " is-tapped"

    `<li className={classes} key={this.props.id}>
      <div className="card-hover">
        <div className={classes}>
          <div className="card-text">
            <a href={card_link}>{this.props.card.card_type.name} {this.props.card.card_type.mana_cost}</a>
            {power}
            <small>{this.props.card.id}</small>
          </div>
        </div>
      </div>

      <div className="card-text">
        <div className="card-title">
          <a href={card_link}>{this.props.card.card_type.name}</a>
        </div>
        <div className="card-power">
          {power}
        </div>
      </div>
    </li>`
