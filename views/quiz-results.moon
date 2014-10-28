import Widget from require "lapis.html"

Helpers = require('views.helpers')

class QuizResults extends Widget
  @include Helpers

  content: =>
    h1 class: "header", @_("Kodomo Quiz")
    h2 @_("Quiz ") .. @quiz.name
    for task in *(@quiz\all_tasks!)
      @task_table task
      raw '<br/>'

