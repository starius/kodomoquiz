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

local funcs = {
["_G"] = "таблица глобальных переменных",
["_VERSION"] = "версия Lua",
["assert"] = "бросает ошибку, если аргумент ложный",
["dofile"] = "выполняет файл",
["error"] = "производит ошибку",
["ipairs"] = "итератор для обхода списка",
["pairs"] = "итератор для обхода словаря",
["loadstring"] = "переводит строку в функцию",
["pcall"] = "безопасный запуск функции",
["print"] = "печатает свои аргументы на экран",
["require"] = "подключает внешний модуль",
["tonumber"] = "переводит свой аргумент в число",
["tostring"] = "переводит свой аргумент в строку",
["type"] = "возвращает тип",
["unpack"] = "переводит таблицу-список в много результатов",
["io.open"] = "открывает файл",
["io.flush"] = "синхронирует стандартный поток вывода",
["io.lines"] = "итератор для обхода строк файла",
["io.stderr"] = "стандартный поток ошибок",
["io.stdin"] = "стандартный поток ввода",
["io.stdout"] = "стандартный поток вывода",
["file:close"] = "закрывает файл",
["file:flush"] = "синхронизирует файл с диском",
["file:lines"] = "итератор для обхода строк файла",
["file:read"] = "читает из файла",
["file:seek"] = "перейти к определенной позиции в файле",
["file:setvbuf"] = "настраивает буфер записи",
["file:write"] = "принимает строку и пишет её в файл",
["os.clock"] = "время, которое 'съел' текущий процесс",
["os.time"] = "метка времени",
["os.date"] = "текущая дата как строка",
["os.execute"] = "принимает команду и выполняет её",
["os.exit"] = "завершает текущий процесс",
["os.getenv"] = "выдаёт значение переменной окружения",
["os.remove"] = "удаляет файл",
["os.rename"] = "переименовывает файл",
["os.setlocale"] = "выставляет языковой стандарт",
["string.byte"] = "числовые значения символов строки",
["string.char"] = "переводит список байт в строку",
["string.dump"] = "переводит функцию в строку",
["string.find"] = "ищет в строке",
["string.format"] = "подставляет в строку-шаблон",
["string.gsub"] = "поиск и замена",
["string.len"] = "длина строки",
["string.lower"] = "перевод в нижний регистр",
["string.match"] = "проверка соответствия строки паттерну",
["string.rep"] = "возторяет строку несколько раз",
["string.reverse"] = "разворячивает строку",
["string.sub"] = "вырезает часть строки",
["string.upper"] = "перевод в заглавный регистр",
["table.concat"] = "объединяет элементы списка в строку",
["table.insert"] = "вставляет элемент в список",
["table.remove"] = "удаляет элемент списка",
["table.sort"] = "сортирует список",
}

local keys = {}
for k, v in pairs(funcs) do
    table.insert(keys, k)
end

local function makeSkeys()
    local selected = {}
    local skeys = {}
    for i = 1, 4 do
        local key
        while not key do
            local k = keys[math.random(1, #keys)]
            if not selected[k] then
                key = k
            end
        end
        selected[key] = true
        table.insert(skeys, key)
    end
    return skeys
end

local function lua2text()
    local skeys = makeSkeys()
    return
    skeys[1],
    funcs[skeys[1]],
    funcs[skeys[2]],
    funcs[skeys[3]],
    funcs[skeys[4]],
    [[Укажите описание следующей глобальной переменной:]]
end

local function text2lua()
    local skeys = makeSkeys()
    return
    funcs[skeys[1]],
    skeys[1],
    skeys[2],
    skeys[3],
    skeys[4],
    [[Какая переменная соответствует этому описанию:]]
end

for i = 0, 9 do
    lua3hw["lua2text" .. i] = lua2text
end

for i = 0, 9 do
    lua3hw["text2lua" .. i] = text2lua
end

return lua3hw
