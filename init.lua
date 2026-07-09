-- הגדרת הנתיב הבסיסי
local urlBase = "https://raw.githubusercontent.com/thepro2324/GAME-LUA/main/"

-- פונקציה גלובלית לטעינת מודולים (חשוב ל-_G כדי שכל הסקריפטים יכירו אותה)
_G.loadModule = function(name)
    local url = urlBase .. name
    print("🔄 מנסה לטעון מודול: " .. url)
    
    local success, response = pcall(function() return game:HttpGet(url) end)
    if not success then return warn("❌ שגיאת HTTP ב-" .. name) end
    
    local func, err = loadstring(response)
    if not func then return warn("❌ שגיאת Syntax ב-" .. name .. ": " .. tostring(err)) end
    
    -- מריצים את הפונקציה ומחזירים את התוצאה (הטבלה)
    return func()
end

-- טעינת המודול הראשי
local MenuModule = _G.loadModule("ui/menu.lua")

-- בדיקה אם המודול אכן נטען
if MenuModule and type(MenuModule) == "table" then
    print("✅ MenuModule נטען בהצלחה! מפעיל...")
    local playerGui = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    MenuModule.init(playerGui)
else
    warn("🚨 קריטי: MenuModule הוא nil! וודא ש-menu.lua מסתיים ב-return!")
end
