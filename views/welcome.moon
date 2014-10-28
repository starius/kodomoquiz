import Widget from require "lapis.html"

class Welcome extends Widget
  content: =>
    h1 class: "header", @_("Kodomo Quiz")
    div class: "body", ->
      p @_("Welcome to Kodomo Quiz!")
      element 'ol', ->
        element 'li', ->
          text @_("Please, create file ")
          b @session.filename
          raw @_(" in your <b>public_html</b>")
          text @_(" and write the following text: ")
          b @session.token
        element 'li', ->
          form method: "POST", action: @url_for("login"), ->
            input {type: "hidden", name: "csrf_token",
                value: @new_csrf}
            text @_("Your username: ")
            input type: "text", name: "user"
            text ' '
            input type: "submit", value: @_("Login")
