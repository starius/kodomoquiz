html = require "lapis.html"

class extends html.Widget
  content: =>
    html_5 ->
      head ->
        meta charset: 'utf-8'
        link
          rel: "icon", type: "image/x-icon",
          href: "/favicon.ico"
        link
          rel: "stylesheet", type: "text/css",
          href: "/static/quiz.css"
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
            text @_('Language: ')
            a href: @url_for('russian'), ->
              text "Русский"
            text ", "
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
        @content_for "inner"
        br!
        p 'Copyright (C) 2014-2015 Boris Nagaev '
        text @_([[The kodomoquiz is under the MIT license and
          available at ]])
        a href: 'https://github.com/starius/kodomoquiz',->
          text 'Github'
