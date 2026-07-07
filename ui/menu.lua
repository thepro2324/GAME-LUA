local Menu = {}

-- פונקציית האתחול - מקבלת את כל התלויות מהמערכת הראשית
function Menu.init(tab, Elements, UIReferences, Localization, updateLangFunc, safeCall, PlayerMod, VisualsMod, WorldMod)
    
    -- 1. הגנה: הגדרת ערכי ברירת מחדל אם משהו חסר כדי למנוע את השגיאה של ה-nil
    local lang = (Localization and Localization.HE) or { 
        Welcome = "Welcome", 
        Version = "v1.0",
        Settings = "Settings"
    }

    -- 2. יצירת אלמנט בסיסי בטאב (דוגמה)
    if tab then
        local title = Instance.new("TextLabel", tab)
        title.Size = UDim2.new(1, 0, 0, 30)
        title.Text = lang.Welcome
        title.TextColor3 = Color3.fromRGB(255, 255, 255)
        title.BackgroundTransparency = 1
        
        -- כאן אתה יכול להמשיך להוסיף את שאר ה-UI שלך
        -- דוגמה לשימוש ב-Elements (אם הוא קיים):
        if Elements and Elements.addCorner then
            Elements.addCorner(title, UDim.new(0, 5))
        end
    else
        warn("Menu.init: tab is nil!")
    end

    print("✅ Menu module initialized successfully")
end

-- !!! השורה הכי חשובה !!!
-- בלי השורה הזו, ה-loadstring יחזיר nil והקוד יקרוס
return Menu
