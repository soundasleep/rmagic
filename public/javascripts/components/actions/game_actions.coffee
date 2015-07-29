$ = require('jquery')
React = require("react")
FormSubmitter = require("../../form-submitter")

module.exports = GameActions = React.createClass
  propTypes:
    duel: React.PropTypes.number
    player: React.PropTypes.number

  render: ->
    actions = this.props.game.map (e, i) =>
      url = "/duel/#{this.props.duel}/player/#{this.props.player}/game_action.json"

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
