$ = require("jquery")
React = require("react")
Subscribed = require("../../subscribed")
API = require("../../api")

Hand = require("../player/hand")

FormSubmitter = require("../../form-submitter")

module.exports = Mulligan = Subscribed.createClass
  propTypes:
    duel: React.PropTypes.number
    player: React.PropTypes.number

  load: ->
    API.getDuel(this.props.duel)

  channel: ->
    "duel/#{this.props.duel}"

  gameActionButton: (key, value) ->
    url = "/duel/#{this.props.duel}/player/#{this.props.player}/game_action.json"

    click = (e) ->
      FormSubmitter.submitFromClick e

    `<form action={url} method="post">
      <input type="hidden" name="key" value={key} />
      <input type="button" value={value} onClick={click} />
    </form>`

  renderLoaded: ->
    if this.props.phase == "mulligan_phase"
      yesButton = @gameActionButton "pass", "Yes"
      noButton = @gameActionButton "mulligan", "No"

      `<div className="interface mulligan">
        <h2>Do you want to keep this hand?</h2>

        <Hand {...this.props} />

        <p>You may use the <i>mulligan rule</i> to draw a new hand, with one less card.</p>

        {yesButton} {noButton}
      </div>`
    else
      `<div className="interface not-displayed" />`

