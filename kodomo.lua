local KODOMO = 'kodomo.fbb.msu.ru'

local kodomo = {}

function kodomo.url_of(user)
    return 'http://' .. KODOMO .. '/~' .. user .. '/'
end

function kodomo.a_of(u)
    return '<a href="' .. kodomo.url_of(u) ..
        '" target="_blank">' .. u ..'</a>'
end

return kodomo

