import Widget from require "lapis.html"

quizs = require('quiz.all')
model = require('model')
msk_time = require "msk_time"

class AllTests extends Widget
  content: =>
    div class: "body", ->
      if @prep
        a href: @url_for("prep-quizs"), ->
          text @_("Finished quizes")
        text ' '
        a href: @url_for("prep-quizs-today"), ->
          text @_("(today)")
      p @_("Start new quiz:")
      for name, _ in pairs quizs
        form method: "POST", action: @url_for("new-quiz"), ->
          input {type: "hidden", name: "csrf_token",
              value: @new_csrf}
          input {type: "hidden", name: "name", value: name}
          input type: "submit", value: name
      my_quizs = (text, state) ->
        qq = model.my_quizs(@, state)
        if #qq > 0
          p text
        element 'ul', ->
          for quiz in *qq
            element 'li', ->
              time = msk_time(quiz.created_at)
              raw quiz\anchor(@) .. ', ' .. time
              if quiz.state == model.FINISHED
                r = quiz.right_answers
                a = quiz.tasks
                b " | #{r} / #{a}"
      my_quizs @_("Your active quizes:"), model.ACTIVE
      my_quizs @_("Your finished quizes:"), model.FINISHED

