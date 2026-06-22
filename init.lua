-- init.lua
local GITHUB_USER = "thepro2324"
local REPO_NAME   = "GAME-LUA"

local function import(path)
    local url = "https://raw.githubusercontent.com/" .. GITHUB_USER .. "/" .. REPO_NAME .. "/main/" .. path
    local success, result = pcall(function() return game:HttpGet(url, true) end)
    if success and result and result ~= "" then
        local func = loadstring(result)
        if func then return func() end
    end
end

-- טעינת המודול של הטארגט
local TargetMod = import("modules/target.lua") or {}

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ori_dev_script"
screenGui.ResetOnSpawn = false
screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

-- הפאנל הראשי (בעיצוב המקורי שלך)
local frame = Instance.new("Frame")
frame.Parent = screenGui
frame.Size = UDim2.new(0.35, 0, 0.45, 0) -- מותאם אישית מכיוון שאין טאבים
frame.Position = UDim2.new(0.325, 0, 0.2, 0)
frame.BackgroundColor3 = Color3.new(0, 0, 0)
frame.BackgroundTransparency = 0.5
frame.BorderSizePixel = 0

local uiCorner = Instance.new("UICorner")
uiCorner.Parent = frame
uiCorner.CornerRadius = UDim.new(0.05, 0)

local border = Instance.new("UIStroke")
border.Parent = frame
border.Color = Color3.new(1, 1, 1)
border.Thickness = 2
border.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

-- כותרת
local title = Instance.new("TextLabel")
title.Parent = frame
title.Size = UDim2.new(0.6, 0, 0.15, 0)
title.Position = UDim2.new(0.05, 0, 0.02, 0)
title.Text = "ori_dev_script"
title.TextColor3 = Color3.new(1, 1, 1)
title.TextScaled = true
title.TextXAlignment = Enum.TextXAlignment.Left
title.Font = Enum.Font.SourceSansBold
title.BackgroundTransparency = 1

-- שורת קרדיט
local creditLabel = Instance.new("TextLabel")
creditLabel.Parent = frame
creditLabel.Size = UDim2.new(1, 0, 0.08, 0)
creditLabel.Position = UDim2.new(0, 0, 0.90, 0)
creditLabel.Text = "Created by ori_dev"
creditLabel.TextColor3 = Color3.new(0.6, 0.6, 0.6)
creditLabel.TextScaled = true
creditLabel.Font = Enum.Font.SourceSansItalic
creditLabel.BackgroundTransparency = 1

---------------------------------------------------------
-- כפתורי הקטנה וסגירה
---------------------------------------------------------
local minimizeButton = Instance.new("TextButton")
minimizeButton.Parent = frame
minimizeButton.Size = UDim2.new(0.08, 0, 0.1, 0)
minimizeButton.Position = UDim2.new(0.78, 0, 0.04, 0)
minimizeButton.Text = "-"
minimizeButton.TextColor3 = Color3.new(1, 1, 1)
minimizeButton.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
minimizeButton.Font = Enum.Font.SourceSansBold
minimizeButton.TextScaled = true
Instance.new("UICorner", minimizeButton).CornerRadius = UDim.new(0.3, 0)

local closeButton = Instance.new("TextButton")
closeButton.Parent = frame
closeButton.Size = UDim2.new(0.08, 0, 0.1, 0)
closeButton.Position = UDim2.new(0.88, 0, 0.04, 0)
closeButton.Text = "X"
closeButton.TextColor3 = Color3.new(1, 0.3, 0.3)
closeButton.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
closeButton.Font = Enum.Font.SourceSansBold
closeButton.TextScaled = true
Instance.new("UICorner", closeButton).CornerRadius = UDim.new(0.3, 0)

-- פריים קבוצת האלמנטים של ה-Target
local targetGroup = Instance.new("Frame")
targetGroup.Parent = frame
targetGroup.Size = UDim2.new(1, 0, 0.75, 0)
targetGroup.Position = UDim2.new(0, 0, 0.18, 0)
targetGroup.BackgroundTransparency = 1

---------------------------------------------------------
-- אלמנטים TARGET
---------------------------------------------------------
local textBox = Instance.new("TextBox")
textBox.Parent = targetGroup
textBox.Size = UDim2.new(0.8, 0, 0.18, 0)
textBox.Position = UDim2.new(0.1, 0, 0.05, 0)
textBox.PlaceholderText = "Target Nickname"
textBox.Text = ""
textBox.TextColor3 = Color3.new(1, 1, 1)
textBox.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
textBox.BackgroundTransparency = 0.5
textBox.Font = Enum.Font.SourceSans
textBox.TextScaled = true
textBox.ClearTextOnFocus = false
Instance.new("UICorner", textBox).CornerRadius = UDim.new(0.1, 0)

local searchResultsFrame = Instance.new("ScrollingFrame")
searchResultsFrame.Parent = targetGroup
searchResultsFrame.Size = UDim2.new(0.8, 0, 0.45, 0)
searchResultsFrame.Position = UDim2.new(0.1, 0, 0.25, 0)
searchResultsFrame.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
searchResultsFrame.BackgroundTransparency = 0.1
searchResultsFrame.BorderSizePixel = 0
searchResultsFrame.Visible = false
searchResultsFrame.ScrollBarThickness = 5
searchResultsFrame.ZIndex = 5
Instance.new("UICorner", searchResultsFrame).CornerRadius = UDim.new(0.05, 0)

local searchListLayout = Instance.new("UIListLayout")
searchListLayout.Parent = searchResultsFrame
searchListLayout.SortOrder = Enum.SortOrder.LayoutOrder
searchListLayout.Padding = UDim.new(0, 2)

local startButton = Instance.new("TextButton")
startButton.Parent = targetGroup
startButton.Size = UDim2.new(0.7, 0, 0.22, 0)
startButton.Position = UDim2.new(0.15, 0, 0.65, 0)
startButton.Text = "Start Targeter"
startButton.TextColor3 = Color3.new(1, 1, 1)
startButton.BackgroundColor3 = Color3.new(0.1, 0.5, 0.1)
startButton.BackgroundTransparency = 0.3
startButton.Font = Enum.Font.SourceSansBold
startButton.TextScaled = true
Instance.new("UICorner", startButton).CornerRadius = UDim.new(0.1, 0)

---------------------------------------------------------
-- חיבור הלוגיקה מהמודול לחלונות הממשק
---------------------------------------------------------

-- עדכון תוצאות חיפוש בזמן אמת
textBox:GetPropertyChangedSignal("Text"):Connect(function()
    for _, child in ipairs(searchResultsFrame:GetChildren()) do
        if child:IsA("TextButton") then child:Destroy() end
    end
    
    if not TargetMod.getMatches then return end
    local matches = TargetMod.getMatches(textBox.Text)
    
    if #matches > 0 then
        searchResultsFrame.Visible = true
        searchResultsFrame.CanvasSize = UDim2.new(0, 0, 0, #matches * 25)
        for i, name in ipairs(matches) do
            local btn = Instance.new("TextButton")
            btn.Parent = searchResultsFrame
            btn.Size = UDim2.new(1, 0, 0, 23)
            btn.BackgroundColor3 = Color3.new(0.15, 0.15, 0.15)
            btn.BorderSizePixel = 0
            btn.Text = " " .. name
            btn.TextColor3 = Color3.new(1, 1, 1)
            btn.TextXAlignment = Enum.TextXAlignment.Left
            btn.Font = Enum.Font.SourceSans
            btn.TextSize = 14
            btn.ZIndex = 6
            Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)
            
            btn.MouseButton1Click:Connect(function()
                textBox.Text = name
                searchResultsFrame.Visible = false
            end)
        end
    else
        searchResultsFrame.Visible = false
    end
end)

-- לחיצה על כפתור ה-Start/Stop
startButton.MouseButton1Click:Connect(function()
    if not TargetMod.startTargeting then return end
    if TargetMod.isTeleporting then
        TargetMod.stopTargeting(startButton)
    else
        TargetMod.startTargeting(textBox.Text, startButton, searchResultsFrame)
    end
end)

-- כפתור הקטנה
local isMinimized = false
local originalSize = frame.Size
minimizeButton.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    if isMinimized then
        frame.Size = UDim2.new(originalSize.X.Scale, originalSize.X.Offset, 0, 45) 
        targetGroup.Visible = false
        creditLabel.Visible = false
        minimizeButton.Text = "+"
        searchResultsFrame.Visible = false
    else
        frame.Size = originalSize
        minimizeButton.Text = "-"
        targetGroup.Visible = true
        creditLabel.Visible = true
    end
end)

-- כפתור סגירה
closeButton.MouseButton1Click:Connect(function()
    if TargetMod.stopTargeting then TargetMod.stopTargeting() end
    screenGui:Destroy()
end)

print("🎯 [Ori Dev] מערכת ה-Targeter הטהורה מוכנה להפעלה!")
