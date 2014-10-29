import Widget from require "lapis.html"

model = require('model')
msk_time = require "msk_time"

class PrepQuizs extends Widget
  content: =>
    local quizs
    if @today_only
      quizs = model.today_quizs(model.FINISHED)
    else
      quizs = model.all_quizs(model.FINISHED)
    element 'table', border: 1, ->
      element 'tr', ->
        element 'td', -> text @_("quiz")
        element 'td', -> text @_("user")
        element 'td', -> text @_("started")
        element 'td', -> text @_("finished")
        element 'td', -> text @_("right answers")
        element 'td', -> text @_("tasks")
      for quiz in *quizs
        color = 'red'
        if quiz.right_answers == quiz.tasks
          color = 'green'
        element 'tr', ->
          element 'td', ->
            a href: @url_for("prep-quiz", {id: quiz.id}), ->
              text quiz.name
          element 'td', -> text quiz.user
          element 'td', -> text msk_time(quiz.created_at)
          element 'td', -> text msk_time(quiz.updated_at)
          element 'td', bgcolor: color, ->
            text quiz.right_answers
          element 'td', bgcolor: color, ->
            text quiz.tasks

