import Widget from require "lapis.html"

model = require('model')
msk_time = require "msk_time"
all = require('quiz.all').all

Helpers = require('views.helpers')

class PrepQuizsName extends Widget
  @include Helpers

  content: =>
    q = all[@quiz_name]
    if not q
      error(@_("No such quiz found"))
    quizs = model.quizs_of_name(@quiz_name, model.FINISHED)
    h1 @_[[All quizes]] .. ' ' .. @quiz_name
    @detailed_results(q, quizs)

