local math = require("math")

math.randomseed(os.time())

local h = require('quiz.helpers')
local f = h.f
local _ = h._
local task = h.task
local task2 = h.task2
local shortrand = h.shortrand
local zeroless = h.zeroless

local bioinf1 = {}

function bioinf1.complement(req)
    local text = 'A' .. h.atgc_rand(10) .. 'G'
    return
    text,
    h.complement(text),
    text,
    text:reverse(),
    text:gsub('%w', {A='T', T='A', G='C', C='G'}),
    [[Дана последовательность одной цепочки ДНК.
    Напишите последовательность комплементарной цепочки]]
end

function bioinf1.chr46(req)
    return
    '',
    '46',
    '23',
    '24',
    '48',
    'Сколько хромосом в ядре одной соматической клетки человека?'
end

function bioinf1.chrXY(req)
    return
    '',
    'половыми хромосомами: у мужчины X и Y хромосомы, у женщины две X хромосомы',
    'половыми хромосомами: у женщины X и Y хромосомы, у мужчины две Y хромосомы',
    'у мужчины на одну половую хромосому больше',
    'у женщины на одну половую хромосому больше',
    'Чем отличаются наборы хромосом у мужчины и у женщины?'
end

function bioinf1.daltonism(req)
    return
    '',
    'Потому что дефект, вызывающий дальтонизм, располагается на X-хромосоме',
    'Потому что дефект, вызывающий дальтонизм, располагается на Y-хромосоме',
    'Потому что мужчин чаще проверяют на дальтонизм (финский армейский тест)',
    'Все ответы неправильные',
    'Почему дальтонизм встречается чаще у мужчин, чем у женщин?'
end

return bioinf1
