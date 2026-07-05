local VisualsMod = {}
local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local playerObj = Players.LocalPlayer

_G.ESP_Enabled = false
_G.ESP_Box = false
_G.ESP_Names = false

-- משתנה לשמירת החיבור של הלולאה
local espConnection = nil

-- הפונקציה שמעדכנת את ה-ESP לכל השחקנים
local function updateESP()
    if not _G.ESP_Enabled then return end

    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= playerObj and p.Character then
            local char = p.Character
            local espFolder = char:FindFirstChild("ori_esp")

            -- אם ה-ESP לא קיים, ניצור אותו
            if not espFolder then
                espFolder = Instance.new("Folder", char)
                espFolder.Name = "ori_esp"
            end

            -- טיפול בתיבות (Highlight)
            local highlight = espFolder:FindFirstChild("Box")
            if _G.ESP_Box then
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
            if _G.ESP_Names and char:FindFirstChild("Head") then
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

-- הפעלה/כיבוי של ה-Loop
function VisualsMod.toggleMasterESP(state)
    _G.ESP_Enabled = state
    
    if state then
        -- אם מפעילים, נתחיל את הלולאה
        if not espConnection then
            espConnection = RunService.Heartbeat:Connect(updateESP)
        end
    else
        -- אם מכבים, נסגור את הלולאה וננקה הכל
        if espConnection then
            espConnection:Disconnect()
            espConnection = nil
        end
        
        -- מחיקת כל ה-ESP מהשחקנים
        for _, p in ipairs(Players:GetPlayers()) do
            if p.Character and p.Character:FindFirstChild("ori_esp") then
                p.Character.ori_esp:Destroy()
            end
        end
    end
end

-- פונקציות להגדרות (רק משנות משתנים, הלולאה כבר רצה)
function VisualsMod.toggleESPBox(state) _G.ESP_Box = state end
function VisualsMod.toggleESPNames(state) _G.ESP_Names = state end

-- Fullbright (זה עובד כי זה משנה ערכים גלובליים, לא צריך לולאה)
function VisualsMod.toggleFullbright(state)
    if state then 
        Lighting.Ambient = Color3.new(1, 1, 1) 
        Lighting.GlobalShadows = false 
    else 
        Lighting.Ambient = Color3.fromRGB(120, 120, 120) 
        Lighting.GlobalShadows = true 
    end
end

return VisualsMod
