import Widget from require "lapis.html"

model = require('model')
msk_time = require "msk_time"
all = require('quiz.all')

class PrepQuizsName extends Widget
  content: =>
    q = all[@quiz_name]
    if not q
      error(@_("No such quiz found"))
    quizs = model.quizs_of_name(@quiz_name, model.FINISHED)
    h1 @_[[All quizes]] .. ' ' .. @quiz_name
    print_header = ->
      element 'tr', ->
        element 'td' -- id
        element 'td', -> text @_("user")
        element 'td', -> text @_("right answers")
        element 'td', -> text @_("tasks")
        for task_name, func in pairs(q) do
          element 'td', -> text task_name
    element 'table', border: 1, ->
      print_header!
      name2score = {}
      for quiz in *quizs
        color = 'red'
        if quiz.right_answers == quiz.tasks
          color = 'green'
        element 'tr', ->
          element 'td', ->
            a href: @url_for("prep-quiz", {id: quiz.id}), ->
              text '#'
          element 'td', ->
            url = @url_for("prep-quizs-of", {user: quiz.user})
            a href: url, ->
              text quiz.user
          element 'td', bgcolor: color, ->
            text quiz.right_answers
          element 'td', bgcolor: color, ->
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

