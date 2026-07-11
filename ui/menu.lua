-- =========================================================================
-- ORI HUB - FINAL BUILD
-- =========================================================================
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local urlBase = "https://raw.githubusercontent.com/thepro2324/GAME-LUA/main/"

-- 1. הגדרת ספרית ה-Elements (זה הלב של הכל!)
_G.Elements = {}
function _G.Elements.createToggleButton(parent, text, default, callback)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(0.9, 0, 0, 35); btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    btn.Text = text .. ": " .. (default and "On" or "Off")
    btn.TextColor3 = Color3.new(1, 1, 1); btn.Font = Enum.Font.Gotham; btn.TextSize = 14
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    local state = default
    btn.MouseButton1Click:Connect(function()
        state = not state; btn.Text = text .. ": " .. (state and "On" or "Off")
        callback(state)
    end)
end

-- 2. פונקציית טעינה
_G.loadModule = function(path)
    local url = urlBase .. path
    local success, response = pcall(function() return game:HttpGet(url) end)
    if not success then return nil end
    local func = loadstring(response)
    return func and func() or nil
end

-- 3. יצירת ה-UI
if CoreGui:FindFirstChild("OriHub") then CoreGui:FindFirstChild("OriHub"):Destroy() end
local screen = Instance.new("ScreenGui", CoreGui); screen.Name = "OriHub"
local frame = Instance.new("Frame", screen); frame.Size = UDim2.new(0, 600, 0, 400)
frame.Position = UDim2.new(0.5, -300, 0.5, -200); frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.Active = true; Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)

-- (גרירה)
local dragStart, startPos; frame.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragStart = i.Position; startPos = frame.Position end end)
UserInputService.InputChanged:Connect(function(i) if dragStart and i.UserInputType == Enum.UserInputType.MouseMovement then frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + (i.Position.X - dragStart.X), startPos.Y.Scale, startPos.Y.Offset + (i.Position.Y - dragStart.Y)) end end)
UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragStart = nil end end)

-- 4. צדדים
local sidebar = Instance.new("Frame", frame); sidebar.Size = UDim2.new(0, 150, 1, 0); sidebar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
local content = Instance.new("Frame", frame); content.Size = UDim2.new(1, -150, 1, 0); content.Position = UDim2.new(0, 150, 0, 0); content.BackgroundTransparency = 1
Instance.new("UIListLayout", sidebar).Padding = UDim.new(0, 5)

-- 5. כפתורים
local categories = {"Home", "Player", "Visuals", "Settings"}
for _, name in pairs(categories) do
    local btn = Instance.new("TextButton", sidebar); btn.Size = UDim2.new(1, 0, 0, 40); btn.Text = name; btn.BackgroundColor3 = Color3.fromRGB(45, 45, 45); btn.TextColor3 = Color3.new(1,1,1)
    btn.MouseButton1Click:Connect(function()
        content:ClearAllChildren()
        local mod = _G.loadModule("modules/"..string.lower(name)..".lua")
        if mod and mod.init then
            mod.init(content, _G.Elements)
        else
            warn("Module " .. name .. " not found or broken!")
        end
    end)
end
