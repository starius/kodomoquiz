local config = require("lapis.config")

config({"development", "production"}, {
  port = 3612,
  secret = require('secret'),
  -- mysql = {
  --   backend = "lua_resty_mysql", -- or luasql
  postgres = {
    backend = "pgmoon",
    host = "127.0.0.1",
    user = "kodomoquiz",
    password = "kodomoquiz",
    database = "kodomoquiz",
  },
  rating_uploader = {
    HOST_NAME = '127.0.0.1',
    PORT_NUMBER = 18780,
    password = 'password',
  },
  checker_url = 'http://hometask.kodomoquiz.tk/send',
})

config("production", {
    code_cache = 'on',
    logging = {queries = false, requests = false},
})

