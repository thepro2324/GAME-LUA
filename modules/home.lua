return function(tab)
    local Players = game:GetService("Players")

    -- פונקציה ליצירת טקסט מעוצב
    local function createStat(name, initialText, pos)
        local label = Instance.new("TextLabel", tab)
        label.Size = UDim2.new(0.9, 0, 0, 30)
        label.Position = pos
        label.Text = name .. ": " .. initialText
        label.TextColor3 = Color3.fromRGB(200, 200, 200)
        label.BackgroundTransparency = 1
        label.Font = Enum.Font.Gotham
        label.TextSize = 16
        label.TextXAlignment = Enum.TextAlignment.Left
        return label
    end

    -- כמות שחקנים
    local playersStat = createStat("Players Online", #Players:GetPlayers(), UDim2.new(0.05, 0, 0.1, 0))
    Players.PlayerAdded:Connect(function() playersStat.Text = "Players Online: " .. #Players:GetPlayers() end)
    Players.PlayerRemoving:Connect(function() playersStat.Text = "Players Online: " .. #Players:GetPlayers() end)

    -- שימושים + קרדיט
    createStat("Script Uses", "1,240", UDim2.new(0.05, 0, 0.2, 0))
    createStat("Developer", "ori_dev", UDim2.new(0.05, 0, 0.3, 0)) -- כאן הוספתי את הקרדיט
    
    -- ברוך הבא
    local welcome = Instance.new("TextLabel", tab)
    welcome.Size = UDim2.new(0.9, 0, 0, 30)
    welcome.Position = UDim2.new(0.05, 0, 0.5, 0)
    welcome.Text = "Welcome, " .. Players.LocalPlayer.Name
    welcome.TextColor3 = Color3.fromRGB(255, 255, 255)
    welcome.BackgroundTransparency = 1
    welcome.Font = Enum.Font.GothamBold
    welcome.TextSize = 20
end
