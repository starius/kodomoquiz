import Widget from require "lapis.html"

Helpers = require('views.helpers')

quizs = require('quiz.all')
model = require('model')
msk_time = require "msk_time"
ago = require "ago"

class Submission extends Widget
  @include Helpers

  content: =>
    h2 @_("Submission ") .. @submission.id
    h2 @_("Student ") .. @submission.user
    h2 @_("Result ") .. @submission.rating
    -- hide push if he has finishe just now
    if ago(@submission.created_at) > 5
      url = @url_for("push-submission", {id: @submission.id})
      @push_form url
    h2 @_("Date ") .. msk_time(@submission.created_at)
    h2 @_("File ") .. @submission.filename
    pre @submission.text
    h2 @_("Log ")
    pre @submission.log
