local function loadModule(path)
    local url = "https://raw.githubusercontent.com/thepro2324/GAME-LUA/main/" .. path
    print("🔍 מנסה לטעון את: " .. url) -- זה ידפיס לך בדיוק מה הוא מחפש
    
    local success, response = pcall(function() return game:HttpGet(url) end)
    
    if not success then
        warn("❌ שגיאת חיבור לשרת (GitHub)")
        return nil
    end

    -- בדיקה חשובה: האם השרת החזיר שגיאת 404?
    if response:find("404") or response == "404: Not Found" then
        warn("❌ שגיאת 404: הקובץ לא נמצא בנתיב הזה ב-GitHub: " .. path)
        return nil
    end

    -- עכשיו ננסה להריץ את הקוד
    local func, err = loadstring(response)
    if not func then
        warn("❌ שגיאת תחביר (Syntax Error) בקובץ: " .. path .. "\n" .. tostring(err))
        return nil
    end

    return func()
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
