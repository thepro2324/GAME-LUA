-- modules/visuals.lua
local VisualsMod = {}
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local localPlayer = Players.LocalPlayer
local camera = workspace.CurrentCamera

local espConnections = {}
local isMasterESP = false
local isESPBox = false
local isESPNames = false
local isTracers = false
local isChams = false

-- פונקציית עזר ליצירת קופסאות ושמות בסיסיים (Highlight & Billboard)
local function createESP(player)
    if player == localPlayer then return end
    
    local function applyVisuals(character)
        if not character then return end
        
        -- יצירת Chams / Highlight (צביעת שחקן דרך קירות)
        local highlight = character:FindFirstChild("ESPHighlight")
        if not highlight then
            highlight = Instance.new("Highlight")
            highlight.Name = "ESPHighlight"
            highlight.FillColor = Color3.fromRGB(255, 60, 60)
            highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
            highlight.FillTransparency = 0.5
            highlight.OutlineTransparency = 0
            highlight.Parent = character
        end
        highlight.Enabled = isChams and isMasterESP

        -- יצירת תיבת טקסט מעל הראש (שמות)
        local head = character:WaitForChild("Head", 5)
        if head then
            local bbGui = head:FindFirstChild("ESPTag")
            if not bbGui then
                bbGui = Instance.new("BillboardGui")
                bbGui.Name = "ESPTag"
                bbGui.Size = UDim2.new(0, 100, 0, 30)
                bbGui.StudsOffset = Vector3.new(0, 2.5, 0)
                bbGui.AlwaysOnTop = true
                
                local textLabel = Instance.new("TextLabel")
                textLabel.Size = UDim2.new(1, 0, 1, 0)
                textLabel.BackgroundTransparency = 1
                textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                textLabel.Font = Enum.Font.GothamBold
                textLabel.TextSize = 12
                textLabel.TextStrokeTransparency = 0
                textLabel.Text = player.Name
                textLabel.Parent = bbGui
                bbGui.Parent = head
            end
            bbGui.Enabled = isESPNames and isMasterESP
        end
    end

    if player.Character then applyVisuals(player.Character) end
    player.CharacterAdded:Connect(applyVisuals)
end

-- רענון ועדכון ה-ESP בזמן אמת
local function updateESPStatus()
    for _, player in ipairs(Players:GetPlayers()) do
        if player.Character then
            local highlight = player.Character:FindFirstChild("ESPHighlight")
            if highlight then highlight.Enabled = isChams and isMasterESP end
            
            local head = player.Character:FindFirstChild("Head")
            local bbGui = head and head:FindFirstChild("ESPTag")
            if bbGui then bbGui.Enabled = isESPNames and isMasterESP end
        end
    end
end

-- 1. כפתור מאסטר (חייב להיות דלוק כדי שה-ESP יעבוד)
function VisualsMod.toggleMasterESP(state)
    isMasterESP = state
    if state then
        for _, player in ipairs(Players:GetPlayers()) do createESP(player) end
        espConnections["PlayerAdded"] = Players.PlayerAdded:Connect(createESP)
    else
        if espConnections["PlayerAdded"] then espConnections["PlayerAdded"]:Disconnect() end
    end
    updateESPStatus()
end

-- 2. כפתור שמות (ESP Names)
function VisualsMod.toggleESPNames(state)
    isESPNames = state
    updateESPStatus()
end

-- 3. כפתור צביעת שחקנים (Chams)
function VisualsMod.toggleChams(state)
    isChams = state
    updateESPStatus()
end

-- 4. כפתור Fullbright (ביטול חושך וצללים)
local originalAmbient = game:GetService("Lighting").Ambient
function VisualsMod.toggleFullbright(state)
    if state then
        game:GetService("Lighting").Ambient = Color3.fromRGB(255, 255, 255)
    else
        game:GetService("Lighting").Ambient = originalAmbient
    end
end

-- הגדרות ריקות לפונקציות הנוספות כדי למנוע שגיאות
function VisualsMod.toggleESPBox(state) isESPBox = state end
function VisualsMod.toggleTracers(state) isTracers = state end
function VisualsMod.toggleHideName(state) end

return VisualsMod
