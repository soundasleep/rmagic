React = require("react")
SubscribedPrivate = require("../../subscribed_private")
API = require("../../api")

$ = require("jquery")

FormSubmitter = require("../../form-submitter")

module.exports = GameActions = SubscribedPrivate.createClass
  propTypes:
    duel: React.PropTypes.number
    player: React.PropTypes.number

  load: ->
    API.getActions(this.props.duel, this.props.player)

  publicChannel: ->
    "actions/#{this.props.player}"

  pingButton: ->
    url = "/duel/#{this.props.duel}/player/#{this.props.player}/ping.json"

    click = (e) ->
      $(".websocket-status").removeClass("loaded")
      window.hasPinged = true
      FormSubmitter.submitFromClick e

    `<li key="ping">
      <form action={url} method="post">
        <input type="button" value="Ping" onClick={click} id="ping-button" />
      </form>
    </li>`

  clickPingButton: ->
    $("#ping-button").click()

  renderLoaded: ->
    pingButton = @pingButton()

    if typeof window.hasPinged == "undefined"
      window.setTimeout @clickPingButton, 1 * 1000

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
      {pingButton}
    </ul>`
