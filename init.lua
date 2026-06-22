-- init.lua (הקובץ הראשי שמריצים ב-Executor)
shared.Config = {
    Username = "ori_dev",
    Version = "3.0"
}

-- פונקציית עזר לטעינת קבצים מהרפוזיטורי שלך
local githubUser = "YOUR_GITHUB_USERNAME" -- שים פה את השם משתמש שלך בגיט
local repoName = "YOUR_REPO_NAME"        -- שים פה את שם הפרויקט

local function import(path)
    local url = string.format("https://raw.githubusercontent.com/%s/%s/main/%s", githubUser, repoName, path)
    local success, result = pcall(function()
        return game:HttpGet(url)
    end)
    if success then
        return loadstring(result)()
    else
        warn("Failed to load module: " .. path)
    end
end

-- טעינת רכיבי העיצוב (UI)
local UIElements = import("ui/elements.lua")
local MainMenu = import("ui/menu.lua")

-- טעינת רכיבי הלוגיקה והיכולות
shared.PlayerModules = import("modules/player.lua")
shared.VisualModules = import("modules/visuals.lua")

-- חיבור הכפתורים מה-UI ללוגיקה
-- (כאן נחבר ביניהם בצורה מסודרת)
print("Ori Dev Mega Script Loaded via GitHub!")
