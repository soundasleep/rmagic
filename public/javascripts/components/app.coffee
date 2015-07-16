React = require("react")
Header = require("./header")
Footer = require("./footer")
Duel = require("./duel")

module.exports = React.createClass
  propTypes:
    duel: React.PropTypes.string

  render: ->
    return `(
      <div className="root">
        <Header />
        <Duel duel={this.props.duel} />
        <Footer />
      </div>
    )`
