import Widget from require "lapis.html"

quizs = require('quiz.all')
model = require('model')

class AllTests extends Widget
  content: =>
    h1 class: "header", @_("Kodomo Quiz")
    div class: "body", ->
      p @_("Start new quiz:")
      for name, _ in pairs quizs
        form method: "POST", action: @url_for("new-quiz"), ->
          input {type: "hidden", name: "csrf_token",
              value: @new_csrf}
          input {type: "hidden", name: "name", value: name}
          input type: "submit", value: name
      my_quizs = (text, state) ->
        p text
        element 'ul', ->
          for quiz in *(model.my_quizs(@, state))
            element 'li', ->
              raw quiz\anchor(@)
      my_quizs @_("Your active quizes:"), model.ACTIVE
      my_quizs @_("Your finished quizes:"), model.FINISHED

