-- הגדרות בסיסיות וניקוי
local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
if playerGui:FindFirstChild("ModernMenu") then playerGui:FindFirstChild("ModernMenu"):Destroy() end

-- יצירת UI ראשי
local screenGui = Instance.new("ScreenGui", playerGui)
screenGui.Name = "ModernMenu"

local mainFrame = Instance.new("Frame", screenGui)
mainFrame.Size = UDim2.new(0, 600, 0, 400)
mainFrame.Position = UDim2.new(0.5, -300, 0.5, -200)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BorderSizePixel = 0
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 15)

-- אזור ה-Sidebar (הצד של הקטגוריות)
local sideBar = Instance.new("Frame", mainFrame)
sideBar.Size = UDim2.new(0, 150, 1, -20)
sideBar.Position = UDim2.new(0, 10, 0, 10)
sideBar.BackgroundColor3 = Color3.fromRGB(45, 45, 45) -- צבע בולט ל-Sidebar
sideBar.BorderSizePixel = 0
Instance.new("UICorner", sideBar).CornerRadius = UDim.new(0, 8)
Instance.new("UIListLayout", sideBar).Padding = UDim.new(0, 5)

-- אזור התוכן (הצד של הכפתורים)
local contentContainer = Instance.new("Frame", mainFrame)
contentContainer.Size = UDim2.new(1, -180, 1, -20)
contentContainer.Position = UDim2.new(0, 170, 0, 10)
contentContainer.BackgroundColor3 = Color3.fromRGB(40, 40, 40) -- צבע בולט ל-Content
contentContainer.BorderSizePixel = 0
Instance.new("UICorner", contentContainer).CornerRadius = UDim.new(0, 8)

-- פונקציות עזר
local firstCategory = true

local function AddCategory(name)
    -- כפתור קטגוריה ב-Sidebar
    local btn = Instance.new("TextButton", sideBar)
    btn.Size = UDim2.new(1, 0, 0, 40)
    btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    
    -- דף תוכן
    local page = Instance.new("ScrollingFrame", contentContainer)
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.Visible = false
    page.ScrollBarThickness = 2
    Instance.new("UIListLayout", page).Padding = UDim.new(0, 5)

    if firstCategory then
        page.Visible = true
        firstCategory = false
    end
    
    btn.MouseButton1Click:Connect(function()
        for _, p in pairs(contentContainer:GetChildren()) do if p:IsA("ScrollingFrame") then p.Visible = false end end
        page.Visible = true
    end)
    return page 
end

local function AddButton(categoryPage, label, callback)
    local btn = Instance.new("TextButton", categoryPage)
    btn.Size = UDim2.new(0.9, 0, 0, 35)
    btn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    btn.Text = label
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.MouseButton1Click:Connect(callback)
end

-- --- יצירת התוכן ---
local combat = AddCategory("Combat")
local visuals = AddCategory("Visuals")

AddButton(combat, "Kill Aura", function() print("Kill Aura!") end)
AddButton(visuals, "ESP", function() print("ESP!") end)

print("✅ UI Created!")
