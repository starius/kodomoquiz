import Widget from require "lapis.html"

Helpers = require('views.helpers')

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
    for task in *(@quiz\all_tasks!)
      @task_table task
      raw '<br/>'

