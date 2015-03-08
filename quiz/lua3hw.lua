local lua3hw = {}

function lua3hw.git_github(req)
    return
    '',
    'git',
    'github',
    'одновременно',
    'неизвестно',
    [[Что возникло раньше: git или github?]]
end

function lua3hw.git_init(req)
    return
    '',
    'git init',
    'git clone',
    'git add',
    'git commit',
    [[Какая команда git создает новый репозиторий?]]
end

function lua3hw.git_clone(req)
    return
    '',
    'git clone',
    'git init',
    'git add',
    'git commit',
    [[Какая команда git создаёт копию репозитория?]]
end

function lua3hw.git_add(req)
    return
    '',
    'git add',
    'git clone',
    'git init',
    'git commit',
    [[Какая команда git добавляет файлы в репозиторий?]]
end

function lua3hw.git_commit(req)
    return
    '',
    'git commit',
    'git add',
    'git clone',
    'git init',
    [[Какая команда git делает коммит?]]
end

function lua3hw.git_push(req)
    return
    '',
    'git push',
    'git add',
    'git clone',
    'git pull',
    [[Какая команда git отправляет коммиты в другой git?]]
end

function lua3hw.git_pull(req)
    return
    '',
    'git pull',
    'git push',
    'git add',
    'git clone',
    [[Какая команда git скачивает коммиты из другого git'а?]]
end

function lua3hw.pure_function(req)
    return
    '',
    [[
local function f(x)
    return function(y)
        return x ^ y
    end
end
    ]],
    [[
local t

local function f(x)
    t = x
    return function(y)
        return t ^ y
    end
end
    ]],
    [[
local function f(x, y)
    return math.sin(x) * math.cos(y)
end
    ]],
    [[
local function f()
    return math.random()
end
    ]],
    [[В каком из случаев функция f является чистой?]]
end

function lua3hw.closure(req)
    return
    [[
local function f(x)
    return function(y)
        return x ^ y
    end
end
local f2 = f(2)
print(f2(10))
print(f2(11))
print(f(3)(40))
print(f(3)(45))
print(f(4)(45))
    ]],
    '5',
    '4',
    '1',
    '7',
    [[Сколько замыканий создаёт этот код?]]
end

function lua3hw.variable_results(req)
    return
    '',
    'может', -- изменчивость может приходить из аргументов
    'не может',
    'может, если она использует внешние локальные переменные',
    'может, если все её аргументы неизменяемые типы',
    [[Может ли функция, не использующая глобальные
    переменные, возвращать разные значения при разных
    запусках с тем же набором аргументов?]]
end

function lua3hw.methods(req)
    return
    'cat:eat(mouse)',
    [[вызов метода eat объекта cat,
    передача mouse вторым аргументом]],
    [[вызов метода cat объекта eat,
    передача mouse вторым аргументом]],
    [[вызов метода eat объекта cat,
    передача mouse первым аргументом]],
    [[вызов метода cat объекта eat,
    передача mouse первым аргументом]],
    [[За что отвечает двоеточие в следующей записи?]]
end

function lua3hw.require(req)
    return
    '',
    'require',
    'assert',
    'import',
    'include',
    [[С помощью какой функции подключаются внешние модули?]]
end

local luafuncs = require 'quiz.luafuncs'

for i = 0, 9 do
    lua3hw["lua2text" .. i] = luafuncs.lua2text
end

for i = 0, 9 do
    lua3hw["text2lua" .. i] = luafuncs.text2lua
end

return lua3hw
