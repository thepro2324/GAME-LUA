-- הגנה מפני הרצה כפולה
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")

if CoreGui:FindFirstChild("MyMenu") then 
    CoreGui:FindFirstChild("MyMenu"):Destroy() 
end

-- יצירת מסך ה-UI
local screen = Instance.new("ScreenGui", CoreGui)
screen.Name = "MyMenu"

-- פריים ראשי
local frame = Instance.new("Frame", screen)
frame.Size = UDim2.new(0, 600, 0, 375)
frame.Position = UDim2.new(0.5, -300, 0.5, -187.5)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)

-- סרגל צד (Sidebar)
local sidebar = Instance.new("Frame", frame)
sidebar.Size = UDim2.new(0, 140, 1, 0)
sidebar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
sidebar.BorderSizePixel = 0
Instance.new("UICorner", sidebar).CornerRadius = UDim.new(0, 10)

-- חלון תוכן ראשי (Main Content)
local mainContent = Instance.new("Frame", frame)
mainContent.Size = UDim2.new(1, -140, 1, 0)
mainContent.Position = UDim2.new(0, 140, 0, 0)
mainContent.BackgroundTransparency = 1

-- פונקציה להפיכת פריים לניתן לגרירה
local function makeDraggable(gui)
    local dragging, dragStart, startPos
    gui.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = gui.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
            local delta = input.Position - dragStart
            gui.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)
end
makeDraggable(frame)

-- כותרת
local title = Instance.new("TextLabel", sidebar)
title.Size = UDim2.new(1, 0, 0, 40)
title.Text = "ori_hub"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 20
title.BackgroundTransparency = 1

-- פונקציה ליצירת כפתור בסרגל הצד
local btnY = 50
local function createButton(name, callback)
    local b = Instance.new("TextButton", sidebar)
    b.Size = UDim2.new(0.8, 0, 0, 35)
    b.Position = UDim2.new(0.1, 0, 0, btnY)
    b.Text = name
    b.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    b.TextColor3 = Color3.new(1, 1, 1)
    b.Font = Enum.Font.Gotham
    b.TextSize = 16
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
    
    b.MouseButton1Click:Connect(function()
        mainContent:ClearAllChildren()
        if callback then callback() end
    end)
    
    btnY = btnY + 45
    return b
end

-- ==========================================
-- כאן אתה יוצר את התוכן של הכפתורים
-- ==========================================

createButton("Home", function()
    local label = Instance.new("TextLabel", mainContent)
    label.Size = UDim2.new(1, 0, 1, 0)
    label.Text = "Welcome to Ori Hub"
    label.TextColor3 = Color3.new(1,1,1)
    label.BackgroundTransparency = 1
end)

createButton("Player", function()
    -- כאן תכניס את הכפתורים של השחקן (Fly, Speed וכו')
    print("Player Menu Opened")
end)

print("הסקריפט הופעל בהצלחה!")
