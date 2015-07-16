React = require("react")
Loading = require("./components/loading")
$ = require("jquery")
dispatcher = require("../dispatcher")

module.exports =
  createClass: (extra = {}) ->
    React.createClass $.extend extra,
      propTypes:
        isLoading: React.PropTypes.bool

      subscribeToPromise: (obj, channel) ->
        this.load().then (result) ->
          obj.setState result

          # and then subscribe to the channel
          channel = dispatcher.subscribe(channel)
          channel.bind 'update', (result) ->
            # console.log "we got pushed ", result
            obj.setState result

      getInitialState: ->
        # state = getTurn(this, this.props.duel)
        state = this.subscribeToPromise(this, this.channel())

        if state
          state.isLoading = false
          state
        else
          isLoading: true

      render: ->
        if this.state.isLoading
          `<Loading />`
        else
          this.renderLoaded()
