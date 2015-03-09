local c1hw = {}

local typing = require 'quiz.typing'

for i = 1, 3 do
    c1hw["typing_direct_" .. i] = typing.direct
end

for i = 1, 3 do
    c1hw["typing_reverse_" .. i] = typing.reverse
end

function c1hw.c_born(req)
    return
    '',
    '1969—1973',
    '1950—1952',
    '1991—1993',
    '1998—2001',
    [[Когда был создан язык C?]]
end

function c1hw.c_file(req)
    return
    '',
    '.c',
    '.h',
    '.C',
    '.a',
    [[Какое расширение имеют сишные файлы с исходным кодом?]]
end

function c1hw.h_file(req)
    return
    '',
    '.h',
    '.c',
    '.a',
    '.o',
    [[Какое расширение имеют заголовочные файлы?]]
end

function c1hw.headers_and_source_files(req)
    return
    '',
    'Заголовочные файлы и файлы с исходным кодом',
    'Объектные и файлы препроцессора',
    'Файлы с расширением .C',
    'Файлы с расширением .a',
    [[Какие типы файлов пишет программист на языке C?]]
end

function c1hw.headers_with_declarations(req)
    return
    '',
    'объявления функций (declaration)',
    'определения функций (definition)',
    'реализации функций (implementation)',
    'SQL-запросы к базе данных (SQL queries)',
    [[Что хранится в заголовочных файлах?]]
end

function c1hw.sources_with_definitions(req)
    return
    '',
    'определения функций (definition)',
    'объявления функций (declaration)',
    'интерфейс функций (interface)',
    'SQL-запросы к базе данных (SQL queries)',
    [[Что хранится в файлах с исходным кодом (.c)?]]
end

function c1hw.preprocessing(req)
    return
    '',
    'препроцессинг',
    'условная компиляция',
    'компиляция',
    'компоновка',
    [[На каком этапе сборки происходит включение
    используемых заголовочных файлов?]]
end

function c1hw.compilation(req)
    return
    '',
    'компиляция',
    'препроцессинг',
    'линковка',
    'компоновка',
    [[На каком этапе сборки происходит образование
    файлов с объектным кодом?]]
end

function c1hw.linking(req)
    return
    '',
    'компоновка',
    'компиляция',
    'препроцессинг',
    'инкапсуляция',
    [[На каком этапе сборки происходит объединение
    нескольких файлов с объектным кодом?]]
end

function c1hw.gcc_compilation(req)
    return
    '',
    'gcc -c file.c -o file.o',
    'gcc file.c -o file.o',
    'gcc -c file.o -o file.c',
    'gcc file.o -o file.c',
    [[Какая команда отвечает за компиляцию?]]
end

function c1hw.gcc_linking(req)
    return
    '',
    'gcc file1.o file2.o -o prog.exe',
    'gcc file1.o file2.o prog.exe',
    'gcc -c file1.o file2.o -o prog.exe',
    'gcc -c file1.o file2.o prog.exe',
    [[Какая команда отвечает за компоновку?]]
end

function c1hw.libs(req)
    return
    '',
    'статическая и динамическая',
    'явная и неявная',
    'сильная и слабая',
    'строгая и нестрогая',
    [[Какие типы компоновки бывают?]]
end

function c1hw.include(req)
    return
    '',
    '#include',
    '#import',
    '#require',
    '#ifndef',
    [[Какая директива препроцессора служит для подключения
    заголовочных файлов?]]
end

function c1hw.include(req)
    return
    '',
    '#ifndef XXX',
    '#ifdef XXX',
    '#if XXX',
    '#if !XXX',
    [[Какая директива препроцессора проверяет, что
    макрос XXX не определен?]]
end

function c1hw.comments(req)
    return
    '',
    '//',
    '--',
    '#',
    '%',
    [[Как в C сделать однострочный комментарий?]]
end

function c1hw.comments2(req)
    return
    '',
    '/* ... */',
    '{ ... }',
    '[[ ... ]]',
    '{{ ... }}',
    [[Как в C сделать многострочный комментарий?]]
end

return c1hw
