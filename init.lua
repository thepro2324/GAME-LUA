local function loadModule(path)
    local url = "https://raw.githubusercontent.com/thepro2324/GAME-LUA/main/" .. path
    local success, response = pcall(function() return game:HttpGet(url) end)
    if not success or response:find("404") then return nil end
    local func = loadstring(response)
    return func and func() or nil
end

local MenuModule = loadModule("ui/menu.lua")

if MenuModule then
    print("✅ MenuModule נטען בהצלחה!")
    
    -- אנחנו שולחים את PlayerGui בתור ה-tab, כדי שהמודול יצור את ה-UI בתוכו
    local parentUI = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    
    local Elements, UIReferences, Localization, updateLangFunc, safeCall, PlayerMod, VisualsMod, WorldMod = {}, {}, {}, function() end, function(f) f() end, {}, {}, {}
    
    -- הרצה
    MenuModule.init(parentUI, Elements, UIReferences, Localization, updateLangFunc, safeCall, PlayerMod, VisualsMod, WorldMod)
else
    warn("🚨 המודול לא נטען")
end
