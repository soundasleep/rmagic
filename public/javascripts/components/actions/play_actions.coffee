$ = require('jquery')
React = require("react")

module.exports = PlayActions = React.createClass
  render: ->
    actions = this.props.play.map (e, i) =>
      # TODO call a .json url and return just 'ok'
      url = "/duel/#{this.props.duel}/player/#{this.props.player}/hand/#{e.source_id}/play"

      click = (e) ->
        form = $(e.target).parent("form")
        form_url = form.attr("action")
        values = $(form.find("input"))
        postData = {}
        values.each (i, e) ->
          postData[e.name] = e.value if e.name

        $.ajax
          type: 'POST'
          url: form_url
          data: postData
          beforeSend: (xhr) ->
            xhr.setRequestHeader 'X-CSRF-Token', $('meta[name="csrf-token"]').attr('content')
          error: (xhr, text, error) ->
            console.log error

      `<li key={i}>
        <form action={url} method="post">
          <input type="hidden" name="key" value={e.key} />
          <input type="hidden" name="target_type" value={e.target_type} />
          <input type="hidden" name="target" value={e.target_id} />
          <input type="submit" value={e.description} />
          <div onClick={click}>click me!</div>
        </form>
      </li>`

    `<ul className="play-actions">
      {this.props.play.length} actions: {actions}
    </ul>`
