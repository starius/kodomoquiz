local FORMAT = "(%d+)-(%d+)-(%d+) (%d+):(%d+):(%d+)"

local function parseFT(str)
    local year, month, day, hour, min, sec = str:match(FORMAT)
    return os.time({year=year, month=month, day=day,
        hour=hour, min=min, sec=sec})
end

local function tzDiff()
    local t1 = parseFT(os.date("!%F %T", 0))
    local t2 = parseFT(os.date("%F %T", 0))
    return t2 - t1
end

local tz_diff

return function(utc_str)
    tz_diff = tz_diff or tzDiff()
    return os.time() - parseFT(utc_str) - tz_diff
end
