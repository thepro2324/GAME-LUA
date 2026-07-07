-- הגדרות יסוד
local GITHUB_USER = "thepro2324"
local REPO_NAME   = "GAME-LUA"

local function import(path)
    local success, result = pcall(function()
        return loadstring(game:HttpGet("https://raw.githubusercontent.com/"..GITHUB_USER.."/"..REPO_NAME.."/main/"..path))()
    end)
    if not success then warn("❌ Failed to load: " .. path .. "\n" .. tostring(result)) return nil end
    return result
end

local function safeCall(mod, funcName, ...) if mod and mod[funcName] then return mod[funcName](...) end end

-- טעינת UI
local Elements = import("ui/elements.lua")
local Menu = import("ui/menu.lua")
local MenuInterface = Menu.init(Elements)

-- טעינת מודולים
local HomeMod     = import("modules/home.lua")
local TargetMod   = import("modules/target.lua")
-- (הוסף כאן את השאר)

-- הגדרות מערכת (כאן ה-Localization מוגדר כטבלה)
local UIReferences = {}
local Localization = {
    Welcome = "ברוך הבא ל-Private Hub",
    Settings = "הגדרות המערכת"
}

-- מערכת הרצת הטאבים (הגנה על הארגומנטים)
local function loadTab(name, order, mod)
    if not mod then warn("Module " .. name .. " not found!") return end
    local tab = MenuInterface.createTab(name, order, Elements)
    
    -- העברת 5 הפרמטרים במדויק:
    mod.init(tab, Elements, UIReferences, Localization, safeCall)
end

-- הרצה
loadTab("Home", 1, HomeMod)
loadTab("Target", 2, TargetMod)

print("🚀 המערכת נטענה בהצלחה!")
