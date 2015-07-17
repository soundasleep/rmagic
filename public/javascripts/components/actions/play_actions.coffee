$ = require('jquery')
React = require("react")
FormSubmitter = require("../../form-submitter")

module.exports = PlayActions = React.createClass
  render: ->
    actions = this.props.play.map (e, i) =>
      # TODO call a .json url and return just 'ok'
      url = "/duel/#{this.props.duel}/player/#{this.props.player}/hand/#{e.source_id}/play"

      click = (e) ->
        FormSubmitter.submitFromClick e

      `<li key={i}>
        <form action={url} method="post">
          <input type="hidden" name="key" value={e.key} />
          <input type="hidden" name="target_type" value={e.target_type} />
          <input type="hidden" name="target" value={e.target_id} />
          <input type="button" value={e.description} onClick={click} />
        </form>
      </li>`

    `<ul className="play-actions">
      {actions}
    </ul>`
