local lapis = require("lapis")
local http = require("lapis.nginx.http")
local csrf = require("lapis.csrf")
local tr_ru = require('tr_ru')
local random_token = require("random_token")

local fbb = require("fbb")
local preps = require("preps")
local kodomo = require("kodomo")
local model = require("model")
local quizs = require('quiz.all')

local app = lapis.Application()

app.layout = require("views.layout")

-- FIXME https://github.com/leafo/lapis/issues/188
app.__class:before_filter(function(self)
    local lang = self.session.lang
    local accept = self.req.headers['Accept-Language']
    if not lang and accept then
        lang = accept:sub(1, 2)
    end
    local _
    if lang == 'ru' then
        _ = tr_ru
    else
        _ = function(t) return t end
    end
    self._ = function(a, t)
        return _(t)
    end
    self.title = self:_("Kodomo Quiz")
end)

local check_csrf = function(f)
    return function(self)
        if not csrf.validate_token(self) then
            self.title = self:_("Permission denied")
            return self:_("Bad csrf token")
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
            if preps.as_dict[self.session.user] then
                self.prep = true
            end
            return f(self)
        end
    end)
end

local check_prep = function(f)
    return check_user(function(self)
        if not self.prep then
            self.title = self:_("Permission denied")
            return self:_("Only preps can see this page")
        else
            return f(self)
        end
    end)
end

local check_quiz = function(f)
    return check_user(function(self)
        if not self.quiz then
            self.quiz = model.Quiz:find(self.params.id)
        end
        if not self.quiz then
            return self:_("Can't find this quiz")
        end
        if self.quiz.user ~= self.session.user then
            -- preps can view finished quizes
            if not (self.quiz.state == model.FINISHED and
                    self.prep) then
                return self:_("It is not your quiz")
            end
        end
        return f(self)
    end)
end

local check_task = function(f)
    return function(self)
        self.task = model.Task:find(self.params.id)
        if not self.task then
            return self:_("Can't find this task")
        end
        self.quiz = self.task:quiz()
        return check_quiz(f)(self)
    end
end

app:get("index", "/", gen_csrf(function(self)
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

app:post("guest-login", "/login/guest",
check_csrf(function(self)
    self.session.user = 'guest' .. random_token()
    return {redirect_to = self:url_for('all-tests')}
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
        self.title = self:_("Permission denied")
        return self:_('error: invalid username')
    end
    local url = kodomo.url_of(user) .. self.session.filename
    local body, status_code, headers = http.simple(url)
    if not body:find(self.session.token) then
        self.title = self:_("Permission denied")
        return 'Error! Please make sure file ' ..
            '<a href="' .. url .. '">' .. url .. '</a>' ..
            ' exists and contains ' .. self.session.token ..
            '<br/><button onclick="window.history.back()">' ..
            'Go back</button>'
    end
    self.session.user = user
    return {redirect_to = self:url_for('all-tests')}
end))

app:post("logout", "/logout", check_user(function(self)
    self.session.user = nil
    return {redirect_to = self:url_for('index')}
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

app:get("quiz", "/tests/quiz/:id", check_quiz(function(self)
    if self.quiz.state == model.ACTIVE then
        if self.session.all_tasks then
            return {render='quiz-final-check'}
        else
            local fresh_task = self.quiz:fresh_task()
            if fresh_task then
                local url = self:url_for("task",
                    {id=fresh_task.id})
                return {redirect_to = url}
            else
                return {render='quiz-final-check'}
            end
        end
    elseif self.quiz.state == model.FINISHED then
        return {render='quiz-results'}
    elseif self.quiz.state == model.CANCELLED then
        return self:_("This quiz was canceled")
    end
    return "???"
end))

app:post("all-tasks", "/tests/quiz/:id/all-tasks",
check_quiz(function(self)
    self.session.all_tasks = true
    local url = self:url_for('quiz', {id=self.quiz.id})
    return {redirect_to = url}
end))

app:post("one-task", "/tests/quiz/:id/one-task",
check_quiz(function(self)
    self.session.all_tasks = nil
    local url = self:url_for('quiz', {id=self.quiz.id})
    return {redirect_to = url}
end))

app:get("task", "/tests/task/:id", check_task(function(self)
    if self.quiz.state ~= model.ACTIVE then
        return self:_("This quiz is not active")
    end
    return {render='task'}
end))

app:post("answer", "/tests/task/:id/answer",
check_task(function(self)
    if self.quiz.state ~= model.ACTIVE then
        return self:_("This quiz is not active")
    end
    local ans = tonumber(self.req.params_post.ans)
    self.task:update({selected = self.task:ans_i(ans)})
    local url = self:url_for('quiz', {id=self.quiz.id})
    url = url .. '#' .. self.task.name
    return {redirect_to = url}
end))

app:post("finish", "/tests/quiz/:id/finish",
check_quiz(function(self)
    if self.quiz.state ~= model.ACTIVE then
        return self:_("This quiz is not active")
    end
    self.quiz:finish()
    local url = self:url_for('quiz', {id=self.quiz.id})
    return {redirect_to = url}
end))

app:post("cancel", "/tests/quiz/:id/cancel",
check_quiz(function(self)
    if self.quiz.state ~= model.ACTIVE then
        return self:_("This quiz is not active")
    end
    self.quiz:update({state=model.CANCELLED})
    local url = self:url_for('quiz', {id=self.quiz.id})
    return {redirect_to = url}
end))

app:get("prep-quizs", "/admin", check_prep(function(self)
    return {render='prep-quizs'}
end))

app:get("quiz-state", "/admin/quiz-state",
check_prep(function(self)
    return {render='quiz-state'}
end))

app:post("set-quiz-state", "/admin/quiz-state/set",
check_prep(function(self)
    for name, _ in pairs(quizs) do
        local state = model.QuizState:find(name)
        if self.params[name] == 'on' then
            state:update({enabled=true})
        else
            state:update({enabled=false})
        end
    end
    local url = self:url_for('quiz-state')
    return {redirect_to=url}
end))

app:get("prep-quizs-today", "/admin/today",
check_prep(function(self)
    self.today_only = true
    return {render='prep-quizs'}
end))

app:get("prep-quizs-name", "/admin/name/:name",
check_prep(function(self)
    self.quiz_name = self.params.name
    return {render='prep-quizs-name'}
end))

app:get("prep-kr", "/admin/kr/:name",
check_prep(function(self)
    self.quiz_name = self.params.name
    return {render='prep-kr'}
end))

app:get("prep-quizs-of", "/admin/user/:user",
check_prep(function(self)
    self.target_user = self.params.user
    return {render='prep-quizs'}
end))

app:get("prep-quiz", "/admin/quiz/:id",
check_quiz(check_prep(function(self)
    return {render='quiz-results'}
end)))

app:get("russian", "/ru", function(self)
    self.session.lang = 'ru'
    return {redirect_to = self.req.headers.Referer}
end)

app:get("english", "/en", function(self)
    self.session.lang = 'en'
    return {redirect_to = self.req.headers.Referer}
end)

return app

