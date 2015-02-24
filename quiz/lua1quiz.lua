local lua1quiz = {}

function lua1quiz.greeter(req)
    return
    '',
    '>',
    '$',
    '#',
    '%',
    [[Каким символом интерпретатор Lua приветствует
    пользователя в интерактивном режиме?]]
end

function lua1quiz.operator(req)
    return
    '',
    'operator',
    'statement',
    'function',
    'call',
    [[Как русское слово "операция" переводится на английский
    в контексте программирования?]]
end

function lua1quiz.table_field(req)
    return
    '',
    '{["abc"] = 2}',
    '{[abc] = 2}',
    '{["abc"] = "2"}',
    '{[abc] = "2"}',
    [[Как создать таблицу с полем "abc" со значенем 2?]]
end

function lua1quiz.table_is_not_cloned(req)
    return
    [[
x = {}
x.abc = 123
y = x
y.abc = 456
print(x.abc)
    ]],
    '456',
    'abc',
    '123',
    'ошибка',
    [[Что выведет следующий Lua-код?]]
end

function lua1quiz.ne(req)
    return
    '',
    'a ~= b',
    'a != b',
    'a <> b',
    'a == b',
    'Как в Lua будет "не равно" (в условиях)?'
end

function lua1quiz.key_type(req)
    return
    [[
    t = {}
    t[{}] = 123
    t[{}] = 123
    ]],
    '2',
    '1',
    '0',
    'код выкинет ошибку',
    [[Сколько элементов будет в таблице,
    созданной следующим кодом?]]
end

return lua1quiz
