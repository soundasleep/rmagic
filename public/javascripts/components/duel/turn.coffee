React = require("react")

module.exports = Turn = React.createClass
  render: ->
    `<div className="turn">
      Turn {this.props.turn} ({this.props.phase}):
      Current player {this.props.current_player_number},
      Priority player {this.props.priority_player_number}
    </div>`
