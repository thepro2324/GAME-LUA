-- הגנה מפני הרצה כפולה
local CoreGui = game:GetService("CoreGui")
if CoreGui:FindFirstChild("MyMenu") then 
    CoreGui:FindFirstChild("MyMenu"):Destroy() 
end

-- יצירת מסך ה-UI
local screen = Instance.new("ScreenGui", CoreGui)
screen.Name = "MyMenu"

-- פריים ראשי (הוגדל מעט לגובה 380 כדי להכיל יותר קטגוריות)
local frame = Instance.new("Frame", screen)
frame.Size = UDim2.new(0, 500, 0, 380)
frame.Position = UDim2.new(0.5, -250, 0.5, -190)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)

-- כותרת ה-Hub
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 40)
title.Text = "ori_dev_hub"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 22
title.BackgroundTransparency = 1

-- פונקציה ליצירת כפתור
local function createButton(name, pos)
    local b = Instance.new("TextButton", frame)
    b.Size = UDim2.new(0.25, 0, 0, 35)
    b.Position = pos
    b.Text = name
    b.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    b.TextColor3 = Color3.new(1, 1, 1)
    b.Font = Enum.Font.Gotham
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
    return b
end

-- יצירת הכפתורים בקטגוריות מסודרות
local btnHome    = createButton("Home",    UDim2.new(0.02, 0, 0.15, 0))
local btnTarget  = createButton("Target",  UDim2.new(0.02, 0, 0.26, 0))
local btnVisuals = createButton("Visuals", UDim2.new(0.02, 0, 0.37, 0))
local btnPlayer  = createButton("Player",  UDim2.new(0.02, 0, 0.48, 0))
local btnWorld   = createButton("World",   UDim2.new(0.02, 0, 0.59, 0))
local btnMisc    = createButton("Misc",    UDim2.new(0.02, 0, 0.70, 0))
local btnSettings= createButton("Settings",UDim2.new(0.02, 0, 0.81, 0))

-- הדפסות לבדיקה
btnHome.MouseButton1Click:Connect(function() print("Home pressed") end)
btnTarget.MouseButton1Click:Connect(function() print("Target pressed") end)
btnVisuals.MouseButton1Click:Connect(function() print("Visuals pressed") end)
btnPlayer.MouseButton1Click:Connect(function() print("Player pressed") end)
btnWorld.MouseButton1Click:Connect(function() print("World pressed") end)
btnMisc.MouseButton1Click:Connect(function() print("Misc pressed") end)
btnSettings.MouseButton1Click:Connect(function() print("Settings pressed") end)

return true
