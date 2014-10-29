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
          text @_ "Русский"
        text " | "
        a href: @url_for('english'), ->
          text @_ "English"
        raw '<br/>'
        @content_for "inner"

