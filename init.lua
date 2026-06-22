local GITHUB_USER = "thepro2324"
local REPO_NAME   = "GAME-LUA"

local function import(path)
    local url = "https://raw.githubusercontent.com/" .. GITHUB_USER .. "/" .. REPO_NAME .. "/main/" .. path
    local success, result = pcall(function()
        return game:HttpGet(url, true)
    end)
    if success and result and result ~= "" then
        local func, err = loadstring(result)
        if func then
            return func()
        end
    end
end

local Elements = import("ui/elements.lua")
local Menu = import("ui/menu.lua")

if not Elements or not Menu then 
    error("🔴 [Ori Dev] שגיאה בטעינת קבצי ה-UI מה-GitHub!")
end

local MenuInterface = Menu.init(Elements)

-- טאב 1: HOME
local homeTab = MenuInterface.createTab("Home", 1)

-- טאב 2: TARGET
local targetTab = MenuInterface.createTab("Target", 2)

-- טאב 3: PLAYER
local playerTab = MenuInterface.createTab("Player", 3)

Elements.createSlider(playerTab, "Walk Speed", 16, 500, 16, function(v) print("Speed changed to: " .. v) end)
Elements.createSlider(playerTab, "Jump Power", 50, 1000, 50, function(v) print("Jump changed to: " .. v) end)
Elements.createSlider(playerTab, "Fly Speed", 20, 500, 100, function(v) print("Fly changed to: " .. v) end)

local pGrid = Instance.new("Frame", playerTab)
pGrid.Size = UDim2.new(0.95, 0, 0, 120)
pGrid.BackgroundTransparency = 1
local g1 = Instance.new("UIGridLayout", pGrid) 
g1.CellSize = UDim2.new(0.48, 0, 0, 32) 
g1.CellPadding = UDim2.new(0, 8, 0, 8)

Elements.createToggleButton(pGrid, "Fly Mode", false, function(s) print("Fly: " .. tostring(s)) end)
Elements.createToggleButton(pGrid, "Infinite Jump", false, function(s) print("Inf: " .. tostring(s)) end)
Elements.createToggleButton(pGrid, "Noclip", false, function(s) print("Noclip: " .. tostring(s)) end)
Elements.createToggleButton(pGrid, "Ctrl+Click TP", false, function(s) print("TP: " .. tostring(s)) end)
Elements.createToggleButton(pGrid, "God Mode", false, function(s) print("God: " .. tostring(s)) end)
Elements.createToggleButton(pGrid, "Invisible", false, function(s) print("Invis: " .. tostring(s)) end)

-- טאב 4: VISUALS
local visualsTab = MenuInterface.createTab("Visuals", 4)

local vGrid = Instance.new("Frame", visualsTab)
vGrid.Size = UDim2.new(0.95, 0, 0, 80)
vGrid.BackgroundTransparency = 1
local g2 = Instance.new("UIGridLayout", vGrid) 
g2.CellSize = UDim2.new(0.48, 0, 0, 32) 
g2.CellPadding = UDim2.new(0, 8, 0, 8)

Elements.createToggleButton(vGrid, "Master ESP", false, function(s) print("ESP: " .. tostring(s)) end)
Elements.createToggleButton(vGrid, "ESP Box", false, function(s) print("Box: " .. tostring(s)) end)
Elements.createToggleButton(vGrid, "ESP Names", false, function(s) print("Names: " .. tostring(s)) end)
Elements.createToggleButton(vGrid, "Fullbright", false, function(s) print("Bright: " .. tostring(s)) end)

-- טאב 5: WORLD
local worldTab = MenuInterface.createTab("World", 5)
Elements.createSlider(worldTab, "Gravity Level", 0, 400, 196, function(v) print("Gravity: " .. v) end)
Elements.createSlider(worldTab, "Field of View", 50, 120, 70, function(v) print("FOV: " .. v) end)

-- טאב 6: SERVERS
local serversTab = MenuInterface.createTab("Servers", 6)

local rjButton = Instance.new("TextButton", serversTab)
rjButton.Size = UDim2.new(0.95, 0, 0, 32)
rjButton.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
rjButton.TextColor3 = Color3.fromRGB(240, 240, 245)
rjButton.Font = Enum.Font.GothamBold
rjButton.TextSize = 12
rjButton.Text = "QUICK REJOIN"
Elements.addCorner(rjButton, UDim.new(0, 5))
Elements.addStroke(rjButton, Color3.fromRGB(35, 35, 45), 1)

local spacer = Instance.new("Frame", serversTab)
spacer.Size = UDim2.new(1, 0, 0, 4)
spacer.BackgroundTransparency = 1

local hopButton = Instance.new("TextButton", serversTab)
hopButton.Size = UDim2.new(0.95, 0, 0, 32)
hopButton.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
hopButton.TextColor3 = Color3.fromRGB(240, 240, 245)
hopButton.Font = Enum.Font.GothamBold
hopButton.TextSize = 12
hopButton.Text = "SERVER HOP"
Elements.addCorner(hopButton, UDim.new(0, 5))
Elements.addStroke(hopButton, Color3.fromRGB(35, 35, 45), 1)

print("🚀 [Ori Dev] ה-GUI נטען בהצלחה!")
