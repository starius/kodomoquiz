local lua2quiz = {}

function lua2quiz.function_returns_table(req)
    return
    '',
    [[function() return {} end]],
    [[{func = function() end}]],
    [[func = function() end]],
    [[function(x) x = {} end]],
    [[Выберите код функции, возвращающей таблицу]]
end

function lua2quiz.change_argument(req)
    return
    '',
    [[
local x = 1
local f = function()
    x = 2
end
f()
print(x)
]],
    [[
local x = 1
local f = function(x)
    x = 2
end
f(x)
print(x)
]],
    [[
local t = {x = 1}
local f = function(t)
    t.x = 2
end
f({x = 2})
print(t.x)
]],
    [[
local x = 1
local f = function()
    local x
    x = 2
end
f()
print(x)
]],
    [[Выберите код, печатающий число 2]]
end

function lua2quiz.returns_1_and_2(req)
    return
    [[
local x = 1
local function f()
    if x == 1 then
        x = 2
    else
        x = 1
    end
    return x
end]],
    'возвращает по очереди 1 и 2, начинает с 2',
    'возвращает по очереди 1 и 2, начинает с 1',
    'возвращает всё время 2',
    'возвращает всё время 1',
    [[Как ведёт себя функция f?]]
end

function lua2quiz.swap_vars(req)
    return
    '',
    'x, y = y, x',
    'local x, y = y, x',
    'local x = y, y = x',
    'x = y, y = x',
    [[Как поменять местами значения локальных
    переменных x и y?]]
end

function lua2quiz.if_returns_same_for_x_and_y(req)
    return
    [[
local f = function(g)
    return function(x, y)
        return g(x) == g(y)
    end
end

print(f(function(a)
    return a % 10
end)(15, 25))
    ]],
    'true',
    'false',
    'nil',
    'Error',
    [[Что распечатает следующий код?]]
end

function lua2quiz.scope(req)
    return
    [[
local function f(x)
    local a = 1
    -- (1)
    if x == 2 then
        a = 100
        -- (2)
    end
    -- (3)
end
-- (4)
    ]],
    '(3)',
    '(1)',
    '(2)',
    '(4)',
    [[На какой строке завершается область видимости переменной a?]]
end

return lua2quiz
