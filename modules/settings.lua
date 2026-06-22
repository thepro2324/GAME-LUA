-- modules/settings.lua (גרסה מתוקנת - סריקת UI מקיפה לשנוי צבעים ומקשים)

local SettingsMod = {}
local UIS = game:GetService("UserInputService")

shared.toggleKey = shared.toggleKey or Enum.KeyCode.RightControl

-- פונקציה לשינוי מקש הקיצור (אות אחת)
function SettingsMod.setToggleKey(text, textBox)
    local cleanedText = text:upper()
    if #cleanedText > 1 then
        cleanedText = cleanedText:sub(1, 1)
        textBox.Text = cleanedText
    end
    
    if #cleanedText == 1 then
        local success, keycode = pcall(function()
            return Enum.KeyCode[cleanedText]
        end)
        if success and keycode then
            shared.toggleKey = keycode
            textBox.TextColor3 = Color3.fromRGB(30, 215, 96) -- ירוק
            return true
        else
            textBox.TextColor3 = Color3.fromRGB(255, 75, 75) -- אדום
        end
    end
    return false
end

-- פונקציה חזקה לשינוי צבע הנושא בכל חלקי ה-UI שנמצאים בתוך התפריט שלך
function SettingsMod.changeTheme(color, versionLabel)
    if versionLabel then 
        versionLabel.TextColor3 = color 
    end
    
    -- מוצא את ה-ScreenGui של הסקריפט בתוך ה-CoreGui של רובלוקס
    local coreGui = game:GetService("CoreGui")
    local scriptGui = coreGui:FindFirstChild("ModernMenuGui") or coreGui:FindFirstChild("ScreenGui")
    
    if scriptGui then
        -- סורק את כל האובייקטים של ה-UI ומחפש מסגרות (UIStroke) או כפתורים שצריכים להשתנות
        for _, obj in ipairs(scriptGui:GetDescendants()) do
            if obj:IsA("UIStroke") then
                -- משנה את הצבע של המסגרת הדומיננטית (לא אלו של תיבות הטקסט)
                if obj.Color ~= Color3.fromRGB(45, 45, 55) and obj.Color ~= Color3.fromRGB(35, 35, 45) then
                    obj.Color = color
                end
            elseif obj:IsA("TextButton") and (obj.Name == "TabButton" or obj.Parent:IsA("UIGridLayout")) then
                -- אם תרצה לשנות גם אלמנטים מסוימים מהכפתורים, אפשר להוסיף לוגיקה כאן
            end
        end
    end
end

return SettingsMod
