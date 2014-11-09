import Widget from require "lapis.html"

model = require('model')
msk_time = require "msk_time"
all = require('quiz.all').all
kurs1 = require('kurs1')

Helpers = require('views.helpers')

class PrepKr extends Widget
  @include Helpers

  content: =>
    q = all[@quiz_name]
    if not q
      error(@_("No such quiz found"))
    quizs0 = model.kr(@quiz_name)
    name2quiz = {}
    for quiz in *quizs0
      if name2quiz[quiz.user] == nil
        name2quiz[quiz.user] = quiz
    quizs = {}
    for stud in *kurs1.excel_list
      quiz = name2quiz[stud]
      if not quiz
        quiz = {user: stud,
          all_tasks: ->
            {},
          color: ->
            'white'}
      table.insert(quizs, quiz)
    @detailed_results(q, quizs)

