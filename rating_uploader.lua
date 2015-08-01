local simple = require("simple")

local config = require("lapis.config").get()

return function(login, task, rating)
    local delay = 0.0
    ngx.timer.at(delay, function()
        local password = config.rating_uploader.password
        local HOST_NAME = config.rating_uploader.HOST_NAME
        local PORT_NUMBER = config.rating_uploader.PORT_NUMBER
        local PATH = '/?login=%s&task=%s&rating=%s&password=%s'
        local path = PATH:format(login, task, rating, password)
        simple.request(HOST_NAME, PORT_NUMBER, {
            path=path, timeout=100000,
        })
    end)
end
