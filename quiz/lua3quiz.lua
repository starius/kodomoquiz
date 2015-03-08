local lua3quiz = {}

local luafuncs = require 'quiz.luafuncs'

for i = 1, 2 do
    lua3quiz["lua2text" .. i] = luafuncs.lua2text
end

for i = 1, 2 do
    lua3quiz["text2lua" .. i] = luafuncs.text2lua
end

return lua3quiz
