-- =========================================================================
-- ORI HUB V7 - MENU.LUA (Main UI Logic)
-- =========================================================================
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")

-- מחיקת גרסה קודמת
if CoreGui:FindFirstChild("OriHub") then CoreGui:FindFirstChild("OriHub"):Destroy() end

-- הגדרות עיצוב
local Colors = {
    Main = Color3.fromRGB(20, 20, 20),
    Sidebar = Color3.fromRGB(28, 28, 28),
    Button = Color3.fromRGB(40, 40, 40),
    Accent = Color3.fromRGB(60, 120, 255),
    Text = Color3.fromRGB(255, 255, 255)
}

-- טבלת מיפוי מודולים (מקשרת שם של כפתור לקובץ ב-GitHub)
local moduleMap = {
    ["Home"] = "modules/home.lua",
    ["Player"] = "modules/player.lua",
    ["Visuals"] = "modules/visuals.lua",
    ["Teleport"] = "modules/teleport.lua",
    ["Target"] = "modules/target.lua",
    ["World"] = "modules/world.lua",
    ["Settings"] = "modules/settings.lua"
}

local initializedTabs = {} -- מונע טעינה כפולה של מודולים

local screen = Instance.new("ScreenGui", CoreGui); screen.Name = "OriHub"
local frame = Instance.new("Frame", screen); frame.Size = UDim2.new(0, 600, 0, 400); frame.Position = UDim2.new(0.5, -300, 0.5, -200); frame.BackgroundColor3 = Colors.Main; frame.Active = true; frame.Draggable = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10); Instance.new("UIStroke", frame).Color = Color3.fromRGB(50, 50, 50)

-- Sidebar
local sidebar = Instance.new("Frame", frame); sidebar.Size = UDim2.new(0, 160, 1, 0); sidebar.BackgroundColor3 = Colors.Sidebar
Instance.new("UICorner", sidebar).CornerRadius = UDim.new(0, 10); Instance.new("UIPadding", sidebar).PaddingTop = UDim.new(0, 15)
local listLayout = Instance.new("UIListLayout", sidebar); listLayout.Padding = UDim.new(0, 8); listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- Content Container
local content = Instance.new("Frame", frame); content.Size = UDim2.new(1, -160, 1, 0); content.Position = UDim2.new(0, 160, 0, 0); content.BackgroundTransparency = 1

local Tabs = {}

-- פונקציה ליצירת דף
local function createTab(name)
    local page = Instance.new("ScrollingFrame", content)
    page.Size = UDim2.new(1, 0, 1, 0); page.BackgroundTransparency = 1; page.ScrollBarThickness = 2; page.Visible = false
    
    local list = Instance.new("UIListLayout", page); list.Padding = UDim.new(0, 10)
    Instance.new("UIPadding", page).PaddingLeft = UDim.new(0, 15); Instance.new("UIPadding", page).PaddingTop = UDim.new(0, 15)
    
    Tabs[name] = page
    return page
end

-- רשימת קטגוריות
local categories = {"Home", "Player", "Visuals", "Teleport", "Target", "World", "Settings"}

for _, name in pairs(categories) do
    local tab = createTab(name)
    
    local btn = Instance.new("TextButton", sidebar); btn.Size = UDim2.new(0.85, 0, 0, 45); btn.Text = name; btn.BackgroundColor3 = Colors.Button; btn.TextColor3 = Colors.Text; btn.Font = Enum.Font.GothamBold; btn.TextSize = 14; btn.AutoButtonColor = false
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    
    -- לוגיקת החלפת דפים וטעינת מודולים
    btn.MouseButton1Click:Connect(function()
        -- 1. החלפת תצוגה
        for _, otherTab in pairs(Tabs) do otherTab.Visible = false end
        tab.Visible = true
        
        -- 2. טעינת מודול במידת הצורך (Lazy Loading)
        if not initializedTabs[name] and moduleMap[name] then
            local success, mod = pcall(function() return _G.loadModule(moduleMap[name]) end)
            if success and mod then
                -- מפעילים את פונקציית ה-init של המודול
                mod.init(tab, _G.Elements, nil, nil, function(m, f, ...) m[f](...) end)
                initializedTabs[name] = true
                print("Module loaded: " .. name)
            else
                warn("Failed to load: " .. name)
            end
        end
    end)
    
    btn.MouseEnter:Connect(function() btn.BackgroundColor3 = Colors.Accent end)
    btn.MouseLeave:Connect(function() btn.BackgroundColor3 = Colors.Button end)
end

-- פתיחת דף הבית כברירת מחדל
Tabs["Home"].Visible = true
