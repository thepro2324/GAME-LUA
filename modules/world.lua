-- modules/world.lua
local WorldMod = {}
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")

local timeConnection
local originalFogStart = Lighting.FogStart
local originalFogEnd = Lighting.FogEnd

-- 1. שינוי כוח המשיכה (Gravity)
function WorldMod.setGravity(v)
    workspace.Gravity = v
end

-- 2. שינוי שדה הראייה (FOV)
function WorldMod.setFOV(v)
    local camera = workspace.CurrentCamera
    if camera then
        camera.FieldOfView = v
    end
end

-- 3. שינוי שעת היום במשחק
function WorldMod.setTime(v)
    Lighting.ClockTime = v
end

-- 4. הקפאת שעת היום שלא תשתנה
function WorldMod.toggleFreezeTime(state)
    if timeConnection then timeConnection:Disconnect() timeConnection = nil end
    if state then
        local currentTime = Lighting.ClockTime
        timeConnection = RunService.Heartbeat:Connect(function()
            Lighting.ClockTime = currentTime
        end)
    end
end

-- 5. ביטול ערפל (Remove Fog)
function WorldMod.toggleFog(state)
    if state then
        Lighting.FogStart = 9e9
        Lighting.FogEnd = 9e9
    else
        Lighting.FogStart = originalFogStart
        Lighting.FogEnd = originalFogEnd
    end
end

-- 6. אופטימיזציה ופתיחת FPS (FPS Unlocker בסיסי)
function WorldMod.toggleFPS(state)
    if setfpscap then
        if state then
            setfpscap(999)
        else
            setfpscap(60)
        end
    end
end

-- 7. מחיקת אלמנטים מהמפה (Destroy Map Elements)
function WorldMod.destroyMap()
    for _, obj in ipairs(workspace:GetChildren()) do
        if obj:IsA("Folder") or obj:IsA("Model") and obj.Name ~= "Players" and obj.Name ~= "Terrain" then
            if not game:GetService("Players"):GetPlayerFromCharacter(obj) then
                obj:Destroy()
            end
        end
    end
end

return WorldMod
