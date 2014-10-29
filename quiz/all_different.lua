local all_different = function(...)
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

assert(all_different(1,2,3,4))
assert(not all_different(1,1,3,4))

return all_different

