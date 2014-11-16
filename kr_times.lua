local kr2date = {
    hello = '2014-10-31',
    if_list_for_range_short = '2014-11-07',
    dict_file_short = '2014-11-14',
    func_short = '2014-11-21',
}

local kr_times = {}

for kr, date in pairs(kr2date) do
    kr_times[kr] = {
        start1 = date .. ' ' .. '06:00:00',
        stop1 = date .. ' ' .. '06:30:00',
        start2 = date .. ' ' .. '07:55:00',
        stop2 = date .. ' ' .. '08:25:00',
    }
end

return kr_times

