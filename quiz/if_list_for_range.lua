local math = require("math")

math.randomseed(os.time())

local h = require('quiz.helpers')

local ilfr = {}

function ilfr.odd_even(req)
    local val = math.random(0, 100)
    local result, fake
    if val % 2 == 0 then
        result = 'even'
        fake = 'odd'
    else
        result = 'odd'
        fake = 'even'
    end
    return
    h.f([[
if %i %% 2 == 0:
    print('even')
else:
    print('odd')]], val),
    result,
    fake,
    'Error',
    h.f('%i', val % 2),
    h.task(req)
end

function ilfr.in_str(req)
    local str = h.shortrand()
    local pattern, result, fake
    if h.rr(0, 1) == 0 then
        pattern = str:sub(h.rr(1, 2), h.rr(-2, -1))
        result = 'True'
        fake = 'False'
    else
        pattern = str:sub(h.rr(1, 2), h.rr(-2, -1)) .. '1'
        result = 'False'
        fake = 'True'
    end
    return
    h.f('>>> "%s" in "%s"', pattern, str),
    result,
    fake,
    'Error',
    h.f('%s', pattern),
    h.task(req)
end

function ilfr.in_list(req)
    local list_size = h.rr(3, 6)
    local pattern = h.rr(1, 4)
    local ll = {}
    local result = 'False'
    local fake2 = 'Error'
    for i = 1, list_size do
        local v = h.rr(1, 4)
        table.insert(ll, v)
        if v == pattern then
            result = 'True'
        end
    end
    if h.rr(0, 3) == 0 then
        result = 'False'
        pattern = h.f('"%i"', pattern)
    end
    if h.rr(0, 3) == 0 then
        result = 'Error'
        pattern = pattern .. '"'
    end
    local fake
    if result == 'True' then
        fake = 'False'
    elseif result == 'Error' then
        fake = 'True'
        fake2 = 'False'
    else
        fake = 'True'
    end
    local pyll = h.f('[%s]', table.concat(ll, ', '))
    return
    h.f('>>> %s in %s', tostring(pattern), pyll),
    result,
    fake,
    fake2,
    h.f('%s', tostring(pattern)),
    h.task(req)
end

function ilfr.elif(req)
    local val = h.rr(0, 10)
    local result
    if val % 2 == 0 then
        result = 'even'
    elseif val % 3 == 0 then
        result = 'divisible by three'
    else
        result = 'odd and indivisible by three'
    end
    local a1, a2, a3, a4 = h.unpack(h.with_fakes(result, {
        'even', 'divisible by three',
        'odd and indivisible by three', tostring(val)
    }))
    return
    h.f([[
if %i %% 2 == 0:
    print('even')
elif %i %% 3 == 0:
    print('divisible by three')
else:
    print('odd and indivisible by three')
]], val, val),
    a1, a2, a3, a4,
    h.task(req)
end

function ilfr.strip(req)
    local sp1 = string.rep(' ', h.rr(1, 3))
    local sp2 = string.rep(' ', h.rr(1, 3))
    local w = h.shortrand()
    local w0 = sp1 .. w .. sp2
    return
    w,
    h.f('"%s".strip()', w0),
    h.f('"%s".split()', w0),
    h.f('len("%s")', w0),
    h.f('range("%s")', w0),
    h.task2(req)
end

function ilfr.split1(req)
    local list_size = h.rr(2, 4)
    local ll1 = {}
    local ll2 = {}
    local ll3 = {}
    local str = ''
    for i = 1, list_size do
        local v = h.rr(1, 4)
        table.insert(ll1, h.f("'%i'", v))
        table.insert(ll2, h.f("%i", v))
        table.insert(ll3, h.f("'%i'", v))
        str = str .. v .. ' '
        if h.rr(0, 1) == 0 or i == 1 then
            table.insert(ll3, "''")
            str = str .. ' '
        end
    end
    local ll4 = h.one_of(ll1, ll2, ll3)
    return
    h.f('"%s".split()', str),
    h.f('[%s]', table.concat(ll1, ', ')),
    h.f('[%s]', table.concat(ll2, ', ')),
    h.f('[%s]', table.concat(ll3, ', ')),
    h.f('[[%s]]', table.concat(ll4, ', ')),
    h.task(req)
end

function ilfr.split2(req)
    local list_size = h.rr(2, 4)
    local ll1 = {}
    local ll2 = {}
    local ll3 = {}
    local ll4 = {}
    local str = ''
    for i = 1, list_size do
        local v0 = h.rr(1, 4)
        v = v0
        if h.rr(0, 1) == 0 or i == list_size then
            v = ' ' .. v
        end
        if h.rr(0, 1) == 0 then
            v = v .. ' '
        end
        table.insert(ll1, h.f("'%s'", v))
        table.insert(ll2, h.f("%i", v0))
        table.insert(ll3, h.f("%s", v))
        table.insert(ll4, h.f("'%i'", v0))
        str = str .. v
        if i ~= list_size then
            str = str .. ','
        end
    end
    return
    h.f('"%s".split(",")', str),
    h.f('[%s]', table.concat(ll1, ', ')),
    h.f('[%s]', table.concat(ll2, ', ')),
    h.f('[%s]', table.concat(ll3, ', ')),
    h.f('[%s]', table.concat(ll4, ', ')),
    h.task(req)
end

return ilfr

