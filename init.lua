-- init.lua (הקובץ הראשי שאתה מריץ ב-Executor)

-- הגדרות ה-GitHub שלך
local GITHUB_USER = "thepro2324"
local REPO_NAME   = "GAME-LUA"

-- פונקציה חכמה ומאובטחת להורדת קבצים
local function import(path)
    local url = "https://raw.githubusercontent.com/" .. GITHUB_USER .. "/" .. REPO_NAME .. "/main/" .. path
    local success, result = pcall(function()
        return game:HttpGet(url, true)
    end)
    
    if success and result and result ~= "" then
        local func, err = loadstring(result)
        if func then
            local runSuccess, runResult = pcall(func)
            if runSuccess then
                return runResult
            else
                warn("🔴 [Ori Dev] שגיאה בזמן הרצת הקובץ " .. path .. ": " .. tostring(runResult))
                return nil
            end
        else
            warn("🔴 [Ori Dev] שגיאת קומפילציה (Syntax) בקובץ " .. path .. ": " .. tostring(err))
            return nil
        end
    else
        warn("🔴 [Ori Dev] נכשלה הורדת המודול מ-GitHub: " .. path)
        return nil
    end
end

-- 1. טעינת רכיבי ה-UI והעיצוב
local Elements = import("ui/elements.lua")
local Menu = import("ui/menu.lua")

if not Elements then error("🔴 [Ori Dev] קריסה: קובץ ui/elements.lua לא נטען או מכיל שגיאה!") end
if not Menu then error("🔴 [Ori Dev] קריסה: קובץ ui/menu.lua לא נטען או מכיל שגיאה!") end

-- 2. טעינת רכיבי הלוגיקה והיכולות (Modules) עם הגנה מפני קריסה
local PlayerMod    = import("modules/player.lua") or {}
local VisualsMod   = import("modules/visuals.lua") or {}
local WorldMod     = import("modules/world.lua") or {}
local TeleportMod  = import("modules/teleport.lua") or {}

-- 3. אתחול ה-Menu הראשי
local MenuInterface = Menu.init(Elements)
if not MenuInterface or not MenuInterface.createTab then
    error("🔴 [Ori Dev] פונקציית createTab לא נמצאה בתוך Menu. ודא ש-menu.lua מעודכן ושלם!")
end

---------------------------------------------------------
-- 4. יצירת הטאבים וחיבור הכפתורים בפועל (האינטגרציה)
---------------------------------------------------------

-- טאב 1: HOME
local homeTab = MenuInterface.createTab("Home", 1)

-- טאב 2: TARGET
local targetTab = MenuInterface.createTab("Target", 2)

-- טאב 3: PLAYER (מהירות, קפיצה, תעופה וכו')
local playerTab = MenuInterface.createTab("Player", 3)

if Elements.createSlider then
    Elements.createSlider(playerTab, "Walk Speed", 16, 500, 16, function(v) shared.walkSpeedValue = v end)
    Elements.createSlider(playerTab, "Jump Power", 50, 1000, 50, function(v) shared.jumpPowerValue = v end)
    Elements.createSlider(playerTab, "Fly Speed", 20, 500, 100, function(v) shared.flySpeed = v end)
end

-- יצירת גריד עבור ה-Toggle Buttons של השחקן
local pGrid = Instance.new("Frame", playerTab)
pGrid.Size = UDim2.new(0.95, 0, 0, 120)
pGrid.BackgroundTransparency = 1
local g1 = Instance.new("UIGridLayout", pGrid) 
g1.CellSize = UDim2.new(0.48, 0, 0, 32) 
g1.CellPadding = UDim2.new(0, 8, 0, 8)

if Elements.createToggleButton then
    Elements.createToggleButton(pGrid, "Fly Mode", false, PlayerMod.toggleFly or function() end)
    Elements.createToggleButton(pGrid, "Infinite Jump", false, PlayerMod.toggleInfJump or function() end)
    Elements.createToggleButton(pGrid, "Noclip", false, PlayerMod.toggleNoclip or function() end)
    Elements.createToggleButton(pGrid, "Ctrl+Click TP", false, TeleportMod.toggleCtrlClick or function() end)
    Elements.createToggleButton(pGrid, "God Mode", false, PlayerMod.toggleGodMode or function() end)
    Elements.createToggleButton(pGrid, "Invisible", false, PlayerMod.toggleInvisible or function() end)
end

-- טאב 4: VISUALS (ראיית קירות ו-ESP)
local visualsTab = MenuInterface.createTab("Visuals", 4)

local vGrid = Instance.new("Frame", visualsTab)
vGrid.Size = UDim2.new(0.95, 0, 0, 80)
vGrid.BackgroundTransparency = 1
local g2 = Instance.new("UIGridLayout", vGrid) 
g2.CellSize = UDim2.new(0.48, 0, 0, 32) 
g2.CellPadding = UDim2.new(0, 8, 0, 8)

if Elements.createToggleButton then
    Elements.createToggleButton(vGrid, "Master ESP", false, VisualsMod.toggleMasterESP or function() end)
    Elements.createToggleButton(vGrid, "ESP Box", false, VisualsMod.toggleESPBox or function() end)
    Elements.createToggleButton(vGrid, "ESP Names", false, VisualsMod.toggleESPNames or function() end)
    Elements.createToggleButton(vGrid, "Fullbright", false, VisualsMod.toggleFullbright or function() end)
end

-- טאב 5: WORLD
local worldTab = MenuInterface.createTab("World", 5)
if Elements.createSlider then
    Elements.createSlider(worldTab, "Gravity Level", 0, 400, 196, WorldMod.setGravity or function() end)
    Elements.createSlider(worldTab, "Field of View", 50, 120, 70, WorldMod.setFOV or function() end)
end

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

print("🚀 [Ori Dev] הסקריפט המודולרי נטען בהצלחה והכל מחובר!")
