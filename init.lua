-- הגדרת הנתיב הבסיסי
local urlBase = "https://raw.githubusercontent.com/thepro2324/GAME-LUA/main/"

-- פונקציה לטעינת המודול
local function loadModule(name)
    local url = urlBase .. name
    print("🔄 מנסה לטעון: " .. url)
    
    local success, response = pcall(function() return game:HttpGet(url) end)
    if not success then return warn("❌ שגיאת HTTP ב-" .. name) end
    
    local func, err = loadstring(response)
    if not func then return warn("❌ שגיאת Syntax ב-" .. name .. ": " .. tostring(err)) end
    
    -- כאן אנחנו מריצים את הקוד ומקבלים את מה שהוא מחזיר
    local module = func()
    return module
end

-- טעינת המודול
local MenuModule = loadModule("ui/menu.lua")

-- בדיקה אם המודול אכן נטען (אם הוא nil, זה אומר שלא היה return בסוף הקובץ!)
if MenuModule and type(MenuModule) == "table" then
    print("✅ MenuModule נטען בהצלחה! מפעיל...")
    
    local playerGui = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    MenuModule.init(playerGui)
else
    warn("🚨 קריטי: MenuModule הוא nil! וודא ש-menu.lua מסתיים ב-return!")
end
