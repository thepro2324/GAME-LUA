-- הגדרות
local GITHUB_BASE = "https://raw.githubusercontent.com/thepro2324/GAME-LUA/main/"

local function loadModule(path)
    local url = GITHUB_BASE .. path
    
    -- 1. ניסיון הורדה מהרשת
    local success, response = pcall(function() return game:HttpGet(url) end)
    if not success then
        warn("❌ שגיאת רשת בטעינת: " .. path)
        return nil
    end
    
    -- 2. בדיקה האם הקובץ קיים (404)
    if response == "404: Not Found" or response == "400: Invalid request" then
        warn("❌ הקובץ לא נמצא ב-GitHub (404): " .. path)
        return nil
    end

    -- 3. ניסיון להפוך את הטקסט לקוד (Loadstring)
    local func, err = loadstring(response)
    if not func then
        warn("❌ שגיאת קוד (Syntax Error) בתוך הקובץ: " .. path .. "\n" .. tostring(err))
        return nil
    end

    -- 4. הרצה
    local mod = func()
    if not mod then
        warn("❌ המודול חזר כ-nil (אולי שכחת לעשות return בסוף הקובץ?): " .. path)
        return nil
    end
    
    return mod
end
