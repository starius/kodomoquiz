local date = require("date")
local lapis = require("lapis")
local http = require("lapis.nginx.http")
local csrf = require("lapis.csrf")
local db = require("lapis.db")
local tr_ru = require('tr_ru')
local random_token = require("random_token")
require('httpclient') -- httprequest
local config = require("lapis.config").get()

local fbb = require("fbb")
local preps = require("preps")
local kodomo = require("kodomo")
local model = require("model")
local quizs = require('quiz.all')

local app = lapis.Application()

app.layout = require("views.layout")

app.cookie_attributes = function(self)
    local expires = date(true):adddays(365):fmt("${http}")
    return "Expires=" .. expires .. "; Path=/; HttpOnly"
end

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
        local key = self.session.key
        local csrf_ok, msg = csrf.validate_token(self, key)
        if not key or not csrf_ok then
            self.title = self:_("Permission denied")
            return self:_("Bad csrf token") .. ' ' .. msg
        else
            return f(self)
        end
    end
end

local gen_csrf = function(f)
    return function(self)
        local key = self.session.key
        if not key then
            key = 'csrf' .. random_token()
            self.session.key = key
        end
        self.new_csrf = csrf.generate_token(self, key)
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
                return self:_([[It is not your quiz and
                    it is canceled]])
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

app:post("push-quiz", "/quiz/push/:id",
check_user(check_quiz(function(self)
    model.upload_quiz(self.quiz)
    --
    local url = self:url_for('quiz', {id=self.quiz.id})
    return {redirect_to = url}
end)))

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

-- submissions

app:post("new-submission", "/submission/new",
check_user(function(self)
    local file = self.params.uploaded_file
    if not file or not file.filename or
            file.filename == '' then
        return 'No file uploaded'
    end
    local filename = file.filename
    local text = file.content
    local tmpname = os.tmpname()
    do
        local f = io.open(tmpname, 'w')
        f:write(text)
        f:close()
    end
    local f = io.open(tmpname, 'r')
    local httprequest = httpclient.httprequest
    local resp = httprequest(config.checker_url, {
        data = {
            uploaded_file = {
                file = f,
                name = filename,
                type = 'text/plain'
            },
        }
    })
    os.remove(tmpname)
    if resp.status ~= 200 then
        return 'Bad response from back-end'
    end
    local body = resp.body
    local s = model.new_submission(self, filename, text, body)
    --
    local url = self:url_for('submission', {id=s.id})
    return {redirect_to = url}
end))

app:post("push-submission", "/submission/push/:id",
check_user(function(self)
    local s = model.Submission:find({id=self.params.id})
    model.upload_submission(s)
    --
    local url = self:url_for('submission', {id=s.id})
    return {redirect_to = url}
end))

app:get("submission", "/submission/:id",
check_user(function(self)
    self.submission = model.Submission:find({id=self.params.id})
    if self.submission.user ~= self.session.user then
        return 'Access denied'
    end
    return {render='submission'}
end))

-- admin

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
        if self.params[name] == 'on' and not state.enabled then
            state:update({enabled=true})
        elseif self.params[name] ~= 'on' and state.enabled then
            state:update({enabled=false})
        end
    end
    local url = self:url_for('all-tests')
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

app:get("prep-submissions-download", "/admin/submission/download",
check_prep(function(self)
    local submissions = db.select [[
        DISTINCT ON (submission.user, task)
        submission.user, task, filename, text
        FROM submission
        ORDER BY submission.user, task, rating desc, created_at desc
    ]]
    local tmpname = os.tmpname()
    local tmpdir = tmpname .. '.dir'
    local path = tmpdir .. '/submissions/'
    os.execute('mkdir -p ' .. path)
    for _, submission in ipairs(submissions) do
        local dir = path .. submission.user
        os.execute('mkdir -p ' .. dir)
        local fname = ('%s/%s_%s'):format(dir,
            submission.task, submission.filename)
        local f = io.open(fname, 'w')
        f:write(submission.text)
        f:close()
    end
    local tar = tmpdir .. '/submissions.tar.gz'
    os.execute(('tar -czf %s -C %s .'):format(tar, tmpdir))
    local f = io.open(tar)
    local tar_data = f:read('*a')
    f:close()
    os.execute('rm -r ' .. path .. ' ' .. tmpdir)
    ngx.header['Content-Disposition'] =
        'inline; filename="submissions.tar.gz"'
    return {
        content_type = 'application/x-compressed',
        layout = false,
        tar_data,
    }
end))

app:get("prep-submission", "/admin/submission/:id",
check_prep(function(self)
    self.submission = model.Submission:find({id=self.params.id})
    return {render='submission'}
end))

app:get("prep-submissions", "/admin/submission/",
check_prep(function(self)
    return {render='prep-submissions'}
end))

app:post("update-code", "/admin/update-code",
check_prep(function(self)
    os.execute('git pull && make && killall -s SIGHUP nginx')
    local url = self:url_for('all-tests')
    return {redirect_to=url}
end))

-- languages

app:get("russian", "/ru", function(self)
    self.session.lang = 'ru'
    return {redirect_to = self.req.headers.Referer}
end)

app:get("english", "/en", function(self)
    self.session.lang = 'en'
    return {redirect_to = self.req.headers.Referer}
end)

return app

