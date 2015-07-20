local all = {}

local groups = require 'quiz.groups'

for _, group in ipairs(groups) do
    local tests = group[2]
    for _, test in ipairs(tests) do
        local name = test[1]
        local mod = test[2]
        all[name] = mod
    end
end

return all
