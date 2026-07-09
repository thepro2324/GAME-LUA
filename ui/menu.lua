-- =========================================================================
-- ORI HUB - SIDEBAR ONLY (נקי, יציב ומעוצב)
-- =========================================================================
local CoreGui = game:GetService("CoreGui")

-- ניקוי GUI קודם
if CoreGui:FindFirstChild("OriHub") then CoreGui:FindFirstChild("OriHub"):Destroy() end

-- הגדרות צבעים
local Colors = {
    Sidebar = Color3.fromRGB(28, 28, 28),
    Button = Color3.fromRGB(40, 40, 40),
    Hover = Color3.fromRGB(60, 120, 255),
    Text = Color3.fromRGB(255, 255, 255)
}

-- יצירת המעטפת (הסרגל)
local screen = Instance.new("ScreenGui", CoreGui); screen.Name = "OriHub"
local sidebar = Instance.new("Frame", screen); sidebar.Size = UDim2.new(0, 160, 0, 400); sidebar.Position = UDim2.new(0.5, -300, 0.5, -200); sidebar.BackgroundColor3 = Colors.Sidebar
Instance.new("UICorner", sidebar).CornerRadius = UDim.new(0, 10)
Instance.new("UIStroke", sidebar).Color = Color3.fromRGB(50, 50, 50)

-- סידור הכפתורים (ללא PaddingTop בשגיאות)
local listLayout = Instance.new("UIListLayout", sidebar); listLayout.Padding = UDim.new(0, 8); listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
Instance.new("UIPadding", sidebar).PaddingTop = UDim.new(0, 15) -- זה הרווח מלמעלה בצורה בטוחה

-- פונקציה ליצירת כפתור עם אפקט Hover
local function createCategoryButton(name)
    local btn = Instance.new("TextButton", sidebar)
    btn.Size = UDim2.new(0.85, 0, 0, 45)
    btn.Text = name
    btn.BackgroundColor3 = Colors.Button
    btn.TextColor3 = Colors.Text
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    btn.AutoButtonColor = false -- כדי שהאפקט שלנו יעבוד חלק
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    
    -- אפקט Hover
    btn.MouseEnter:Connect(function() btn.BackgroundColor3 = Colors.Hover end)
    btn.MouseLeave:Connect(function() btn.BackgroundColor3 = Colors.Button end)
    
    -- לחיצה
    btn.MouseButton1Click:Connect(function() print("Category selected: " .. name) end)
end

-- יצירת הכפתורים
local categories = {"Player", "Visuals", "Teleport", "Target", "World", "Settings"}
for _, name in pairs(categories) do
    createCategoryButton(name)
end

print("Sidebar Loaded Successfully!")
