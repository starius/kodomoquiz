import Widget from require "lapis.html"

quizs = require('quiz.groups')
kr = require('quiz.kr')

model = require('model')
msk_time = require "msk_time"

Helpers = require('views.helpers')

class AllTests extends Widget
  @include Helpers

  content: =>
    div class: "body", ->
      if @prep
        a href: @url_for("prep-quizs"), ->
          text @_("finished quizes")
        text ' | '
        a href: @url_for("prep-quizs-today"), ->
          text @_("today quizes")
        text ' | '
        a href: @url_for("quiz-state"), ->
          text @_("enable/disable quiz")
        for i, name in ipairs kr
          text ' | '
          a href: @url_for("prep-kr", {name: name}), ->
            text @_("kr") .. i
      p @_("Start new quiz:")
      for _, group in ipairs(quizs)
        group_name = group[1]
        group_quizs = group[2]
        element 'table', -> tr ->
          td ->
            text group_name
          for _, quiz in ipairs(group_quizs)
            quiz_name = quiz[1]
            if model.Quiz.can_create(quiz_name) or @prep
              td ->
                @new_test_button quiz_name
      my_quizs = (t, state) ->
        qq = model.my_quizs(@, state)
        if #qq > 0
          p t
        element 'ul', ->
          for quiz in *qq
            element 'li', ->
              time = msk_time(quiz.created_at)
              raw quiz\anchor(@) .. ', ' .. time
              if quiz.state == model.FINISHED
                r = quiz.right_answers
                a = quiz.tasks
                text " | "
                b style: 'color: ' .. quiz\color!, ->
                  text "#{r} / #{a}"
      my_quizs @_("Your active quizes:"), model.ACTIVE
      my_quizs @_("Your finished quizes:"), model.FINISHED

