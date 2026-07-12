-- =========================================================================
-- ORI HUB V13 - STABLE, FAST & MODULAR
-- =========================================================================
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")

_G.Elements = {}
local Colors = { Main = Color3.fromRGB(20, 20, 20), Sidebar = Color3.fromRGB(28, 28, 28), Button = Color3.fromRGB(40, 40, 40), Accent = Color3.fromRGB(60, 120, 255), Text = Color3.fromRGB(255, 255, 255) }

function _G.Elements.addCorner(p) local c = Instance.new("UICorner", p); c.CornerRadius = UDim.new(0, 6) end

-- פונקציות ליצירת אלמנטים
function _G.Elements.createLabel(parent, text)
    local lbl = Instance.new("TextLabel", parent); lbl.Size = UDim2.new(0.9, 0, 0, 30); lbl.BackgroundTransparency = 1; lbl.Text = text; lbl.TextColor3 = Colors.Text; lbl.Font = Enum.Font.GothamBold; lbl.TextSize = 16; return lbl
end

function _G.Elements.createButton(parent, text, callback)
    local btn = Instance.new("TextButton", parent); btn.Size = UDim2.new(0.9, 0, 0, 40); btn.BackgroundColor3 = Colors.Button; btn.Text = text; btn.TextColor3 = Colors.Text; btn.Font = Enum.Font.GothamBold; btn.TextSize = 15; _G.Elements.addCorner(btn)
    btn.MouseButton1Click:Connect(callback)
    return btn
end

-- סליידר חדש ומקצועי (למהירות, קפיצה, תעופה)
function _G.Elements.createSlider(parent, text, min, max, default, callback)
    local container = Instance.new("Frame", parent); container.Size = UDim2.new(0.9, 0, 0, 50); container.BackgroundTransparency = 1
    local lbl = Instance.new("TextLabel", container); lbl.Size = UDim2.new(1, 0, 0, 20); lbl.BackgroundTransparency = 1; lbl.Text = text .. ": " .. default; lbl.TextColor3 = Colors.Text; lbl.Font = Enum.Font.GothamBold
    local bar = Instance.new("Frame", container); bar.Size = UDim2.new(1, 0, 0, 8); bar.Position = UDim2.new(0, 0, 0, 30); bar.BackgroundColor3 = Colors.Button; _G.Elements.addCorner(bar)
    local fill = Instance.new("Frame", bar); fill.Size = UDim2.new((default-min)/(max-min), 0, 1, 0); fill.BackgroundColor3 = Colors.Accent; _G.Elements.addCorner(fill)
    
    local function update(input)
        local pos = math.clamp((input.Position.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
        fill.Size = UDim2.new(pos, 0, 1, 0); local val = math.floor(min + (pos * (max-min))); lbl.Text = text .. ": " .. val; callback(val)
    end
    bar.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then update(i) end end)
    bar.InputChanged:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseMovement and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then update(i) end end)
end

-- UI Setup
if CoreGui:FindFirstChild("OriHub") then CoreGui:FindFirstChild("OriHub"):Destroy() end
local screen = Instance.new("ScreenGui", CoreGui); screen.Name = "OriHub"
local frame = Instance.new("Frame", screen); frame.Size = UDim2.new(0, 600, 0, 400); frame.Position = UDim2.new(0.5, -300, 0.5, -200); frame.BackgroundColor3 = Colors.Main; frame.Active = true; _G.Elements.addCorner(frame); Instance.new("UIStroke", frame).Color = Color3.fromRGB(50, 50, 50)

-- גרירה
local d, s, p; frame.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then d=true; s=i.Position; p=frame.Position end end)
UserInputService.InputChanged:Connect(function(i) if d and i.UserInputType == Enum.UserInputType.MouseMovement then frame.Position = UDim2.new(p.X.Scale, p.X.Offset + (i.Position.X - s.X), p.Y.Scale, p.Y.Offset + (i.Position.Y - s.Y)) end end)
UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then d=false end end)

-- Sidebar & Content
local sidebar = Instance.new("Frame", frame); sidebar.Size = UDim2.new(0, 160, 1, 0); sidebar.BackgroundColor3 = Colors.Sidebar; _G.Elements.addCorner(sidebar)
Instance.new("UIListLayout", sidebar).Padding = UDim.new(0, 8); Instance.new("UIPadding", sidebar).PaddingTop = UDim.new(0, 15); Instance.new("UIListLayout", sidebar).HorizontalAlignment = Enum.HorizontalAlignment.Center
local content = Instance.new("Frame", frame); content.Size = UDim2.new(1, -160, 1, 0); content.Position = UDim2.new(0, 160, 0, 0); content.BackgroundTransparency = 1

local categories = {"Home", "Player", "Visuals", "Teleport", "Target", "World", "Settings"}
for _, name in pairs(categories) do
    local tab = Instance.new("ScrollingFrame", content); tab.Size = UDim2.new(1,0,1,0); tab.BackgroundTransparency = 1; tab.Visible = false; tab.AutomaticCanvasSize = Enum.AutomaticSize.Y
    Instance.new("UIListLayout", tab).Padding = UDim.new(0, 10); Instance.new("UIPadding", tab).PaddingLeft = UDim.new(0, 15); Instance.new("UIPadding", tab).PaddingTop = UDim.new(0, 15)
    
    local btn = Instance.new("TextButton", sidebar); btn.Size = UDim2.new(0.85, 0, 0, 45); btn.Text = name; btn.BackgroundColor3 = Colors.Button; btn.TextColor3 = Colors.Text; btn.Font = Enum.Font.GothamBold; btn.TextSize = 16; _G.Elements.addCorner(btn)
    
    local loaded = false
    btn.MouseButton1Click:Connect(function()
        for _, c in pairs(content:GetChildren()) do if c:IsA("ScrollingFrame") then c.Visible = false end end
        tab.Visible = true
        if not loaded then
            local url = "https://raw.githubusercontent.com/thepro2324/GAME-LUA/main/modules/" .. string.lower(name) .. ".lua"
            local success, res = pcall(function() return game:HttpGet(url) end)
            if success and res then
                local func = loadstring(res)
                if func then func()(tab, _G.Elements) end
                loaded = true
            end
        end
    end)
end
