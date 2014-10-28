local lapis = require("lapis")
local app = lapis.Application()

local fbb = require("fbb")
local preps = require("preps")

local _ = function(t) return t end

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
            self.title = _("Permission denied")
            return _("Only preps can see this page")
        else
            return f(self)
        end
    end)
end

app:get("/", function()
  return "Welcome to Lapis " .. require("lapis.version")
end)

return app
