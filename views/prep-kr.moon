import Widget from require "lapis.html"

model = require('model')
msk_time = require "msk_time"
all = require('quiz.all')

Helpers = require('views.helpers')

class PrepKr extends Widget
  @include Helpers

  content: =>
    q = all[@quiz_name]
    if not q
      error(@_("No such quiz found"))
    quizs = model.kr(@quiz_name)
    @detailed_results(q, quizs)

