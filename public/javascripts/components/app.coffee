React = require("react")
Header = require("./header")
Footer = require("./footer")
TurnInformation = require("./turn-information")

module.exports = React.createClass
  propTypes:
    duel: React.PropTypes.string

  render: ->
    return `(
      <div className="root">
        <Header />
        <TurnInformation duel={this.props.duel} />
        <Footer />
      </div>
    )`
