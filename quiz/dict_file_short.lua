
local h = require('quiz.helpers')
local orig = require('quiz.dict_file')

local dict_file_short = {}

local group = h.make_group(dict_file_short, orig)

group('dict_get', 'dict_get_fake', 'dict_get_fake2')
group('dict_set', 'dict_set_fake', 'dict_set_fake2')
group('list_as_keys', 'list_as_keys2', 'list_as_keys3',
    'list_as_keys4')
group('slice1', 'slice_list', 'slice_list_to_end')
group('slice_rev')
group('open_file_r')
group('open_file_w')
group('close_file')
group('file_to_list')
group('write_int')
group('list_len')

return dict_file_short

