-- init.lua (הקובץ הראשי שאתה מריץ ב-Executor)

-- הגדרות ה-GitHub שלך - שים פה את הפרטים המדויקים שלך!
local GITHUB_USER = "thepro2324"
local REPO_NAME   = "GAME-LUA"

-- פונקציה חכמה שמושכת קבצים מהגיטאהב שלך בזמן אמת
local function import(path)
    local url = string.format("https://raw.githubusercontent.com/%s/%s/main/%s", GITHUB_USER, repoName, path)
    local success, result = pcall(function()
        return game:HttpGet(url)
    end)
    if success then
        return loadstring(result)()
    else
        warn("🔴 [Ori Dev] נכשלה טעינת המודול: " .. path)
    end
end

-- 1. טעינת רכיבי ה-UI והעיצוב
local Elements = import("ui/elements.lua")
local Menu = import("ui/menu.lua")

-- 2. טעינת רכיבי הלוגיקה והיכולות (Modules)
local PlayerMod    = import("modules/player.lua")
local VisualsMod   = import("modules/visuals.lua")
local WorldMod     = import("modules/world.lua")
local TeleportMod  = import("modules/teleport.lua")

-- וידוא שהכל נטען בהצלחה
if not (Elements and Menu and PlayerMod and VisualsMod and WorldMod and TeleportMod) then
    error("🔴 [Ori Dev] אחד או יותר מהקבצים לא נטענו כראוי מ-GitHub. תבדוק שמות ונתיבים!")
end

-- 3. אתחול ה-Menu הראשי
local MenuInterface = Menu.init(Elements)

---------------------------------------------------------
-- 4. יצירת הטאבים וחיבור הכפתורים בפועל (האינטגרציה)
---------------------------------------------------------

-- טאב 1: HOME
local homeTab = MenuInterface.createTab("Home", "🏠", 1)
-- (התוכן של ה-Home Card כבר מובנה בתוך menu.lua שבנית)

-- טאב 2: TARGET
local targetTab = MenuInterface.createTab("Target", "🎯", 2)
-- (מנגנון ה-Targeter מנוהל ישירות מול teleport.lua ומול התיבה שבתוך menu.lua)

-- טאב 3: PLAYER (חיבור סליידרים וכפתורים)
local playerTab = MenuInterface.createTab("Player", "🧍", 3)

Elements.createSlider(playerTab, "Walk Speed", 16, 500, 16, function(v) shared.walkSpeedValue = v end)
Elements.createSlider(playerTab, "Jump Power", 50, 1000, 50, function(v) shared.jumpPowerValue = v end)
Elements.createSlider(playerTab, "Fly Speed", 20, 500, 100, function(v) shared.flySpeed = v end)

local pGrid = Instance.new("Frame", playerTab)
pGrid.Size = UDim2.new(0.9, 0, 0, 120)
pGrid.BackgroundTransparency = 1
local g1 = Instance.new("UIGridLayout", pGrid) g1.CellSize = UDim2.new(0.48, 0, 0, 35)

Elements.createToggleButton(pGrid, "Fly Mode", false, PlayerMod.toggleFly)
Elements.createToggleButton(pGrid, "Infinite Jump", false, PlayerMod.toggleInfJump)
Elements.createToggleButton(pGrid, "Noclip", false, PlayerMod.toggleNoclip)
Elements.createToggleButton(pGrid, "Ctrl+Click TP", false, TeleportMod.toggleCtrlClick)
Elements.createToggleButton(pGrid, "God Mode", false, PlayerMod.toggleGodMode)
Elements.createToggleButton(pGrid, "Invisible", false, PlayerMod.toggleInvisible)

-- טאב 4: VISUALS (ESP)
local visualsTab = MenuInterface.createTab("Visuals", "👁️", 4)

local vGrid = Instance.new("Frame", visualsTab)
vGrid.Size = UDim2.new(0.9, 0, 0, 80)
vGrid.BackgroundTransparency = 1
local g2 = Instance.new("UIGridLayout", vGrid) g2.CellSize = UDim2.new(0.48, 0, 0, 35)

Elements.createToggleButton(vGrid, "Master ESP", false, VisualsMod.toggleMasterESP)
Elements.createToggleButton(vGrid, "ESP Box", false, VisualsMod.toggleESPBox)
Elements.createToggleButton(vGrid, "ESP Names", false, VisualsMod.toggleESPNames)
Elements.createToggleButton(vGrid, "Fullbright", false, VisualsMod.toggleFullbright)

-- טאב 5: WORLD
local worldTab = MenuInterface.createTab("World", "🌍", 5)
Elements.createSlider(worldTab, "Gravity Level", 0, 400, 196, WorldMod.setGravity)
Elements.createSlider(worldTab, "Field of View", 50, 120, 70, WorldMod.setFOV)

-- טאב 6: SERVERS
local serversTab = MenuInterface.createTab("Servers", "🖥️", 6)

local rjButton = Instance.new("TextButton", serversTab)
rjButton.Size = UDim2.new(0.9, 0, 0, 35)
rjButton.BackgroundColor3 = Color3.fromRGB(40,40,40)
rjButton.TextColor3 = Color3.new(1,1,1)
rjButton.Font = Enum.Font.SourceSansBold
rjButton.TextSize = 15
rjButton.Text = "Quick Rejoin"
Elements.addCorner(rjButton, UDim.new(0,6))
rjButton.MouseButton1Click:Connect(TeleportMod.rejoin)

local hopButton = rjButton:Clone()
hopButton.Text = "Server Hop"
hopButton.Parent = serversTab
hopButton.MouseButton1Click:Connect(TeleportMod.serverHop)

print("🚀 [Ori Dev] הסקריפט המודולרי נטען בהצלחה והכל מחובר!")
