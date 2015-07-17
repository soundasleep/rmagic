$ = require('jquery')
React = require("react")
FormSubmitter = require("../../form-submitter")

module.exports = AttackActions = React.createClass
  render: ->
    # TODO call a .json url and return just 'ok'
    url = "/duel/#{this.props.duel}/player/#{this.props.player}/declare_attackers"

    click = (e) ->
      FormSubmitter.submitFromClick e

    actions = this.props.attack.map (e, i) =>
      `<li key={e.id}>
        <label>
          <input type="checkbox" name="attacker[]" value={e.id} />
          {e.card.card_type.name}
        </label>
      </li>`

    if this.props.attack.length
      `<div className="attack-actions">
        <form action={url} method="post">
          Declare attackers:
          <ul>
            {actions}
          </ul>
          <input type="button" name="commit" value="Declare attackers and pass" onClick={click} />
        </form>
      </div>`
    else
      `<div className="attack-actions">(no attackers)</div>`
