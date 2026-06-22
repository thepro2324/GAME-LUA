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

    -- חלון ראשי
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Parent = screenGui
    mainFrame.Size = UDim2.new(0, 650, 0, 450)
    mainFrame.Position = UDim2.new(0.5, -325, 0.5, -225)
    mainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    mainFrame.BackgroundTransparency = 0.1
    Elements.addCorner(mainFrame, UDim.new(0, 10))
    Elements.addStroke(mainFrame, Color3.new(1, 1, 1), 2)
    mainFrame.Active = true

    -- כותרת עליונה לגרירה
    local topBar = Instance.new("Frame")
    topBar.Size = UDim2.new(1, 0, 0, 40)
    topBar.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    Elements.addCorner(topBar, UDim.new(0, 10))
    topBar.Parent = mainFrame
    
    local hideCorner = Instance.new("Frame")
    hideCorner.Size = UDim2.new(1, 0, 0.5, 0)
    hideCorner.Position = UDim2.new(0, 0, 0.5, 0)
    hideCorner.BackgroundColor3 = topBar.BackgroundColor3
    hideCorner.BorderSizePixel = 0
    hideCorner.Parent = topBar

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(0.5, 0, 1, 0)
    titleLabel.Position = UDim2.new(0, 15, 0, 0)
    titleLabel.Text = "ORI_DEV | MEGA CONTAINER v3"
    titleLabel.TextColor3 = Color3.new(1, 1, 1)
    titleLabel.Font = Enum.Font.SourceSansBold
    titleLabel.TextSize = 18
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.BackgroundTransparency = 1
    titleLabel.Parent = topBar

    -- כפתור סגירה
    local closeButton = Instance.new("TextButton")
    closeButton.Size = UDim2.new(0, 30, 0, 30)
    closeButton.Position = UDim2.new(1, -35, 0, 5)
    closeButton.Text = "X"
    closeButton.TextColor3 = Color3.new(1, 1, 1)
    closeButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    closeButton.Font = Enum.Font.SourceSansBold
    Elements.addCorner(closeButton, UDim.new(0, 6))
    closeButton.Parent = topBar
    closeButton.MouseButton1Click:Connect(function() screenGui:Destroy() end)

    -- פאנל תוכן מרכזי לקטגוריות
    local contentFrame = Instance.new("Frame")
    contentFrame.Size = UDim2.new(1, -160, 1, -50)
    contentFrame.Position = UDim2.new(0, 155, 0, 45)
    contentFrame.BackgroundTransparency = 1
    contentFrame.Parent = mainFrame

    -- סיידבר קטגוריות (Side Bar)
    local sideBar = Instance.new("ScrollingFrame")
    sideBar.Size = UDim2.new(0, 140, 1, -55)
    sideBar.Position = UDim2.new(0, 5, 0, 45)
    sideBar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    sideBar.BackgroundTransparency = 0.3
    sideBar.ScrollBarThickness = 2
    Elements.addCorner(sideBar, UDim.new(0, 8))
    Elements.addStroke(sideBar, Color3.fromRGB(100, 100, 100), 1)
    sideBar.Parent = mainFrame

    local sideLayout = Instance.new("UIListLayout")
    sideLayout.Padding = UDim.new(0, 5)
    sideLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    sideLayout.Parent = sideBar

    -- פונקציה לייצור טאב פנימי
    local containers = {}
    function Menu.createTab(name, icon, order)
        local container = Instance.new("ScrollingFrame")
        container.Name = name .. "Container"
        container.Size = UDim2.new(1, -10, 1, 0)
        container.BackgroundTransparency = 1
        container.ScrollBarThickness = 4
        container.Visible = false
        
        local layout = Instance.new("UIListLayout")
        layout.Padding = UDim.new(0, 10)
        layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        layout.Parent = container
        container.Parent = contentFrame
        table.insert(containers, container)

        local tabBtn = Instance.new("TextButton")
        tabBtn.Size = UDim2.new(0.95, 0, 0, 35)
        tabBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        tabBtn.TextColor3 = Color3.new(0.8, 0.8, 0.8)
        tabBtn.Font = Enum.Font.SourceSansBold
        tabBtn.TextSize = 14
        tabBtn.Text = icon .. "  " .. name:upper()
        tabBtn.LayoutOrder = order
        Elements.addCorner(tabBtn, UDim.new(0, 6))
        Elements.addStroke(tabBtn, Color3.new(1, 1, 1), 0.5)
        tabBtn.Parent = sideBar

        tabBtn.MouseButton1Click:Connect(function()
            for _, c in ipairs(containers) do c.Visible = false end
            for _, b in ipairs(sideBar:GetChildren()) do
                if b:IsA("TextButton") then b.BackgroundColor3 = Color3.fromRGB(30, 30, 30) end
            end
            container.Visible = true
            tabBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        end)

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
