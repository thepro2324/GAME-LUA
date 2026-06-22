-- init.lua (הקובץ הראשי שאתה מריץ ב-Executor)

-- הגדרות ה-GitHub שלך
local GITHUB_USER = "thepro2324"
local REPO_NAME   = "GAME-LUA"

-- פונקציה מעודכנת ויציבה יותר עבור Xeno
local function import(path)
    local url = "https://raw.githubusercontent.com/" .. GITHUB_USER .. "/" .. REPO_NAME .. "/main/" .. path
    local success, result = pcall(function()
        return game:HttpGet(url, true) -- true עוקף בעיות קאש ב-Xeno
    end)
    
    if success and result and result ~= "" then
        local func, err = loadstring(result)
        if func then
            return func()
        else
            warn("🔴 [Ori Dev] שגיאת קומפילציה בקובץ " .. path .. ": " .. tostring(err))
            return nil
        end
    else
        warn("🔴 [Ori Dev] נכשלה הורדת המודול: " .. path)
        return nil
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
    error("🔴 [Ori Dev] קריסה: אחד או יותר מהרכיבים לא נטענו מ-GitHub. תבדוק שמות קבצים!")
end

-- 3. אתחול ה-Menu הראשי
local MenuInterface = Menu.init(Elements)

---------------------------------------------------------
-- 4. יצירת הטאבים וחיבור הכפתורים בפועל (האינטגרציה)
---------------------------------------------------------

-- טאב 1: HOME
local homeTab = MenuInterface.createTab("Home", 1)
-- (כאן אפשר להוסיף כפתורים או כרטיס ברכה לטאב הבית בהמשך)

-- טאב 2: TARGET
local targetTab = MenuInterface.createTab("Target", 2)
-- (כאן יושב מנגנון הטרגט והטילפורט לשחקנים)

-- טאב 3: PLAYER (מהירות, קפיצה, תעופה וכו')
local playerTab = MenuInterface.createTab("Player", 3)

Elements.createSlider(playerTab, "Walk Speed", 16, 500, 16, function(v) shared.walkSpeedValue = v end)
Elements.createSlider(playerTab, "Jump Power", 50, 1000, 50, function(v) shared.jumpPowerValue = v end)
Elements.createSlider(playerTab, "Fly Speed", 20, 500, 100, function(v) shared.flySpeed = v end)

-- יצירת גריד מסודר ויפה עבור ה-Toggle Buttons של השחקן
local pGrid = Instance.new("Frame", playerTab)
pGrid.Size = UDim2.new(0.95, 0, 0, 120)
pGrid.BackgroundTransparency = 1
local g1 = Instance.new("UIGridLayout", pGrid) 
g1.CellSize = UDim2.new(0.48, 0, 0, 32) 
g1.CellPadding = UDim2.new(0, 8, 0, 8)

Elements.createToggleButton(pGrid, "Fly Mode", false, PlayerMod.toggleFly)
Elements.createToggleButton(pGrid, "Infinite Jump", false, PlayerMod.toggleInfJump)
Elements.createToggleButton(pGrid, "Noclip", false, PlayerMod.toggleNoclip)
Elements.createToggleButton(pGrid, "Ctrl+Click TP", false, TeleportMod.toggleCtrlClick)
Elements.createToggleButton(pGrid, "God Mode", false, PlayerMod.toggleGodMode)
Elements.createToggleButton(pGrid, "Invisible", false, PlayerMod.toggleInvisible)

-- טאב 4: VISUALS (ראיית קירות ו-ESP)
local visualsTab = MenuInterface.createTab("Visuals", 4)

-- גריד מסודר עבור כפתורי ה-ESP
local vGrid = Instance.new("Frame", visualsTab)
vGrid.Size = UDim2.new(0.95, 0, 0, 80)
vGrid.BackgroundTransparency = 1
local g2 = Instance.new("UIGridLayout", vGrid) 
g2.CellSize = UDim2.new(0.48, 0, 0, 32) 
g2.CellPadding = UDim2.new(0, 8, 0, 8)

Elements.createToggleButton(vGrid, "Master ESP", false, VisualsMod.toggleMasterESP)
Elements.createToggleButton(vGrid, "ESP Box", false, VisualsMod.toggleESPBox)
Elements.createToggleButton(vGrid, "ESP Names", false, VisualsMod.toggleESPNames)
Elements.createToggleButton(vGrid, "Fullbright", false, VisualsMod.toggleFullbright)

-- טאב 5: WORLD (כוח משיכה וטווח ראייה)
local worldTab = MenuInterface.createTab("World", 5)
Elements.createSlider(worldTab, "Gravity Level", 0, 400, 196, WorldMod.setGravity)
Elements.createSlider(worldTab, "Field of View", 50, 120, 70, WorldMod.setFOV)

-- טאב 6: SERVERS (מעבר שרתים וחיבור מחדש)
local serversTab = MenuInterface.createTab("Servers", 6)

-- יצירת כפתור Rejoin מעוצב בהתאם לסטייל הכהה החדש
local rjButton = Instance.new("TextButton", serversTab)
rjButton.Size = UDim2.new(0.95, 0, 0, 32)
rjButton.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
rjButton.TextColor3 = Color3.fromRGB(240, 240, 245)
rjButton.Font = Enum.Font.GothamBold
rjButton.TextSize = 12
rjButton.Text = "QUICK REJOIN"
Elements.addCorner(rjButton, UDim.new(0, 5))
local rjStroke = Elements.addStroke(rjButton, Color3.fromRGB(35, 35, 45), 1)
rjButton.MouseButton1Click:Connect(TeleportMod.rejoin)

-- יצירת רווח קטן בין הכפתורים בשרתים
local spacer = Instance.new("Frame", serversTab)
spacer.Size = UDim2.new(1, 0, 0, 2)
spacer.BackgroundTransparency = 1

-- יצירת כפתור Server Hop מעוצב
local hopButton = Instance.new("TextButton", serversTab)
hopButton.Size = UDim2.new(0.95, 0, 0, 32)
hopButton.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
hopButton.TextColor3 = Color3.fromRGB(240, 240, 245)
hopButton.Font = Enum.Font.GothamBold
hopButton.TextSize = 12
hopButton.Text = "SERVER HOP"
Elements.addCorner(hopButton, UDim.new(0, 5))
local hopStroke = Elements.addStroke(hopButton, Color3.fromRGB(35, 35, 45), 1)
hopButton.MouseButton1Click:Connect(TeleportMod.serverHop)

print("🚀 [Ori Dev] הסקריפט המודולרי נטען בהצלחה והכל מחובר!")
