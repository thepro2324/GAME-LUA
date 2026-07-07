local Menu = {}
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local playerObj = Players.LocalPlayer

-- משתנים גלובליים למודול
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

    -- [כאן תוסיף את הקוד של ה-TopBar וכפתור הסגירה שלך...]
    -- ... (הקוד המקורי שלך ל-TopBar נשאר זהה)

    Menu.SideBar = Instance.new("ScrollingFrame", mainFrame)
    Menu.SideBar.Size = UDim2.new(0, 130, 1, -45); Menu.SideBar.Position = UDim2.new(0, 5, 0, 40)
    Menu.SideBar.BackgroundColor3 = Color3.fromRGB(10, 10, 13); Menu.SideBar.ScrollBarThickness = 0
    Menu.SideBar.AutomaticCanvasSize = "Y"
    Elements.addCorner(Menu.SideBar, UDim.new(0, 6)); Elements.addStroke(Menu.SideBar, Color3.fromRGB(25, 25, 32), 1)
    Instance.new("UIListLayout", Menu.SideBar).Padding = UDim.new(0, 5)

    Menu.ContentFrame = Instance.new("Frame", mainFrame)
    Menu.ContentFrame.Size = UDim2.new(1, -150, 1, -45); Menu.ContentFrame.Position = UDim2.new(0, 143, 0, 40)
    Menu.ContentFrame.BackgroundTransparency = 1

    -- לוגיקת סגירה וגרירה (כפי שכתבת - מעולה!)
    -- ... (הקוד המקורי שלך לגרירה נשאר זהה)

    return Menu
end

-- הפונקציה החשובה - הוצאנו אותה החוצה
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

    if order == 1 then container.Visible = true end -- טאב ראשון נפתח אוטומטית
    return container
end

return Menu
