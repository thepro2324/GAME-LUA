-- הגדרת נתוני שפה
local Localization = {
    HE = { Welcome = "ברוך הבא למערכת", Version = "v1.0", AntiAFK = "Anti-AFK", AutoReset = "Auto-Reset", HideUser = "הסתר", FPSUnlock = "FPS", PlayersOnline = "שחקנים: " }
}

-- פונקציה לטעינה בטוחה
local function loadModule(path)
    local success, mod = pcall(function()
        return loadstring(game:HttpGet("https://raw.githubusercontent.com/thepro2324/GAME-LUA/main/"..path))()
    end)
    if not success then warn("❌ FAILED TO LOAD: " .. path .. "\n" .. tostring(mod)) return nil end
    return mod
end

-- טעינת המודולים
local HomeMod = loadModule("modules/home.lua")

-- בדיקה: האם המודול נטען?
if HomeMod then
    -- קריאה לפונקציה עם כל 9 הפרמטרים בסדר מדויק
    -- הוספתי "nil" במקומות שחסרים לך מודולים כרגע כדי לשמור על הסדר
    HomeMod.init(
        tab,            -- 1
        Elements,       -- 2
        UIReferences,   -- 3
        Localization,   -- 4
        updateLangFunc, -- 5
        safeCall,       -- 6
        nil,            -- 7 (PlayerMod)
        nil,            -- 8 (VisualsMod)
        nil             -- 9 (WorldMod)
    )
else
    warn("HomeMod לא נטען, לכן לא הרצנו את ה-init")
end
