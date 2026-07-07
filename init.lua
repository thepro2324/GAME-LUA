lo-- הגדרת פונקציית הטעינה (נשארת כפי שהייתה)
local function loadModule(path)
    local url = "https://raw.githubusercontent.com/thepro2324/GAME-LUA/main/" .. path
    local success, response = pcall(function() return game:HttpGet(url) end)
    
    if not success then return nil end
    if response:find("404") then return nil end
    
    local func, err = loadstring(response)
    if not func then return nil end
    
    return func()
end

-- טעינת המודול
local MenuModule = loadModule("ui/menu.lua")

-- בדיקה קריטית: האם הוא באמת נטען?
if MenuModule and type(MenuModule) == "table" then
    print("✅ MenuModule נטען בהצלחה!")
    
    local playerGui = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    
    -- הפעלה
    pcall(function()
        MenuModule.init(playerGui) 
    end)
else
    warn("🚨 שגיאה: MenuModule לא נטען. בדוק שהקובץ ב-GitHub מסתיים ב-return!")
end
