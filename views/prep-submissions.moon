import Widget from require "lapis.html"

model = require('model')
msk_time = require "msk_time"

Helpers = require('views.helpers')

class PrepSubmissions extends Widget
  @include Helpers

  content: =>
    h1 @_[[All submissions]]
    submissions = model.Submission\select('order by id')
    @print_submissions(submissions)
