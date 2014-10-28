local lapis = require("lapis")
local http = require("lapis.nginx.http")
local csrf = require("lapis.csrf")
local tr_ru = require('tr_ru')
local random_token = require("random_token")

local fbb = require("fbb")
local preps = require("preps")
local kodomo = require("kodomo")
local model = require("model")

local app = lapis.Application()

-- FIXME https://github.com/leafo/lapis/issues/188
app.__class:before_filter(function(self)
    local lang = self.req.headers['Accept-Language']:sub(1, 2)
    local _
    if lang == 'ru' then
        _ = tr_ru
    else
        _ = function(t) return t end
    end
    self._ = function(a, b)
        if b then
            return _(b)
        else
            return _(a)
        end
    end
    self.title = self._("Kodomo Quiz")
end)

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

local any_csrf = function(f)
    return function(self)
        if next(self.req.params_post) then
            -- POST
            return gen_csrf(check_csrf(f))(self)
        else
            return gen_csrf(f)(self)
        end
    end
end

local check_user = function(f)
    return any_csrf(function(self)
        if not self.session.user then
            return {redirect_to='/'}
        else
            return f(self)
        end
    end)
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

app:get("/", gen_csrf(function(self)
    if self.session.user then
        return {redirect_to = self:url_for('all-tests')}
    else
        if not self.session.token then
            self.session.token = random_token()
        end
        if not self.session.filename then
            self.session.filename = 'kodomoquiz-' ..
                random_token() .. '.txt'
        end
        return {render = 'welcome'}
    end
end))

app:post("login", "/login", check_csrf(function(self)
    if not self.session.token then
        return 'error: no session token'
    end
    if not self.session.filename then
        return 'error: no filename token'
    end
    local user = self.req.params_post.user
    if fbb.as_dict[user] == nil then
        self.title = self._("Permission denied")
        return self._('error: invalid username')
    end
    local url = kodomo.url_of(user) .. self.session.filename
    local body, status_code, headers = http.simple(url)
    if not body:find(self.session.token) then
        self.title = self._("Permission denied")
        return 'Error! Please make sure file ' ..
            '<a href="' .. url .. '">' .. url .. '</a>' ..
            ' exists and contains ' .. self.session.token ..
            '<br/><button onclick="window.history.back()">' ..
            'Go back</button>'
    end
    self.session.user = user
    return {redirect_to = self:url_for('all-tests')}
end))

app:get("schema", "/schema", function()
    model.create_schema()
end)

app:get("all-tests", "/tests", check_user(function(self)
    return {render='all-tests'}
end))

app:post("new-quiz", "/tests/new", check_user(function(self)
    local quiz = model.new_quiz(self)
    local url = self:url_for('quiz', {id=quiz.id})
    return {redirect_to = url}
end))

app:get("quiz", "/tests/quiz/:id", check_user(function(self)
    -- TODO
    return tostring(self.params.id)
end))

return app

