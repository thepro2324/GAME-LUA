local function loadModule(path)
    local success, content = pcall(function()
        return game:HttpGet("https://raw.githubusercontent.com/thepro2324/GAME-LUA/main/" .. path)
    end)
    
    if not success then warn("❌ נכשל בטעינת הקובץ מהרשת") return nil end
    
    local func, err = loadstring(content)
    if not func then warn("❌ שגיאת תחביר בקובץ: " .. tostring(err)) return nil end
    
    local mod = func()
    if not mod then warn("❌ הקובץ לא החזיר טבלה (חסר return בקובץ?)") return nil end
    
    return mod
end

-- טעינת המודול
local MenuModule = loadModule("menu.lua") -- משתמשים בשם הקובץ הנכון

if MenuModule then
    print("✅ Menu נטען בהצלחה")
    
    -- קריאה לפונקציה עם כל הפרמטרים
    MenuModule.init(
        tab, 
        Elements, 
        UIReferences, 
        Localization, 
        updateLangFunc, 
        safeCall, 
        PlayerMod, 
        VisualsMod, 
        WorldMod
    )
else
    warn("🚨 MenuModule הוא nil, לכן לא ניתן להריץ את ה-init")
end
