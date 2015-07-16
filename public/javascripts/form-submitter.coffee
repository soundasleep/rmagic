$ = require("jquery")

module.exports = FormSubmitter =
  submitFromClick: (e) ->
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

    e.stopPropagation()
    e.preventDefault()

