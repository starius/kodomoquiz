import Widget from require "lapis.html"

Helpers = require('views.helpers')

class QuizResults extends Widget
  @include Helpers

  content: =>
    h2 @_("Quiz ") .. @quiz.name
    h2 @_("Student ") .. @quiz.user
    for task in *(@quiz\all_tasks!)
      @task_table task
      raw '<br/>'

