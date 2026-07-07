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

-- 3. הגדרת ה-tab (כאן השינוי!)
-- תבדוק איפה ה-UI שלך נמצא ב-Explorer ותשנה את הנתיב בהתאם
local tab = script.Parent -- אם הסקריפט נמצא בתוך ה-Frame, זה יעבוד. 

-- 4. הרצת ה-init רק אם הכל מוכן
if MenuModule then
    print("✅ MenuModule נטען בהצלחה!")
    
    -- בדיקת הגנה: האם tab קיים?
    if tab then
        print("🚀 מפעיל את התפריט על: " .. tab.Name)
        MenuModule.init(tab, Elements, UIReferences, Localization, updateLangFunc, safeCall, PlayerMod, VisualsMod, WorldMod)
    else
        warn("🚨 המשתנה tab ריק (nil), לא ניתן להמשיך!")
    end
else
    warn("🚨 המודול לא נטען, לכן לא הרצנו את ה-init")
end
