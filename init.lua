-- הגדרות GitHub (שנה לפרטים שלך)
local GITHUB_USER = "thepro2324"
local REPO_NAME   = "GAME-LUA"
local BRANCH      = "main" -- או master

-- פונקציית ייבוא (Import)
local function import(path)
    local url = "https://raw.githubusercontent.com/"..GITHUB_USER.."/"..REPO_NAME.."/"..BRANCH.."/"..path
    local success, result = pcall(function()
        return loadstring(game:HttpGet(url))()
    end)
    if not success then
        warn("❌ Error loading: " .. path .. "\n" .. tostring(result))
        return nil
    end
    return result
end

-- פונקציה לבטיחות הרצה
local function safeCall(mod, funcName, ...) 
    if mod and mod[funcName] then 
        return mod[funcName](...) 
    end 
end

-- 1. טעינת תשתית
local Elements = import("ui/elements.lua")
local Menu     = import("ui/menu.lua")

if not Elements or not Menu then 
    warn("Failed to load UI components!") 
    return 
end

-- 2. אתחול הממשק
local MenuInterface = Menu.init(Elements)

-- 3. טעינת מודולים
local Modules = {
    HomeMod     = import("modules/home.lua"),
    PlayerMod   = import("modules/player.lua"),
    TargetMod   = import("modules/target.lua"),
    VisualsMod  = import("modules/visuals.lua"),
    WorldMod    = import("modules/world.lua"),
    TeleportMod = import("modules/teleport.lua"),
    SettingsMod = import("modules/settings.lua"),
}

-- 4. הגדרות לוקליזציה ורפרנסים
local UIReferences = {}
local Localization = { ["Title"] = "ori_dev_hub" }

-- 5. בניית הטאבים והרצה
local tabConfig = {
    {"Home", Modules.HomeMod},
    {"Target", Modules.TargetMod},
    {"Player", Modules.PlayerMod},
    {"Visuals", Modules.VisualsMod},
    {"World", Modules.WorldMod},
    {"Servers", Modules.TeleportMod},
    {"Settings", Modules.SettingsMod}
}

for i, data in ipairs(tabConfig) do
    local tabName, mod = data[1], data[2]
    if mod then
        local tab = MenuInterface.createTab(tabName, i, Elements)
        mod.init(tab, Elements, UIReferences, Localization, safeCall)
    end
end

print("🚀 ori_dev_hub loaded successfully!")
