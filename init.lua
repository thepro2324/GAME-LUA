-- הגדרת ה-Localization מראש
local Localization = {
    HE = {
        Welcome = "ברוך הבא ל-Hub",
        Version = "Version 1.0",
        AntiAFK = "Anti-AFK",
        AutoReset = "Auto-Reset",
        HideUser = "Hide User",
        FPSUnlock = "FPS Unlock",
        PlayersOnline = "שחקנים: "
    }
}

-- פונקציית עדכון שפה (חייבת להיות מוגדרת לפני הקריאה למודולים)
local function updateLangFunc(lang)
    print("Language: " .. lang)
end

-- בתוך הלולאה שלך, וודא שאתה מעביר הכל:
-- נניח שזה בתוך לולאה או פונקציית הטעינה:
HomeMod.init(
    MenuInterface.createTab("Home", 1, Elements), -- 1: tab
    Elements,                                    -- 2: Elements
    UIReferences,                                -- 3: UIReferences
    Localization,                                -- 4: Localization (זה חייב לעבור!)
    updateLangFunc,                              -- 5: updateLangFunc
    safeCall,                                    -- 6: safeCall
    PlayerMod,                                   -- 7: PlayerMod
    VisualsMod,                                  -- 8: VisualsMod
    WorldMod                                     -- 9: WorldMod
)
