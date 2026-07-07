local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- ניקוי קודם
if playerGui:FindFirstChild("ModernMenu") then playerGui:FindFirstChild("ModernMenu"):Destroy() end

-- יצירת ה-GUI עם DisplayOrder גבוה כדי שיהיה מעל הכל
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ModernMenu"
screenGui.DisplayOrder = 999 
screenGui.IgnoreGuiInset = true
screenGui.Parent = playerGui

-- פונקציה ליצירת אלמנט מעוצב (כדי לחסוך קוד)
local function Create(class, props, parent)
    local obj = Instance.new(class)
    for i, v in pairs(props) do obj[i] = v end
    obj.Parent = parent
    return obj
end

-- פריים ראשי
local main = Create("Frame", {
    Size = UDim2.new(0, 500, 0, 300),
    Position = UDim2.new(0.5, -250, 0.5, -150),
    BackgroundColor3 = Color3.fromRGB(25, 25, 25),
    BorderSizePixel = 0
}, screenGui)
Create("UICorner", {CornerRadius = UDim.new(0, 10)}, main)
Create("UIStroke", {Color = Color3.fromRGB(50, 50, 50), Thickness = 2}, main)

-- אזור ניווט (Sidebar)
local sideBar = Create("Frame", {
    Size = UDim2.new(0, 120, 1, 0),
    BackgroundTransparency = 1
}, main)
Create("UIListLayout", {Padding = UDim.new(0, 5), HorizontalAlignment = Enum.HorizontalAlignment.Center, PaddingTop = UDim.new(0, 10)}, sideBar)

-- אזור תוכן
local content = Create("Frame", {
    Size = UDim2.new(1, -130, 1, -10),
    Position = UDim2.new(0, 125, 0, 5),
    BackgroundTransparency = 1
}, main)

-- פונקציית יצירת קטגוריה
local function AddCategory(name)
    local btn = Create("TextButton", {
        Size = UDim2.new(0.9, 0, 0, 35),
        BackgroundColor3 = Color3.fromRGB(40, 40, 40),
        Text = name,
        TextColor3 = Color3.new(1, 1, 1),
        Font = Enum.Font.GothamSemibold,
        TextSize = 14
    }, sideBar)
    Create("UICorner", {CornerRadius = UDim.new(0, 5)}, btn)
    
    local page = Create("ScrollingFrame", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Visible = false,
        ScrollBarThickness = 2
    }, content)
    Create("UIListLayout", {Padding = UDim.new(0, 5)}, page)
    
    btn.MouseButton1Click:Connect(function()
        for _, p in pairs(content:GetChildren()) do if p:IsA("ScrollingFrame") then p.Visible = false end end
        page.Visible = true
    end)
    return page
end

-- הוספת תוכן לדוגמה
local combat = AddCategory("Combat")
local visuals = AddCategory("Visuals")

-- פונקציית הוספת כפתור לתוכן
local function AddButton(page, text, callback)
    local btn = Create("TextButton", {
        Size = UDim2.new(0.9, 0, 0, 30),
        BackgroundColor3 = Color3.fromRGB(60, 60, 60),
        Text = text,
        TextColor3 = Color3.new(1, 1, 1),
        Font = Enum.Font.Gotham
    }, page)
    Create("UICorner", {CornerRadius = UDim.new(0, 4)}, btn)
    btn.MouseButton1Click:Connect(callback)
end

AddButton(combat, "Kill Aura", function() print("Aura") end)
AddButton(visuals, "ESP", function() print("ESP") end)

print("✅ UI המודרני נטען!")
