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

return {
    lua2text = lua2text,
    text2lua = text2lua,
}
