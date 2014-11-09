local a = {}

a.all = {}
a.all.hello = require('quiz.hello')
a.all.if_list_for_range = require('quiz.if_list_for_range')
a.all.if_list_for_range_short =
    require('quiz.if_list_for_range_short')
a.all.dict_file = require('quiz.dict_file')
a.all.dict_file_short = require('quiz.dict_file_short')

local all = a.all

a.available = {}
a.available.dict_file_short = all.dict_file_short
a.available.dict_file = all.dict_file
a.available.if_list_for_range = all.if_list_for_range
a.available.hello = all.hello

return a

