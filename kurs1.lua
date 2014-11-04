
local kurs1 = {}

kurs1.group1 = {
'akmarina',
'dbadmaev',
'polina_bai',
'e.biryukova',
'boyko.s',
'polietilenglikol',
'vladislaw_aesc',
'gorbokonenko',
'denisgrishaev96',
'e.dontsov',
'efremov_aleks',
'nuts',
'danil.zuev',
'ivanova_sd',
'ilnitsky',
'arinka',
'anandia',
'neoblako',
'maria',
'chlamidomonas',
'nooroka',
'crescent8547',
'sstarikov',
'tana_shir',
}

kurs1.group2 = {
'ivan',
'batyrsha',
'pvolk96',
'diankin',
'nataliya.kashko',
'nknjasewa',
'a.kozlova',
'kolupaeva',
'askorzina',
'explover',
'mnikolaev',
'polina-na',
'elenaoch',
'ranhummer',
'dariya.portugalskaya',
'riuminkd',
'margarita',
'grigorij',
'froltasa',
'chaplyk',
'arma',
'talianash',
'a_lex'
}

kurs1.excel_list = {}
for _, stud in ipairs(kurs1.group1) do
    table.insert(kurs1.excel_list, stud)
end
for _, stud in ipairs(kurs1.group2) do
    table.insert(kurs1.excel_list, stud)
end

return kurs1

