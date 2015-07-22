local function group(names)
    local g = {}
    for _, name in ipairs(names) do
        local ok, module = pcall(require, 'quiz.' .. name)
        if not ok then
            local helpers = require 'quiz.helpers'
            local yml = ('quiz/%s.yml'):format(name)
            module = helpers.fromYamlFile(yml)
        end
        table.insert(g, {name, module})
    end
    return g
end

return {
    {'Python', group {
        'hello',
        'if_list_for_range',
        'if_list_for_range_short',
        'dict_file',
        'dict_file_short',
        'func',
        'func_short',
    }},

    {'Logic', group {
        'logic',
        'logic_defs',
    }},

    {'LuaAndC', group {
        'lua0',
        'lua1hw',
        'lua1quiz',
        'lua2hw',
        'lua2quiz',
        'lua3hw',
        'lua3quiz',
        'c1',
        'c1quiz',
        'c2',
    }},
}
