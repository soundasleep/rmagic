$ = require('jquery')
React = require("react")
FormSubmitter = require("../../form-submitter")

module.exports = GameActions = React.createClass
  render: ->
    actions = this.props.game.map (e, i) =>
      # TODO call a .json url and return just 'ok'
      url = "/duel/#{this.props.duel}/player/#{this.props.player}/game_action"

      click = (e) ->
        FormSubmitter.submitFromClick e

      `<li key={i}>
        <form action={url} method="post">
          <input type="hidden" name="key" value={e.key} />
          <input type="button" value={e.description} onClick={click} />
        </form>
      </li>`

    `<ul className="game-actions">
      {actions}
    </ul>`
