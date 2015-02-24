local lua2hw = {}

function lua2hw.statement1(req)
    return
    '',
    '=',
    '+',
    '..',
    'f()',
    [[Что из перечисленного является оператором?]]
end

function lua2hw.statement2(req)
    return
    '',
    'if',
    '~=',
    '==',
    'print',
    [[Что из перечисленного является оператором?]]
end

function lua2hw.operator1(req)
    return
    '',
    '==',
    '=',
    'if',
    'end',
    [[Что из перечисленного является операцией?]]
end

function lua2hw.highlevel(req)
    return
    '',
    'преимущественно в высокоуровневый',
    'преимущественно в низкоуровневый',
    'в оба',
    'ни в один',
    [[Код проекта А разделён на два слоя: низкоуровневый и
    высокоуровневый. Вася решил связать проект А с проектом Б.
    В какой из этих двух слоев проекта А придётся вносить
    код, работающий с кодом проекта Б?
    (При условии, что проекты А и Б написаны как следует.)]]
end

function lua2hw.selectlevel1(req)
    return
    '',
    'это сэкономит время и усилия команды',
    'верхние уровни разных программ совпадают чаще, чем нижние',
    'у команды есть опыт работы с используемыми библиотеками',
    'такой подход приводит к написанию более быстрого кода',
    [[Команда из 10 разработчиков должна написать код
    за 1 месяц. Какая причина может побудить их начать
    писать с верхнего уровня?]]
end

function lua2hw.selectc(req)
    return
    '',
    'C',
    'Python',
    'HTML',
    'Lua',
    [[В своем замечательном Lua-проекте разработчики решили
    оптимизировать низкоуровневый код на другом языке.
    Какой язык программирования они вероятно
    выберут для этого?]]
end

function lua2hw.selectlua(req)
    return
    '',
    'Lua',
    'C',
    'C++',
    'JavaScript',
    [[Команда разработчиков приступила к работе над новой
    Lua-библиотекой, в которой они планируют использовать
    Lua в связке с языком C. С какого языка им стоит
    начать писать?]]
end

function lua2hw.local_decl(req)
    return
    '',
    'local myvar',
    'myvar',
    'local myvar = true',
    'local myvar = nil',
    [[Как объявить локальную переменную с именем myvar?]]
end

function lua2hw.global_delete(req)
    return
    '',
    'myvar = nil',
    'global myvar = nil',
    'delete myvar',
    'myvar == nil',
    [[Как удалить глобальную переменную с именем myvar?]]
end

function lua2hw.local_delete(req)
    return
    '',
    [[локальная переременная никак не удалится,
        пока не закончится её область видимости]],
    'myvar = nil',
    'local myvar = nil',
    'объявить новую локальную переменную с именем myvar',
    [[Как удалить локальную переменную с именем myvar?]]
end

function lua2hw.local_assign(req)
    return
    '',
    'x = 1',
    'local x = 1',
    'x := 1',
    'local x := 1',
    [[Как присвоить значение 1 локальной переменной x?]]
end

function lua2hw.proced_lang(req)
    return
    '',
    'подпрограммы',
    'ветвление',
    'циклы',
    'классы',
    [[Что из этого отсутствует в структурном программировании,
    однако присутствует в процедурном программировании?]]
end

function lua2hw.proced_lang(req)
    return
    [[
print((function(x)
    return function(y)
        return x + y
    end
end)(1)(2))
    ]],
    '3',
    '1',
    '2',
    'Ошибка',
    [[Что распечатает следующий код на Lua?]]
end

function lua2hw.function_expression(req)
    return
    'function() return 1 end',
    'функцию',
    '1',
    'nil',
    'ошибку',
    [[Что возвращает следующее выражение?]]
end

function lua2hw.function_is_anonymous(req)
    return
    '',
    '[0, +∞)',
    '[1, +∞)',
    '[1, 1]',
    '[0, 1]',
    [[Под сколькими именами может быть известна
    одна и та же функция в Lua?]]
end

function lua2hw.closure(req)
    return
    [[
local f = function(x)
    x = x * 2
    return function(y)
        x = x + y
        return x
    end
end

local n = 100
local f1 = f(n)
f1(50)
print(n)
    ]],
    '100',
    '150',
    '250',
    'Ошибка',
    [[Что распечатает следующий код на Lua?]]
end

function lua2hw.number_of_args(req)
    return
    [[
local function f(...)
    print(#{...})
end

f(5, 6, 7)
    ]],
    '3',
    '5 6 7',
    '5',
    'Ошибка',
    [[Что распечатает следующий код на Lua?]]
end

function lua2hw.falsy(req)
    return
    'true, false, nil, 0, 1, {}, ""',
    'false, nil',
    'false, nil, 0, {}, {}',
    'false, nil, 0, {}',
    'false, nil, 0',
    [[Какие из этих значений считаются ложными?]]
end

function lua2hw.truthy(req)
    return
    [[
local x = 0
if x then
    print('x')
else
    print('not x')
end
    ]],
    'x',
    'not x',
    'not x, x',
    'x, not x',
    [[Что распечатает следующий код на Lua?]]
end

function lua2hw.declaration(req)
    return
    '',
    'local a, b = true, false',
    'local a = true, b = false',
    'a, b = true, false',
    'a = true, b = false',
    [[Как одновременно создать две локальные переменные
    a и b и положить в них значения true и false
    соответственно?]]
end

function lua2hw.interactive_locals(req)
    return
    [[
> f = function(x) return x + 1 end
> local x = f(100)
> print(x)
    ]],
    'nil',
    '100',
    '101',
    'error',
    [[Что будет распечатано, если в интерактивном режиме
    набрать следующие команды?]]
end

function lua2hw.global_functions(req)
    return
    '',
    'глобальные переменные',
    'функции',
    'особый вид переменных',
    'продедуры',
    [[К какому типу переменных относятся встроенные функции,
    например print?]]
end

function lua2hw.change_print(req)
    return
    '',
    [[
local original_print = print
print = function(...)
    original_print('hello', ...)
end
]],
    [[
print = function(...)
    print('hello', ...)
end
]],
    [[
local original_print = print
print = function(...)
    original_print('hello')
    original_print(...)
end
]],
    [[
local print = function(...)
    print('hello', ...)
end
]],
    [[Что нужно сделать, чтобы print при запуске
    в любом месте кода перед выдачей в той же строке
    печатал слово hello?]]
end

return lua2hw
