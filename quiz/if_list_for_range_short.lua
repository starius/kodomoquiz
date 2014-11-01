
local h = require('quiz.helpers')
local orig = require('quiz.if_list_for_range')

local ilfr_short = {}

local group = function(...)
    local orig_names = {...}
    local name = orig_names[1]
    local orig_funcs = {}
    for _, orig_name in ipairs(orig_names) do
        table.insert(orig_funcs, orig[orig_name])
    end
    assert(#orig_funcs >= 1)
    ilfr_short[name] = h.one_of_getter(h.unpack(orig_funcs))
end

group('odd_even', 'indentation_error', 'no_indentation_error')
group('in_str')
group('elif', 'nocolon_error')
group('strip')
group('split1', 'split2')
group('len')
group('test_or', 'test_and')
group('bool_expression')
group('list_index', 'index_error', 'negative_index')
group('append', 'fake_append')
group('range')
group('for2', 'test_while')

return ilfr_short

