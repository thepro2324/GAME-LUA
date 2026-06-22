-- modules/settings.lua (מודול הגדרות: שינוי מקשים ועיצוב)

local SettingsMod = {}

local UIS = game:GetService("UserInputService")
shared.toggleKey = shared.toggleKey or Enum.KeyCode.RightControl -- ברירת מחדל: קונטרול ימני

-- פונקציה לשינוי מקש הקיצור (מקבלת אות אחת או שם מקש)
function SettingsMod.setToggleKey(text, textBox)
    local cleanedText = text:upper()
    if #cleanedText > 1 then
        cleanedText = cleanedText:sub(1, 1) -- לוקח רק את האות הראשונה
        textBox.Text = cleanedText
    end
    
    if #cleanedText == 1 then
        local success, keycode = pcall(function()
            return Enum.KeyCode[cleanedText]
        end)
        if success and keycode then
            shared.toggleKey = keycode
            textBox.TextColor3 = Color3.fromRGB(30, 215, 96) -- ירוק = תקין
            return true
        else
            textBox.TextColor3 = Color3.fromRGB(255, 75, 75) -- אדום = לא תקין
            return false
        end
    end
end

-- פונקציה לשינוי צבע הנושא של ה-UI
function SettingsMod.changeTheme(color, MainFrame, versionLabel)
    if versionLabel then 
        versionLabel.TextColor3 = color 
    end
    if MainFrame then
        -- מחפש את הסטרוק (המסגרת) של ה-MainFrame ומעדכן אותו
        local stroke = MainFrame:FindFirstChildOfClass("UIStroke")
        if stroke then
            stroke.Color = color
        end
    end
end

return SettingsMod
