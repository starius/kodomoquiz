import Widget from require "lapis.html"

Helpers = require('views.helpers')

quizs = require('quiz.all')
model = require('model')

class QuizResults extends Widget
  @include Helpers

  content: =>
    h2 @_("Quiz ") .. @quiz.name
    h2 @_("Student ") .. @quiz.user
    if @prep
      url = @url_for("prep-quizs-of", {user: @quiz.user})
      a href: url, ->
        text @_("Other quizes by ") .. @quiz.user
    h2 @quiz.right_answers .. ' / ' .. @quiz.tasks
    h2 @quiz.created_at .. ' - ' .. @quiz.updated_at
    if quizs[@quiz.name] and model.Quiz.can_create(@quiz.name)
      element 'table', ->
        element 'tr', ->
          element 'td', ->
            text @_('Go through this test again:')
          element 'td', ->
            @new_test_button @quiz.name
    raw '<br/>'
    for task in *(@quiz\all_tasks!)
      @task_table task
      raw '<br/>'

