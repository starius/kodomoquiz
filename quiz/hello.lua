local math = require("math")

math.randomseed(os.time())

local f = function(...)
    local t = string.format(...)
    return t:gsub(' *>>>', '>>>')
end

local hello = {}

local _ = function(text, req)
    if req then
        return req:_(text)
    else
        return text
    end
end

local task = function(req)
    return _([[What does Python print
            if you enter the following commands?]], req)
end

local shortrand = function()
    local t = {}
    local l = math.random(3, 7)
    for i = 1, l do
        table.insert(t, math.random(65, 90)) -- A-Z
    end
    local unPack = unpack or table.unpack
    return string.char(unPack(t))
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
    f(">>> print(%0.1f / %0.1f)", a, b),
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
    _([[How to execute Python script
        from command line?]], req)
end

function hello.python_org(req)
    return
    '',
    'python.org',
    'python.com',
    'python.ru',
    'kodomo.fbb.msu.ru',
    _("What is the Python's official site?", req)
end

function hello.python_exit(req)
    return
    '',
    'exit()',
    'exit',
    'quit',
    'stop()',
    _("How to interrupt interactive Python session?", req)
end

function hello.python_far_ctrl_o(req)
    return
    '',
    'Ctrl+O',
    'Ctrl+Q',
    'F' .. math.random(1, 5),
    'F' .. math.random(6, 10),
    _([[How to view Python output if it has been shadowed
        by FAR blue window?]], req)
end

function hello.raw_input(req)
    local v = 'v' .. math.random(0, 9)
    return
    '',
    f('>>> %s = raw_input()\n123\n>>>print(%s)', v, v),
    f('>>> %s = raw_input()\n123\n>>>%s', v, v),
    f('>>> %s = int(raw_input()\n123\n>>>%s', v, v),
    f('>>> %s = str(raw_input())\n123\n>>>%s', v, v),
    _("Which Python code produces output 123?", req)
end

function hello.sqrt(req)
    local result = math.random(10, 20)
    return
    f('>>> print(%i ** 0.5)', result ^ 2),
    f('%i', result),
    f('%i', result * 0.5),
    f('%i', result / 0.5),
    f('Error:'),
    task(req)
end

function hello.pow10(req)
    local val = math.random(5, 15)
    return
    f('>>> print(len(str(10 ** %i)))', val),
    f('%i', val + 1),
    f('%i', val),
    f('%i', val + 2),
    f('%i', val + 3),
    task(req)
end

function hello.pow10f(req)
    local val = math.random(5, 15)
    return
    f('>>> print(len(str(10.0 ** %i)))', val),
    f('%i', val + 3),
    f('%i', val + 1),
    f('%i', val),
    f('%i', val + 2),
    task(req)
end

function hello.minusminus(req)
    local a = math.random(11, 15)
    local b = math.random(1, 5)
    return
    f('>>> print(-%i - %i)', a, b),
    f('%i', -a - b),
    f('%i', a - b),
    f('%i', -a - b + 1),
    f('%i', -a - b + 2),
    task(req)
end

function hello.lastdigit(req)
    local a = math.random(1110, 9999)
    return
    f('>>> print(%i %% 10)', a),
    f('%i', a % 10),
    f('%i', a % 100),
    f('%i', a % 1000),
    f('%i', -a % 10),
    task(req)
end

function hello.last2digits(req)
    local a = math.random(1110, 9999)
    return
    f('>>> print(%i %% 100)', a),
    f('%i', a % 100),
    f('%i', a % 10),
    f('%i', a % 1000),
    f('%i', -a % 10),
    task(req)
end

function hello.stringcat(req)
    local s = shortrand()
    return
    f('>>> print("%s" + "%s")', s, s),
    f('%s', s .. s),
    f('%s', s),
    f('""'),
    f('Error'),
    task(req)
end

function hello.stringcatnumber(req)
    local s = shortrand()
    local i = math.random(3, 7)
    return
    f('>>> print("%s" + %i)', s, i),
    f('Error'),
    f('%s', s .. i),
    f('%s', string.rep(s, i)),
    f('%i', i),
    task(req)
end

function hello.stringmulnumber(req)
    local s = shortrand()
    local i = math.random(3, 7)
    return
    f('>>> print("%s" * %i)', s, i),
    f('%s', string.rep(s, i)),
    f('Error'),
    f('%s', s .. i),
    f('%i', i),
    task(req)
end

return hello

