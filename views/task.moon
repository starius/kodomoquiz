import Widget from require "lapis.html"

Helpers = require('views.helpers')

class Task extends Widget
  @include Helpers

  content: =>
    h2 @_("Quiz ") .. @quiz.name
    h3 @_("Task ") .. @task.name
    @task_table @task
    @cancel_form!

