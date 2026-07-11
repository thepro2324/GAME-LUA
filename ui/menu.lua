-- =========================================================================
-- ORI HUB V10 - PROFESSIONAL DRAG LOGIC
-- =========================================================================
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")

if CoreGui:FindFirstChild("OriHub") then CoreGui:FindFirstChild("OriHub"):Destroy() end

-- הגדרות עיצוב
local Colors = {
    Main = Color3.fromRGB(20, 20, 20),
    Sidebar = Color3.fromRGB(28, 28, 28),
    Button = Color3.fromRGB(40, 40, 40),
    Accent = Color3.fromRGB(60, 120, 255),
    Text = Color3.fromRGB(255, 255, 255)
}

-- יצירת מסך ופריים
local screen = Instance.new("ScreenGui", CoreGui); screen.Name = "OriHub"
local frame = Instance.new("Frame", screen)
frame.Size = UDim2.new(0, 600, 0, 400); frame.Position = UDim2.new(0.5, -300, 0.5, -200)
frame.BackgroundColor3 = Colors.Main; frame.Active = true -- Active נשאר כדי לקלוט לחיצה
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10); Instance.new("UIStroke", frame).Color = Color3.fromRGB(50, 50, 50)

-- === [מנוע גרירה מקצועי] ===
local dragging, dragInput, dragStart, startPos
frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = frame.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)
-- === [סוף מנוע גרירה] ===

-- Sidebar (Active = false כדי לא לחסום את הגרירה)
local sidebar = Instance.new("Frame", frame); sidebar.Size = UDim2.new(0, 160, 1, 0)
sidebar.BackgroundColor3 = Colors.Sidebar; sidebar.Active = false
Instance.new("UICorner", sidebar).CornerRadius = UDim.new(0, 10)
Instance.new("UIPadding", sidebar).PaddingTop = UDim.new(0, 15)
local listLayout = Instance.new("UIListLayout", sidebar)
listLayout.Padding = UDim.new(0, 8); listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- Content Container
local content = Instance.new("Frame", frame); content.Size = UDim2.new(1, -160, 1, 0); content.Position = UDim2.new(0, 160, 0, 0)
content.BackgroundTransparency = 1; content.Active = false

-- (שאר הקוד ליצירת הטאבים והכפתורים נשאר אותו דבר כמו בגרסה הקודמת)
local initializedTabs = {}
local Tabs = {}

local function createTab(name)
    local page = Instance.new("ScrollingFrame", content)
    page.Size = UDim2.new(1, 0, 1, 0); page.BackgroundTransparency = 1; page.BorderSizePixel = 0
    page.ScrollBarThickness = 2; page.Visible = false; page.AutomaticCanvasSize = Enum.AutomaticSize.Y
    local list = Instance.new("UIListLayout", page); list.Padding = UDim.new(0, 10)
    Instance.new("UIPadding", page).PaddingLeft = UDim.new(0, 15); Instance.new("UIPadding", page).PaddingTop = UDim.new(0, 15)
    Tabs[name] = page
    return page
end

local categories = {"Home", "Player", "Visuals", "Teleport", "Target", "World", "Settings"}
for _, name in pairs(categories) do
    local tab = createTab(name)
    local btn = Instance.new("TextButton", sidebar)
    btn.Size = UDim2.new(0.85, 0, 0, 45); btn.Text = name; btn.BackgroundColor3 = Colors.Button
    btn.TextColor3 = Colors.Text; btn.Font = Enum.Font.GothamBold; btn.TextSize = 14; btn.AutoButtonColor = false
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    btn.MouseButton1Click:Connect(function()
        for _, otherTab in pairs(Tabs) do otherTab.Visible = false end
        tab.Visible = true
        if not initializedTabs[name] then
            -- וודא שהפונקציה _G.loadModule קיימת בסקריפט ההרצה שלך
            local success, mod = pcall(function() return _G.loadModule(name) end)
            if success and mod then mod.init(tab, _G.Elements) initializedTabs[name] = true end
        end
    end)
    btn.MouseEnter:Connect(function() btn.BackgroundColor3 = Colors.Accent end)
    btn.MouseLeave:Connect(function() btn.BackgroundColor3 = Colors.Button end)
end

Tabs["Home"].Visible = true
print("Ori Hub V10 Loaded - Drag Engine Active!")
