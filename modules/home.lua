local HomeMod = {}

function HomeMod.init(tab, Elements, UIReferences, Localization, updateLangFunc, safeCall, PlayerMod, VisualsMod, WorldMod)
    -- --- כפתורי שפה ---
    local langContainer = Instance.new("Frame", tab)
    langContainer.Size = UDim2.new(0.95, 0, 0, 35)
    langContainer.BackgroundTransparency = 1

    local enBtn = Instance.new("TextButton", langContainer)
    enBtn.Size = UDim2.new(0.47, 0, 1, 0)
    enBtn.Text = "🇺🇸 English"
    enBtn.TextColor3 = Color3.fromRGB(240, 240, 245)
    enBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    Elements.addCorner(enBtn, UDim.new(0, 5))
    enBtn.MouseButton1Click:Connect(function() updateLangFunc("EN") end)

    local heBtn = Instance.new("TextButton", langContainer)
    heBtn.Size = UDim2.new(0.47, 0, 1, 0)
    heBtn.Position = UDim2.new(0.53, 0, 0, 0)
    heBtn.Text = "🇮🇱 עברית"
    heBtn.TextColor3 = Color3.fromRGB(240, 240, 245)
    heBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    Elements.addCorner(heBtn, UDim.new(0, 5))
    heBtn.MouseButton1Click:Connect(function() updateLangFunc("HE") end)

    -- --- טקסטים (Welcome & Version) ---
    local textContainer = Instance.new("Frame", tab)
    textContainer.Size = UDim2.new(0.95, 0, 0, 50)
    textContainer.Position = UDim2.new(0, 0, 0, 40)
    textContainer.BackgroundTransparency = 1

    UIReferences.welcomeLabel = Instance.new("TextLabel", textContainer)
    UIReferences.welcomeLabel.Size = UDim2.new(1, 0, 0.5, 0)
    UIReferences.welcomeLabel.Text = Localization.HE.Welcome -- ניתן לשנות לדינמי בהמשך
    UIReferences.welcomeLabel.BackgroundTransparency = 1
    UIReferences.welcomeLabel.TextColor3 = Color3.fromRGB(255, 255, 255)

    UIReferences.versionLabel = Instance.new("TextLabel", textContainer)
    UIReferences.versionLabel.Size = UDim2.new(1, 0, 0.5, 0)
    UIReferences.versionLabel.Position = UDim2.new(0, 0, 0.5, 5)
    UIReferences.versionLabel.Text = Localization.HE.Version
    UIReferences.versionLabel.BackgroundTransparency = 1
    UIReferences.versionLabel.TextColor3 = Color3.fromRGB(150, 150, 150)

    -- --- גריד כפתורים ---
    local hGrid = Instance.new("Frame", tab)
    hGrid.Size = UDim2.new(0.95, 0, 0, 120)
    hGrid.Position = UDim2.new(0, 0, 0, 100)
    hGrid.BackgroundTransparency = 1
    
    local gh = Instance.new("UIGridLayout", hGrid) 
    gh.CellSize = UDim2.new(0.48, 0, 0, 32) 
    gh.CellPadding = UDim2.new(0, 8, 0, 8)

    -- יצירת הכפתורים
    UIReferences.btnAntiAFK = Elements.createToggleButton(hGrid, Localization.HE.AntiAFK, false, function(s) safeCall(PlayerMod, "toggleAntiAFK", s) end)
    UIReferences.btnAutoReset = Elements.createToggleButton(hGrid, Localization.HE.AutoReset, false, function(s) safeCall(PlayerMod, "toggleAutoReset", s) end)
    UIReferences.btnHideUser = Elements.createToggleButton(hGrid, Localization.HE.HideUser, false, function(s) safeCall(VisualsMod, "toggleHideName", s) end)
    UIReferences.btnFPS = Elements.createToggleButton(hGrid, Localization.HE.FPSUnlock, false, function(s) safeCall(WorldMod, "toggleFPS", s) end)

    -- --- תצוגת שחקנים ---
    UIReferences.playerCountLabel = Instance.new("TextLabel", tab)
    UIReferences.playerCountLabel.Size = UDim2.new(0.95, 0, 0, 30)
    UIReferences.playerCountLabel.Position = UDim2.new(0.025, 0, 0, 230)
    UIReferences.playerCountLabel.BackgroundTransparency = 1
    UIReferences.playerCountLabel.TextColor3 = Color3.fromRGB(30, 215, 96)
    UIReferences.playerCountLabel.Font = Enum.Font.SourceSansBold
    
    -- לולאה בטוחה (עוצרת אם הטקסט נמחק)
    task.spawn(function()
        while UIReferences.playerCountLabel and UIReferences.playerCountLabel.Parent do
            local count = #game:GetService("Players"):GetPlayers()
            local max = game:GetService("Players").MaxPlayers
            UIReferences.playerCountLabel.Text = Localization.HE.PlayersOnline .. count .. "/" .. max
            task.wait(2)
        end
    end)
end

return HomeMod
