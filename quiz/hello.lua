local math = require("math")

math.randomseed(os.time())

local f = function(...)
    local t = string.format(...)
    return t:gsub(' *>>>', '>>>')
end

local hello = {}

local task = function(req)
    return req._([[What does Python print after
        typing following commands?]])
end

function hello.print1(req)
    local val = math.random(0, 100)
    return
    f('>>> print(%i)', val),
    f('%i', val),
    f('(%i)', val),
    f('print(%i)', val),
    f('"%i"', val),
    task(req)
end

function hello.print_sum(req)
    local val = math.random(10, 100)
    return
    f([[>>> a = %i
        >>> b = a
        >>> print(a+b)]], val),
    f('%i', val * 2),
    f('%i', val),
    f('a+b', val),
    f('"a+b"', val),
    task(req)
end

return hello

