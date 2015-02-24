local lua1hw = {}

function lua1hw.concat(req)
    return
    '',
    'a .. b',
    'a + b',
    'a . b',
    'a & b',
    'Какая операция в Lua объединяет строки?'
end

function lua1hw.ne(req)
    return
    '',
    'a ~= b',
    'a != b',
    'a <> b',
    'a == b',
    'Как в Lua будет "не равно" (в условиях)?'
end

function lua1hw.print(req)
    return
    '',
    'print(a)',
    'print a',
    'echo(a)',
    'echo a',
    'Как в Lua вывести на экран значение переменной a?'
end

function lua1hw.read(req)
    return
    '',
    'a = io.read()',
    'a = read()',
    'a = io.read("*n")',
    'a = read("*n")',
    'Как в Lua запросить ввод строки с клавиатуры в переменную a?'
end

function lua1hw.readn(req)
    return
    '',
    'a = io.read("*n")',
    'a = read("*n")',
    'a = io.read()',
    'a = read()',
    'Как в Lua запросить ввод числа с клавиатуры в переменную a?'
end

function lua1hw.tonumber_string(req)
    return
    '',
    'функция tonumber вернёт nil',
    'функция tonumber вернёт 0',
    'функция tonumber вернёт ""',
    'Lua бросит ошибку',
    [[Что произойдёт, если попытаться преобразовать строку
    "hello" в число при помощи tonumber?]]
end

function lua1hw.type_type(req)
    return
    '',
    '"string"',
    'зависит от x',
    'nil',
    '"type"',
    [[Чему равно type(type(x))?]]
end

function lua1hw.remove_key(req)
    return
    '',
    't.abc = nil',
    't.delete("abc")',
    't."abc" = nil',
    't = nil',
    [[Как удалить элемент таблицы t с ключом "abc"?]]
end

function lua1hw.index1(req)
    return
    '',
    '1',
    '0',
    'pi',
    'e',
    [[С какого числа принято начинать индексацию таблиц-списков в Lua?]]
end

function lua1hw.index0(req)
    return
    '',
    't = {[0] = 0}',
    't = {0 = 0}',
    't = {0: 0}',
    't = {["0"] = 0}',
    [[Как создать таблицу t, в которой есть элемент
    с индексом 0 и значением 0?]]
end

function lua1hw.key_type(req)
    return
    [[
    t = {}
    t[0] = 123
    t['0'] = 123
    ]],
    '2',
    '1',
    '0',
    '123',
    [[Сколько элементов будет в таблице, созданной следующим кодом?]]
end

function lua1hw.key_possible_types(req)
    return
    '',
    'любые типы, кроме nil',
    'строки, числа и логические переменные',
    'зависит от таблицы',
    'любые типы, кроме nil и таблиц',
    [[Элементы каких типов могут быть ключами таблицы?]]
end

function lua1hw.number_to_string(req)
    return
    '',
    't = {}; t[123] = "abc"',
    '"123" + 1',
    '"123" .. 1',
    '"123" * 1',
    [[В каком из этих случаев НЕ происходит автоматической
    конвертации типов string и number?]]
end

function lua1hw.convert_error(req)
    return
    '',
    '"123" + "a"',
    '"123" + "1"',
    '"123" * "1"',
    '123 .. 1',
    [[В каком из этих случаев будет брошена ошибка Lua?]]
end

function lua1hw.increment(req)
    return
    '',
    'x = x + 1',
    'x += 1',
    'x++',
    'x + 1',
    [[Как в Lua увеличить значение переменной x на 1?]]
end

function lua1hw.nil_var_type(req)
    return
    '',
    'глобальные',
    'локальные',
    'члены таблиц',
    'nil',
    [[Если использовать переменную с несуществующим названием,
    то к какому типу будет принадлежать эта переменная
    (именно переменная, а не её значение)?]]
end

function lua1hw.nil_data_type(req)
    return
    '',
    'nil',
    'глобальные',
    'локальные',
    'члены таблиц',
    [[Если использовать переменную с несуществующим названием,
    то к какому типу будет принадлежать её значение?]]
end

function lua1hw.logical_expr(req)
    return
    '',
    '(a and b) and not (a or b)',
    '(a and not b) or (b and not a)',
    'a ~= b',
    '(a or b) and not (a and b)',
    [[Переменные a, b хранят данные логического типа
    (true или false). Какое выражение НЕ соответствует
    данному утверждению:
    "из переменных a, b истинна ровно одна"?]]
end

function lua1hw.count_list(req)
    return
    '',
    '#t',
    't.size()',
    'len(t)',
    't.length',
    [[Как получить число элементов таблицы-списка t?]]
end

function lua1hw.count_table(req)
    return
    '',
    'пересчитать все члены таблицы t c помощью цикла и функции pairs',
    'пересчитать все члены таблицы t c помощью цикла и функции ipairs',
    '#t',
    '##t',
    [[Как получить число элементов таблицы-словаря t?]]
end

function lua1hw.for_range(req)
    return
    [[for i = 1, 3 do
        print(i)
    end]],
    '1 2 3',
    '1 2',
    '0 1 2',
    '0 1 2 3',
    [[Какие числа распечатает следующий код?]]
end

function lua1hw.for_range_step(req)
    return
    [[for i = 1, 3, 2 do
        print(i)
    end]],
    '1 3',
    '1 2',
    '1 2 3',
    '1 3 2',
    [[Какие числа распечатает следующий код?]]
end

function lua1hw.for_range_step_neg(req)
    return
    [[for i = 3, 1, -2 do
        print(i)
    end]],
    '3 1',
    '1 3',
    '3 2 1',
    '3 1 -2',
    [[Какие числа распечатает следующий код?]]
end

function lua1hw.for_ipairs_value(req)
    return
    [[for index, value in ipairs({5, 6, 7}) do
        print(value)
    end]],
    '5 6 7',
    '5 6',
    '1 2 3',
    '1 2',
    [[Какие числа распечатает следующий код?]]
end

function lua1hw.for_ipairs_index(req)
    return
    [[for index, value in ipairs({5, 6, 7}) do
        print(index)
    end]],
    '1 2 3',
    '5 6 7',
    '5 6',
    '1 2',
    [[Какие числа распечатает следующий код?]]
end

function lua1hw.for_ipairs_both(req)
    return
    [[for index, value in ipairs({5, 6, 7}) do
        print(index, value)
    end]],
    '1 5 2 6 3 7',
    '5 6 7',
    '1 2 3',
    'Error',
    [[Какие числа распечатает следующий код?]]
end

function lua1hw.repeat_until(req)
    return
    [[
    x = 0
    repeat
        x = x + 1
        print(x)
    until x == 3]],
    '1 2 3',
    '1 2',
    '0 1 2',
    '0 1',
    [[Какие числа распечатает следующий код?]]
end

function lua1hw.for_break(req)
    return
    '',
    'break',
    'last',
    'continue',
    'такого слова нет',
    [[Какое ключевое слово прерывает цикл?]]
end

function lua1hw.for_continue(req)
    return
    '',
    'такого слова нет',
    'break',
    'last',
    'continue',
    [[Какое ключевое слово приводит к переходу к следующей итерации цикла?]]
end

function lua1hw.pow(req)
    return
    '',
    '2 ^ 10',
    '2 ** 10',
    '10 ^ 2',
    '10 ** 2',
    [[Как рассчитать число 2 в степени 10?]]
end

function lua1hw.pow(req)
    return
    '',
    [[нельзя, так как в Lua используют нецелые числа,
    в которых младшие разряды больших чисел теряются]],
    [[нельзя, так как такое большое число не уместится
    в числовой тип, который используется в Lua]],
    [[можно, для этого надо число преобразовать в строку
    и взять в ней последний символ]],
    [[можно, для этого надо взять остаток от деления на 10]],
    [[Мы рассчитали число 2 в степени 100 в Lua.
    Можно ли с его помощью узнать, на какую цифру
    оканчивается число 2 в степени 100? Ответ объясните.]]
end

function lua1hw.table_def(req)
    return
    '',
    'таблицы',
    'строки',
    'ограничивают блоки кода',
    'комментарии',
    [[За что в Lua отвечают фигурные скобки { }?]]
end

function lua1hw.long_string(req)
    return
    '',
    'строки',
    'таблицы',
    'ограничивают блоки кода',
    'комментарии',
    'За что в Lua отвечают двойные квадратные скобки [[ ]]?'
end

function lua1hw.comments(req)
    return
    '',
    'комментарии',
    'строки',
    'таблицы',
    'ограничивают блоки кода',
    'За что в Lua отвечает запись --?'
end

function lua1hw.lua_country(req)
    return
    '',
    'Бразилия',
    'США',
    'Япония',
    'Россия',
    'В какой стране создали Lua?'
end

function lua1hw.lua_stresed(req)
    return
    '',
    '1',
    '2',
    '3',
    '4',
    'На какой слог падает ударение в слове Луа?'
end

function lua1hw.lua_translation(req)
    return
    '',
    'луна',
    'взять',
    'солнце',
    'лук',
    'Как lua переводится с португальского?'
end

return lua1hw
