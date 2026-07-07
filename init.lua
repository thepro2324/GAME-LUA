-- 1. הגדרת פונקציית הטעינה
local function loadModule(path)
    local url = "https://raw.githubusercontent.com/thepro2324/GAME-LUA/main/" .. path
    print("🔍 מנסה לטעון: " .. url)
    
    local success, response = pcall(function() return game:HttpGet(url) end)
    
    if not success then
        warn("❌ שגיאת חיבור לשרת: " .. url)
        return nil
    end

    if response:find("404") or response == "404: Not Found" then
        warn("❌ שגיאת 404: הקובץ לא קיים בכתובת הזו!")
        return nil
    end

    local func, err = loadstring(response)
    if not func then
        warn("❌ שגיאת תחביר בקובץ: " .. path .. "\n" .. tostring(err))
        return nil
    end

    return func()
end

-- 2. טעינת המודול
local MenuModule = loadModule("ui/menu.lua")

-- 3. הגדרת המשתנים הדרושים (כדי שלא יקרוס על nil)
local Elements = {} 
local UIReferences = {}
local Localization = {HE = {Welcome = "ברוך הבא"}} -- דוגמה למבנה, תוסיף את שלך
local updateLangFunc = function() end
local safeCall = function(f) f() end
local PlayerMod = {}
local VisualsMod = {}
local WorldMod = {}

-- !! כאן השינוי הכי חשוב !!
-- תבחר את השורה שמתאימה למיקום של ה-UI שלך ב-Explorer:
local tab = game:GetService("CoreGui"):FindFirstChild("YourScreenGuiName") -- אפשרות א': נתיב מוחלט
-- local tab = script.Parent -- אפשרות ב': אם הסקריפט בתוך ה-Frame (תשתמש בזה רק אם זה עובד)

-- 4. הרצה עם בדיקה בטיחותית
if MenuModule then
    print("✅ MenuModule נטען בהצלחה!")
    
    if tab then
        print("🚀 מפעיל את ה-init על: " .. tab.Name)
        -- הרצה עם כל הפרמטרים
        pcall(function()
            MenuModule.init(tab, Elements, UIReferences, Localization, updateLangFunc, safeCall, PlayerMod, VisualsMod, WorldMod)
        end)
    else
        warn("🚨 המשתנה tab הוא nil! הנה רשימת אובייקטים למציאת הנתיב הנכון:")
        -- מדפיס לך מה קיים כדי שתוכל למצוא את השם הנכון
        for _, child in pairs(game:GetService("CoreGui"):GetChildren()) do
            print("מצאתי ב-CoreGui: " .. child.Name)
        end
    end
else
    warn("🚨 המודול לא נטען, לכן לא הרצנו את ה-init")
end
