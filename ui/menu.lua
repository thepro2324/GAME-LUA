local HomeMod = {}

function HomeMod.init(tab, Elements, UIReferences, Localization, updateLangFunc, safeCall, PlayerMod, VisualsMod, WorldMod)
    -- הגנת "אל-כשל": אם Localization הגיע ריק, נטען ערכי ברירת מחדל כדי למנוע קריסה
    local langData = (Localization and Localization.HE) or {
        Welcome = "Welcome", Version = "V1", AntiAFK = "Anti-AFK", 
        AutoReset = "Reset", HideUser = "Hide", FPSUnlock = "FPS", PlayersOnline = "Players: "
    }

    -- --- טקסטים (Welcome & Version) ---
    local textContainer = Instance.new("Frame", tab)
    textContainer.Size = UDim2.new(0.95, 0, 0, 50)
    textContainer.Position = UDim2.new(0, 0, 0, 40)
    textContainer.BackgroundTransparency = 1

    UIReferences.welcomeLabel = Instance.new("TextLabel", textContainer)
    UIReferences.welcomeLabel.Size = UDim2.new(1, 0, 0.5, 0)
    UIReferences.welcomeLabel.Text = langData.Welcome -- כאן כבר לא תהיה שגיאה
    UIReferences.welcomeLabel.BackgroundTransparency = 1
    UIReferences.welcomeLabel.TextColor3 = Color3.fromRGB(255, 255, 255)

    -- ... שאר הקוד שלך (כפתורים וכו') ...
end

return HomeMod
