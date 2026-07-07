-- הגדרות בסיסיות
local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- מחיקת ה-UI הקודם כדי למנוע כפילויות
if playerGui:FindFirstChild("ModernMenu") then
    playerGui:FindFirstChild("ModernMenu"):Destroy()
end

-- יצירת ה-UI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ModernMenu"
screenGui.Parent = playerGui

local frame = Instance.new("Frame", screenGui)
frame.Size = UDim2.new(0, 300, 0, 400)
frame.Position = UDim2.new(0.5, -150, 0.5, -200)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0

local corner = Instance.new("UICorner", frame)
corner.CornerRadius = UDim.new(0, 15)

local stroke = Instance.new("UIStroke", frame)
stroke.Color = Color3.fromRGB(100, 100, 100)
stroke.Thickness = 2

-- הוספת כותרת שתראה שזה עבד
local title = Instance.new("TextLabel", frame)
title.Text = "Menu Loaded"
title.Size = UDim2.new(1, 0, 0, 50)
title.BackgroundTransparency = 1
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 20

print("✅ UI Created Successfully!")
