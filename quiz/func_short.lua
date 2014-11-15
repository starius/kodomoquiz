
local h = require('quiz.helpers')
local orig = require('quiz.func')

local func_short = {}

local group = h.make_group(func_short, orig)

group('func_summ', 'func_arg_name', 'var_undefined')
group('sin', 'cos')
group('sin_rev')
group('argv')
group('argv1')
group('argv2')
group('system')
group('urllib2')
group('randint')
group('complement')

return func_short

