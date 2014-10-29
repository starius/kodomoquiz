html = require "lapis.html"

class extends html.Widget
  content: =>
    html_5 ->
      head ->
        meta charset: 'utf-8'
        link
          rel: "icon", type: "image/x-icon",
          href: "/favicon.ico"
        title @title or @_ "Kodomo Quiz"
      body ->
        h1 class: "header", @_("Kodomo Quiz")
        element 'table', -> element 'tr', ->
          element 'td', ->
            a href: @url_for('index'), ->
              text @_ "Main page"
          element 'td', ->
            text "|"
          element 'td', ->
            a href: @url_for('russian'), ->
              text "Русский"
          element 'td', ->
            text "|"
          element 'td', ->
            a href: @url_for('english'), ->
              text "English"
          if @session.user
            element 'td', ->
              text "|"
            element 'td', ->
              b @session.user
            element 'td', ->
              url = @url_for("logout")
              form method: "POST", action: url, ->
                input {type: "hidden", name: "csrf_token",
                    value: @new_csrf}
                input type: "submit", value: @_('Logout')
        raw '<br/>'
        @content_for "inner"

