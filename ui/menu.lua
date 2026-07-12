-- =========================================================================
-- ORI HUB V10 - FINAL COMBINED VERSION
-- =========================================================================
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")

if CoreGui:FindFirstChild("OriHub") then CoreGui:FindFirstChild("OriHub"):Destroy() end

local Colors = {
    Main = Color3.fromRGB(20, 20, 20),
    Sidebar = Color3.fromRGB(28, 28, 28),
    Button = Color3.fromRGB(40, 40, 40),
    Accent = Color3.fromRGB(60, 120, 255),
    Text = Color3.fromRGB(255, 255, 255)
}

-- === 1. ספריית האלמנטים (הלב של יצירת הכפתורים) ===
_G.Elements = {}
function _G.Elements.addCorner(p, r) local c = Instance.new("UICorner", p); c.CornerRadius = r or UDim.new(0, 6) end

function _G.Elements.createToggleButton(parent, text, default, callback)
    local btn = Instance.new("TextButton", parent); btn.Size = UDim2.new(0.9, 0, 0, 35); btn.BackgroundColor3 = Colors.Button
    btn.Text = text .. ": " .. (default and "ON" or "OFF"); btn.TextColor3 = Colors.Text; btn.Font = Enum.Font.GothamBold; btn.TextSize = 13
    _G.Elements.addCorner(btn, UDim.new(0, 6))
    local state = default
    btn.MouseButton1Click:Connect(function()
        state = not state; btn.Text = text .. ": " .. (state and "ON" or "OFF")
        btn.BackgroundColor3 = state and Colors.Accent or Colors.Button
        callback(state)
    end)
    return btn
end

function _G.Elements.createSlider(parent, text, min, max, default, callback)
    local frame = Instance.new("Frame", parent); frame.Size = UDim2.new(0.9, 0, 0, 45); frame.BackgroundTransparency = 1
    local label = Instance.new("TextLabel", frame); label.Size = UDim2.new(1,0,0,20); label.Text = text; label.TextColor3 = Colors.Text; label.BackgroundTransparency = 1
    local bg = Instance.new("Frame", frame); bg.Size = UDim2.new(1, 0, 0, 6); bg.Position = UDim2.new(0,0,0,30); bg.BackgroundColor3 = Colors.Button; _G.Elements.addCorner(bg, UDim.new(1,0))
    local fill = Instance.new("Frame", bg); fill.Size = UDim2.new((default-min)/(max-min), 0, 1, 0); fill.BackgroundColor3 = Colors.Accent; _G.Elements.addCorner(fill, UDim.new(1,0))
    bg.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then 
        local pos = math.clamp((input.Position.X - bg.AbsolutePosition.X) / bg.AbsoluteSize.X, 0, 1)
        fill.Size = UDim2.new(pos, 0, 1, 0); local val = math.floor(min + (pos * (max-min))); callback(val)
    end end)
end

-- === 2. בניית ה-UI ===
local screen = Instance.new("ScreenGui", CoreGui); screen.Name = "OriHub"
local frame = Instance.new("Frame", screen)
frame.Size = UDim2.new(0, 600, 0, 400); frame.Position = UDim2.new(0.5, -300, 0.5, -200)
frame.BackgroundColor3 = Colors.Main; frame.Active = true; _G.Elements.addCorner(frame, UDim.new(0, 10))
Instance.new("UIStroke", frame).Color = Color3.fromRGB(50, 50, 50)

-- מנוע גרירה
local dragging, dragStart, startPos
frame.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true; dragStart = i.Position; startPos = frame.Position end end)
UserInputService.InputChanged:Connect(function(i) if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + (i.Position.X - dragStart.X), startPos.Y.Scale, startPos.Y.Offset + (i.Position.Y - dragStart.Y)) end end)
UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)

local sidebar = Instance.new("Frame", frame); sidebar.Size = UDim2.new(0, 160, 1, 0); sidebar.BackgroundColor3 = Colors.Sidebar; sidebar.Active = false; _G.Elements.addCorner(sidebar, UDim.new(0, 10))
Instance.new("UIPadding", sidebar).PaddingTop = UDim.new(0, 15)
Instance.new("UIListLayout", sidebar).Padding = UDim.new(0, 8); Instance.new("UIListLayout", sidebar).HorizontalAlignment = Enum.HorizontalAlignment.Center

local content = Instance.new("Frame", frame); content.Size = UDim2.new(1, -160, 1, 0); content.Position = UDim2.new(0, 160, 0, 0); content.BackgroundTransparency = 1

local initializedTabs = {}
local Tabs = {}

local function createTab(name)
    local page = Instance.new("ScrollingFrame", content)
    page.Size = UDim2.new(1, 0, 1, 0); page.BackgroundTransparency = 1; page.BorderSizePixel = 0; page.ScrollBarThickness = 2; page.Visible = false; page.AutomaticCanvasSize = Enum.AutomaticSize.Y
    Instance.new("UIListLayout", page).Padding = UDim.new(0, 10); Instance.new("UIPadding", page).PaddingLeft = UDim.new(0, 15); Instance.new("UIPadding", page).PaddingTop = UDim.new(0, 15)
    Tabs[name] = page
    return page
end

-- === 3. לוגיקת כפתורים וטעינת מודולים ===
local categories = {"Home", "Player", "Visuals", "Teleport", "Target", "World", "Settings"}

for _, name in pairs(categories) do
    local tab = createTab(name)
    local btn = Instance.new("TextButton", sidebar)
    btn.Size = UDim2.new(0.85, 0, 0, 45); btn.Text = name; btn.BackgroundColor3 = Colors.Button
    btn.TextColor3 = Colors.Text; btn.Font = Enum.Font.GothamBold; btn.TextSize = 14; _G.Elements.addCorner(btn, UDim.new(0, 6))
    
    btn.MouseButton1Click:Connect(function()
        print("--- CLICK DETECTED: " .. name .. " ---") -- הודעה 1: נדע אם הכפתור עובד
        
        for _, otherTab in pairs(Tabs) do otherTab.Visible = false end
        tab.Visible = true
        
        if not initializedTabs[name] then
            local fileName = string.lower(name) .. ".lua"
            print("Trying to load: " .. fileName) -- הודעה 2: נדע אם הוא מחפש את הקובץ הנכון
            
            local mod = _G.loadModule(fileName)
            
            if mod then
                print("Module returned data, running init...") -- הודעה 3: נדע אם הקובץ תקין
                pcall(function() mod.init(tab, _G.Elements) end)
                initializedTabs[name] = true
            else
                warn("CRITICAL: Module " .. fileName .. " returned nil! (Check GitHub)")
            end
        else
            print("Module already initialized.")
        end
    end)
    
    btn.MouseEnter:Connect(function() btn.BackgroundColor3 = Colors.Accent end)
    btn.MouseLeave:Connect(function() btn.BackgroundColor3 = Colors.Button end)
end
