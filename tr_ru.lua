local load_mo_file = require("load_mo_file")

function file_exists(name)
    local f = io.open(name, "r")
    if f ~= nil then
        io.close(f)
        return true
    else
        return false
    end
end

if file_exists("ru/messages.mo") then
    return assert(load_mo_file("ru/messages.mo"))
else
    return function(t) return t end
end

