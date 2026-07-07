local Menu = {}
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local playerObj = Players.LocalPlayer

Menu.MainFrame = nil
Menu.SideBar = nil
Menu.ContentFrame = nil
Menu.Containers = {}
Menu.TabButtons = {}

function Menu.init(Elements)
    local screenGui = Instance.new("ScreenGui", playerObj:WaitForChild("PlayerGui"))
    screenGui.Name = "ori_dev_mega_container"
    screenGui.ResetOnSpawn = false

    local mainFrame = Instance.new("Frame", screenGui)
    mainFrame.Size = UDim2.new(0, 560, 0, 380); mainFrame.Position = UDim2.new(0.5, -280, 0.5, -190)
    mainFrame.BackgroundColor3 = Color3.fromRGB(14, 14, 17); mainFrame.Active = true
    Elements.addCorner(mainFrame, UDim.new(0, 8)); Elements.addStroke(mainFrame, Color3.fromRGB(40, 40, 50), 1.5)
    Menu.MainFrame = mainFrame

    -- TopBar
    local topBar = Instance.new("TextButton", mainFrame)
    topBar.Size = UDim2.new(1, 0, 0, 35); topBar.BackgroundColor3 = Color3.fromRGB(22, 22, 28); topBar.Text = ""
    topBar.AutoButtonColor = false; Elements.addCorner(topBar, UDim.new(0, 8))
    
    local titleLabel = Instance.new("TextLabel", topBar)
    titleLabel.Size = UDim2.new(0.5, 0, 1, 0); titleLabel.Position = UDim2.new(0, 12, 0, 0)
    titleLabel.Text = "ORI_DEV | PRIVATE HUB"; titleLabel.TextColor3 = Color3.fromRGB(240, 240, 245)
    titleLabel.Font = Enum.Font.GothamBold; titleLabel.TextSize = 13; titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.BackgroundTransparency = 1

    -- Dragging Logic
    local dragging, dragInput, dragStart, startPos
    topBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true; dragStart = input.Position; startPos = mainFrame.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    topBar.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)

    Menu.SideBar = Instance.new("ScrollingFrame", mainFrame)
    Menu.SideBar.Size = UDim2.new(0, 130, 1, -45); Menu.SideBar.Position = UDim2.new(0, 5, 0, 40)
    Menu.SideBar.BackgroundColor3 = Color3.fromRGB(10, 10, 13); Menu.SideBar.ScrollBarThickness = 0
    Menu.SideBar.AutomaticCanvasSize = "Y"; Elements.addCorner(Menu.SideBar, UDim.new(0, 6))
    Instance.new("UIListLayout", Menu.SideBar).Padding = UDim.new(0, 5)

    Menu.ContentFrame = Instance.new("Frame", mainFrame)
    Menu.ContentFrame.Size = UDim2.new(1, -150, 1, -45); Menu.ContentFrame.Position = UDim2.new(0, 143, 0, 40)
    Menu.ContentFrame.BackgroundTransparency = 1

    return Menu
end

function Menu.createTab(name, order, Elements)
    local container = Instance.new("ScrollingFrame", Menu.ContentFrame)
    container.Size = UDim2.new(1, 0, 1, -5); container.BackgroundTransparency = 1
    container.ScrollBarThickness = 3; container.AutomaticCanvasSize = "Y"; container.Visible = false
    Instance.new("UIListLayout", container).Padding = UDim.new(0, 8)
    table.insert(Menu.Containers, container)

    local tabBtn = Instance.new("TextButton", Menu.SideBar)
    tabBtn.Size = UDim2.new(0.92, 0, 0, 32); tabBtn.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
    tabBtn.Text = name:upper(); tabBtn.Font = Enum.Font.GothamBold; tabBtn.TextSize = 11
    Elements.addCorner(tabBtn, UDim.new(0, 5)); local bStroke = Elements.addStroke(tabBtn, Color3.fromRGB(28, 28, 38), 1)
    table.insert(Menu.TabButtons, {btn = tabBtn, stroke = bStroke})

    tabBtn.MouseButton1Click:Connect(function()
        for _, c in ipairs(Menu.Containers) do c.Visible = false end
        for _, tData in ipairs(Menu.TabButtons) do
            tData.btn.BackgroundColor3 = Color3.fromRGB(18, 18, 24); tData.stroke.Color = Color3.fromRGB(28, 28, 38)
        end
        container.Visible = true; tabBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 42); bStroke.Color = Color3.fromRGB(65, 65, 90)
    end)

    if order == 1 then container.Visible = true end
    return container
end

return Menu
