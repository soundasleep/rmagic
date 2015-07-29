React = require("react")

module.exports = Turn = React.createClass
  turnClassNames: (id) ->
    classes = [id]
    classes.push "current-phase" if this.props.phase == id
    classes.join(" ")

  phaseName: (id) ->
    switch id
      when "mulligan_phase" then "Mulligans"
      when "drawing_phase" then "Draw"
      when "playing_phase" then "Main"
      when "attacking_phase" then "Combat"
      when "cleanup_phase" then "Cleanup"
      when "finished_phase" then "End"
      else "(unknown phase)"

  render: ->
    classNames = "turn turn-#{this.props.phase}"

    phases = ["mulligan_phase", "drawing_phase", "playing_phase", "attacking_phase", "cleanup_phase", "finished_phase"]
    phaseList = phases.map (phase) =>
      phaseName = @phaseName(phase)
      classes = @turnClassNames(phase)

      `<li key={phase} className={classes}>{phaseName}</li>`

    `<div className={classNames}>
      <div className="turn-info">
        Turn {this.props.turn}
      </div>

      <ul className="turn-list">
        {phaseList}
      </ul>
    </div>`
