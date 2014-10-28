model = require('model')

bgcolor = (task, i) ->
  form = task\quiz().state == model.ACTIVE
  bc = 'white'
  if task\ans_i(i) == task.selected
    bc = 'yellow'
  if not form and task\ans_i(i) == task.selected
    bc = 'red'
  if not form and task\ans_i(i) == 1
    bc = 'green'
  return bc

class Helpers
  ans_form: (task, i) =>
    url = @url_for("answer", {id: task.id})
    form method: "POST", action: url, ->
      input {type: "hidden", name: "csrf_token",
          value: @new_csrf}
      input type: "hidden", name: "task", value: task.id
      input type: "hidden", name: "ans", value: i
      input type: "submit", value: @_('Select')

  cancel_form: =>
    url = @url_for("cancel", {id: @quiz.id})
    raw '<br/><br/>'
    element 'hr'
    raw '<br/><br/>'
    font color: 'red', @_("Dangerous zone")
    form method: "POST", action: url, ->
      input {type: "hidden", name: "csrf_token",
          value: @new_csrf}
      input {type: "submit", value: @_('Cancell quiz'),
        style: 'background-color: pink'}

  task_table: (task) =>
    form = task\quiz().state == model.ACTIVE
    element "table", border: 1, ->
      element "tr", ->
        element "td", colspan: 4, ->
          b task.name
          raw ' '
          pre task.text
      element "tr", ->
        for i = 1, 4
          element "td", {width: 100,
              bgcolor: bgcolor(task, i)}, ->
            pre task\ans(i)
            if form
              @ans_form task, i

