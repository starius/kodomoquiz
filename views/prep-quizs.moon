import Widget from require "lapis.html"

model = require('model')
msk_time = require "msk_time"

class PrepQuizs extends Widget
  content: =>
    local quizs
    if @today_only
      quizs = model.today_quizs(model.FINISHED)
      h1 @_[[Today quizes]]
    elseif @target_user
      quizs = model.quizs_of(@target_user, model.FINISHED)
      h1 @_[[All quizes of ]] .. @target_user
    else
      quizs = model.all_quizs(model.FINISHED)
      h1 @_[[All quizes]]
    element 'table', border: 1, ->
      element 'tr', ->
        element 'td' -- #
        element 'td', -> text @_("quiz")
        element 'td', -> text @_("user")
        element 'td', -> text @_("started")
        element 'td', -> text @_("finished")
        element 'td', -> text @_("right answers")
        element 'td', -> text @_("tasks")
      for quiz in *quizs
        element 'tr', ->
          element 'td', ->
            a href: @url_for("prep-quiz", {id: quiz.id}), ->
              text '#'
          element 'td', ->
            a href: @url_for("prep-quizs-name", {name: quiz.name}), ->
              text quiz.name
          element 'td', ->
            url = @url_for("prep-quizs-of", {user: quiz.user})
            a href: url, ->
              text quiz.user
          element 'td', -> text msk_time(quiz.created_at)
          element 'td', -> text msk_time(quiz.updated_at)
          element 'td', bgcolor: quiz\color!, ->
            text quiz.right_answers
          element 'td', ->
            text quiz.tasks

