-- =========================================================================
-- ORI HUB - גרסה מלאה ומסודרת
-- =========================================================================
local CoreGui = game:GetService("CoreGui")
local UIS = game:GetService("UserInputService")

-- 1. ניקוי UI קודם
if CoreGui:FindFirstChild("OriHub") then CoreGui:FindFirstChild("OriHub"):Destroy() end

-- 2. יצירת ה-GUI הראשי
local screen = Instance.new("ScreenGui", CoreGui); screen.Name = "OriHub"
local frame = Instance.new("Frame", screen); frame.Size = UDim2.new(0, 600, 0, 375); frame.Position = UDim2.new(0.5, -300, 0.5, -187.5); frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30); Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)

-- 3. גרירה (Draggable)
local dragToggle, dragStart, startPos
frame.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragToggle = true; dragStart = input.Position; startPos = frame.Position end end)
UIS.InputChanged:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseMovement and dragToggle then local delta = input.Position - dragStart; frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y) end end)
UIS.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragToggle = false end end)

-- 4. עיצוב ה-Sidebar
local sidebar = Instance.new("Frame", frame); sidebar.Size = UDim2.new(0, 140, 1, 0); sidebar.BackgroundColor3 = Color3.fromRGB(40, 40, 40); Instance.new("UICorner", sidebar).CornerRadius = UDim.new(0, 10)
local listLayout = Instance.new("UIListLayout", sidebar); listLayout.Padding = UDim.new(0, 5); listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center; listLayout.Padding = UDim.new(0, 10); listLayout.PaddingTop = UDim.new(0, 20)

local mainContent = Instance.new("Frame", frame); mainContent.Size = UDim2.new(1, -140, 1, 0); mainContent.Position = UDim2.new(0, 140, 0, 0); mainContent.BackgroundTransparency = 1

-- פונקציה ליצירת כפתור
local function createCategoryBtn(name, callback)
    local b = Instance.new("TextButton", sidebar); b.Size = UDim2.new(0.8, 0, 0, 35); b.Text = name; b.BackgroundColor3 = Color3.fromRGB(60, 60, 60); b.TextColor3 = Color3.new(1,1,1); b.Font = Enum.Font.Gotham; Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
    b.MouseButton1Click:Connect(function() mainContent:ClearAllChildren(); callback(mainContent) end)
end

-- =========================================================================
-- כאן יוצרים את הכפתורים (הצד העיצובי)
-- =========================================================================

createCategoryBtn("Home", function(c) 
    print("Home Tab Opened") 
end)

createCategoryBtn("Target", function(c) 
    print("Target Tab Opened") 
end)

createCategoryBtn("Visuals", function(c) 
    print("Visuals Tab Opened") 
end)

createCategoryBtn("Player", function(c) 
    -- כאן תכניס את הכפתורים של ה-Player (Fly, Speed וכו')
    local lbl = Instance.new("TextLabel", c); lbl.Text = "Player Settings"; lbl.Size = UDim2.new(1,0,0,50); lbl.BackgroundTransparency = 1; lbl.TextColor3 = Color3.new(1,1,1)
end)

createCategoryBtn("World", function(c) 
    print("World Tab Opened") 
end)

createCategoryBtn("Settings", function(c) 
    print("Settings Tab Opened") 
end)
