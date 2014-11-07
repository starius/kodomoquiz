import Widget from require "lapis.html"

quizs = {'if_list_for_range', 'hello'}
model = require('model')
msk_time = require "msk_time"

Helpers = require('views.helpers')

class AllTests extends Widget
  @include Helpers

  content: =>
    div class: "body", ->
      if @prep
        a href: @url_for("prep-quizs"), ->
          text @_("Finished quizes")
        text ' '
        a href: @url_for("prep-quizs-today"), ->
          text @_("(today)")
        text ' '
        a href: @url_for("prep-kr", {name: 'hello'}), ->
          text @_("kr1")
        text ' '
        url = @url_for("prep-kr", {
          name: 'if_list_for_range_short'})
        a href: url, ->
          text @_("kr2")
      p @_("Start new quiz:")
      element 'table', -> element 'tr', ->
        for name in *quizs
          element 'td', ->
            @new_test_button name
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

