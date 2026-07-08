-- הגנה מפני הרצה כפולה
local Menu = {}
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")

if CoreGui:FindFirstChild("MyMenu") then 
    CoreGui:FindFirstChild("MyMenu"):Destroy() 
end

-- יצירת מסך ה-UI
local screen = Instance.new("ScreenGui", CoreGui)
screen.Name = "MyMenu"

-- פריים ראשי (600x375)
local frame = Instance.new("Frame", screen)
frame.Size = UDim2.new(0, 600, 0, 375)
frame.Position = UDim2.new(0.5, -300, 0.5, -187.5)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)

-- סרגל צד (Sidebar) לכפתורים
local sidebar = Instance.new("Frame", frame)
sidebar.Size = UDim2.new(0, 140, 1, 0)
sidebar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
sidebar.BorderSizePixel = 0
Instance.new("UICorner", sidebar).CornerRadius = UDim.new(0, 10)

-- חלון תוכן ראשי (Main Content) - כאן יופיעו הפיצ'רים שלך
local mainContent = Instance.new("Frame", frame)
mainContent.Size = UDim2.new(1, -140, 1, 0)
mainContent.Position = UDim2.new(0, 140, 0, 0)
mainContent.BackgroundTransparency = 1

-- פונקציה להפיכת פריים לניתן לגרירה
local function makeDraggable(gui)
    local dragging, dragInput, dragStart, startPos
    gui.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = gui.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
            local delta = input.Position - dragStart
            gui.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
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
local function createButton(name)
    local b = Instance.new("TextButton", sidebar)
    b.Size = UDim2.new(0.8, 0, 0, 35)
    b.Position = UDim2.new(0.1, 0, 0, btnY)
    b.Text = name
    b.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    b.TextColor3 = Color3.new(1, 1, 1)
    b.Font = Enum.Font.Gotham
    b.TextSize = 16
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
    btnY = btnY + 45 -- יורד שורה
    return b
end

-- יצירת הכפתורים בצד
createButton("Home")
createButton("Target")
createButton("Visuals")
createButton("Player")
createButton("World")
createButton("Settings")

return Menu
