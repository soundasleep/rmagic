$ = require("jquery")
React = require("react")

Subscribed = require("./subscribed")

window.subscribedChannels = {}

module.exports = SubscribedPrivate =
  createClass: (extra = {}) ->
    Subscribed.createClass $.extend extra,
      propTypes:
        player: React.PropTypes.number

      channel: ->
        if @currentPlayer() == this.props.player
          "#{@publicChannel()}/private/#{this.props.player}"
        else
          @publicChannel()

      currentPlayer: ->
        parseInt($("#app")[0].dataset["player"], 10)
