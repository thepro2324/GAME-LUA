-- הגדרות בסיסיות וניקוי
local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
if playerGui:FindFirstChild("ModernMenu") then playerGui:FindFirstChild("ModernMenu"):Destroy() end

-- יצירת UI
local screenGui = Instance.new("ScreenGui", playerGui)
screenGui.Name = "ModernMenu"
local mainFrame = Instance.new("Frame", screenGui)
mainFrame.Size = UDim2.new(0, 600, 0, 400)
mainFrame.Position = UDim2.new(0.5, -300, 0.5, -200)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BorderSizePixel = 0
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 15)
Instance.new("UIStroke", mainFrame).Color = Color3.fromRGB(60, 60, 60)

-- אזורים
local sideBar = Instance.new("Frame", mainFrame)
sideBar.Size = UDim2.new(0, 150, 1, 0)
sideBar.BackgroundTransparency = 1
local contentContainer = Instance.new("Frame", mainFrame)
contentContainer.Size = UDim2.new(1, -160, 1, -10)
contentContainer.Position = UDim2.new(0, 155, 0, 5)
contentContainer.BackgroundTransparency = 1

-- פונקציה להוספת קטגוריה
local function AddCategory(name)
    local btn = Instance.new("TextButton", sideBar)
    btn.Size = UDim2.new(0.9, 0, 0, 35)
    btn.Position = UDim2.new(0.05, 0, 0, #sideBar:GetChildren() * 40)
    btn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    
    local page = Instance.new("ScrollingFrame", contentContainer)
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.Visible = false
    page.ScrollBarThickness = 2
    Instance.new("UIListLayout", page).Padding = UDim.new(0, 5)
    
    btn.MouseButton1Click:Connect(function()
        for _, p in pairs(contentContainer:GetChildren()) do if p:IsA("ScrollingFrame") then p.Visible = false end end
        page.Visible = true
    end)
    return page 
end

-- פונקציה להוספת כפתור לתוך קטגוריה
local function AddButton(categoryPage, label, callback)
    local btn = Instance.new("TextButton", categoryPage)
    btn.Size = UDim2.new(0.9, 0, 0, 35)
    btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    btn.Text = label
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    
    btn.MouseButton1Click:Connect(callback)
end

-- --- כאן אתה מוסיף את התוכן שלך ---

-- 1. צור קטגוריות
local combat = AddCategory("Combat")
local visuals = AddCategory("Visuals")

-- 2. תוסיף כפתורים לכל קטגוריה (פשוט תקרא ל-AddButton)
AddButton(combat, "Kill Aura", function()
    print("Kill Aura Enabled!")
    -- כאן תכתוב את הקוד של ה-Kill Aura
end)

AddButton(combat, "Speed Hack", function()
    print("Speed Hack Enabled!")
end)

AddButton(visuals, "ESP", function()
    print("ESP On!")
end)

print("✅ Menu Initialized with Buttons!")
