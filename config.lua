local config = require("lapis.config")

config({"development", "production"}, {
  port = 3612,
  secret = require('secret'),
  postgres = {
    backend = "pgmoon",
    host = "127.0.0.1",
    user = "kodomoquiz",
    password = "kodomoquiz",
    database = "kodomoquiz"
  }
})

config("production", {
    code_cache = 'on',
    logging = {queries = false, requests = false},
})

