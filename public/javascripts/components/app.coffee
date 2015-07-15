React = require("react")
Header = require("./header")
Footer = require("./footer")

module.exports = React.createClass
  render: ->
    return `(
      <div className="root">
        <Header />
        <Footer />
      </div>
    )`
