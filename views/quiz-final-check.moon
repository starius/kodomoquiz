import Widget from require "lapis.html"

Helpers = require('views.helpers')

class QuizFinalCheck extends Widget
  @include Helpers

  content: =>
    h1 class: "header", @_("Kodomo Quiz")
    h2 @_("Quiz ") .. @quiz.name
    url = @url_for("finish", {id: @quiz.id})
    font color: 'red', @_([[Quiz is not finished untill
      you press the button]])
    form method: "POST", action: url, ->
      input {type: "hidden", name: "csrf_token",
          value: @new_csrf}
      input type: "submit", value: @_('Finish this quiz')
    raw '<br/>'
    for task in *(@quiz\all_tasks!)
      @task_table task
      raw '<br/>'

