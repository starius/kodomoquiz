model = require('model')
quizs = require('quiz.all')

bgcolor = (task, i) ->
  form = task\quiz().state == model.ACTIVE
  bc = 'white'
  if not form and task\ans_i(i) == 1
    bc = 'green'
  if task\ans_i(i) == task.selected
    bc = 'yellow'
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
      input {type: "submit", value: @_('Cancel quiz'),
        style: 'background-color: pink'}

  help_for: (task) =>
    quiz_name = task\quiz().name
    func = quizs[quiz_name][task.name]
    r, a1, a2, a3, a4, help = func(@)
    return help

  task_table: (task) =>
    form = task\quiz().state == model.ACTIVE
    element "table", border: 1, ->
      element "tr", ->
        element "td", colspan: 4, style: "padding:10px", ->
          if task\quiz().state == model.FINISHED
            b task.name
          p @help_for(task)
          pre task.text
      element "tr", ->
        for i = 1, 4
          element "td", {width: 100, style: "padding:10px",
              bgcolor: bgcolor(task, i)}, ->
            pre task\ans(i)
            if form
              @ans_form task, i

  tasks_number_switcher: (quiz) =>
    element 'table', -> element 'tr', ->
      element 'td', ->
        url = @url_for('all-tasks', {id: quiz.id})
        form method: 'POST', action: url, ->
          input {type: "hidden", name: "csrf_token",
              value: @new_csrf}
          input {type: 'submit',
            value: @_[[All tasks at one page]]}
      element 'td', ->
        url = @url_for('one-task', {id: quiz.id})
        form method: 'POST', action: url, ->
          input {type: "hidden", name: "csrf_token",
              value: @new_csrf}
          input {type: 'submit',
            value: @_[[One task at one page]]}

  new_test_button: (name) =>
    url = @url_for("new-quiz")
    form method: "POST", action: url, ->
      input {type: "hidden", name: "csrf_token",
          value: @new_csrf}
      input {type: "hidden", name: "name", value: name}
      input type: "submit", value: name

  finish_quiz_button: =>
    font color: 'red', @_([[Quiz is not finished untill
      you press the button]])
    url = @url_for("finish", {id: @quiz.id})
    form method: "POST", action: url, ->
      input {type: "hidden", name: "csrf_token",
          value: @new_csrf}
      input type: "submit", value: @_('Finish this quiz')

