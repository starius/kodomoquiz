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
    h.f("'%s'", w),
    h.f('>>> "%s".strip()', w0),
    h.f('>>> "%s".split()', w0),
    h.f('>>> len("%s")', w0),
    h.f('>>> range("%s")', w0),
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
    h.f('>>> "%s".split()', str),
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
    h.f('>>> "%s".split(",")', str),
    h.f('[%s]', table.concat(ll1, ', ')),
    h.f('[%s]', table.concat(ll2, ', ')),
    h.f('[%s]', table.concat(ll3, ', ')),
    h.f('[%s]', table.concat(ll4, ', ')),
    h.task(req)
end

function ilfr.len(req)
    local list_size = h.rr(2, 4)
    local ll1 = {}
    for i = 1, list_size do
        local v = h.rr(1, 4)
        table.insert(ll1, h.f("%i", v))
    end
    local list = h.f('[%s]', table.concat(ll1, ', '))
    local str = h.f('"%s"', list)
    local ans = {tostring(list_size), tostring(#str - 2),
        table.concat(ll1, ' '), list}
    local input, output
    if h.rr(0, 1) == 1 then
        input = h.f('>>> len(%s)', list)
        output = tostring(list_size)
    else
        input = h.f('>>> len(%s)', str)
        output = tostring(#str - 2)
    end
    local a,b,c,d = h.unpack(h.with_fakes(output, ans))
    return
    input,
    a,b,c,d,
    h.task(req)
end

local int2bool = {[0] = false, [1] = true}
local lua2py = {[true] = 'True', [false] = 'False'}

function ilfr.test_or(req)
    local a = int2bool[h.rr(0, 1)]
    local b = int2bool[h.rr(0, 1)]
    local result = a or b
    local ans = {'True', 'False', 'or', 'Error'}
    local a1,a2,a3,a4 = h.unpack(h.with_fakes(lua2py[result], ans))
    return
    h.f('>>> %s or %s', lua2py[a], lua2py[b]),
    a1,a2,a3,a4,
    h.task(req)
end

function ilfr.test_and(req)
    local a = int2bool[h.rr(0, 1)]
    local b = int2bool[h.rr(0, 1)]
    local result = a and b
    local ans = {'True', 'False', 'and', 'Error'}
    local a1,a2,a3,a4 = h.unpack(h.with_fakes(lua2py[result], ans))
    return
    h.f('>>> %s and %s', lua2py[a], lua2py[b]),
    a1,a2,a3,a4,
    h.task(req)
end

function ilfr.bool_expression(req)
    -- (a b) (c d)
    local a = int2bool[h.rr(0, 1)]
    local b = int2bool[h.rr(0, 1)]
    local c = int2bool[h.rr(0, 1)]
    local d = int2bool[h.rr(0, 1)]
    local nota = int2bool[h.rr(0, 1)]
    local notb = int2bool[h.rr(0, 1)]
    local notc = int2bool[h.rr(0, 1)]
    local notd = int2bool[h.rr(0, 1)]
    local aOPb = int2bool[h.rr(0, 1)] -- true=and, false=or
    local cOPd = int2bool[h.rr(0, 1)] -- true=and, false=or
    local notab = int2bool[h.rr(0, 1)]
    local notcd = int2bool[h.rr(0, 1)]
    local abOPcd = int2bool[h.rr(0, 1)] -- true=and, false=or
    local notabcd = int2bool[h.rr(0, 1)]
    local fop = function(b)
        if b == true then
            return function(x, y)
                return x and y
            end
        else
            return function(x, y)
                return x or y
            end
        end
    end
    local fnot = function(b)
        if b == true then
            return function(x)
                return not x
            end
        else
            return function(x)
                return x
            end
        end
    end
    local v_nota = fnot(nota)(a)
    local v_notb = fnot(notb)(b)
    local v_notc = fnot(notc)(c)
    local v_notd = fnot(notd)(d)
    local v_ab = fop(aOPb)(v_nota, v_notb)
    local v_cd = fop(cOPd)(v_notc, v_notd)
    local v_notab = fnot(notab)(v_ab)
    local v_notcd = fnot(notcd)(v_cd)
    local v_abcd = fop(abOPcd)(v_notab, v_notcd)
    local v_notabcd = fnot(notabcd)(v_abcd)
    --
    local result = lua2py[v_notabcd]
    local not2py = {[true] = 'not ', [false] = ''}
    local op2py = {[true] = 'and', [false] = 'or'}
    local expr = h.f(
        ">>> %s((%s(%s%s %s %s%s)) %s (%s(%s%s %s %s%s)))",
        not2py[notabcd],
                not2py[notab],
                    not2py[nota], lua2py[a],
                    op2py[aOPb],
                    not2py[notb], lua2py[b],
            op2py[abOPcd],
                not2py[notcd],
                    not2py[notc], lua2py[c],
                    op2py[cOPd],
                    not2py[notd], lua2py[d]
    )
    local ans = {'True', 'False', h.rr(0, 1), 'Error'}
    local a1,a2,a3,a4 = h.unpack(h.with_fakes(result, ans))
    return
    expr,
    a1,a2,a3,a4,
    h.task(req)
end

ilfr.bool_expression_2 = ilfr.bool_expression
ilfr.bool_expression_3 = ilfr.bool_expression

function ilfr.indentation_error(req)
    local t, a1, a2, a3, a4, m = ilfr.odd_even(req)
    t = t:gsub('else', '  else') -- half indent else
    a1, a2, a3, a4 = h.unpack(h.with_fakes('Error',
        {a1, a2, a3, a4}))
    return t, a1, a2, a3, a4, m
end

function ilfr.no_indentation_error(req)
    local t, a1, a2, a3, a4, m = ilfr.odd_even(req)
    t = t:gsub("print%('odd'%)", "    print('odd')")
    return t, a1, a2, a3, a4, m
end

function ilfr.nocolon_error(req)
    local t, a1, a2, a3, a4, m = ilfr.elif(req)
    t = t:gsub('else:', 'else')
    a1, a2, a3, a4 = h.unpack(h.with_fakes('Error',
        {a1, a2, a3, a4}))
    return t, a1, a2, a3, a4, m
end

function ilfr.list_index(req)
    local list_size = h.rr(3, 6)
    local ll = {}
    for i = 1, list_size do
        local v = h.rr(1, 5)
        table.insert(ll, v)
    end
    local ll1 = h.copy_list(ll)
    local i = h.rr(2, list_size)
    local v = h.shortrand()
    ll1[i] = v
    local ll2 = h.copy_list(ll) -- wrong index (+1)
    local i2 = i - 1
    ll2[i2] = v
    local t = h.f('>>> arr = %s', h.list2py(ll))
    t = t .. h.f('\n>>> arr[%i] = %s', i-1, h.value2py(v))
    t = t .. h.f('\n>>> print(arr)')
    return
    t,
    h.list2py(ll1),
    h.list2py(ll),
    h.list2py(ll2),
    'Error',
    h.task(req)
end

return ilfr

