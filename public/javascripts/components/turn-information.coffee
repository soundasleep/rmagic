React = require("react")
Loading = require("./loading")
API = require("../api")

getTurn = (obj, duel) ->
  API.getTurn(duel).then (result) ->
    obj.setState result

module.exports = React.createClass
  propTypes:
    duel: React.PropTypes.string
    isLoading: React.PropTypes.bool

  getInitialState: ->
    state = getTurn(this, this.props.duel)
    if state
      state.isLoading = false
      state
    else
      isLoading: true

  render: ->
    if this.state.isLoading
      return `<Loading />`

    `<div className="turnInformation">
      Turn {this.state.turn} ({this.state.phase}):
      Current player {this.state.current_player_number},
      Priority player {this.state.priority_player_number}
    </div>`

