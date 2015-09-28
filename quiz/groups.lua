local function group(names)
    local g = {}
    for _, name in ipairs(names) do
        local ok, module = pcall(require, 'quiz.' .. name)
        if not ok then
            local helpers = require 'quiz.helpers'
            local yml = ('quiz/%s.yml'):format(name)
            local ok = pcall(function()
                module = helpers.fromYamlFile(yml)
            end)
            if not ok then
                print("Can't load " .. name)
                module = {}
            end
        end
        table.insert(g, {name, module})
    end
    return g
end


local file = io.open('quiz/groups.yml', 'r')
local yml = file:read('*all')
file:close()

local yaml = require 'yaml'
local groups_yml = yaml.load(yml)

local groups = {}

for i, g in ipairs(groups_yml) do
    local name, quizs = next(g)
    groups[i] = {name, group(quizs)}
end

return groups
