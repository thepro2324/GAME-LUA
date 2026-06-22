-- ui/menu.lua
local Menu = {}
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local playerObj = Players.LocalPlayer

function Menu.init(Elements)
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "ori_dev_mega_container"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = playerObj:WaitForChild("PlayerGui")

    -- חלון ראשי - עיצוב מודרני כהה
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Parent = screenGui
    mainFrame.Size = UDim2.new(0, 560, 0, 380)
    mainFrame.Position = UDim2.new(0.5, -280, 0.5, -190)
    mainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 24) -- גוון כהה עמוק
    Elements.addCorner(mainFrame, UDim.new(0, 9))
    Elements.addStroke(mainFrame, Color3.fromRGB(45, 45, 58), 1.5)
    mainFrame.Active = true

    -- כותרת עליונה דקה ואלגנטית
    local topBar = Instance.new("Frame")
    topBar.Size = UDim2.new(1, 0, 0, 35)
    topBar.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    Elements.addCorner(topBar, UDim.new(0, 9))
    topBar.Parent = mainFrame
    
    -- הסתרת הפינות התחתונות של הטופבר
    local hideCorner = Instance.new("Frame")
    hideCorner.Size = UDim2.new(1, 0, 0.5, 0)
    hideCorner.Position = UDim2.new(0, 0, 0.5, 0)
    hideCorner.BackgroundColor3 = topBar.BackgroundColor3
    hideCorner.BorderSizePixel = 0
    hideCorner.Parent = topBar

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(0.5, 0, 1, 0)
    titleLabel.Position = UDim2.new(0, 12, 0, 0)
    titleLabel.Text = "THEPRO | PRIVATE HUB v3"
    titleLabel.TextColor3 = Color3.fromRGB(240, 240, 245)
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 14
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.BackgroundTransparency = 1
    titleLabel.Parent = topBar

    -- כפתור סגירה מעוצב
    local closeButton = Instance.new("TextButton")
    closeButton.Size = UDim2.new(0, 24, 0, 24)
    closeButton.Position = UDim2.new(1, -30, 0, 5.5)
    closeButton.Text = "×"
    closeButton.TextSize = 18
    closeButton.TextColor3 = Color3.fromRGB(255, 100, 100)
    closeButton.BackgroundColor3 = Color3.fromRGB(35, 25, 30)
    closeButton.Font = Enum.Font.GothamBold
    Elements.addCorner(closeButton, UDim.new(0, 6))
    Elements.addStroke(closeButton, Color3.fromRGB(80, 40, 40), 1)
    closeButton.Parent = topBar
    closeButton.MouseButton1Click:Connect(function() screenGui:Destroy() end)

    -- סיידבר קטגוריות שמאלי נקי
    local sideBar = Instance.new("ScrollingFrame")
    sideBar.Size = UDim2.new(0, 135, 1, -45)
    sideBar.Position = UDim2.new(0, 5, 0, 40)
    sideBar.BackgroundColor3 = Color3.fromRGB(13, 13, 18)
    sideBar.BackgroundTransparency = 0.2
    sideBar.ScrollBarThickness = 0 -- מעלים סקרולבר מכוער
    sideBar.CanvasSize = UDim2.new(0, 0, 0, 0)
    sideBar.AutomaticCanvasSize = Enum.AutomaticCanvasSize.Y
    Elements.addCorner(sideBar, UDim.new(0, 6))
    Elements.addStroke(sideBar, Color3.fromRGB(30, 30, 40), 1)
    sideBar.Parent = mainFrame

    local sideLayout = Instance.new("UIListLayout")
    sideLayout.Padding = UDim.new(0, 4)
    sideLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    sideLayout.Parent = sideBar
    
    local sidePadding = Instance.new("UIPadding")
    sidePadding.PaddingTop = UDim.new(0, 5)
    sidePadding.Parent = sideBar

    -- פאנל תוכן מרכזי לקטגוריות
    local contentFrame = Instance.new("Frame")
    contentFrame.Size = UDim2.new(1, -155, 1, -45)
    contentFrame.Position = UDim2.new(0, 148, 0, 40)
    contentFrame.BackgroundTransparency = 1
    contentFrame.Parent = mainFrame

    -- מערכת ניהול טאבים מתוקנת
    local containers = {}
    local tabButtons = {}
    
    function Menu.createTab(name, icon, order)
        local container = Instance.new("ScrollingFrame")
        container.Name = name .. "Container"
        container.Size = UDim2.new(1, 0, 1, -5)
        container.BackgroundTransparency = 1
        container.ScrollBarThickness = 3
        container.ScrollBarImageColor3 = Color3.fromRGB(60, 60, 80)
        container.CanvasSize = UDim2.new(0, 0, 0, 0)
        container.AutomaticCanvasSize = Enum.AutomaticCanvasSize.Y
        container.Visible = false
        
        local layout = Instance.new("UIListLayout")
        layout.Padding = UDim.new(0, 8)
        layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        layout.Parent = container
        
        local pad = Instance.new("UIPadding")
        pad.PaddingTop = UDim.new(0, 2)
        pad.PaddingBottom = UDim.new(0, 10)
        pad.Parent = container
        
        container.Parent = contentFrame
        table.insert(containers, container)

        -- כפתור הטאב הפיזי בסיידבר
        local tabBtn = Instance.new("TextButton")
        tabBtn.Size = UDim2.new(0.9, 0, 0, 32)
        tabBtn.BackgroundColor3 = Color3.fromRGB(22, 22, 30)
        tabBtn.TextColor3 = Color3.fromRGB(160, 160, 180)
        tabBtn.Font = Enum.Font.GothamBold
        tabBtn.TextSize = 12
        tabBtn.Text = icon .. "  " .. name
        tabBtn.LayoutOrder = order
        Elements.addCorner(tabBtn, UDim.new(0, 5))
        local bStroke = Elements.addStroke(tabBtn, Color3.fromRGB(35, 35, 45), 1)
        tabBtn.Parent = sideBar
        table.insert(tabButtons, {btn = tabBtn, stroke = bStroke})

        -- אירוע לחיצה שמחליף טאבים באמת ומעדכן צבעים
        tabBtn.MouseButton1Click:Connect(function()
            for _, c in ipairs(containers) do c.Visible = false end
            for _, tData in ipairs(tabButtons) do
                tData.btn.BackgroundColor3 = Color3.fromRGB(22, 22, 30)
                tData.btn.TextColor3 = Color3.fromRGB(160, 160, 180)
                tData.stroke.Color = Color3.fromRGB(35, 35, 45)
            end
            container.Visible = true
            tabBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
            tabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            bStroke.Color = Color3.fromRGB(70, 70, 100)
        end)

        -- ברירת מחדל: הטאב הראשון שנפתח יהיה גלוי
        if order == 1 then
            container.Visible = true
            tabBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
            tabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            bStroke.Color = Color3.fromRGB(70, 70, 100)
        end

        return container
    end

    -- מערכת גרירה חלקה
    local dragging, dragInput, dragStart, startPos
    topBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true dragStart = input.Position startPos = mainFrame.Position
            input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
        end
    end)
    topBar.InputChanged:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    return Menu
end

return Menu
