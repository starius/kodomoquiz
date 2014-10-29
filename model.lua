local schema = require("lapis.db.schema")
local Model = require("lapis.db.model").Model

local quizs = require('quiz.all')

local model = {}

model.ACTIVE = 1
model.CANCELLED = 2
model.FINISHED = 3

function model.create_schema()
    local types = schema.types

    schema.create_table("task", {
        {"id", types.serial},
        {"quiz_id", types.foreign_key},
        {"name", types.varchar},
        {"text", types.varchar},
        {"a1", types.varchar},
        {"a2", types.varchar},
        {"a3", types.varchar},
        {"a4", types.varchar},
        {"sequence", types.varchar}, -- e.g. "2143"
        {"selected", types.integer},
        "PRIMARY KEY (id)"
    })

    schema.create_table("quiz", {
        {"id", types.serial},
        {"name", types.varchar},
        {"user", types.varchar},
        {"created_at", types.time},
        {"updated_at", types.time},
        {"tasks", types.integer},
        {"answers", types.integer},
        {"right_answers", types.integer},
        {"state", types.integer},
        {"ip", types.varchar},
        {"ua", types.varchar},
        "PRIMARY KEY (id)"
    })
end

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
    end
})

model.Quiz = Model:extend("quiz", {
    timestamp = true,

    anchor = function(self, app)
        local url = app:url_for('quiz', {id=self.id})
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
    end
})

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

function model.new_quiz(app)
    local user = app.session.user
    local quiz_name = app.req.params_post.name
    local q = quizs[quiz_name]
    if not q then
        error(app:_("No such quiz found"))
    end
    local ip = app.req.headers['X-Forwarded-For'] or '0.0.0.0'
    local ua = app.req.headers['User-Agent']
    local quiz = model.Quiz:create({name=quiz_name, user=user,
        tasks=table_size(q), answers=0, right_answers=0,
        state=model.ACTIVE, ip=ip, ua=ua})
    for task_name, func in pairs(q) do
        local text, a1, a2, a3, a4 = func(app)
        model.Task:create({quiz_id=quiz.id, name=task_name,
            text=text, a1=a1, a2=a2, a3=a3, a4=a4,
            sequence=rand_sequence(), selected=0})
    end
    return quiz
end

function model.my_quizs(app, state)
    local user = app.session.user
    return model.Quiz:select('where "user" = ? and state = ?',
        user, state)
end

return model

