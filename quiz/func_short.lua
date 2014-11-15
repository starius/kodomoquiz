
local h = require('quiz.helpers')
local orig = require('quiz.func')

local func_short = {}

local group = h.make_group(func_short, orig)

group('func_summ', 'func_arg_name', 'var_undefined')
group('sin', 'cos', 'sin_rev')
group('argv', 'argv1', 'argv2')
group('complement')
group('system')
group('urllib2')
group('randint')

return func_short

