local math = require("math")

math.randomseed(os.time())

local f = function(...)
    local t = string.format(...)
    return t:gsub(' *>>>', '>>>')
end

local hello = {}

local _ = function(req, text)
    if req then
        return req:_(text)
    else
        return text
    end
end

local task = function(req)
    return _(req, [[What does Python print
            if you enter the following commands?]])
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

function hello.division_int(req)
    local a = math.random(60, 100)
    local b = math.random(10, 50)
    local result = math.floor(a / b)
    return
    f(">>> print(%i // %i)", a, b),
    f('%i', result),
    f('%i', result + 1),
    f('%i', result - 1),
    f('%i', result - 2),
    task(req)
end

function hello.division_float(req)
    local result = 0.5 * math.random(2, 5)
    local b = math.random(10, 50)
    local a = result * b
    return
    f(">>> print(%i.0 / %i.0)", a, b),
    f('%0.1f', result),
    f('%0.1f', result - 0.5),
    f('%0.1f', result + 0.5),
    f('%0.1f', result * 2),
    task(req)
end

function hello.mod(req)
    local a = math.random(60, 100)
    local b = math.random(10, 50)
    local result = a % b
    return
    f(">>> print(%i %% %i)", a, b),
    f('%i', result),
    f('%i', result + 1),
    f('%i', result - 1),
    f('%i', a),
    task(req)
end

function hello.start_file(req)
    local target_file = 'p' .. math.random(10, 50) .. '.py'
    return
    f("Filename: %s", target_file),
    f('python %s', target_file),
    f('%s', target_file),
    f('C:\\\\ %s', target_file),
    f(':) %s :)', target_file),
    _(req, [[How to execute Python script
        from command line?]])
end

function hello.python_org(req)
    return
    '',
    'python.org',
    'python.com',
    'python.ru',
    'kodomo.fbb.msu.ru',
    _(req, "What is the Python's official site?")
end

return hello

