local SettingsMod = {}
local UIS = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

-- משתנה לניהול המקש הראשי
shared.toggleKey = shared.toggleKey or Enum.KeyCode.RightControl

-- פונקציה לשינוי מקש הקיצור
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
            textBox.TextColor3 = Color3.fromRGB(30, 215, 96) -- ירוק להצלחה
            return true
        else
            textBox.TextColor3 = Color3.fromRGB(255, 75, 75) -- אדום לשגיאה
        end
    end
    return false
end

-- פונקציה לשינוי ערכת הנושא (צבע)
function SettingsMod.changeTheme(color)
    local scriptGui = CoreGui:FindFirstChild("ModernMenuGui") -- שנה לשם ה-Gui שלך
    if not scriptGui then return end
    
    for _, obj in ipairs(scriptGui:GetDescendants()) do
        if obj:IsA("UIStroke") then
            -- משנה רק מסגרות שאינן בצבעי הרקע הבסיסיים
            if obj.Color ~= Color3.fromRGB(45, 45, 55) and obj.Color ~= Color3.fromRGB(35, 35, 45) then
                obj.Color = color
            end
        end
    end
end

-- בניית הממשק בטאב ההגדרות
function SettingsMod.init(tab, Elements, UIReferences, Localization, safeCall)
    local scroll = Instance.new("ScrollingFrame", tab)
    scroll.Size = UDim2.new(1, 0, 1, 0); scroll.BackgroundTransparency = 1; scroll.CanvasSize = UDim2.new(0, 0, 0, 300)
    Instance.new("UIListLayout", scroll).Padding = UDim.new(0, 10)

    -- 1. שינוי מקש
    local keyContainer = Instance.new("Frame", scroll)
    keyContainer.Size = UDim2.new(0.95, 0, 0, 40); keyContainer.BackgroundTransparency = 1
    
    local label = Instance.new("TextLabel", keyContainer)
    label.Text = "Toggle Key (Single Letter):"; label.Size = UDim2.new(0.6, 0, 1, 0); label.BackgroundTransparency = 1; label.TextColor3 = Color3.new(1,1,1)
    
    local keyBox = Instance.new("TextBox", keyContainer)
    keyBox.Size = UDim2.new(0.3, 0, 1, 0); keyBox.Position = UDim2.new(0.65, 0, 0, 0); keyBox.Text = tostring(shared.toggleKey.Name)
    keyBox.BackgroundColor3 = Color3.fromRGB(35, 35, 45); keyBox.TextColor3 = Color3.new(1,1,1)
    Elements.addCorner(keyBox, UDim.new(0, 5))
    
    keyBox.FocusLost:Connect(function()
        SettingsMod.setToggleKey(keyBox.Text, keyBox)
    end)

    -- 2. בחירת צבעים
    local colorContainer = Instance.new("Frame", scroll)
    colorContainer.Size = UDim2.new(0.95, 0, 0, 60); colorContainer.BackgroundTransparency = 1
    local grid = Instance.new("UIGridLayout", colorContainer); grid.CellSize = UDim2.new(0.2, 0, 0, 30)

    local colors = {
        {"Red", Color3.fromRGB(255, 75, 75)},
        {"Green", Color3.fromRGB(30, 215, 96)},
        {"Blue", Color3.fromRGB(75, 150, 255)},
        {"Purple", Color3.fromRGB(150, 75, 255)}
    }

    for _, cData in ipairs(colors) do
        local btn = Instance.new("TextButton", colorContainer)
        btn.Text = cData[1]; btn.BackgroundColor3 = cData[2]; btn.TextColor3 = Color3.new(1,1,1)
        Elements.addCorner(btn, UDim.new(0, 5))
        btn.MouseButton1Click:Connect(function() SettingsMod.changeTheme(cData[2]) end)
    end
end

return SettingsMod
