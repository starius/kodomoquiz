local all = require('quiz.all')
local all_different = require('quiz.helpers').all_different
local has_nil = require('quiz.helpers').has_nil

local N = 1000

math.randomseed(os.time())

local execute
if _VERSION == 'Lua 5.2' then
    execute = os.execute
elseif _VERSION == 'Lua 5.1' then
    execute = function(...)
        local status = os.execute(...)
        return status == 0
    end
end

local tmpin_fname = os.tmpname()
local tmpout_fname = os.tmpname()
local tmperr_fname = os.tmpname()

local get_py_output = function(t)
    local interactive = t:find('^>>> ')
    if interactive then
        t = t:gsub('>>> ', '')
    end
    local tmpin = io.open(tmpin_fname, 'w')
    tmpin:write(t)
    tmpin:close()
    local cmd
    if interactive then
        cmd = string.format('python -i < %s > %s 2> %s',
            tmpin_fname, tmpout_fname, tmperr_fname)
    else
        cmd = string.format('python %s > %s 2> %s',
            tmpin_fname, tmpout_fname, tmperr_fname)
    end
    local run_ok = execute(cmd)
    if not run_ok then
        return 'Error'
    end
    local tmperr = io.open(tmperr_fname, 'r')
    local task_err = tmperr:read('*a')
    tmperr:close()
    if task_err:find('Error') then
        return 'Error'
    end
    local tmpout = io.open(tmpout_fname, 'r')
    local task_out = tmpout:read('*a')
    tmpout:close()
    return task_out
end

local trim = function(t)
    t = t:gsub("%s+$", "")
    t = t:gsub("^%s+", "")
    return t
end

for i = 1, N do
    print('iteration ' .. i)
    for quiz_name, quiz in pairs(all) do
        for task_name, task in pairs(quiz) do
            local t, a1, a2, a3, a4, m = task()
            if has_nil(5, t, a1, a2, a3, a4) then
                error(quiz_name .. '.' .. task_name)
            end
            if not all_different(a1, a2, a3, a4) then
                error(quiz_name .. '.' .. task_name ..
                    '\n\n' ..
                    table.concat({t, a1, a2, a3, a4}, '\n\n'))
            end
            if m:find('What does Python print') then
                local out = get_py_output(t)
                if trim(out) ~= trim(a1) then
                    print(t, a1, a2, a3, a4, m)
                    print('Actual output: ' .. out)
                    print('Expected output: ' .. a1)
                    error()
                end
            end
        end
    end
end

