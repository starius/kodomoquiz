local all = require('quiz.all')
local all_different = require('quiz.helpers').all_different
local has_nil = require('quiz.helpers').has_nil

local N = 1000

math.randomseed(os.time())

for i = 1, N do
    for quiz_name, quiz in pairs(all) do
        for task_name, task in pairs(quiz) do
            local t, a1, a2, a3, a4 = task()
            if has_nil(5, t, a1, a2, a3, a4) then
                error(quiz_name .. '.' .. task_name)
            end
            if not all_different(a1, a2, a3, a4) then
                error(quiz_name .. '.' .. task_name ..
                    '\n\n' ..
                    table.concat({t, a1, a2, a3, a4}, '\n\n'))
            end
        end
    end
end

