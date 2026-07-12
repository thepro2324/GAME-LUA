-- =========================================================================
-- ORI HUB V11 - CLEAN & PROFESSIONAL UI
-- =========================================================================
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

-- הגדרות צבעים (Dark Modern Theme)
local Colors = {
    Main = Color3.fromRGB(22, 22, 22),
    Sidebar = Color3.fromRGB(28, 28, 28),
    Button = Color3.fromRGB(35, 35, 35),
    Accent = Color3.fromRGB(65, 130, 255), -- כחול יפה
    Text = Color3.fromRGB(240, 240, 240)
}

-- 1. פונקציית טעינה
_G.loadModule = function(path)
    local url = "https://raw.githubusercontent.com/thepro2324/GAME-LUA/main/" .. path
    local success, response = pcall(function() return game:HttpGet(url) end)
    if not success then return nil end
    return loadstring(response)()
end

-- 2. יצירת ה-UI המעוצב
if CoreGui:FindFirstChild("OriHub") then CoreGui:FindFirstChild("OriHub"):Destroy() end
local screen = Instance.new("ScreenGui", CoreGui); screen.Name = "OriHub"

local frame = Instance.new("Frame", screen)
frame.Size = UDim2.new(0, 550, 0, 350); frame.Position = UDim2.new(0.5, -275, 0.5, -175)
frame.BackgroundColor3 = Colors.Main; frame.Active = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)
Instance.new("UIStroke", frame).Color = Color3.fromRGB(50, 50, 50); Instance.new("UIStroke", frame).Thickness = 2

-- === [מנוע גרירה חכם] ===
local dragging, dragStart, startPos
frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true; dragStart = input.Position; startPos = frame.Position
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)

-- Sidebar
local sidebar = Instance.new("Frame", frame); sidebar.Size = UDim2.new(0, 140, 1, 0)
sidebar.BackgroundColor3 = Colors.Sidebar; Instance.new("UICorner", sidebar).CornerRadius = UDim.new(0, 12)
Instance.new("UIListLayout", sidebar).Padding = UDim.new(0, 5); Instance.new("UIPadding", sidebar).PaddingTop = UDim.new(0, 10)

-- Content
local content = Instance.new("Frame", frame); content.Size = UDim2.new(1, -140, 1, 0); content.Position = UDim2.new(0, 140, 0, 0); content.BackgroundTransparency = 1

-- 3. יצירת אלמנטים (Elements)
_G.Elements = {}
function _G.Elements.createToggleButton(parent, text, default, callback)
    local btn = Instance.new("TextButton", parent); btn.Size = UDim2.new(0.9, 0, 0, 40)
    btn.BackgroundColor3 = Colors.Button; btn.Text = text; btn.TextColor3 = Colors.Text
    btn.Font = Enum.Font.GothamMedium; btn.AutoButtonColor = false
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    
    local state = default
    local function update()
        btn.BackgroundColor3 = state and Colors.Accent or Colors.Button
        callback(state)
    end
    btn.MouseButton1Click:Connect(function() state = not state; update() end)
    update()
end

-- 4. טעינת קטגוריות
local categories = {"Home", "Player", "Visuals", "Settings"}
for _, name in pairs(categories) do
    local btn = Instance.new("TextButton", sidebar); btn.Size = UDim2.new(0.9, 0, 0, 40)
    btn.BackgroundColor3 = Colors.Button; btn.Text = name; btn.TextColor3 = Colors.Text; btn.Font = Enum.Font.GothamBold
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    
    btn.MouseButton1Click:Connect(function()
        content:ClearAllChildren()
        local mod = _G.loadModule("modules/"..string.lower(name)..".lua")
        if mod then mod.init(content, _G.Elements) end
    end)
    
    -- אפקט Hover (מעבר עכבר)
    btn.MouseEnter:Connect(function() TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Colors.Accent}):Play() end)
    btn.MouseLeave:Connect(function() TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Colors.Button}):Play() end)
end
