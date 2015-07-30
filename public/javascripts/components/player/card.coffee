$ = require('jquery')
React = require("react")

CardActions = require("./card_actions")

module.exports = Card = React.createClass
  propTypes:
    zone: React.PropTypes.string
    duel: React.PropTypes.number
    player: React.PropTypes.number

  capitalize: (s) ->
    s.charAt(0).toUpperCase() + s.slice(1)

  formatTagsInline: (tags) ->
    @capitalize(tags.filter(@relevantTag).join(", "))

  formatTagsLines: (tags) ->
    tags.filter(@relevantTag).map (e, i) =>
      me = @
      `<div key={i}>{me.capitalize(e)}</div>`

  relevantTag: (tag, i) ->
    tag == "flying" || tag == "reach"

  render: ->
    parent_classes = "card-parent"
    if this.props.is_tapped
      parent_classes += " is-tapped"

    enchantments = ""
    if this.props.visible
      if this.props.card.enchantments.length > 0
        parent_classes += " has-enchantments"

      enchantments = this.props.card.enchantments.map (e, i) =>
        me = @
        `<Card key={i} zone={me.props.zone} duel={me.props.duel} player={me.props.player} card={e} />`

    if this.props.visible
      card_link = "/cards/#{this.props.card.card_type.metaverse_id}"
      power = ""
      if this.props.card.card_type.is_creature
        power = `<span className="power">{this.props.card.power}/{this.props.card.toughness}</span>`

      classes = "card card-#{this.props.zone} card-#{this.props.card.id} #{this.props.zone}-#{this.props.id} metaverse-#{this.props.card.card_type.metaverse_id}"
      if this.props.is_tapped
        classes += " is-tapped"
      if this.props.card.card_type.is_creature
        classes += " is-creature"

      hover_html = `<div className={classes}>
            <div className="card-power-hover">
              {power}
            </div>
            <div className="card-text-and-actions">
              <div className="card-text">
                <a href={card_link}>{this.props.card.card_type.name} {this.props.card.card_type.mana_cost}</a> <small>{this.props.card.id}</small>
                <div className="card-tags">
                  {this.formatTagsLines(this.props.card.tags)}
                </div>
                <div className="card-actions">
                  <CardActions duel={this.props.duel} player={this.props.player} card={this.props.card.id} />
                </div>
              </div>
            </div>
          </div>`

      card_html = `<div className={classes}>
        <div className="card-hover">
          {hover_html}
        </div>

        <div className="card-text">
          <div className="card-title">
            <a href={card_link}>{this.props.card.card_type.name}</a>
          </div>

          <div className="card-tags">
            {this.formatTagsInline(this.props.card.tags)}
          </div>
        </div>

        <div className="card-power">
          {power}
        </div>
      </div>`

    else
      card_html = `<div className="hidden-card">hidden</div>`

    `<li className={parent_classes} key={this.props.id}>
      <ul className="enchantments">
        {enchantments}
      </ul>

      {card_html}
    </li>`
