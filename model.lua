local schema = require("lapis.db.schema")
local Model = require("lapis.db.model").Model

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
        "PRIMARY KEY (id)"
    })
end

model.Task = Model:extend("task")
model.Quiz = Model:extend("quiz", {timestamp=true})

return model

