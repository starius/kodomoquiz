import Widget from require "lapis.html"

model = require('model')
msk_time = require "msk_time"

class PrepSubmissions extends Widget
  content: =>
    h1 @_[[All submissions]]
    submissions = model.Submission\select('order by id')
    @print_submissions(submissions)
