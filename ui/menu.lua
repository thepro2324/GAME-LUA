-- הגנה מפני הרצה כפולה
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")

if CoreGui:FindFirstChild("MyMenu") then 
    CoreGui:FindFirstChild("MyMenu"):Destroy() 
end

-- יצירת מסך ה-UI
local screen = Instance.new("ScreenGui", CoreGui)
screen.Name = "MyMenu"

-- פריים ראשי (500x300)
local frame = Instance.new("Frame", screen)
frame.Size = UDim2.new(0, 520, 0, 320)
frame.Position = UDim2.new(0.5, -250, 0.5, -150) -- מחושב למרכז לפי הגובה החדש
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)

-- פונקציה להפיכת פריים לניתן לגרירה
local function makeDraggable(gui)
    local dragging, dragInput, dragStart, startPos
    
    gui.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = gui.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
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

-- הפעלת הגרירה על הפריים הראשי
makeDraggable(frame)

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
    b.TextSize = 16 
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
    return b
end

-- יצירת הכפתורים (מסודרים בשתי עמודות להתאמה לגובה 300)
local btnHome    = createButton("Home",    UDim2.new(0.05, 0, 0.20, 0))
local btnTarget  = createButton("Target",  UDim2.new(0.05, 0, 0.40, 0))
local btnVisuals = createButton("Visuals", UDim2.new(0.05, 0, 0.60, 0))

local btnPlayer  = createButton("Player",  UDim2.new(0.35, 0, 0.20, 0))
local btnWorld   = createButton("World",   UDim2.new(0.35, 0, 0.40, 0))
local btnSettings= createButton("Settings",UDim2.new(0.35, 0, 0.60, 0))

-- הדפסות לבדיקה
btnHome.MouseButton1Click:Connect(function() print("Home pressed") end)
btnTarget.MouseButton1Click:Connect(function() print("Target pressed") end)
btnVisuals.MouseButton1Click:Connect(function() print("Visuals pressed") end)
btnPlayer.MouseButton1Click:Connect(function() print("Player pressed") end)
btnWorld.MouseButton1Click:Connect(function() print("World pressed") end)
btnSettings.MouseButton1Click:Connect(function() print("Settings pressed") end)

return true
