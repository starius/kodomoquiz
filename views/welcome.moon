import Widget from require "lapis.html"

class Welcome extends Widget
  content: =>
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
        element 'li', ->
          text @_[[Then you can remove the file.
            It is checked only when you press
            the button above.]]

      element 'table', -> element 'tr', ->
        element 'td', ->
          text @_("Alternatively, you can use ")
        element 'td', ->
          url = @url_for("guest-login")
          form method: "POST", action: url, ->
            input {type: "hidden", name: "csrf_token",
                value: @new_csrf}
            input type: "submit", value: @_("guest login")
        element 'td', ->
          text '.'
      i @_[[Let us know your transient username, otherwise
        all your results will be lost]]

