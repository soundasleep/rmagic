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

    `<div className="attack-actions">
      <form action={url} method="post">
        Declare attackers:
        <ul>
          {this.props.attack.length} actions: {actions}
        </ul>
        <input type="submit" name="commit" value="Declare attackers and pass" onClick={click} />
      </form>
    </div>`
