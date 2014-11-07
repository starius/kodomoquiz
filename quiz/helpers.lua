local h = {}

h.f = function(...)
    local t = string.format(...)
    t = t:gsub(' *>>>', '>>>')
    return t
end

h._ = function(text, req)
    if req then
        return req:_(text)
    else
        return text
    end
end

h.task = function(req)
    return h._([[What does Python print
            if you enter the following commands?]], req)
end

h.task2 = function(req)
    return h._([[Which Python code produces this output?]], req)
end

h.unpack = unpack or table.unpack

h.shortrand = function()
    local t = {}
    local l = math.random(3, 7)
    for i = 1, l do
        table.insert(t, math.random(65, 90)) -- A-Z
    end
    return string.char(h.unpack(t))
end

h.rr = math.random

h.d19 = function()
    return math.random(1, 9)
end

h.zeroless = function()
    local d19 = h.d19
    return d19() + d19() * 10 + d19() * 100 + d19() * 1000
end

h.all_different = function(...)
    local t = {...}
    for i = 2, #t do
        for j = 1, i - 1 do
            if t[i] == t[j] then
                return false
            end
        end
    end
    return true
end

assert(h.all_different(1,2,3,4))
assert(not h.all_different(1,1,3,4))

h.has_nil = function(n, ...)
    local t = {...}
    for i = 1, n do
        if t[i] == nil then
            return true
        end
    end
    return false
end

assert(h.has_nil(4, 1,nil,3,4))
assert(not h.has_nil(4, 1,1,3,4))

h.with_fakes = function(result, answers)
    local answers1 = {}
    for _, a in ipairs(answers) do
        if a ~= result then
            table.insert(answers1, a)
        end
    end
    return {result, h.unpack(answers1)}
end

assert(#h.with_fakes('1', {'1', '2', '3', '4'}) == 4)
assert(h.all_different(h.with_fakes('1', {'1', '2', '3', '4'})))
assert(not h.has_nil(4,
    h.unpack(h.with_fakes('1', {'1', '2', '3', '4'}))))

h.shuffle = function(t)
    local t2 = {}
    while #t > 0 do
        table.insert(t2, table.remove(t, h.rr(1, #t)))
    end
    return t2
end

h.one_of = function(...)
    local t = {...}
    return t[h.rr(1, #t)]
end

h.one_of_getter = function(...)
    local funcs = {...}
    return function(...)
        return h.one_of(h.unpack(funcs))(...)
    end
end

h.value2py = function(e)
    if type(e) == 'number' then
        return tostring(e)
    elseif type(e) == 'string' then
        return string.format("'%s'", e)
    elseif e == true then
        return 'True'
    elseif e == false then
        return 'False'
    else
        error('Unknown type ' .. type(e))
    end
end

h.list2py = function(ll)
    local ll2 = {}
    for _, e in ipairs(ll) do
        table.insert(ll2, h.value2py(e))
    end
    return string.format('[%s]', table.concat(ll2, ', '))
end

h.copy_list = function(ll)
    local ll2 = {}
    for _, e in ipairs(ll) do
        table.insert(ll2, e)
    end
    return ll2
end

h.dict2py = function(ll)
    local ll2 = {}
    for k, v in pairs(ll) do
        local k1 = h.value2py(k)
        local v1 = h.value2py(v)
        local kv1 = string.format('%s: %s', k1, v1)
        table.insert(ll2, kv1)
    end
    return string.format('{%s}', table.concat(ll2, ', '))
end

return h

