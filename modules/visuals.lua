local VisualsMod = {}
local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local lp = Players.LocalPlayer

-- משתנים מקומיים (במקום _G)
local espEnabled = false
local espBox = false
local espNames = false
local espConnection = nil

-- לוגיקה פנימית של עדכון ה-ESP
local function updateESP()
    if not espEnabled then return end

    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= lp and p.Character then
            local char = p.Character
            local espFolder = char:FindFirstChild("ori_esp")

            -- יצירת תיקייה אם לא קיימת
            if not espFolder then
                espFolder = Instance.new("Folder", char)
                espFolder.Name = "ori_esp"
            end

            -- טיפול בתיבות (Highlight)
            local highlight = espFolder:FindFirstChild("Box")
            if espBox then
                if not highlight then
                    highlight = Instance.new("Highlight", espFolder)
                    highlight.Name = "Box"
                end
                highlight.FillTransparency = 0.5
                highlight.FillColor = Color3.new(1, 0, 0)
                highlight.OutlineColor = Color3.new(1, 1, 1)
            elseif highlight then
                highlight:Destroy()
            end

            -- טיפול בשמות (BillboardGui)
            local billboard = espFolder:FindFirstChild("NameTag")
            if espNames and char:FindFirstChild("Head") then
                if not billboard then
                    billboard = Instance.new("BillboardGui", espFolder)
                    billboard.Name = "NameTag"
                    billboard.Size = UDim2.new(0, 200, 0, 50)
                    billboard.AlwaysOnTop = true
                    billboard.StudsOffset = Vector3.new(0, 2, 0)
                    billboard.Adornee = char.Head
                    
                    local tl = Instance.new("TextLabel", billboard)
                    tl.Size = UDim2.new(1, 0, 1, 0)
                    tl.BackgroundTransparency = 1
                    tl.TextColor3 = Color3.new(1, 1, 1)
                    tl.Font = Enum.Font.SourceSansBold
                    tl.TextSize = 14
                end
                billboard.TextLabel.Text = p.Name
            elseif billboard then
                billboard:Destroy()
            end
        end
    end
end

-- פונקציות Toggle
function VisualsMod.toggleMasterESP(state)
    espEnabled = state
    if state then
        if not espConnection then espConnection = RunService.Heartbeat:Connect(updateESP) end
    else
        if espConnection then espConnection:Disconnect(); espConnection = nil end
        for _, p in ipairs(Players:GetPlayers()) do
            if p.Character and p.Character:FindFirstChild("ori_esp") then p.Character.ori_esp:Destroy() end
        end
    end
end

function VisualsMod.toggleESPBox(state) espBox = state end
function VisualsMod.toggleESPNames(state) espNames = state end

function VisualsMod.toggleFullbright(state)
    Lighting.Ambient = state and Color3.new(1, 1, 1) or Color3.fromRGB(120, 120, 120)
    Lighting.GlobalShadows = not state
end

-- בניית הממשק (UI)
function VisualsMod.init(tab, Elements, UIReferences, Localization, safeCall)
    local scroll = Instance.new("ScrollingFrame", tab)
    scroll.Size = UDim2.new(1, 0, 1, 0); scroll.BackgroundTransparency = 1; scroll.CanvasSize = UDim2.new(0, 0, 0, 300)
    Instance.new("UIListLayout", scroll).Padding = UDim.new(0, 10)

    Elements.createToggleButton(scroll, "ESP Master", false, function(s) safeCall(VisualsMod, "toggleMasterESP", s) end)
    Elements.createToggleButton(scroll, "ESP Boxes", false, function(s) safeCall(VisualsMod, "toggleESPBox", s) end)
    Elements.createToggleButton(scroll, "ESP Names", false, function(s) safeCall(VisualsMod, "toggleESPNames", s) end)
    Elements.createToggleButton(scroll, "Fullbright", false, function(s) safeCall(VisualsMod, "toggleFullbright", s) end)
end

return VisualsMod
