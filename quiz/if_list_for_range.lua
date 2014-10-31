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

return ilfr

