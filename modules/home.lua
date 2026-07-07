local HomeMod = {}

function HomeMod.init(tab, Elements, UIReferences, Localization)
    -- --- כפתורי שפה ---
    local langContainer = Instance.new("Frame", tab)
    langContainer.Size = UDim2.new(0.95, 0, 0, 35)
    langContainer.BackgroundTransparency = 1

    local enBtn = Instance.new("TextButton", langContainer)
    enBtn.Size = UDim2.new(0.47, 0, 1, 0)
    enBtn.Text = "🇺🇸 English"
    enBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    Elements.addCorner(enBtn, UDim.new(0, 5))
    enBtn.MouseButton1Click:Connect(function() _G.updateLanguage("EN") end)

    local heBtn = Instance.new("TextButton", langContainer)
    heBtn.Size = UDim2.new(0.47, 0, 1, 0)
    heBtn.Position = UDim2.new(0.53, 0, 0, 0)
    heBtn.Text = "🇮🇱 עברית"
    heBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    Elements.addCorner(heBtn, UDim.new(0, 5))
    heBtn.MouseButton1Click:Connect(function() _G.updateLanguage("HE") end)

    -- --- טקסטים ---
    local textContainer = Instance.new("Frame", tab)
    textContainer.Size = UDim2.new(0.95, 0, 0, 50)
    textContainer.BackgroundTransparency = 1

    UIReferences.welcomeLabel = Instance.new("TextLabel", textContainer)
    UIReferences.welcomeLabel.Text = Localization.HE.Welcome
    UIReferences.welcomeLabel.BackgroundTransparency = 1

    UIReferences.versionLabel = Instance.new("TextLabel", textContainer)
    UIReferences.versionLabel.Text = Localization.HE.Version
    UIReferences.versionLabel.BackgroundTransparency = 1

    -- --- גריד כפתורים ---
    local hGrid = Instance.new("Frame", tab)
    hGrid.Size = UDim2.new(0.95, 0, 0, 120)
    local gh = Instance.new("UIGridLayout", hGrid) 
    gh.CellSize = UDim2.new(0.48, 0, 0, 32) 

    UIReferences.btnAntiAFK = Elements.createToggleButton(hGrid, Localization.HE.AntiAFK, true, function(state) _G.safeCall("PlayerMod", "toggleAntiAFK", state) end)
    -- הוסף כאן את שאר הכפתורים...

    -- --- תצוגת שחקנים ---
    UIReferences.playerCountLabel = Instance.new("TextLabel", tab)
    UIReferences.playerCountLabel.Size = UDim2.new(0.95, 0, 0, 30)
    UIReferences.playerCountLabel.Position = UDim2.new(0.025, 0, 0, 230)
    UIReferences.playerCountLabel.BackgroundTransparency = 1
    UIReferences.playerCountLabel.TextColor3 = Color3.fromRGB(30, 215, 96)

    task.spawn(function()
        while task.wait(2) do
            if UIReferences.playerCountLabel then
                local count = #game:GetService("Players"):GetPlayers()
                local max = game:GetService("Players").MaxPlayers
                UIReferences.playerCountLabel.Text = Localization[_G.currentLanguage].PlayersOnline .. count .. "/" .. max
            end
        end
    end)
end

return HomeMod
