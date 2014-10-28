local schema = require("lapis.db.schema")
local Model = require("lapis.db.model").Model

local quizs = require('quiz.all')

local model = {}

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
        {"right_answers", types.integer},
        {"finished", types.boolean},
        {"ip", types.varchar},
        {"ua", types.varchar},
        "PRIMARY KEY (id)"
    })
end

model.Task = Model:extend("task")
model.Quiz = Model:extend("quiz", {timestamp=true})

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
        right_answers=0, finished=false, ip=ip, ua=ua})
    for task_name, func in pairs(q) do
        if task_name ~= 'task' then
            local text, a1, a2, a3, a4 = func(app)
            model.Task:create({quiz_id=quiz.id, name=task_name,
                text=text, a1=a1, a2=a2, a3=a3, a4=a4,
                selected=0})
        end
    end
    return quiz
end

return model

