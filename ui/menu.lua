-- הגדרות בסיסיות
local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- ניקוי GUI ישן אם קיים
if playerGui:FindFirstChild("ModernMenu") then
    playerGui:FindFirstChild("ModernMenu"):Destroy()
end

-- יצירת ה-ScreenGui
local screenGui = Instance.new("ScreenGui", playerGui)
screenGui.Name = "ModernMenu"

-- ה-Frame הראשי
local mainFrame = Instance.new("Frame", screenGui)
mainFrame.Size = UDim2.new(0, 600, 0, 400)
mainFrame.Position = UDim2.new(0.5, -300, 0.5, -200)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BorderSizePixel = 0
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 15)
Instance.new("UIStroke", mainFrame).Color = Color3.fromRGB(60, 60, 60)

-- אזור הניווט (Sidebar)
local sideBar = Instance.new("Frame", mainFrame)
sideBar.Size = UDim2.new(0, 150, 1, 0)
sideBar.BackgroundTransparency = 1
local listLayout = Instance.new("UIListLayout", sideBar)
listLayout.Padding = UDim.new(0, 5)
listLayout.PaddingTop = UDim.new(0, 10)

-- אזור התוכן (Content Container)
local contentContainer = Instance.new("Frame", mainFrame)
contentContainer.Size = UDim2.new(1, -160, 1, -10)
contentContainer.Position = UDim2.new(0, 155, 0, 5)
contentContainer.BackgroundTransparency = 1

-- פונקציה להוספת קטגוריה
local function AddCategory(name)
    -- כפתור בצד
    local btn = Instance.new("TextButton", sideBar)
    btn.Size = UDim2.new(0.9, 0, 0, 35)
    btn.Position = UDim2.new(0.05, 0, 0, 0)
    btn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    
    -- דף תוכן
    local page = Instance.new("ScrollingFrame", contentContainer)
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.Visible = false
    page.ScrollBarThickness = 2
    
    -- לוגיקת מעבר
    btn.MouseButton1Click:Connect(function()
        for _, p in pairs(contentContainer:GetChildren()) do
            if p:IsA("ScrollingFrame") then p.Visible = false end
        end
        page.Visible = true
    end)
    
    return page 
end

-- --- כאן אתה מוסיף את הקטגוריות שלך ---
local combatPage = AddCategory("Combat")
local visualsPage = AddCategory("Visuals")

-- דוגמה איך להוסיף כפתור בתוך דף:
local testBtn = Instance.new("TextButton", combatPage)
testBtn.Text = "Kill Aura"
testBtn.Size = UDim2.new(0.8, 0, 0, 30)
testBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
testBtn.TextColor3 = Color3.fromRGB(255, 255, 255)

print("✅ UI Created Successfully!")
