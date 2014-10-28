local lapis = require("lapis")
local csrf = require("lapis.csrf")
local load_mo_file = require("load_mo_file")

local fbb = require("fbb")
local preps = require("preps")

local app = lapis.Application()

local tr_ru = assert(load_mo_file(nil))

-- FIXME https://github.com/leafo/lapis/issues/188
app.__class:before_filter(function(self)
    local lang = self.req.headers['Accept-Language']:sub(1, 2)
    if lang == 'ru' then
        self._ = tr_ru
    else
        self._ = function(t) return t end
    end
end)

local check_user = function(f)
    return function(self)
        if not self.session.user then
            return {redirect_to='/'}
        else
            return f(self)
        end
    end
end

local check_prep = function(f)
    return check_user(function(self)
        if preps.as_dict[self.session.user] == nil then
            self.title = self._("Permission denied")
            return self._("Only preps can see this page")
        else
            return f(self)
        end
    end)
end

local check_csrf = function(f)
    return function(self)
        if not csrf.validate_token(self) then
            self.title = self._("Permission denied")
            return self._("Bad csrf token")
        else
            return f(self)
        end
    end
end

local gen_csrf = function(f)
    return function(self)
        self.new_csrf = csrf.generate_token(self)
        return f(self)
    end
end

app:get("/", function()
  return "Welcome to Lapis " .. require("lapis.version")
end)

return app
