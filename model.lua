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

model.Task = Model:extend("task")
model.Quiz = Model:extend("quiz", {timestamp=true})

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
        error(app._("No such quiz found"))
    end
    local ip = app.req.headers['X-Forwarded-For']
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

model.Quiz.all_tasks = function(self)
    return model.Task:find_all({quiz_id=self.id})
end

model.Quiz.fresh_task = function(self)
    local all_fresh = self:all_tasks()
    if #all_fresh == 0 then
        return nil
    else
        return all_fresh[math.random(1, #all_fresh)]
    end
end

model.Task.quiz = function(self)
    return model.Quiz:find({id=self.id})
end

model.Task.ans = function(self, i)
    assert(i >= 1)
    assert(i <= 4)
    return self['a' .. self.sequence:sub(i, i)]
end

return model

