-- הגנה מפני הרצה כפולה
local CoreGui = game:GetService("CoreGui")
if CoreGui:FindFirstChild("MyMenu") then 
    CoreGui:FindFirstChild("MyMenu"):Destroy() 
end

-- יצירת מסך ה-UI
local screen = Instance.new("ScreenGui", CoreGui)
screen.Name = "MyMenu"

-- פריים ראשי
local frame = Instance.new("Frame", screen)
frame.Size = UDim2.new(0, 500, 0, 300)
frame.Position = UDim2.new(0.5, -250, 0.5, -150)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)

-- כותרת ה-Hub
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 40)
title.Position = UDim2.new(0, 0, 0, 0)
title.Text = "ori_dev_hub"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 20
title.BackgroundTransparency = 1

-- פונקציה ליצירת כפתור (כדי לא לשכפל קוד)
local function createButton(name, pos)
    local b = Instance.new("TextButton", frame)
    b.Size = UDim2.new(0.25, 0, 0, 40)
    b.Position = pos
    b.Text = name
    b.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    b.TextColor3 = Color3.new(1, 1, 1)
    b.Font = Enum.Font.Gotham
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
    return b
end

-- יצירת הכפתורים בקטגוריות
local btnHome = createButton("Home", UDim2.new(0.02, 0, 0.15, 0))
local btnTarget = createButton("Target", UDim2.new(0.02, 0, 0.35, 0))
local btnPlayer = createButton("Player", UDim2.new(0.02, 0, 0.55, 0))
local btnWorld = createButton("World", UDim2.new(0.02, 0, 0.75, 0))

-- כאן נחבר את הלוגיקה בהמשך (בינתיים רק הדפסה לבדיקה)
btnHome.MouseButton1Click:Connect(function() print("Home pressed") end)
btnTarget.MouseButton1Click:Connect(function() print("Target pressed") end)
btnPlayer.MouseButton1Click:Connect(function() print("Player pressed") end)
btnWorld.MouseButton1Click:Connect(function() print("World pressed") end)

-- השורה שמבטיחה שה-Executor לא יקפיץ שגיאה
return true
