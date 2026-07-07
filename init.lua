-- הגדרות ראשוניות (Import ו-SafeCall)
local GITHUB_USER = "thepro2324"
local REPO_NAME   = "GAME-LUA"

local function import(path)
    -- ... (הקוד של ה-import שלך נשאר אותו דבר) ...
end
local function safeCall(mod, funcName, ...) if mod and mod[funcName] then return mod[funcName](...) end end

-- טעינת רכיבי ממשק
local Elements = import("ui/elements.lua")
local Menu = import("ui/menu.lua")
local MenuInterface = Menu.init(Elements)

-- טעינת מודולים (כאן אנחנו מייבאים אותם)
local HomeMod     = import("modules/home.lua")
local PlayerMod   = import("modules/player.lua")
local TargetMod   = import("modules/target.lua")
local VisualsMod  = import("modules/visuals.lua")
local WorldMod    = import("modules/world.lua")
local TeleportMod = import("modules/teleport.lua")
local SettingsMod = import("modules/settings.lua")

-- מערכת UIReferences ו-Localization (גלובלי או מועבר)
local UIReferences = {}
local Localization = { -- ... (הטבלה שלך כאן) ... }

-- הרצת הטאבים (החלק המרכזי שרצית)
HomeMod.init(MenuInterface.createTab("Home", 1), Elements, UIReferences, Localization, safeCall)
TargetMod.init(MenuInterface.createTab("Target", 2), Elements, UIReferences, Localization, safeCall)
PlayerMod.init(MenuInterface.createTab("Player", 3), Elements, UIReferences, Localization, safeCall)
VisualsMod.init(MenuInterface.createTab("Visuals", 4), Elements, UIReferences, Localization, safeCall)
WorldMod.init(MenuInterface.createTab("World", 5), Elements, UIReferences, Localization, safeCall)
TeleportMod.init(MenuInterface.createTab("Servers", 6), Elements, UIReferences, Localization, safeCall)
SettingsMod.init(MenuInterface.createTab("Settings", 7), Elements, UIReferences, Localization, safeCall)

print("🚀 הכל נטען ועובד!")
