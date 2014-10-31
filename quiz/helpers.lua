local h = {}

h.f = function(...)
    local t = string.format(...)
    return t:gsub(' *>>>', '>>>')
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

h.shortrand = function()
    local t = {}
    local l = math.random(3, 7)
    for i = 1, l do
        table.insert(t, math.random(65, 90)) -- A-Z
    end
    local unPack = unpack or table.unpack
    return string.char(unPack(t))
end


h.d19 = function()
    return math.random(1, 9)
end

h.zeroless = function()
    local d19 = h.d19
    return d19() + d19() * 10 + d19() * 100 + d19() * 1000
end

return h

