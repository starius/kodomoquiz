local module = {}

module.as_list = {
'tuser',
'aba',
'dendik',
'artemov',
'manyashka',
'udavdasha',
'dasg',
'ase',
'feniouk',
'mgelfand',
'golovin',
'aegor',
'grishin',
'prep',
'ermakova',
'khrameeva',
'ishmudip',
'lan787',
'human',
'amironov',
'serge2006',
'snaumenko',
'anna',
'quant',
'psn',
'ok',
'bennigsen',
'abr',
'ravcheyev',
'irina',
'sheval_e',
'gsim',
'rust',
'sas',
'stavrovskaya',
'sutormin',
'tregubova',
'kinta',
'zanolia',
'dian',
'bnagaev',
}

module.as_dict = {}
for k, v in pairs(module.as_list) do
    module.as_dict[v] = 1
end

return module

