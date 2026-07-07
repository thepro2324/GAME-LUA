-- 1. הגדרת פונקציית הטעינה (שים אותה כאן בהתחלה)
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

-- 2. עכשיו אתה יכול להשתמש בה כדי לטעון את המודולים שלך
local MenuModule = loadModule("ui/menu.lua")

-- 3. רק אם הטעינה הצליחה, תריץ את ה-init
if MenuModule then
    print("✅ MenuModule נטען בהצלחה!")
    
    -- כאן תבצע את הקריאה ל-init עם כל הארגומנטים שלך
    MenuModule.init(tab, Elements, UIReferences, Localization, updateLangFunc, safeCall, PlayerMod, VisualsMod, WorldMod)
else
    warn("🚨 המודול לא נטען, לכן לא הרצנו את ה-init")
end
