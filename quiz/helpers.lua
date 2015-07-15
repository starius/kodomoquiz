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

h.shortrand = function(l)
    local t = {}
    if not l then
        l = math.random(3, 7)
    end
    local used = {}
    for i = 1, l do
        local v
        while not v or used[v] do
            v = math.random(65, 90) -- A-Z
        end
        used[v] = true
        table.insert(t, v)
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

h.make_group = function(dst, src)
    return function(...)
        local orig_names = {...}
        local name = orig_names[1]
        local orig_funcs = {}
        for _, orig_name in ipairs(orig_names) do
            table.insert(orig_funcs, src[orig_name])
        end
        assert(#orig_funcs >= 1)
        dst[name] = h.one_of_getter(h.unpack(orig_funcs))
    end
end

h.testDefinitions = function(definitions)
    local keys = {}
    for k, v in pairs(definitions) do
        table.insert(keys, k)
    end

    local function makeSkeys()
        local selected_keys = {}
        local selected_values = {}
        local skeys = {}
        for i = 1, 4 do
            local key
            while not key do
                local k = keys[math.random(1, #keys)]
                local v = definitions[k]
                if not selected_keys[k] and
                        not selected_values[v] then
                    key = k
                end
            end
            selected_keys[key] = true
            selected_values[definitions[key]] = true
            table.insert(skeys, key)
        end
        return skeys
    end

    local function direct()
        local skeys = makeSkeys()
        return
        skeys[1],
        definitions[skeys[1]],
        definitions[skeys[2]],
        definitions[skeys[3]],
        definitions[skeys[4]],
        [[Выберите подходящее описание:]]
    end

    local function reverse()
        local skeys = makeSkeys()
        return
        definitions[skeys[1]],
        skeys[1],
        skeys[2],
        skeys[3],
        skeys[4],
        [[Что соответствует данному описанию?]]
    end

    return {
        direct = direct,
        reverse = reverse,
    }
end

h.fromTable = function(t)
    --[[
    Keys of t are strings.
    Values of t can be values of macros and questions.
    Macro is a string. It causes substitution Key => Value.
    Question is a table with 4 keys:
     - "Q" - question (if absent, macro "Q" is used)
     - "T" - task (if absent, macro "T" is used)
     - "A" - right answer
     - "W" - wrong answers (list of 3 strings)
    If any of them are equal to a macro, the substitution
    happens.
    ]]
    assert(type(t) == 'table')
    -- check keys and values
    for key, v in pairs(t) do
        assert(type(key) == 'string')
        assert(type(v) == 'string' or type(v) == 'table')
    end
    -- find macros
    local macros = {}
    for key, v in pairs(t) do
        if type(v) == 'string' then
            macros[key] = v
        end
    end
    local function expandMacro(text)
        return macros[text] or text
    end
    -- check values (questions)
    for key, v in pairs(t) do
        if type(v) == 'table' then
            assert((v.Q and type(v.Q) == 'string') or macros.Q)
            assert((v.T and type(v.T) == 'string') or macros.T)
            assert(v.A and type(v.A) == 'string')
            assert(v.W and type(v.W) == 'table')
            assert(#v.W == 3)
            for i = 1, 3 do
                assert(type(v.W[i]) == 'string')
            end
        end
    end
    -- create module object
    local m = {}
    for key, v in pairs(t) do
        if type(v) == 'table' then
            m[key] = function(req)
                return expandMacro(v.T or macros.T),
                    expandMacro(v.A),
                    expandMacro(v.W[1]),
                    expandMacro(v.W[2]),
                    expandMacro(v.W[3]),
                    expandMacro(v.Q or macros.Q)
            end
        end
    end
    return m
end

h.fromYamlFile = function(filename)
    local file = io.open(filename, 'r')
    local yml = file:read('*all')
    file:close()
    local yaml = require 'yaml'
    local t = yaml.load(yml)
    return h.fromTable(t)
end

return h

