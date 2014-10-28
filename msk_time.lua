return function(time)
    local p = "(%d+)-(%d+)-(%d+) (%d+):(%d+):(%d+)"
    local year, month, day, hour, min, sec = time:match(p)
    local time = os.time({year=year, month=month, day=day,
        hour=hour, min=min, sec=sec})
    local MSK = 3
    time = time + 3600 * MSK
    return os.date('%c', time)
end
