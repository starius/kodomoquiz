local math = require("math")

math.randomseed(os.time())

local h = require('quiz.helpers')
local rr = h.rr
local _ = h._

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

function dict_file.dict_set_fake2(req)
    local task = [[>>> d = {1: 2, 2: 3, 3: 4, 4: 5}
    >>> d['%i'] = d[%i] * 100
    >>> a = d[%i]
    >>> print(a)
    ]]
    local i0 = rr(1, 3)
    local v0 = i0 + 1
    local i1 = rr(1, 3)
    local v1 = i1 + 1
    local fake = v0 * 100
    local result = v1
    local fake2 = 0
    return
    h.f(task, i1, i0, i1),
    h.f("%i", result),
    h.f("%i", fake),
    h.f("%i", fake2),
    'Error',
    h.task(req)
end

function dict_file.list_as_keys(req)
    local ll = {}
    local dd = {}
    local n = rr(5, 8)
    local cc_fake3 = 0
    local cc_fake2 = 0
    for i = 1, n do
        local v = rr(2, n)
        table.insert(ll, v)
        dd[v] = true
        cc_fake3 = cc_fake3 + v
        cc_fake2 = cc_fake2 + 1
    end
    local cc = 0
    local cc_fake = 0
    for v, _ in pairs(dd) do
        cc = cc + v
        cc_fake = cc_fake + 1
    end
    local lname = 'l' .. rr(1, 3)
    local dname = 'd' .. rr(2, 4)
    local dvalue = 100
    local task0 = [[
%s = %s
%s = {}
for a in %s:
    %s[a] = %i
cc = 0
for k in %s.keys():
    cc = cc + k
print(cc)
]]
    local task = h.f(task0, lname, h.list2py(ll),
        dname, lname, dname, dvalue, dname)
    return
    task,
    h.f("%i", cc),
    h.f("%i", cc_fake),
    h.f("%i", cc_fake2),
    h.f("%i", cc_fake3),
    h.task(req)
end

function dict_file.list_as_keys2(req)
    local ll = {}
    local dd = {}
    local n = rr(5, 8)
    local cc_fake3 = 0
    local cc_fake2 = 0
    for i = 1, n do
        local v = rr(2, n)
        table.insert(ll, v)
        dd[v] = true
        cc_fake3 = cc_fake3 + v
        cc_fake2 = cc_fake2 + 1
    end
    local cc = 0
    local cc_fake = 0
    for v, _ in pairs(dd) do
        cc = cc + 1
        cc_fake = cc_fake + v
    end
    local lname = 'l' .. rr(1, 3)
    local dname = 'd' .. rr(2, 4)
    local dvalue = 100
    local task0 = [[
%s = %s
%s = {}
for a in %s:
    %s[a] = %i
cc = 0
for k in %s.keys():
    cc = cc + 1
print(cc)
]]
    local task = h.f(task0, lname, h.list2py(ll),
        dname, lname, dname, dvalue, dname)
    return
    task,
    h.f("%i", cc),
    h.f("%i", cc_fake),
    h.f("%i", cc_fake2),
    h.f("%i", cc_fake3),
    h.task(req)
end

function dict_file.list_as_keys3(req)
    local ll = {}
    local dd = {}
    local n = rr(5, 8)
    local cc_fake3 = 0
    local cc = 0
    for i = 1, n do
        local v = rr(2, n)
        table.insert(ll, v)
        dd[v] = true
        cc_fake3 = cc_fake3 + v
        cc = cc + 1
    end
    local cc_fake = 0
    local cc_fake2 = 0
    for v, _ in pairs(dd) do
        cc_fake = cc_fake + 1
        cc_fake2 = cc_fake2 + v
    end
    local lname = 'l' .. rr(1, 3)
    local dname = 'd' .. rr(2, 4)
    local dvalue = 100
    local task0 = [[
%s = %s
%s = {}
for a in %s:
    %s[a] = %i
cc = 0
for k in %s:
    cc = cc + 1
print(cc)
]]
    local task = h.f(task0, lname, h.list2py(ll),
        dname, lname, dname, dvalue, lname)
    return
    task,
    h.f("%i", cc),
    h.f("%i", cc_fake),
    h.f("%i", cc_fake2),
    h.f("%i", cc_fake3),
    h.task(req)
end

function dict_file.list_as_keys4(req)
    local ll = {}
    local dd = {}
    local n = rr(5, 8)
    local cc_fake3 = 0
    local cc = 0
    for i = 1, n do
        local v = rr(2, n)
        table.insert(ll, v)
        dd[v] = true
        cc_fake3 = cc_fake3 + 1
        cc = cc + v
    end
    local cc_fake = 0
    local cc_fake2 = 0
    for v, _ in pairs(dd) do
        cc_fake = cc_fake + 1
        cc_fake2 = cc_fake2 + v
    end
    local lname = 'l' .. rr(1, 3)
    local dname = 'd' .. rr(2, 4)
    local dvalue = 100
    local task0 = [[
%s = %s
%s = {}
for a in %s:
    %s[a] = %i
cc = 0
for k in %s:
    cc = cc + k
print(cc)
]]
    local task = h.f(task0, lname, h.list2py(ll),
        dname, lname, dname, dvalue, lname)
    return
    task,
    h.f("%i", cc),
    h.f("%i", cc_fake),
    h.f("%i", cc_fake2),
    h.f("%i", cc_fake3),
    h.task(req)
end

local index_task = function(text, index)
    local sname = 's' .. rr(1, 9)
    return h.f([[>>> %s = %s
            >>> %s[%s] ]],
            sname, text, sname, index)
end

function dict_file.slice1(req)
    local n = rr(8, 12)
    local text = h.shortrand(n)
    local start = rr(2, 4)
    local stop = rr(n - 5, n - 3)
    local pystart = start - 1
    local pystop = stop - 1 + 1
    return
    index_task(h.f('"%s"', text), pystart .. ':' .. pystop),
    h.f("'%s'", text:sub(start, stop)),
    h.f("'%s'", text:sub(start, stop + 1)),
    h.f("'%s'", text:sub(start - 1, stop - 1)),
    h.f("'%s'", text:sub(start - 1, stop - 1 + 1)),
    h.task(req)
end

function dict_file.slice_rev(req)
    local n = rr(8, 12)
    local text = h.shortrand(n)
    local start = rr(2, 4)
    local stop = rr(n - 5, n - 3)
    local pystart = start - 1
    local pystop = stop - 1 + 1
    local textq = h.f("'%s'", text)
    return
    h.f("'%s'", text:sub(start, stop)),
    index_task(textq, pystart .. ':' .. pystop),
    index_task(textq, pystart .. ':' .. pystop - 1),
    index_task(textq, pystart + 1 .. ':' .. pystop + 1),
    index_task(textq, pystart + 1 .. ':' .. pystop + 1 - 1),
    h.task2(req)
end

function dict_file.slice_list(req)
    local n = rr(8, 12)
    local start = rr(2, 4)
    local stop = rr(n - 5, n - 3)
    local pystart = start - 1
    local pystop = stop - 1 + 1
    local ll = {}
    local slice = {}
    local fake1 = {}
    local fake2 = {}
    local fake3 = {}
    local initv = rr(10, 20)
    for i = 1, n do
        local v = initv - i
        table.insert(ll, v)
        if i >= start and i <= stop then
            table.insert(slice, v)
        end
        if i >= start and i <= stop + 1 then
            table.insert(fake1, v)
        end
        if i >= start - 1 and i <= stop - 1 then
            table.insert(fake2, v)
        end
        if i >= start - 1 and i <= stop - 1 + 1 then
            table.insert(fake3, v)
        end
    end
    return
    index_task(h.list2py(ll), pystart .. ':' .. pystop),
    h.list2py(slice),
    h.list2py(fake1),
    h.list2py(fake2),
    h.list2py(fake3),
    h.task(req)
end

function dict_file.open_file_r(req)
    return
    '',
    "aaa = open('aaa.txt', 'r')",
    "aaa = open('aaa.txt', 'w')",
    "aaa = open(aaa.txt, r)",
    "aaa = open(aaa.txt, w)",
    _([[How to open file aaa.txt for reading?]], req)
end

function dict_file.open_file_w(req)
    return
    '',
    "aaa = open('aaa.txt', 'w')",
    "aaa = open('aaa.txt', 'r')",
    "aaa = open(aaa.txt, r)",
    "aaa = open(aaa.txt, w)",
    _([[How to open file aaa.txt for writing?]], req)
end

function dict_file.file_to_list(req)
    return
    '',
    "lines = list(aaa)",
    "lines = file(aaa)",
    "lines = read(aaa)",
    "lines = aaa.read()",
    _([[How to get list of all lines of file
        (variable aaa)?]], req)
end

function dict_file.write_int(req)
    return
    h.f([[>>> age = int(raw_input('Enter your age: '))
    >>> age5 = age + 5
    >>> f = open('out.txt')
    >>> f.write('Your age in 5 years is ')
    ]]),
    h.f([[
    >>> f.write(str(age5))
    >>> f.close()
    ]]),
    h.f([[
    >>> f.write([age5])
    >>> f.close()
    ]]),
    h.f([[
    >>> f.write(age5)
    >>> f.close()
    ]]),
    h.f([[
    >>> f.write([str(age5)])
    >>> f.close()
    ]]),
    _([[Complete the script (write result to the file)]], req)
end

function dict_file.close_file(req)
    return
    '',
    '>>> myfile.close()',
    '>>> myfile.close',
    '>>> close(myfile)',
    '>>> close myfile',
    _([[How to close file (variable myfile)?]], req)
end

return dict_file

