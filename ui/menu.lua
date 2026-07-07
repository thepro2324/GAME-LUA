-- הגדרות ראשוניות
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")

-- ניקוי קודם
if CoreGui:FindFirstChild("MyMenu") then CoreGui:FindFirstChild("MyMenu"):Destroy() end

-- יצירת ה-UI
local screen = Instance.new("ScreenGui", CoreGui)
screen.Name = "MyMenu"

-- הפריים הראשי
local main = Instance.new("Frame", screen)
main.Size = UDim2.new(0, 350, 0, 250)
main.Position = UDim2.new(0.5, -175, 0.5, -125)
main.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
main.BorderSizePixel = 0
main.ClipsDescendants = true

local corner = Instance.new("UICorner", main)
corner.CornerRadius = UDim.new(0, 12)

local stroke = Instance.new("UIStroke", main)
stroke.Color = Color3.fromRGB(60, 60, 60)
stroke.Thickness = 2

-- כותרת
local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1, 0, 0, 40)
title.Text = "  PRO MENU"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.TextXAlignment = Enum.TextXAlignment.Left

-- כפתור סגירה
local closeBtn = Instance.new("TextButton", main)
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -35, 0, 5)
closeBtn.Text = "X"
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 6)
closeBtn.MouseButton1Click:Connect(function() screen:Destroy() end)

-- פונקציה להוספת כפתור מעוצב
local function createButton(name, pos)
    local btn = Instance.new("TextButton", main)
    btn.Size = UDim2.new(0.8, 0, 0, 40)
    btn.Position = pos
    btn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(220, 220, 220)
    btn.Font = Enum.Font.Gotham
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    
    -- אפקט לחיצה פשוט
    btn.MouseButton1Down:Connect(function() btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60) end)
    btn.MouseButton1Up:Connect(function() btn.BackgroundColor3 = Color3.fromRGB(45, 45, 45) end)
    
    return btn
end

-- יצירת כפתורים
createButton("Kill Aura", UDim2.new(0.1, 0, 0.25, 0)).MouseButton1Click:Connect(function() print("Kill Aura!") end)
createButton("ESP", UDim2.new(0.1, 0, 0.45, 0)).MouseButton1Click:Connect(function() print("ESP!") end)
createButton("Speed", UDim2.new(0.1, 0, 0.65, 0)).MouseButton1Click:Connect(function() print("Speed!") end)

print("✅ Modern UI Loaded!")
