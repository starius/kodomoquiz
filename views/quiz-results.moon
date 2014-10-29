import Widget from require "lapis.html"

Helpers = require('views.helpers')

class QuizResults extends Widget
  @include Helpers

  content: =>
    h2 @_("Quiz ") .. @quiz.name
    h2 @_("Student ") .. @quiz.user
    h2 @quiz.right_answers .. ' / ' .. @quiz.tasks
    for task in *(@quiz\all_tasks!)
      @task_table task
      raw '<br/>'

