-- modules/world.lua
local WorldMod = {}
local workspace = game:GetService("Workspace")
local camera = workspace.CurrentCamera

function WorldMod.setGravity(value)
    workspace.Gravity = value
end

function WorldMod.setFOV(value)
    camera.FieldOfView = value
end

return WorldMod
