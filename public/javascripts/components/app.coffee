React = require("react")
Header = require("./header")
Footer = require("./footer")
TurnInformation = require("./turn-information")

module.exports = React.createClass
  render: ->
    return `(
      <div className="root">
        <Header />
        <TurnInformation />
        <Footer />
      </div>
    )`
