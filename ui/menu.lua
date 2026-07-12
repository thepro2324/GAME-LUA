-- =========================================================================
-- ORI HUB - ORIGINAL DESIGN & DYNAMIC ENGINE
-- =========================================================================
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

-- 1. ניקוי קודם
if CoreGui:FindFirstChild("OriHub") then CoreGui:FindFirstChild("OriHub"):Destroy() end

-- 2. ספרית האלמנטים הגלובלית (כדי שהמודולים ישתמשו בה)
_G.Elements = {}
function _G.Elements.addCorner(p, r) local c = Instance.new("UICorner", p); c.CornerRadius = r or UDim.new(0, 6) end

function _G.Elements.createToggleButton(parent, text, isActive, callback)
    local button = Instance.new("TextButton", parent); button.Size = UDim2.new(0.9, 0, 0, 32); button.BackgroundColor3 = Color3.fromRGB(22, 22, 28); button.Font = Enum.Font.GothamBold; button.TextSize = 12; _G.Elements.addCorner(button, UDim.new(0, 5))
    local state = isActive; local function update() button.Text = text .. (state and " : ON" or " : OFF"); button.TextColor3 = state and Color3.fromRGB(80, 255, 140) or Color3.fromRGB(220, 80, 80) end; update()
    button.MouseButton1Click:Connect(function() state = not state; update(); callback(state) end)
end

function _G.Elements.createSlider(parent, text, min, max, default, callback)
    local frame = Instance.new("Frame", parent); frame.Size = UDim2.new(0.9, 0, 0, 40); frame.BackgroundTransparency = 1
    local label = Instance.new("TextLabel", frame); label.Size = UDim2.new(1, 0, 0, 20); label.Text = text .. " - " .. default; label.TextColor3 = Color3.new(1,1,1); label.BackgroundTransparency = 1; label.Font = Enum.Font.Gotham; label.TextSize = 12
    local bg = Instance.new("Frame", frame); bg.Size = UDim2.new(1, 0, 0, 6); bg.Position = UDim2.new(0, 0, 0, 25); bg.BackgroundColor3 = Color3.fromRGB(25, 25, 32); _G.Elements.addCorner(bg, UDim.new(1, 0))
    local fill = Instance.new("Frame", bg); fill.Size = UDim2.new((default-min)/(max-min), 0, 1, 0); fill.BackgroundColor3 = Color3.fromRGB(85, 110, 240); _G.Elements.addCorner(fill, UDim.new(1, 0))
    bg.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then local pos = math.clamp((input.Position.X - bg.AbsolutePosition.X) / bg.AbsoluteSize.X, 0, 1); fill.Size = UDim2.new(pos, 0, 1, 0); local val = math.floor(min + (pos * (max-min))); label.Text = text .. " - " .. val; callback(val) end end)
end

-- 3. פונקציית טעינת מודולים
_G.loadModule = function(path)
    local url = "https://raw.githubusercontent.com/thepro2324/GAME-LUA/main/" .. path
    local success, response = pcall(function() return game:HttpGet(url) end)
    if not success then return nil end
    local func = loadstring(response)
    return func and func() or nil
end

-- 4. בניית ה-UI המקורי
local screen = Instance.new("ScreenGui", CoreGui); screen.Name = "OriHub"
local frame = Instance.new("Frame", screen); frame.Size = UDim2.new(0, 600, 0, 375); frame.Position = UDim2.new(0.5, -300, 0.5, -187.5); frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30); _G.Elements.addCorner(frame, UDim.new(0, 10)); frame.Active = true

-- מנוע גרירה
local dragging, dragStart, startPos
frame.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true; dragStart = i.Position; startPos = frame.Position end end)
UserInputService.InputChanged:Connect(function(i) if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + (i.Position.X - dragStart.X), startPos.Y.Scale, startPos.Y.Offset + (i.Position.Y - dragStart.Y)) end end)
UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)

local sidebar = Instance.new("Frame", frame); sidebar.Size = UDim2.new(0, 140, 1, 0); sidebar.BackgroundColor3 = Color3.fromRGB(40, 40, 40); _G.Elements.addCorner(sidebar, UDim.new(0, 10))
local mainContent = Instance.new("Frame", frame); mainContent.Size = UDim2.new(1, -140, 1, 0); mainContent.Position = UDim2.new(0, 140, 0, 0); mainContent.BackgroundTransparency = 1

-- 5. כפתורי צד וטעינה
local btnY = 20
local categories = {"Home", "Player", "Visuals", "Teleport", "Settings"}
for _, name in pairs(categories) do
    local b = Instance.new("TextButton", sidebar); b.Size = UDim2.new(0.8, 0, 0, 35); b.Position = UDim2.new(0.1, 0, 0, btnY); b.Text = name; b.BackgroundColor3 = Color3.fromRGB(60, 60, 60); b.TextColor3 = Color3.new(1,1,1); b.Font = Enum.Font.Gotham; _G.Elements.addCorner(b, UDim.new(0, 6))
    b.MouseButton1Click:Connect(function()
        mainContent:ClearAllChildren()
        local mod = _G.loadModule("modules/"..string.lower(name)..".lua")
        if mod and mod.init then
            local scroll = Instance.new("ScrollingFrame", mainContent); scroll.Size = UDim2.new(1,0,1,0); scroll.BackgroundTransparency = 1; scroll.ScrollBarThickness = 2; scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
            Instance.new("UIListLayout", scroll).Padding = UDim.new(0, 10)
            mod.init(scroll, _G.Elements)
        end
    end)
    btnY += 45
end
