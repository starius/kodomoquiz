local lua0 = {}

function lua0.recursion(req)
    return
    '',
    'рекурсия',
    'возврат',
    'цикл',
    'ветвление',
    'вызов функции изнутри этой же функции - ...'
end

function lua0.operator(req)
    return
    '',
    'операция',
    'оператор',
    'ключевое слово',
    'вызов',
    [[Как английское слово "operator" переводится на русский
    в контексте программирования?]]
end

function lua0.sort(req)
    return
    '',
    'сортировка',
    'процеживание',
    'поиск',
    'разложение',
    'упорядочивание элементов списка от меньшего к большему - ...'
end

function lua0.two100(req)
    return
    '',
    '6',
    '2',
    '4',
    '8',
    'На какую цифру оканчивается число 2 в степени 100?'
end

function lua0.consequence(req)
    return
    '',
    [["если функция не является непрерывной в данной точке,
    то она не дифференцируема в данной точке"]],
    [["если функция является непрерывной в данной точке,
    то она дифференцируема в данной точке"]],
    [["если функция не дифференцируема в данной точке,
    то она не является непрерывной в данной точке"]],
    [["если функция дифференцируема в данной точке,
    то она не является непрерывной в данной точке"]],
    [[Какое из утверждений является следствием утверждения
    "если функция дифференцируема в данной точке,
    то она непрерывна в данной точке"?]]
end

function lua0.DeMorgan(req)
    return
    '',
    [["В доме не более 5 этажей или более 3 подъездов"]],
    [["В доме менее 5 этажей или более 3 подъездов"]],
    [["В доме не более 5 этажей и более 3 подъездов"]],
    [["В доме менее 5 этажей и более 3 подъездов"]],
    [[Какое из утверждений является отрицанием утверждения
    "В доме более 5 этажей и не более 3 подъездов"?]]
end

return lua0
