React = require("react")
Header = require("./header")
Footer = require("./footer")
Duel = require("./duel")

module.exports = App = React.createClass
  propTypes:
    duel: React.PropTypes.string
    player: React.PropTypes.string

  render: ->
    return `(
      <div className="root">
        <Header />
        <Duel duel={this.props.duel} player={this.props.player} />
        <Footer />
      </div>
    )`
