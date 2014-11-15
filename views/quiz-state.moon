import Widget from require "lapis.html"

model = require('model')
quizs = require('quiz.all')

class QuizStates extends Widget
  content: =>
    form method: "POST", action: @url_for("set-quiz-state"), ->
      input {type: "hidden", name: "csrf_token",
          value: @new_csrf}
      for name, _ in pairs(quizs) do
        state = model.QuizState\find(name)
        value = state.enabled and 'on' or nil
        element 'label', ->
          input type: "checkbox", name: name, checked: value
          text name
        raw '<br/>'
      input type: "submit", value: @_('Update')

