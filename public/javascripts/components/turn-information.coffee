React = require("react")
Loading = require("./loading")
API = require("../api")

getTurn = (obj, duel) ->
  API.getTurn(duel).then (result) ->
    obj.setState result

module.exports = React.createClass
  propTypes:
    isLoading: React.PropTypes.bool
    turn: React.PropTypes.number
    phase: React.PropTypes.string

  getInitialState: ->
    state = getTurn(this, 9)
    if state
      state.isLoading = false
      state
    else
      isLoading: true

  render: ->
    if this.state.isLoading
      return `<Loading />`

    `<div className="turnInformation">Turn {this.state.turn} ({this.state.phase}) information will go here</div>`

