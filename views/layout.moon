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
        a href: @url_for('index'), ->
          text @_ "Main page"
        text " | "
        a href: @url_for('russian'), ->
          text "Русский"
        text " | "
        a href: @url_for('english'), ->
          text "English"
        if @session.user
          form method: "POST", action: @url_for("logout"), ->
            input {type: "hidden", name: "csrf_token",
                value: @new_csrf}
            input type: "submit", value: @_('Logout')
        raw '<br/>'
        @content_for "inner"

