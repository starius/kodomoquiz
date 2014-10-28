import Widget from require "lapis.html"

quizs = require('quiz.all')

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
