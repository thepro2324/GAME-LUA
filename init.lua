-- הגדרת Localization עם המבנה שהמודול מצפה לו
local Localization = {
    HE = {
        Welcome = "ברוך הבא למערכת",
        Version = "גרסה 1.0",
        AntiAFK = "Anti-AFK",
        AutoReset = "Auto-Reset",
        HideUser = "הסתר שם",
        FPSUnlock = "FPS Unlock",
        PlayersOnline = "שחקנים מחוברים: "
    },
    EN = {
        Welcome = "Welcome to the Hub",
        Version = "Version 1.0",
        AntiAFK = "Anti-AFK",
        AutoReset = "Auto-Reset",
        HideUser = "Hide Name",
        FPSUnlock = "FPS Unlock",
        PlayersOnline = "Players Online: "
    }
}

-- פונקציית עדכון שפה (נדרשת עבור ה-updateLangFunc)
local function updateLangFunc(lang)
    print("Language changed to: " .. lang)
    -- כאן תוסיף לוגיקה לעדכון ה-TextLabels ב-UIReferences
end

-- קריאה למודול (חייבים 9 ארגומנטים!)
-- שים לב לסדר הארגומנטים:
HomeMod.init(
    MenuInterface.createTab("Home", 1, Elements), 
    Elements, 
    UIReferences, 
    Localization, 
    updateLangFunc, 
    safeCall, 
    PlayerMod, 
    VisualsMod, 
    WorldMod
)
