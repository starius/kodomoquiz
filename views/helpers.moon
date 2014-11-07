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
    element 'hr'
    element 'table', -> element 'tr', ->
      element 'td', ->
        url = @url_for("cancel", {id: @quiz.id})
        form method: "POST", action: url, ->
          input {type: "hidden", name: "csrf_token",
              value: @new_csrf}
          input {type: "submit", value: @_('Cancel quiz'),
            style: 'background-color: pink'}
      element 'td', ->
        font color: 'red', @_("Dangerous zone")

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
    element 'table', -> element 'tr', ->
      element 'td', ->
        url = @url_for("finish", {id: @quiz.id})
        form method: "POST", action: url, ->
          input {type: "hidden", name: "csrf_token",
              value: @new_csrf}
          input type: "submit", value: @_('Finish this quiz')
      element 'td', ->
        font color: 'red', @_([[Quiz is not finished untill
          you press the button]])

  detailed_results: (q, quizs) =>
    h1 @quiz_name
    print_header = ->
      element 'tr', ->
        element 'td' -- id
        element 'td', -> text @_("user")
        element 'td', -> text @_("right answers")
        element 'td', -> text @_("tasks")
        for task_name, func in pairs(q) do
          element 'td', ->
            div class: 'vertical-text', ->
              div class: 'vertical-text__inner', task_name
    element 'table', border: 1, ->
      print_header!
      name2score = {}
      for quiz in *quizs
        element 'tr', ->
          element 'td', ->
            a href: @url_for("prep-quiz", {id: quiz.id}), ->
              text '#'
          element 'td', ->
            url = @url_for("prep-quizs-of", {user: quiz.user})
            a href: url, ->
              text quiz.user
          element 'td', bgcolor: quiz\color!, ->
            text quiz.right_answers
          element 'td', ->
            text quiz.tasks
          tasks = quiz\all_tasks!
          name2task = {}
          for task in *tasks
            name2task[task.name] = task
          for task_name, func in pairs(q) do
            task = name2task[task_name]
            color = 'white'
            t = ''
            if task and task.selected == 1
              color = 'green'
              t = '1'
              if not name2score[task_name]
                name2score[task_name] = 0
              name2score[task_name] = name2score[task_name] + 1
            if task and task.selected > 1
              color = 'red'
              t = '0'
            element 'td', bgcolor: color, ->
              text t
      element 'tr', ->
        element 'td' -- id
        element 'td' --, -> text @_("user")
        element 'td' --, -> text @_("right answers")
        element 'td' --, -> text @_("tasks")
        for task_name, func in pairs(q) do
          element 'td', ->
            if name2score[task_name]
              text name2score[task_name]
            else
              text 0
      print_header!

