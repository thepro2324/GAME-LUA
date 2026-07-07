local HomeMod = {}

function HomeMod.init(tab, Elements, UIReferences, Localization, updateLangFunc, safeCall, PlayerMod, VisualsMod, WorldMod)
    
    -- הגנה: וודא ש-Localization ו-HE קיימים לפני השימוש
    local langData = (Localization and Localization.HE) and Localization.HE or {
        Welcome = "Welcome", 
        Version = "V1", 
        AntiAFK = "Anti-AFK", 
        AutoReset = "Reset", 
        HideUser = "Hide", 
        FPSUnlock = "FPS", 
        PlayersOnline = "Players: "
    }

    -- --- טקסטים (Welcome & Version) ---
    local textContainer = Instance.new("Frame", tab)
    textContainer.Size = UDim2.new(0.95, 0, 0, 50)
    textContainer.Position = UDim2.new(0, 0, 0, 40)
    textContainer.BackgroundTransparency = 1

    UIReferences.welcomeLabel = Instance.new("TextLabel", textContainer)
    UIReferences.welcomeLabel.Size = UDim2.new(1, 0, 0.5, 0)
    -- שימוש ב-langData הבטוח
    UIReferences.welcomeLabel.Text = langData.Welcome 
    UIReferences.welcomeLabel.BackgroundTransparency = 1
    
    -- ... המשך הקוד שלך ...
end

return HomeMod
