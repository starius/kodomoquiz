import Widget from require "lapis.html"

class Welcome extends Widget
  content: =>
    h1 class: "header", _("Kodomo Quiz")
    div class: "body", ->
      text "Welcome to Kodomo Quiz!"
      form method: "POST", action: @url_for("login"), ->
        input {type: "hidden", name: "csrf_token",
            value: @new_csrf}
        input type: "submit"

