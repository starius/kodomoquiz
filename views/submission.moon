import Widget from require "lapis.html"

Helpers = require('views.helpers')

quizs = require('quiz.all')
model = require('model')
msk_time = require "msk_time"

class Submission extends Widget
  @include Helpers

  content: =>
    h2 @_("Submission ") .. @submission.id
    h2 @_("Student ") .. @submission.user
    h2 @_("Result ") .. @submission.rating
    url = @url_for("push-submission", {id: @submission.id})
    form method: "POST", action: url, ->
      input {type: "hidden", name: "csrf_token",
          value: @new_csrf}
      input type: "submit", value: @_('Push to Google Docs')
    h2 @_("Date ") .. msk_time(@submission.created_at)
    h2 @_("File ") .. @submission.filename
    pre @submission.text
    h2 @_("Log ")
    pre @submission.log
