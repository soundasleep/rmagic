$ = require("jquery")
React = require("react")

Subscribed = require("./subscribed")

window.subscribedChannels = {}

module.exports = SubscribedPrivate =
  createClass: (extra = {}) ->
    Subscribed.createClass $.extend extra,
      propTypes:
        player: React.PropTypes.number

      getChannelName: ->
        if @currentPlayer() == this.props.player
          "#{@channel()}/private/#{this.props.player}"
        else
          @channel()

      currentPlayer: ->
        parseInt($("#app")[0].dataset["player"], 10)
