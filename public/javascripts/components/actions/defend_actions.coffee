$ = require('jquery')
React = require("react")
FormSubmitter = require("../../form-submitter")

module.exports = DefendActions = React.createClass
  render: ->
    actions = this.props.defend.map (e, i) =>
      url = "/duel/#{this.props.duel}/player/#{this.props.player}/battlefield/#{e.source_id}/defend.json"
      class_name = "action defend-action action-for-battlefield-#{e.card_id} action-#{e.key}"

      click = (e) ->
        FormSubmitter.submitFromClick e

      `<li key={i} className={class_name}>
        <form action={url} method="post">
          <input type="hidden" name="target" value={e.target_id} />
          <input type="button" value={e.description} onClick={click} />
        </form>
      </li>`

    `<ul className="defend-actions">
      {actions}
    </ul>`
