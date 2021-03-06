local c1quiz = {}

local typing = require 'quiz.typing'

c1quiz.typing_direct = typing.direct

c1quiz.typing_reverse = typing.reverse

function c1quiz.include_direction(req)
    return
    '',
    [[заголовочные файлы - в другие заголовочные файлы
    и файлы с исходным кодом]],
    [[файлы с исходным кодом - в другие файлы с исходным кодом
    и в заголовочные файлы]],
    [[заголовочные файлы - в файлы с исходным кодом]],
    [[файлы с исходным кодом - в заголовочные файлы]],
    [[Известно, что код на языке C пишут в заголовочные файлы
    и в файлы с исходным кодом. Также известно, что с помощью
    директивы #include можно включать содержимое одних файлов
    в другие. Какие файлы при этом включаются в состав каких?]]
end

function c1quiz.where_directives(req)
    return
    '',
    [[и в заголовочных файлах, и в файлах с исходным кодом]],
    [[только в заголовочных файлах]],
    [[только в файлах с исходным кодом]],
    [[только в batch-файлах]],
    [[Известно, что код на языке C пишут в заголовочные файлы
    и в файлы с исходным кодом. В каких из них могут
    встречаться директивы препроцессора?]]
end

function c1quiz.directives_char(req)
    return
    '',
    [[#]],
    [[%]],
    [[$]],
    [[@]],
    [[С какого символа начинаются директивы препроцессора?]]
end

function c1quiz.linking(req)
    local headers = math.random(3, 5)
    local sources = math.random(6, 8)
    return
    ([[Вася написал программу, состоящую из %i заголовочных
    файлов и %i файлов с исходным кодом. Сколько раз ему
    придётся запускать команду компиляции во время сборки
    программы?]]):format(headers, sources),
    tostring(sources),
    tostring(headers),
    tostring(headers + sources),
    tostring(headers * sources),
    ''
end

function c1quiz.headers_and_sources(req)
    if math.random(1, 2) == 1 then
        return
        [[Что хранится в заголовочных файлах?]],
        'объявления функций (declaration)',
        'определения функций (definition)',
        'реализации функций (implementation)',
        'субтитры к Игре престолов :)',
        ''
    else
        return
        [[Что хранится в файлах с исходным кодом?]],
        'определения функций (definition)',
        'объявления функций (declaration)',
        'интерфейс функций (interface)',
        'субтитры к Игре престолов :)',
        ''
    end
end

function c1quiz.progress_github(req)
    return
    'Опрос',
    [[да]],
    [[нет]],
    [[-]],
    [[не знаю]],
    [[Есть ли у вас аккаунт на Github?]]
end

function c1quiz.progress_repo_for_project(req)
    return
    'Опрос',
    [[да]],
    [[нет]],
    [[-]],
    [[не знаю]],
    [[Создан ли репозиторий вашего учебного проекта?]]
end

function c1quiz.progress_commit(req)
    return
    'Опрос',
    [[да]],
    [[нет]],
    [[-]],
    [[не знаю]],
    [[Сделали ли вы хотя бы один коммит?
    (Initial commit не считается)]]
end

function c1quiz.progress_gcc(req)
    return
    'Опрос',
    [[да]],
    [[нет]],
    [[-]],
    [[не знаю]],
    [[Удалось ли вам установить компилятор и прочие утилиты,
    необходимые для сборки программ, и собрать программу
    из нескольких файлов (считающую факториалы)?]]
end

return c1quiz
