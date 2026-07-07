-- הכתובת הישירה של הקובץ (תוודא שזה ה-RAW מגיטהאב)
local url = "https://raw.githubusercontent.com/thepro2324/GAME-LUA/main/ui/menu.lua"

local success, response = pcall(function() 
    return game:HttpGet(url) 
end)

if not success then
    return warn("Failed to fetch script from GitHub")
end

local func = loadstring(response)
if not func then
    return warn("Loadstring failed - syntax error in your file")
end

-- הרצת המודול
local MenuModule = func()

-- בדיקה אם המודול קיים לפני הרצה
if MenuModule and type(MenuModule) == "table" then
    local playerGui = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    MenuModule.init(playerGui)
else
    warn("MenuModule is nil! Check if you put 'return Menu' at the end of the file in GitHub.")
end
