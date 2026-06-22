-- init.lua (הקובץ הראשי שמחבר את ה-UI ללוגיקה האמיתית)

-- הגדרות ה-GitHub שלך
local GITHUB_USER = "thepro2324"
local REPO_NAME   = "GAME-LUA"

-- פונקציה חלקה להורדת קבצים
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

-- 1. טעינת רכיבי ה-UI והעיצוב
local Elements = import("ui/elements.lua")
local Menu = import("ui/menu.lua")

if not Elements or not Menu then 
    error("🔴 [Ori Dev] שגיאה בטעינת קבצי ה-UI מה-GitHub!")
end

-- 2. טעינת המודולים האמיתיים מהתיקייה modules (אם קובץ חסר, הוא ישתמש בגיבוי ריק כדי לא לקרוס)
local PlayerMod    = import("modules/player.lua") or {}
local VisualsMod   = import("modules/visuals.lua") or {}
local WorldMod     = import("modules/world.lua") or {}
local TeleportMod  = import("modules/teleport.lua") or {}

-- 3. אתחול ה-Menu הראשי
local MenuInterface = Menu.init(Elements)

---------------------------------------------------------
-- 4. יצירת הטאבים והכפתורים וחיבורם ללוגיקה
---------------------------------------------------------

-- טאב 1: HOME
local homeTab = MenuInterface.createTab("Home", 1)

-- טאב 2: TARGET
local targetTab = MenuInterface.createTab("Target", 2)

-- טאב 3: PLAYER (שינוי ערכים בפועל)
local playerTab = MenuInterface.createTab("Player", 3)

Elements.createSlider(playerTab, "Walk Speed", 16, 500, 16, function(v) 
    shared.walkSpeedValue = v 
    if PlayerMod.updateSpeed then PlayerMod.updateSpeed(v) end
end)

Elements.createSlider(playerTab, "Jump Power", 50, 1000, 50, function(v) 
    shared.jumpPowerValue = v 
    if PlayerMod.updateJump then PlayerMod.updateJump(v) end
end)

Elements.createSlider(playerTab, "Fly Speed", 20, 500, 100, function(v) 
    shared.flySpeed = v 
end)

local pGrid = Instance.new("Frame", playerTab)
pGrid.Size = UDim2.new(0.95, 0, 0, 120)
pGrid.BackgroundTransparency = 1
local g1 = Instance.new("UIGridLayout", pGrid) 
g1.CellSize = UDim2.new(0.48, 0, 0, 32) 
g1.CellPadding = UDim2.new(0, 8, 0, 8)

Elements.createToggleButton(pGrid, "Fly Mode", false, PlayerMod.toggleFly or function() end)
Elements.createToggleButton(pGrid, "Infinite Jump", false, PlayerMod.toggleInfJump or function() end)
Elements.createToggleButton(pGrid, "Noclip", false, PlayerMod.toggleNoclip or function() end)
Elements.createToggleButton(pGrid, "Ctrl+Click TP", false, TeleportMod.toggleCtrlClick or function() end)
Elements.createToggleButton(pGrid, "God Mode", false, PlayerMod.toggleGodMode or function() end)
Elements.createToggleButton(pGrid, "Invisible", false, PlayerMod.toggleInvisible or function() end)

-- טאב 4: VISUALS
local visualsTab = MenuInterface.createTab("Visuals", 4)

local vGrid = Instance.new("Frame", visualsTab)
vGrid.Size = UDim2.new(0.95, 0, 0, 80)
vGrid.BackgroundTransparency = 1
local g2 = Instance.new("UIGridLayout", vGrid) 
g2.CellSize = UDim2.new(0.48, 0, 0, 32) 
g2.CellPadding = UDim2.new(0, 8, 0, 8)

Elements.createToggleButton(vGrid, "Master ESP", false, VisualsMod.toggleMasterESP or function() end)
Elements.createToggleButton(vGrid, "ESP Box", false, VisualsMod.toggleESPBox or function() end)
Elements.createToggleButton(vGrid, "ESP Names", false, VisualsMod.toggleESPNames or function() end)
Elements.createToggleButton(vGrid, "Fullbright", false, VisualsMod.toggleFullbright or function() end)

-- טאב 5: WORLD
local worldTab = MenuInterface.createTab("World", 5)
Elements.createSlider(worldTab, "Gravity Level", 0, 400, 196, WorldMod.setGravity or function() end)
Elements.createSlider(worldTab, "Field of View", 50, 120, 70, WorldMod.setFOV or function() end)

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
rjButton.MouseButton1Click:Connect(TeleportMod.rejoin or function() end)

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
hopButton.MouseButton1Click:Connect(TeleportMod.serverHop or function() end)

print("🚀 [Ori Dev] ה-GUI מחובר ומפעיל את המודולים האמיתיים!")
