import Widget from require "lapis.html"

Helpers = require('views.helpers')

class QuizFinalCheck extends Widget
  @include Helpers

  content: =>
    h2 @_("Quiz ") .. @quiz.name
    @tasks_number_switcher @quiz
    @finish_quiz_button!
    for task in *(@quiz\all_tasks!)
      a name: task.name, id: task.name
      @task_table task
      raw '<br/>'
    @finish_quiz_button!
    @cancel_form!
