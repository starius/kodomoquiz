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
        element "td", colspan: 2, style: "padding:10px", ->
          if task\quiz().state == model.FINISHED
            b task.name
          p @help_for(task)
          pre task.text
      for i = 0, 1
        element "tr", ->
          for j = 0, 1
            k = i * 2 + j + 1
            element "td", {width: 100, style: "padding:10px",
                bgcolor: bgcolor(task, k)}, ->
              pre task\ans(k)
              if form
                @ans_form task, k

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

  submission_form: =>
    url = @url_for("new-submission")
    form {method: "POST", action: url,
        enctype: "multipart/form-data"}, ->
      input {type: "hidden", name: "csrf_token",
          value: @new_csrf}
      input type: "file", name: "uploaded_file"
      input type: "submit"

  print_submissions: (submissions) =>
    h1 @_[[Submissions]]
    element 'table', border: 1, ->
      element 'tr', ->
        element 'td' -- #
        element 'td', -> text @_("student")
        element 'td', -> text @_("file")
        element 'td', -> text @_("result")
        element 'td', -> text @_("date")
      for s in *submissions
        element 'tr', ->
          element 'td', ->
            a href: @url_for("prep-submission", {id: s.id}), ->
              text '#'
          element 'td', ->
            text s.user
          element 'td', ->
            text s.filename
          element 'td', ->
            text s.rating
          element 'td', ->
            text msk_time(s.created_at)

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
            score = ''
            if task
              color = task\color!
              score = task\score!
              if task.selected == 1
                if not name2score[task_name]
                  name2score[task_name] = 0
                name2score[task_name] = name2score[task_name] + 1
            element 'td', bgcolor: color, ->
              text score
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

