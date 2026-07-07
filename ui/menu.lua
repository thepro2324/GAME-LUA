local Menu = {}

-- וודא שהפונקציה שלך נראית ככה, מקבלת את כל הפרמטרים:
function Menu.init(tab, Elements, UIReferences, Localization, updateLangFunc, safeCall, PlayerMod, VisualsMod, WorldMod)
    -- הגנה מפני nil כדי למנוע את השגיאה של Welcome
    local langData = (Localization and Localization.HE) or { Welcome = "Welcome" }
    
    -- הנה הקוד שלך...
    -- דוגמה לשימוש בטקסט בטוח:
    print(langData.Welcome) 
    
    -- ... שאר הקוד שלך
end

-- הכי חשוב: השורה הזו חייבת להיות בסוף הקובץ!
return Menu
