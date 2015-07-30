$ = require("jquery")
React = require("react")
FormSubmitter = require("../../form-submitter")
Moment = require("moment")

module.exports = RequestPass = React.createClass
  propTypes:
    duel: React.PropTypes.number
    player: React.PropTypes.number

  lastAction: ->
    Moment.max(Moment(this.props.last_action), Moment(this.props.last_pass))

  enableForm: ->
    $(".request-pass form:not(.submitting) input").prop("disabled", false)
    $(".request-pass").removeClass("waiting")

  disableForm: ->
    $(".request-pass form:not(.submitting) input").prop("disabled", true)
    $(".request-pass").addClass("waiting")

  updateLastAction: ->
    seconds = Moment().diff(@lastAction(), "seconds")

    $(".request-pass .last-action").html(seconds)

    if seconds > 30
      @enableForm()
    else
      @disableForm()

  componentDidMount: ->
    @componentDidUpdate()

  componentDidUpdate: ->
    if @lastInterval
      clearInterval @lastInterval

    @lastInterval = setInterval @updateLastAction, 1 * 1000
    @updateLastAction()

  render: ->
    url = "/duel/#{this.props.duel}/player/#{this.props.player}/request_pass.json"

    click = (e) =>
      FormSubmitter.submitFromClick e

    `<div className="request-pass">
      <div className="last-action-text" title="Last action was">
        <span className="last-action">0</span> sec
      </div>
      <form action={url} method="post">
        <input type="button" value="Request pass" onClick={click} />
      </form>
    </div>`
