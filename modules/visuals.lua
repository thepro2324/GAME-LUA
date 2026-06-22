-- modules/visuals.lua
local VisualsMod = {}
local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local playerObj = Players.LocalPlayer

_G.ESP_Enabled = false
_G.ESP_Box = false
_G.ESP_Names = false

function VisualsMod.runESP()
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= playerObj and p.Character then
            local old = p.Character:FindFirstChild("ori_esp") 
            if old then old:Destroy() end
            
            if _G.ESP_Enabled then
                local f = Instance.new("Folder", p.Character) 
                f.Name = "ori_esp"
                
                if _G.ESP_Box then
                    local h = Instance.new("Highlight", f) 
                    h.FillTransparency = 0.5 
                    h.FillColor = Color3.new(1,0,0) 
                    h.OutlineColor = Color3.new(1,1,1)
                end
                
                if _G.ESP_Names and p.Character:FindFirstChild("Head") then
                    local bg = Instance.new("BillboardGui", f) 
                    bg.Size = UDim2.new(0,200,0,50) 
                    bg.AlwaysOnTop = true 
                    bg.StudsOffset = Vector3.new(0,2,0) 
                    bg.Adornee = p.Character.Head
                    
                    local tl = Instance.new("TextLabel", bg) 
                    tl.Size = UDim2.new(1,0,1,0) 
                    tl.BackgroundTransparency = 1 
                    tl.TextColor3 = Color3.new(1,1,1) 
                    tl.Font = Enum.Font.SourceSansBold 
                    tl.TextSize = 14 
                    tl.Text = p.Name
                end
            end
        end
    end
end

-- עדכון אוטומטי כששחקן חדש נכנס או עושה Spawn
Players.PlayerAdded:Connect(function(p) 
    p.CharacterAdded:Connect(function() 
        task.wait(0.5) 
        if _G.ESP_Enabled then VisualsMod.runESP() end 
    end) 
end)

function VisualsMod.toggleMasterESP(state) _G.ESP_Enabled = state VisualsMod.runESP() end
function VisualsMod.toggleESPBox(state) _G.ESP_Box = state VisualsMod.runESP() end
function VisualsMod.toggleESPNames(state) _G.ESP_Names = state VisualsMod.runESP() end

-- Fullbright (ביטול צללים וחושך)
function VisualsMod.toggleFullbright(state)
    if state then 
        Lighting.Ambient = Color3.new(1,1,1) 
        Lighting.GlobalShadows = false 
    else 
        Lighting.Ambient = Color3.fromRGB(120,120,120) 
        Lighting.GlobalShadows = true 
    end
end

return VisualsMod
