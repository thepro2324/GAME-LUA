return function(tab)
    -- ניקוי התוכן הקודם בטאב
    tab:ClearAllChildren()

    -- סידור אוטומטי של האלמנטים
    local layout = Instance.new("UIListLayout", tab)
    layout.Padding = UDim.new(0, 10)
    layout.PaddingTop = UDim.new(0, 15)
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

    local Players = game:GetService("Players")

    -- פונקציה ליצירת טקסט מעוצב
    local function createStat(name, initialText)
        local label = Instance.new("TextLabel", tab)
        label.Size = UDim2.new(0.9, 0, 0, 30)
        label.Text = name .. ": " .. initialText
        label.TextColor3 = Color3.fromRGB(200, 200, 200)
        label.BackgroundTransparency = 1
        label.Font = Enum.Font.Gotham
        label.TextSize = 16
        label.TextXAlignment = Enum.TextAlignment.Left
        return label
    end

    -- ברוך הבא (כותרת ראשונה)
    local welcome = Instance.new("TextLabel", tab)
    welcome.Size = UDim2.new(0.9, 0, 0, 40)
    welcome.Text = "Welcome, " .. Players.LocalPlayer.Name
    welcome.TextColor3 = Color3.fromRGB(255, 255, 255)
    welcome.BackgroundTransparency = 1
    welcome.Font = Enum.Font.GothamBold
    welcome.TextSize = 22
    welcome.TextXAlignment = Enum.TextAlignment.Left

    -- סטטיסטיקות
    local playersStat = createStat("Players Online", #Players:GetPlayers())
    
    -- עדכון אוטומטי למספר השחקנים
    Players.PlayerAdded:Connect(function() playersStat.Text = "Players Online: " .. #Players:GetPlayers() end)
    Players.PlayerRemoving:Connect(function() playersStat.Text = "Players Online: " .. #Players:GetPlayers() end)

    createStat("Script Uses", "1,240")
    createStat("Developer", "ori_dev")
end
