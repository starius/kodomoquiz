local date = require("date")
local schema = require("lapis.db.schema")
local Model = require("lapis.db.model").Model
local config = require("lapis.config").get()

local quizs = require('quiz.all')
local shuffle = require('quiz.helpers').shuffle
local kr_times = require('kr_times')
local rating_uploader = require('rating_uploader')

local model = {}

model.ACTIVE = 1
model.CANCELLED = 2
model.FINISHED = 3

function model.create_schema()
    local types = {
        text = schema.types.text,
        varchar = schema.types.varchar,
        integer = schema.types.integer,
        boolean = schema.types.boolean,
    }
    if config.postgres then
        types.id = schema.types.serial({primary_key=true})
        types.foreign_key = schema.types.foreign_key
        types.datetime = schema.types.time
    elseif config.mysql then
        types.id = schema.types.id
        types.foreign_key = schema.types.integer
        types.datetime = schema.types.datetime
    else
        error('Unknown database type')
    end

    schema.create_table("submission", {
        {"id", types.id},
        {"filename", types.varchar},
        {"text", types.text},
        {"log", types.text},
        {"pr", types.varchar},
        {"task", types.varchar},
        {"user", types.varchar},
        {"created_at", types.datetime},
        {"updated_at", types.datetime},
        {"rating", types.varchar},
        {"ip", types.varchar},
        {"ua", types.varchar},
    })

    schema.create_table("task", {
        {"id", types.id},
        {"quiz_id", types.foreign_key},
        {"name", types.varchar},
        {"text", types.varchar},
        {"a1", types.varchar},
        {"a2", types.varchar},
        {"a3", types.varchar},
        {"a4", types.varchar},
        {"sequence", types.varchar}, -- e.g. "2143"
        {"selected", types.integer},
    })

    schema.create_table("quiz", {
        {"id", types.id},
        {"name", types.varchar},
        {"user", types.varchar},
        {"created_at", types.datetime},
        {"updated_at", types.datetime},
        {"tasks", types.integer},
        {"answers", types.integer},
        {"right_answers", types.integer},
        {"state", types.integer},
        {"ip", types.varchar},
        {"ua", types.varchar},
    })
    schema.create_index('quiz', 'user')
    schema.create_index('quiz', 'created_at')
    schema.create_index('quiz', 'state')

    schema.create_table("quiz-state", {
        {"name", types.varchar({primary_key=true})},
        {"enabled", types.boolean},
    })
    for quiz_name, _ in pairs(quizs) do
        if not model.QuizState:find(quiz_name) then
            model.QuizState:create(
                {name=quiz_name, enabled=true})
        end
    end
end

model.Submission = Model:extend("submission", {
    timestamp = true,
})

model.Task = Model:extend("task", {
    quiz = function(self)
        if not self._quiz then
            self._quiz = model.Quiz:find({id=self.quiz_id})
        end
        return self._quiz
    end,

    ans_i = function(self, i)
        assert(i >= 1)
        assert(i <= 4)
        return tonumber(self.sequence:sub(i, i))
    end,

    ans = function(self, i)
        return self['a' .. self:ans_i(i)]
    end,

    score = function(self)
        local t = ''
        if self.selected == 1 then
            t = '1'
        elseif self.selected > 1 then
            t = '0'
        end
        return t
    end,

    color = function(self)
        local t = 'white'
        if self.selected == 1 then
            t = 'green'
        elseif self.selected > 1 then
            t = 'red'
        end
        return t
    end,
})

model.Quiz = Model:extend("quiz", {
    timestamp = true,

    anchor = function(self, req)
        local url = req:url_for('quiz', {id=self.id})
        return string.format('<a href="%s">%s</a>',
            url, self.name)
    end,

    finish = function(self)
        local answers = 0
        local right_answers = 0
        for _, task in ipairs(self:all_tasks()) do
            if task.selected == 1 then
                right_answers = right_answers + 1
            end
            if task.selected ~= 0 then
                answers = answers + 1
            end
        end
        self:update({state = model.FINISHED,
            answers = answers, right_answers = right_answers,
        })
        if config.rating_uploader then
            local login = self.user
            local task = 'quiz.' .. self.name
            local rating = self.right_answers
            rating_uploader(login, task, rating)
        end
    end,

    fresh_task = function(self)
        local all_fresh = model.Task:select(
            "where quiz_id = ? and selected = ? order by id",
            self.id, 0)
        if #all_fresh == 0 then
            return nil
        else
            return all_fresh[math.random(1, #all_fresh)]
        end
    end,

    all_tasks = function(self)
        return model.Task:select(
            "where quiz_id = ? order by id", self.id)
    end,

    color = function(self)
        local c = 'white'
        if self.tasks then
            if self.right_answers >= self.tasks * 0.9 then
                c = 'green'
            else
                c = 'red'
            end
        end
        return c
    end,
})

model.QuizState = Model:extend("quiz-state", {
    primary_key = {"name"}
})

model.Quiz.can_create = function(name)
    local state = model.QuizState:find(name)
    return state and state.enabled
end

local table_size = function(t)
    local size = 0
    for _ in pairs(t) do
        size = size + 1
    end
    return size
end

local rand_sequence = function()
    local ttt = {1,2,3,4}
    local result = ''
    while #ttt > 0 do
        local i = table.remove(ttt, math.random(1, #ttt))
        result = result .. i
    end
    return result
end

function model.new_submission(self, filename, text, body)
    local log = body:match('<pre>(.*)</pre></body></html>$')
    local rating = tonumber(log:match('Оценка (%d)'))
    local pr, task = filename:match('_(%w+)_([%w-]+).[^.]+$')
    local ip = self.req.headers['X-Forwarded-For'] or '0.0.0.0'
    local ua = self.req.headers['User-Agent']
    local user = self.session.user
    local submission = model.Submission:create({
        filename = filename,
        text = text,
        log = log,
        pr = pr,
        task = task,
        user = user,
        rating = rating,
        ip = ip,
        ua = ua,
    })
    if config.rating_uploader then
        model.upload_submission(submission)
    end
    return submission
end

function model.upload_submission(submission)
    rating_uploader(submission.user,
        submission.task,
        submission.rating)
end

function model.new_quiz(req)
    local user = req.session.user
    local quiz_name = req.req.params_post.name
    if not model.Quiz.can_create(quiz_name) and
            not req.prep then
        error("Can't create instance of this quiz")
    end
    local q = quizs[quiz_name]
    if not q or type(q) ~= 'table' then
        error("No such quiz found")
    end
    local ip = req.req.headers['X-Forwarded-For'] or '0.0.0.0'
    local ua = req.req.headers['User-Agent']
    local quiz = model.Quiz:create({name=quiz_name, user=user,
        tasks=table_size(q), answers=0, right_answers=0,
        state=model.ACTIVE, ip=ip, ua=ua})
    assert(quiz.id)
    local task_names = {}
    for task_name, func in pairs(q) do
        table.insert(task_names, task_name)
    end
    task_names = shuffle(task_names)
    for _, task_name in ipairs(task_names) do
        local func = q[task_name]
        local text, a1, a2, a3, a4 = func(req)
        model.Task:create({quiz_id=quiz.id, name=task_name,
            text=text, a1=a1, a2=a2, a3=a3, a4=a4,
            sequence=rand_sequence(), selected=0})
    end
    return quiz
end

function model.my_quizs(req, state)
    local user = req.session.user
    return model.Quiz:select(
        'where quiz.user = ? and state = ?',
        user, state)
end

function model.today_quizs(state)
    local yesterday = date(true):adddays(-1):fmt("%Y-%m-%d %T")
    return model.Quiz:select([[where created_at > ? and
        state = ? order by id]], yesterday, state)
end

function model.quizs_of(user, state)
    return model.Quiz:select(
        'where quiz.user = ? and state = ? order by id',
        user, state)
end

function model.quizs_of_name(name, state)
    return model.Quiz:select(
        'where name = ? and state = ? order by id',
        name, state)
end

function model.all_quizs(state)
    return model.Quiz:select("where state = ? order by id",
        state)
end

function model.kr(name)
    local times = kr_times[name]
    if not times then
        error('Unknown kr')
    end
    return model.Quiz:select(
        [[where name = ? and state = ? and
        ((created_at >= ? and updated_at <= ?) or
        (created_at >= ? and updated_at <= ?))
        order by id]],
        name, model.FINISHED,
        times.start1, times.stop1, times.start2, times.stop2)
end

return model

