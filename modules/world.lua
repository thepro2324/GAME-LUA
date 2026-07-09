local WorldMod = {}
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local timeConnection = nil
local originalFogStart = Lighting.FogStart
local originalFogEnd = Lighting.FogEnd

-- לוגיקה
function WorldMod.setGravity(v) Workspace.Gravity = tonumber(v) or 196.2 end
function WorldMod.setFOV(v) 
    local cam = workspace.CurrentCamera
    if cam then cam.FieldOfView = tonumber(v) or 70 end
end
function WorldMod.setTime(v) Lighting.ClockTime = tonumber(v) or 12 end

function WorldMod.toggleFreezeTime(state)
    if timeConnection then timeConnection:Disconnect(); timeConnection = nil end
    if state then
        local currentTime = Lighting.ClockTime
        timeConnection = RunService.Heartbeat:Connect(function()
            Lighting.ClockTime = currentTime
        end)
    end
end

function WorldMod.toggleFog(state)
    if state then
        Lighting.FogStart = 9e9
        Lighting.FogEnd = 9e9
    else
        Lighting.FogStart = originalFogStart
        Lighting.FogEnd = originalFogEnd
    end
end

function WorldMod.toggleFPS(state)
    if setfpscap then setfpscap(state and 999 or 60) end
end

function WorldMod.destroyMap()
    for _, obj in ipairs(Workspace:GetChildren()) do
        if (obj:IsA("Folder") or obj:IsA("Model")) and obj.Name ~= "Players" and obj.Name ~= "Terrain" then
            if not game:GetService("Players"):GetPlayerFromCharacter(obj) then
                obj:Destroy()
            end
        end
    end
end

-- בניית הממשק
function WorldMod.init(tab, Elements, UIReferences, Localization, safeCall)
    tab:ClearAllChildren()
    
    local scroll = Instance.new("ScrollingFrame", tab)
    scroll.Size = UDim2.new(1, 0, 1, 0); scroll.BackgroundTransparency = 1; scroll.CanvasSize = UDim2.new(0, 0, 0, 500)
    
    local layout = Instance.new("UIListLayout", scroll)
    layout.Padding = UDim.new(0, 8)
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    layout.PaddingTop = UDim.new(0, 10)

    -- פונקציית עזר ליצירת קלט
    local function createInput(name, callback)
        local box = Instance.new("TextBox", scroll)
        box.Size = UDim2.new(0.95, 0, 0, 35); box.PlaceholderText = name; box.BackgroundColor3 = Color3.fromRGB(35, 35, 45); box.TextColor3 = Color3.new(1,1,1)
        Elements.addCorner(box, UDim.new(0, 5))
        box.FocusLost:Connect(function(enter) if enter then safeCall(WorldMod, callback, box.Text) end end)
    end

    -- יצירת אלמנטים
    createInput("Gravity (Default 196.2)", "setGravity")
    createInput("FOV (Default 70)", "setFOV")
    createInput("Time (0-24)", "setTime")

    Elements.createToggleButton(scroll, "Freeze Time", false, function(s) safeCall(WorldMod, "toggleFreezeTime", s) end)
    Elements.createToggleButton(scroll, "No Fog", false, function(s) safeCall(WorldMod, "toggleFog", s) end)
    Elements.createToggleButton(scroll, "FPS Unlocker", false, function(s) safeCall(WorldMod, "toggleFPS", s) end)

    local destBtn = Instance.new("TextButton", scroll)
    destBtn.Size = UDim2.new(0.95, 0, 0, 35); destBtn.Text = "Destroy Map (Risky)"; destBtn.BackgroundColor3 = Color3.fromRGB(150, 40, 40); destBtn.TextColor3 = Color3.new(1,1,1)
    Elements.addCorner(destBtn, UDim.new(0, 5))
    destBtn.MouseButton1Click:Connect(function() safeCall(WorldMod, "destroyMap") end)
end

return WorldMod
