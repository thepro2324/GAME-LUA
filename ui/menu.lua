-- הגדרות בסיסיות
local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- ניקוי קודם
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
local sideBar = Instance.new("ScrollingFrame", mainFrame)
sideBar.Size = UDim2.new(0, 150, 1, 0)
sideBar.BackgroundTransparency = 1
sideBar.ScrollBarThickness = 0
local listLayout = Instance.new("UIListLayout", sideBar)
listLayout.Padding = UDim.new(0, 5)

-- אזור התוכן (Content Container)
local contentContainer = Instance.new("Frame", mainFrame)
contentContainer.Size = UDim2.new(1, -160, 1, -10)
contentContainer.Position = UDim2.new(0, 155, 0, 5)
contentContainer.BackgroundTransparency = 1

-- פונקציה להוספת קטגוריה (כאן הקסם קורה)
local function AddCategory(name, callback)
    -- 1. יצירת כפתור בניווט
    local btn = Instance.new("TextButton", sideBar)
    btn.Size = UDim2.new(1, 0, 0, 40)
    btn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    btn.Text = name
    btn.TextColor3 = Color3.new(1, 1, 1)
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    
    -- 2. יצירת דף התוכן של הקטגוריה
    local page = Instance.new("Frame", contentContainer)
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.Visible = false -- מתחילים שהכל חבוי

    -- 3. לוגיקת מעבר בין דפים
    btn.MouseButton1Click:Connect(function()
        for _, p in pairs(contentContainer:GetChildren()) do
            if p:IsA("Frame") then p.Visible = false end
        end
        page.Visible = true
    end)

    -- מחזירים את ה-page כדי שתוכל להוסיף אליו כפתורים
    return page 
end

-- --- כאן אתה מוסיף את הקטגוריות שלך ---
local combatPage = AddCategory("Combat")
local visualsPage = AddCategory("Visuals")

-- דוגמה לאיך מוסיפים כפתור בתוך קטגוריה (תחליף את זה ב-UI שלך):
local btnTest = Instance.new("TextButton", combatPage)
btnTest.Text = "Kill All"
btnTest.Size = UDim2.new(0, 100, 0, 30)
btnTest.BackgroundColor3 = Color3.fromRGB(200, 0, 0)

print("✅ UI Created Successfully!")
