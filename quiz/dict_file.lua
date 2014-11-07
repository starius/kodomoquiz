local math = require("math")

math.randomseed(os.time())

local h = require('quiz.helpers')
local rr = h.rr

local dict_file = {}

function dict_file.dict_get(req)
    local task = [[>>> d = {1: 2, 2: 3, 3: 4, 4: 5}
    >>> d[%i]
    ]]
    local val = rr(1, 3)
    local result = val + 1
    local fake = val + 2
    local for_str = (rr(1, 2) == 1) and result or fake
    return
    h.f(task, val),
    h.f("%i", result),
    h.f("%i", fake),
    'Error',
    h.f("'%i'", for_str),
    h.task(req)
end

function dict_file.dict_get_fake(req)
    local task = [[>>> d = {1: 2, 2: 3, 3: 4, 4: 5}
    >>> d["%i"]
    ]]
    local val = rr(1, 3)
    local result = val + 1
    local fake = val + 2
    local for_str = (rr(1, 2) == 1) and result or fake
    return
    h.f(task, val),
    'Error',
    h.f("%i", result),
    h.f("%i", fake),
    h.f("'%i'", for_str),
    h.task(req)
end

function dict_file.dict_get_fake2(req)
    local task = [[>>> d = {1: 2, 2: 3, 3: 4, 4: 5}
    >>> d[0]
    ]]
    local val = rr(1, 3)
    local result = val + 1
    local fake = val + 2
    local for_str = (rr(1, 2) == 1) and result or fake
    return
    h.f(task, val),
    'Error',
    h.f("%i", result),
    h.f("%i", fake),
    h.f("'%i'", for_str),
    h.task(req)
end

function dict_file.dict_set(req)
    local task = [[>>> d = {1: 2, 2: 3, 3: 4, 4: 5}
    >>> d[%i] = d[%i] * 100
    >>> a = d[%i]
    >>> print(a)
    ]]
    local i0 = rr(1, 3)
    local v0 = i0 + 1
    local i1 = rr(1, 3)
    local v1 = i1 + 1
    local result = v0 * 100
    local fake = v1
    local fake2 = 0
    return
    h.f(task, i1, i0, i1),
    h.f("%i", result),
    h.f("%i", fake),
    h.f("%i", fake2),
    'Error',
    h.task(req)
end

function dict_file.dict_set_fake(req)
    local task = [[>>> d = {1: 2, 2: 3, 3: 4, 4: 5}
    >>> d[%i] = d[%i] * 100
    >>> a = d[%i]
    >>> print(a)
    ]]
    local i0 = 0
    local v0 = i0 + 1
    local i1 = rr(1, 3)
    local v1 = i1 + 1
    local result = v0 * 100
    local fake = v1
    local fake2 = 0
    return
    h.f(task, i1, i0, i1),
    'Error',
    h.f("%i", result),
    h.f("%i", fake),
    h.f("%i", fake2),
    h.task(req)
end

return dict_file

