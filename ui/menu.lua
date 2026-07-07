-- הגדרות בסיסיות
local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
if playerGui:FindFirstChild("ModernMenu") then playerGui:FindFirstChild("ModernMenu"):Destroy() end

local screenGui = Instance.new("ScreenGui", playerGui)
screenGui.Name = "ModernMenu"

local mainFrame = Instance.new("Frame", screenGui)
mainFrame.Size = UDim2.new(0, 600, 0, 400)
mainFrame.Position = UDim2.new(0.5, -300, 0.5, -200)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BorderSizePixel = 0
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 15)

-- Sidebar (כאן יהיו הכפתורים)
local sideBar = Instance.new("Frame", mainFrame)
sideBar.Size = UDim2.new(0, 150, 1, -20)
sideBar.Position = UDim2.new(0, 10, 0, 10)
sideBar.BackgroundTransparency = 1 -- שקוף כדי לראות את הכפתורים

-- ה-Layout שמסדר את הכפתורים אוטומטית
local listLayout = Instance.new("UIListLayout", sideBar)
listLayout.Padding = UDim.new(0, 5)
listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- Content Container
local contentContainer = Instance.new("Frame", mainFrame)
contentContainer.Size = UDim2.new(1, -180, 1, -20)
contentContainer.Position = UDim2.new(0, 170, 0, 10)
contentContainer.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
contentContainer.BorderSizePixel = 0
Instance.new("UICorner", contentContainer).CornerRadius = UDim.new(0, 8)

-- פונקציות יצירה
local firstCategory = true

local function AddCategory(name)
    -- יצירת הכפתור ב-Sidebar
    local btn = Instance.new("TextButton", sideBar)
    btn.Size = UDim2.new(0.9, 0, 0, 40)
    btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextScaled = true
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    
    -- יצירת הדף
    local page = Instance.new("ScrollingFrame", contentContainer)
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.Visible = false
    page.ScrollBarThickness = 2
    Instance.new("UIListLayout", page).Padding = UDim.new(0, 5)

    if firstCategory then
        page.Visible = true
        btn.BackgroundColor3 = Color3.fromRGB(100, 100, 100) -- צבע דגש לראשון
        firstCategory = false
    end
    
    btn.MouseButton1Click:Connect(function()
        for _, p in pairs(contentContainer:GetChildren()) do if p:IsA("ScrollingFrame") then p.Visible = false end end
        for _, b in pairs(sideBar:GetChildren()) do if b:IsA("TextButton") then b.BackgroundColor3 = Color3.fromRGB(60, 60, 60) end end
        page.Visible = true
        btn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    end)
    return page 
end

local function AddButton(categoryPage, label, callback)
    local btn = Instance.new("TextButton", categoryPage)
    btn.Size = UDim2.new(0.9, 0, 0, 35)
    btn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    btn.Text = label
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    btn.MouseButton1Click:Connect(callback)
end

-- --- הוספת תוכן ---
local combat = AddCategory("Combat")
local visuals = AddCategory("Visuals")

AddButton(combat, "Kill Aura", function() print("Kill Aura!") end)
AddButton(visuals, "ESP", function() print("ESP!") end)

print("✅ UI & Buttons Created!")
