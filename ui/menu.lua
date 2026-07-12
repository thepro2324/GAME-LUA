-- =========================================================================
-- ORI HUB V12 - MODULAR HOST
-- =========================================================================
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")

-- 1. פונקציית טעינה מהירה
_G.loadModule = function(name)
    local url = "https://raw.githubusercontent.com/thepro2324/GAME-LUA/main/modules/" .. name .. ".lua"
    local success, res = pcall(function() return game:HttpGet(url) end)
    if not success then return nil end
    local func = loadstring(res)
    return func and func() or nil
end

-- 2. ספרית ה-Elements (הכלי שבעזרתו המודולים יבנו לעצמם את הכפתורים)
_G.Elements = {}
local Colors = { Main = Color3.fromRGB(20, 20, 20), Sidebar = Color3.fromRGB(28, 28, 28), Button = Color3.fromRGB(40, 40, 40), Accent = Color3.fromRGB(60, 120, 255), Text = Color3.fromRGB(255, 255, 255) }

function _G.Elements.addCorner(p) local c = Instance.new("UICorner", p); c.CornerRadius = UDim.new(0, 6) end
function _G.Elements.createLabel(parent, text)
    local lbl = Instance.new("TextLabel", parent); lbl.Size = UDim2.new(0.9, 0, 0, 30); lbl.BackgroundTransparency = 1; lbl.Text = text; lbl.TextColor3 = Colors.Text; lbl.Font = Enum.Font.GothamBold; lbl.TextSize = 16; return lbl
end
function _G.Elements.createButton(parent, text, callback)
    local btn = Instance.new("TextButton", parent); btn.Size = UDim2.new(0.9, 0, 0, 40); btn.BackgroundColor3 = Colors.Button; btn.Text = text; btn.TextColor3 = Colors.Text; btn.Font = Enum.Font.GothamBold; btn.TextSize = 15; _G.Elements.addCorner(btn)
    btn.MouseButton1Click:Connect(callback)
    return btn
end
function _G.Elements.createToggleButton(parent, text, default, callback)
    local btn = Instance.new("TextButton", parent); btn.Size = UDim2.new(0.9, 0, 0, 40); btn.BackgroundColor3 = default and Colors.Accent or Colors.Button
    btn.Text = text .. ": " .. (default and "ON" or "OFF"); btn.TextColor3 = Colors.Text; btn.Font = Enum.Font.GothamBold; btn.TextSize = 15; _G.Elements.addCorner(btn)
    local state = default
    btn.MouseButton1Click:Connect(function() state = not state; btn.Text = text .. ": " .. (state and "ON" or "OFF"); btn.BackgroundColor3 = state and Colors.Accent or Colors.Button; callback(state) end)
end

-- 3. בניית ה-UI
if CoreGui:FindFirstChild("OriHub") then CoreGui:FindFirstChild("OriHub"):Destroy() end
local screen = Instance.new("ScreenGui", CoreGui); screen.Name = "OriHub"
local frame = Instance.new("Frame", screen); frame.Size = UDim2.new(0, 600, 0, 400); frame.Position = UDim2.new(0.5, -300, 0.5, -200); frame.BackgroundColor3 = Colors.Main; frame.Active = true; _G.Elements.addCorner(frame); Instance.new("UIStroke", frame).Color = Color3.fromRGB(50, 50, 50)

-- גרירה
local d, s, p; frame.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then d=true; s=i.Position; p=frame.Position end end)
UserInputService.InputChanged:Connect(function(i) if d and i.UserInputType == Enum.UserInputType.MouseMovement then frame.Position = UDim2.new(p.X.Scale, p.X.Offset + (i.Position.X - s.X), p.Y.Scale, p.Y.Offset + (i.Position.Y - s.Y)) end end)
UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then d=false end end)

local sidebar = Instance.new("Frame", frame); sidebar.Size = UDim2.new(0, 160, 1, 0); sidebar.BackgroundColor3 = Colors.Sidebar; sidebar.Active = false; _G.Elements.addCorner(sidebar)
Instance.new("UIListLayout", sidebar).Padding = UDim.new(0, 8); Instance.new("UIPadding", sidebar).PaddingTop = UDim.new(0, 15); Instance.new("UIListLayout", sidebar).HorizontalAlignment = Enum.HorizontalAlignment.Center
local content = Instance.new("Frame", frame); content.Size = UDim2.new(1, -160, 1, 0); content.Position = UDim2.new(0, 160, 0, 0); content.BackgroundTransparency = 1

-- 4. לוגיקת טעינת מודולים
local categories = {"Home", "Player", "Visuals", "Teleport", "Target", "World", "Settings"}
for _, name in pairs(categories) do
    local tab = Instance.new("ScrollingFrame", content); tab.Size = UDim2.new(1,0,1,0); tab.BackgroundTransparency = 1; tab.Visible = false; tab.AutomaticCanvasSize = Enum.AutomaticSize.Y
    Instance.new("UIListLayout", tab).Padding = UDim.new(0, 10); Instance.new("UIPadding", tab).PaddingLeft = UDim.new(0, 15); Instance.new("UIPadding", tab).PaddingTop = UDim.new(0, 15)
    
    local btn = Instance.new("TextButton", sidebar); btn.Size = UDim2.new(0.85, 0, 0, 45); btn.Text = name; btn.BackgroundColor3 = Colors.Button; btn.TextColor3 = Colors.Text; btn.Font = Enum.Font.GothamBold; btn.TextSize = 16; _G.Elements.addCorner(btn)
    
    local isLoaded = false
    btn.MouseButton1Click:Connect(function()
        for _, c in pairs(content:GetChildren()) do if c:IsA("ScrollingFrame") then c.Visible = false end end
        tab.Visible = true
        
        if not isLoaded then
            local mod = _G.loadModule(string.lower(name))
            if mod and mod.init then 
                mod.init(tab, _G.Elements) 
                isLoaded = true 
            end
        end
    end)
end
