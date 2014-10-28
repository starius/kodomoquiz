local math = require("math")

math.randomseed(os.time())

return function()
    return (''..math.random()):sub(3)
end

