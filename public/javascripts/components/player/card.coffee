$ = require('jquery')
React = require("react")

CardActions = require("./card_actions")

module.exports = Card = React.createClass
  propTypes:
    zone: React.PropTypes.string

  mouseOver: (e) ->
    # a simple way to get all the actions from a single source: just
    # use selectors to find them all, then copy them into our hover target
    parent = $(e.target).parents(".card-parent")
    target = parent.find(".card-actions")
    selector = ".my-actions .action.action-for-#{this.props.zone}-#{this.props.card.id}"

    actions = $("#app").find(selector)

    result = actions.map (i, e) ->
      value = $(e).find("input[type=button]").attr("value")

      click = (e) ->
        alert "whoa"

      # `<input type="button" value={value} onClick={click} />`
      button = $("<input type='button' value='#{value}' />")
      button.click (e) ->
        alert "whoa"

      console.log "created button ", button

      button
      # "hello"

    console.log result

    target.html result # result.get().join()
    # `<div className="loaded-actions">{result}</div>`

  render: ->
    card_link = "/cards/#{this.props.card.card_type.metaverse_id}"
    power = ""
    if this.props.card.card_type.is_creature
      power = `<span className="power">({this.props.card.power} / {this.props.card.toughness})</span>`

    classes = "card card-#{this.props.zone} #{this.props.zone}-#{this.props.card.id} metaverse-#{this.props.card.card_type.metaverse_id}"
    if this.props.card.is_tapped
      classes += " is-tapped"
    parent_classes = "card-parent #{classes}"

    # TODO remove
    onMouseOver = (e) =>
      @mouseOver e

    card_actions = (e) ->
      "hello world"

    `<li className={parent_classes} key={this.props.id}>
      <div className="card-hover">
        <div className={classes}>
          <div className="card-text">
            <a href={card_link}>{this.props.card.card_type.name} {this.props.card.card_type.mana_cost}</a>
            {power}
            <small>{this.props.card.id}</small>
            <div className="card-actions">
              <CardActions duel={this.props.duel} player={this.props.player} card={this.props.card.id} />
            </div>
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
