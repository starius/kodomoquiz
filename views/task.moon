import Widget from require "lapis.html"

Helpers = require('views.helpers')

class Task extends Widget
  @include Helpers

  content: =>
    h2 @_("Quiz ") .. @quiz.name
    a href: @url_for("quiz", {id: @quiz.id}), ->
      text @_("Set aside this task")
    @tasks_number_switcher @quiz
    @finish_quiz_button!
    @task_table @task
    @cancel_form!

