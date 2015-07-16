React = require("react")
Loading = require("./components/loading")
$ = require("jquery")
dispatcher = require("./dispatcher")

window.subscribedChannels = {}

module.exports = Subscribed =
  createClass: (extra = {}) ->
    React.createClass $.extend extra,
      propTypes:
        isLoaded: React.PropTypes.bool

      subscribeToPromise: (obj, channel) ->
        this.load().then (result) ->
          obj.setState result

          # and then subscribe to the channel
          c = dispatcher.subscribe(channel)
          c.bind 'update', (result) ->
            obj.setState result

          if typeof window.subscribedChannels[channel] == 'undefined'
            window.subscribedChannels[channel] = []

          window.subscribedChannels[channel].push c

      getInitialState: ->
        {
          isLoaded: false
        }

      componentDidMount: ->
        @subscribeToPromise(@, @channel()).then (result) =>
          @setState
            isLoaded: true

      render: ->
        # we need to wrap it with another div because React
        # (otherwise it seems React can't pick up we've had a change)
        content = "";
        if !this.state.isLoaded
          content = `<Loading />`
        else
          content = @renderLoaded()

        return `<div className="loadingWrapper">{content}</div>`
