class Helpers
  ans_form: (task, i) =>
    url = @url_for("answer", {id: task.id})
    form method: "POST", action: url, ->
      input {type: "hidden", name: "csrf_token",
          value: @new_csrf}
      input type: "hidden", name: "task", value: task.id
      input type: "hidden", name: "ans", value: i
      input type: "submit", value: @_('Select')

  task_form: (task) =>
    element "table", border: 1, ->
      element "tr", ->
        element "td", colspan: 4, ->
          b task.name
          raw ' '
          pre task.text
      element "tr", ->
        for i = 1, 4
          bgcolor = 'white'
          if task\ans_i(i) == task.selected
            bgcolor = 'yellow'
          element "td", bgcolor: bgcolor, ->
            pre task\ans(i)
            @ans_form task, i

