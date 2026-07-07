-- 1. פונקציית הטעינה (מה שכתבנו קודם)
local function loadModule(path)
    local url = "https://raw.githubusercontent.com/thepro2324/GAME-LUA/main/" .. path
    local success, response = pcall(function() return game:HttpGet(url) end)
    if not success or response:find("404") then return nil end
    local func = loadstring(response)
    return func and func() or nil
end

-- 2. טעינת המודול
local MenuModule = loadModule("ui/menu.lua")

-- 3. יצירה אוטומטית של ה-UI (בלי שתצטרך לדעת שמות!)
local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- מחפש/יוצר את ה-ScreenGui
local screenGui = playerGui:FindFirstChild("MyAutoMenuGui") or Instance.new("ScreenGui", playerGui)
screenGui.Name = "MyAutoMenuGui"

-- מחפש/יוצר את ה-Frame (זה ה-tab שלך)
local tab = screenGui:FindFirstChild("MainFrame")
if not tab then
    tab = Instance.new("Frame", screenGui)
    tab.Name = "MainFrame"
    tab.Size = UDim2.new(0, 300, 0, 400) -- גודל ברירת מחדל
    tab.Position = UDim2.new(0.5, -150, 0.5, -200) -- מרכז המסך
    tab.BackgroundColor3 = Color3.fromRGB(45, 45, 45) -- צבע רקע כדי שתראה אותו
    print("✨ נוצר Frame חדש בשם MainFrame")
else
    print("✅ ה-Frame קיים, משתמש בו.")
end

-- 4. הרצה עם כל המשתנים
if MenuModule then
    print("✅ MenuModule נטען!")
    -- הגדרת משתני עזר (אם הם חסרים)
    local Elements, UIReferences, Localization, updateLangFunc, safeCall, PlayerMod, VisualsMod, WorldMod = {}, {}, {}, function() end, function(f) f() end, {}, {}, {}
    
    -- הרצה
    MenuModule.init(tab, Elements, UIReferences, Localization, updateLangFunc, safeCall, PlayerMod, VisualsMod, WorldMod)
else
    warn("🚨 המודול לא נטען")
end
