$ = require('jquery')
React = require("react")
FormSubmitter = require("../../form-submitter")

module.exports = AbilityActions = React.createClass
  propTypes:
    duel: React.PropTypes.number
    player: React.PropTypes.number

  render: ->
    actions = this.props.ability.map (e, i) =>
      url = "/duel/#{this.props.duel}/player/#{this.props.player}/battlefield/#{e.source_id}/ability.json"
      class_name = "action ability-action action-for-battlefield-#{e.card_id} action-#{e.key}"

      click = (e) ->
        FormSubmitter.submitFromClick e

      resetHighlight = ->
        $(".card").removeClass("highlighted-source")
        $(".card").removeClass("highlighted-target")

      mouseOver = (event) ->
        resetHighlight()
        $(".card.card-battlefield.battlefield-#{e.source_id}").addClass("highlighted-source")
        $(".card.card-#{e.target_type}.#{e.target_type}-#{e.target_id}").addClass("highlighted-target")

      mouseOut = (event) ->
        resetHighlight()

      `<li key={i} className={class_name}>
        <form action={url} method="post">
          <input type="hidden" name="key" value={e.key} />
          <input type="hidden" name="target_type" value={e.target_type} />
          <input type="hidden" name="target" value={e.target_id} />
          <input type="button" value={e.description}
              onClick={click} onMouseOver={mouseOver} onMouseOut={mouseOut} />
        </form>
      </li>`

    `<ul className="ability-actions">
      {actions}
    </ul>`
