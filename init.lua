-- init.lua (גרסה מתוקנת ומסונכרנת עם modules/player.lua)

local GITHUB_USER = "thepro2324"
local REPO_NAME   = "GAME-LUA"

local function import(path)
    local url = "https://raw.githubusercontent.com/" .. GITHUB_USER .. "/" .. REPO_NAME .. "/main/" .. path
    local success, result = pcall(function()
        return game:HttpGet(url, true)
    end)
    
    if success and result and result ~= "" and not result:find("404: Not Found") then
        local loader = loadstring or typeof(loadstring) == "function" and loadstring
        if not loader then
            warn("🔴 [Ori Dev] האקזקיוטור שלך לא תומך ב-loadstring!")
            return {}
        end
        
        local func, err = loader(result)
        if func then 
            local runSuccess, runResult = pcall(func)
            if runSuccess then 
                return runResult 
            else
                warn("🔴 [Ori Dev] שגיאה בהרצת המודול: " .. path .. " -> " .. tostring(runResult))
            end
        else
            warn("🔴 [Ori Dev] שגיאה בקומפילציה של המודול: " .. path .. " -> " .. tostring(err))
        end
    else
        warn("⚠️ [Ori Dev] נכשל ייבוא הקובץ מהנתיב: " .. path)
    end
    return {}
end

local Elements = import("ui/elements.lua")
local Menu = import("ui/menu.lua")

local PlayerMod    = import("modules/player.lua") or {}
local VisualsMod   = import("modules/visuals.lua") or {}
local WorldMod     = import("modules/world.lua") or {}
local TeleportMod  = import("modules/teleport.lua") or {}
local TargetMod    = import("modules/target.lua") or {}
local SettingsMod  = import("modules/settings.lua") or {}

local function safeCall(mod, funcName, ...)
    if mod and mod[funcName] then
        return mod[funcName](...)
    end
end

if not Elements or not Menu or not Menu.init then 
    Menu = {init = function() return {createTab = function() return Instance.new("Frame") end, updateTabTitle = function() end} end}
    Elements = {createToggleButton = function(p) return Instance.new("TextButton", p) end, createSlider = function() end, addCorner = function() end, addStroke = function() end}
end

local MenuInterface = Menu.init(Elements)

shared.flySpeed = shared.flySpeed or 100
shared.isFlying = false
shared.infiniteZoomActive = false

local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local cam = workspace.CurrentCamera
local lp = game.Players.LocalPlayer

local currentLanguage = "HE"

local Localization = {
    EN = {
        Version = "Version: 1.5.0",
        Welcome = "Welcome to ori_dev_script mega hub!",
        AntiAFK = "Anti-AFK",
        AutoReset = "Auto-Reset (Low HP)",
        HideUser = "Hide Username",
        FPSUnlock = "FPS Unlocker",
        TargetTab = "Target",
        PlayerTab = "Player",
        VisualsTab = "Visuals",
        WorldTab = "World",
        ServersTab = "Servers",
        SettingsTab = "Settings",
        StartTarget = "Start Targeter",
        StopTarget = "Stop Targeter",
        Placeholder = "Target Nickname",
        ThemeSelect = "Select Menu Theme Color:",
        ToggleKeyLabel = "Menu Toggle Key (1 Letter):"
    },
    HE = {
        Version = "גרסה: 1.5.0",
        Welcome = "ברוך הבא לתוך המגה האב של אורי!",
        AntiAFK = "אנטי AFK",
        AutoReset = "איפוס אוטומטי (חיים נמוכים)",
        HideUser = "הסתרת שם משתמש",
        FPSUnlock = "משחרר FPS",
        TargetTab = "מטרה",
        PlayerTab = "שחקן",
        VisualsTab = "ויזואלס",
        WorldTab = "עולם",
        ServersTab = "שרתים",
        SettingsTab = "הגדרות",
        StartTarget = "הפעל טארגטר",
        StopTarget = "עצור טארגטר",
        Placeholder = "הקלד כינוי של שחקן",
        ThemeSelect = "בחר צבע נושא לתפריט:",
        ToggleKeyLabel = "מקש פתיחה/סגירה (אות אחת):"
    }
}

local UIReferences = {}

local function updateLanguage(lang)
    currentLanguage = lang
    local texts = Localization[lang]
    
    if UIReferences.welcomeLabel then UIReferences.welcomeLabel.Text = texts.Welcome end
    if UIReferences.versionLabel then UIReferences.versionLabel.Text = texts.Version end
    if UIReferences.btnAntiAFK then UIReferences.btnAntiAFK.Text = texts.AntiAFK end
    if UIReferences.btnAutoReset then UIReferences.btnAutoReset.Text = texts.AutoReset end
    if UIReferences.btnHideUser then UIReferences.btnHideUser.Text = texts.HideUser end
    if UIReferences.btnFPS then UIReferences.btnFPS.Text = texts.FPSUnlock end
    
    if UIReferences.textBox then UIReferences.textBox.PlaceholderText = texts.Placeholder end
    if UIReferences.themeLabel then UIReferences.themeLabel.Text = texts.ThemeSelect end
    if UIReferences.keyLabel then UIReferences.keyLabel.Text = texts.ToggleKeyLabel end
    
    if UIReferences.startButton then
        if TargetMod and TargetMod.isTeleporting then
            UIReferences.startButton.Text = texts.StopTarget
        else
            UIReferences.startButton.Text = texts.StartTarget
        end
    end
    
    pcall(function()
        MenuInterface.updateTabTitle(1, lang == "HE" and "בית" or "Home")
        MenuInterface.updateTabTitle(2, texts.TargetTab)
        MenuInterface.updateTabTitle(3, texts.PlayerTab)
        MenuInterface.updateTabTitle(4, texts.VisualsTab)
        MenuInterface.updateTabTitle(5, texts.WorldTab)
        MenuInterface.updateTabTitle(6, texts.ServersTab)
        MenuInterface.updateTabTitle(7, texts.SettingsTab)
    end)
end

-- ==================== טאב 1: HOME ====================
local homeTab = MenuInterface.createTab("Home", 1)

local langContainer = Instance.new("Frame", homeTab)
langContainer.Size = UDim2.new(0.95, 0, 0, 35)
langContainer.BackgroundTransparency = 1

local enBtn = Instance.new("TextButton", langContainer)
enBtn.Size = UDim2.new(0.47, 0, 1, 0)
enBtn.Text = "🇺🇸 English"
enBtn.TextColor3 = Color3.fromRGB(240, 240, 245)
enBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
enBtn.Font = Enum.Font.SourceSansBold
enBtn.TextSize = 14
Elements.addCorner(enBtn, UDim.new(0, 5))
enBtn.MouseButton1Click:Connect(function() updateLanguage("EN") end)

local heBtn = Instance.new("TextButton", langContainer)
heBtn.Size = UDim2.new(0.47, 0, 1, 0)
heBtn.Position = UDim2.new(0.53, 0, 0, 0)
heBtn.Text = "🇮🇱 עברית"
heBtn.TextColor3 = Color3.fromRGB(240, 240, 245)
heBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
heBtn.Font = Enum.Font.SourceSansBold
heBtn.TextSize = 14
Elements.addCorner(heBtn, UDim.new(0, 5))
heBtn.MouseButton1Click:Connect(function() updateLanguage("HE") end)

local textContainer = Instance.new("Frame", homeTab)
textContainer.Size = UDim2.new(0.95, 0, 0, 50)
textContainer.BackgroundTransparency = 1

UIReferences.welcomeLabel = Instance.new("TextLabel", textContainer)
UIReferences.welcomeLabel.Size = UDim2.new(1, 0, 0.5, 0)
UIReferences.welcomeLabel.Position = UDim2.new(0, 0, 0, 5)
UIReferences.welcomeLabel.Text = Localization.HE.Welcome
UIReferences.welcomeLabel.TextColor3 = Color3.fromRGB(200, 200, 205)
UIReferences.welcomeLabel.Font = Enum.Font.SourceSansItalic
UIReferences.welcomeLabel.TextSize = 15
UIReferences.welcomeLabel.BackgroundTransparency = 1

UIReferences.versionLabel = Instance.new("TextLabel", textContainer)
UIReferences.versionLabel.Size = UDim2.new(1, 0, 0.5, 0)
UIReferences.versionLabel.Position = UDim2.new(0, 0, 0.5, 5)
UIReferences.versionLabel.Text = Localization.HE.Version
UIReferences.versionLabel.TextColor3 = Color3.fromRGB(30, 215, 96)
UIReferences.versionLabel.Font = Enum.Font.SourceSansBold
UIReferences.versionLabel.TextSize = 14
UIReferences.versionLabel.BackgroundTransparency = 1

local hGrid = Instance.new("Frame", homeTab)
hGrid.Size = UDim2.new(0.95, 0, 0, 120)
hGrid.BackgroundTransparency = 1
local gh = Instance.new("UIGridLayout", hGrid) 
gh.CellSize = UDim2.new(0.48, 0, 0, 32) 
gh.CellPadding = UDim2.new(0, 8, 0, 8)

UIReferences.btnAntiAFK = Elements.createToggleButton(hGrid, Localization.HE.AntiAFK, true, function(state) safeCall(PlayerMod, "toggleAntiAFK", state) end)
UIReferences.btnAutoReset = Elements.createToggleButton(hGrid, Localization.HE.AutoReset, false, function(state) safeCall(PlayerMod, "toggleAutoReset", state) end)
UIReferences.btnHideUser = Elements.createToggleButton(hGrid, Localization.HE.HideUser, false, function(state) safeCall(VisualsMod, "toggleHideName", state) end)
UIReferences.btnFPS = Elements.createToggleButton(hGrid, Localization.HE.FPSUnlock, false, function(state) safeCall(WorldMod, "toggleFPS", state) end)

-- ==================== טאב 2: TARGET ====================
local targetTab = MenuInterface.createTab("Target", 2)

local textBox = Instance.new("TextBox")
textBox.Parent = targetTab
textBox.Size = UDim2.new(0.9, 0, 0, 35)
textBox.Position = UDim2.new(0.05, 0, 0, 10)
textBox.PlaceholderText = Localization.HE.Placeholder
textBox.TextColor3 = Color3.fromRGB(240, 240, 245)
textBox.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
textBox.Font = Enum.Font.SourceSans
textBox.TextSize = 16
textBox.ClearTextOnFocus = false
Elements.addCorner(textBox, UDim.new(0, 6))
Elements.addStroke(textBox, Color3.fromRGB(45, 45, 55), 1)
UIReferences.textBox = textBox

local searchResultsFrame = Instance.new("ScrollingFrame")
searchResultsFrame.Parent = targetTab
searchResultsFrame.Size = UDim2.new(0.9, 0, 0, 110)
searchResultsFrame.Position = UDim2.new(0.05, 0, 0, 50)
searchResultsFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
searchResultsFrame.BorderSizePixel = 0
searchResultsFrame.Visible = false
searchResultsFrame.ScrollBarThickness = 4
searchResultsFrame.ZIndex = 10
Elements.addCorner(searchResultsFrame, UDim.new(0, 6))

local searchListLayout = Instance.new("UIListLayout")
searchListLayout.Parent = searchResultsFrame
searchListLayout.SortOrder = Enum.SortOrder.LayoutOrder
searchListLayout.Padding = UDim.new(0, 4)

local spacer = Instance.new("Frame", targetTab)
spacer.Size = UDim2.new(1, 0, 0, 125) 
spacer.BackgroundTransparency = 1

local startButton = Instance.new("TextButton")
startButton.Parent = targetTab
startButton.Size = UDim2.new(0.9, 0, 0, 40)
startButton.Position = UDim2.new(0.05, 0, 0, 0)
startButton.Text = Localization.HE.StartTarget
startButton.TextColor3 = Color3.new(1, 1, 1)
startButton.BackgroundColor3 = Color3.fromRGB(30, 130, 40)
startButton.Font = Enum.Font.SourceSansBold
startButton.TextSize = 18
Elements.addCorner(startButton, UDim.new(0, 6))
UIReferences.startButton = startButton

textBox:GetPropertyChangedSignal("Text"):Connect(function()
    for _, child in ipairs(searchResultsFrame:GetChildren()) do
        if child:IsA("Frame") or child:IsA("TextButton") then child:Destroy() end
    end
    local text = textBox.Text
    if text == "" then searchResultsFrame.Visible = false return end
    local matches = {}
    for _, p in ipairs(game.Players:GetPlayers()) do
        if p ~= game.Players.LocalPlayer and p.Name:lower():find(text:lower()) then
            table.insert(matches, p.Name)
        end
    end
    if #matches > 0 then
        searchResultsFrame.Visible = true
        searchResultsFrame.CanvasSize = UDim2.new(0, 0, 0, #matches * 32)
        for i, name in ipairs(matches) do
            local itemFrame = Instance.new("Frame")
            itemFrame.Parent = searchResultsFrame
            itemFrame.Size = UDim2.new(1, 0, 0, 28)
            itemFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
            itemFrame.BorderSizePixel = 0
            itemFrame.ZIndex = 11
            Elements.addCorner(itemFrame, UDim.new(0, 4))
            
            local avatarImage = Instance.new("ImageLabel")
            avatarImage.Parent = itemFrame
            avatarImage.Size = UDim2.new(0, 22, 0, 22)
            avatarImage.Position = UDim2.new(0, 4, 0.5, -11)
            avatarImage.BackgroundTransparency = 1
            avatarImage.ZIndex = 12
            
            local targetPlrObj = game.Players:FindFirstChild(name)
            if targetPlrObj then
                pcall(function()
                    local content = game.Players:GetUserThumbnailAsync(targetPlrObj.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size48x48)
                    avatarImage.Image = content
                end)
            end
            
            local btn = Instance.new("TextButton")
            btn.Parent = itemFrame
            btn.Size = UDim2.new(1, 0, 1, 0)
            btn.BackgroundTransparency = 1
            btn.Text = "      " .. name
            btn.TextColor3 = Color3.new(1, 1, 1)
            btn.TextXAlignment = Enum.TextXAlignment.Left
            btn.Font = Enum.Font.SourceSans
            btn.TextSize = 14
            btn.ZIndex = 13
            btn.MouseButton1Click:Connect(function()
                textBox.Text = name
                searchResultsFrame.Visible = false
            end)
        end
    else
        searchResultsFrame.Visible = false
    end
end)

startButton.MouseButton1Click:Connect(function()
    if not TargetMod or not TargetMod.startTargeting then return end
    if TargetMod.isTeleporting then
        TargetMod.stopTargeting(startButton)
        startButton.Text = Localization[currentLanguage].StartTarget
    else
        TargetMod.startTargeting(textBox.Text, startButton, searchResultsFrame)
        startButton.Text = Localization[currentLanguage].StopTarget
    end
end)

-- ==================== טאב 3: PLAYER ====================
local playerTab = MenuInterface.createTab("Player", 3)

Elements.createSlider(playerTab, "Walk Speed", 16, 2000, 16, function(v) 
    shared.walkSpeedValue = v 
    safeCall(PlayerMod, "updateSpeed", v)
end)

Elements.createSlider(playerTab, "Jump Power", 50, 1500, 50, function(v) 
    shared.jumpPowerValue = v 
    safeCall(PlayerMod, "updateJump", v)
end)

Elements.createSlider(playerTab, "Fly Speed", 20, 2000, 100, function(v) 
    shared.flySpeed = v 
end)

Elements.createSlider(playerTab, "Hip Height", 0, 50, 2, function(v) safeCall(PlayerMod, "updateHipHeight", v) end)

-- הגדלנו את הגובה מ-260 ל-320 כדי לתת מקום לשורה החדשה של הכפתור
local pGrid = Instance.new("Frame", playerTab)
pGrid.Size = UDim2.new(0.95, 0, 0, 320)
pGrid.BackgroundTransparency = 1

local g1 = Instance.new("UIGridLayout", pGrid) 
g1.CellSize = UDim2.new(0.48, 0, 0, 32) 
g1.CellPadding = UDim2.new(0, 8, 0, 8)

Elements.createToggleButton(pGrid, "Fly Mode", false, function(state)
    shared.isFlying = state
    safeCall(PlayerMod, "toggleFly", state)
end)

Elements.createToggleButton(pGrid, "Infinite Jump", false, function(state) safeCall(PlayerMod, "toggleInfJump", state) end)
Elements.createToggleButton(pGrid, "Noclip", false, function(state) safeCall(PlayerMod, "toggleNoclip", state) end)
Elements.createToggleButton(pGrid, "Ctrl+Click TP", false, function(state) safeCall(TeleportMod, "toggleCtrlClick", state) end)
Elements.createToggleButton(pGrid, "God Mode", false, function(state) safeCall(PlayerMod, "toggleGodMode", state) end)
Elements.createToggleButton(pGrid, "Invisible", false, function(state) safeCall(PlayerMod, "toggleInvisible", state) end)
Elements.createToggleButton(pGrid, "No Ragdoll", false, function(state) safeCall(PlayerMod, "toggleNoRagdoll", state) end)
Elements.createToggleButton(pGrid, "Auto-Heal", false, function(state) safeCall(PlayerMod, "toggleAutoHeal", state) end)

Elements.createToggleButton(pGrid, "Infinite Zoom", false, function(state)
    shared.infiniteZoomActive = state
    safeCall(PlayerMod, "toggleInfiniteZoom", state)
end)

-- התיקון המלא: הכפתור נוצר כעת בצורה תקינה בתוך ה-pGrid עם מספיק מקום מסך
Elements.createToggleButton(pGrid, "Fake Staff LB", false, function(state)
    safeCall(PlayerMod, "toggleFakeStaff", state)
end)

-- התיקון כאן: הפנייה ישירה ללוגיקה החדשה בתוך מודול שחקן
Elements.createToggleButton(pGrid, "Fake Staff LB", false, function(state)
    safeCall(PlayerMod, "toggleFakeStaff", state)
end)

-- ==================== טאב 4: VISUALS ====================
local visualsTab = MenuInterface.createTab("Visuals", 4)

local vGrid = Instance.new("Frame", visualsTab)
vGrid.Size = UDim2.new(0.95, 0, 0, 120)
vGrid.BackgroundTransparency = 1
local g2 = Instance.new("UIGridLayout", vGrid) 
g2.CellSize = UDim2.new(0.48, 0, 0, 32) 
g2.CellPadding = UDim2.new(0, 8, 0, 8)

Elements.createToggleButton(vGrid, "Master ESP", false, function(state) safeCall(VisualsMod, "toggleMasterESP", state) end)
Elements.createToggleButton(vGrid, "ESP Box", false, function(state) safeCall(VisualsMod, "toggleESPBox", state) end)
Elements.createToggleButton(vGrid, "ESP Names", false, function(state) safeCall(VisualsMod, "toggleESPNames", state) end)
Elements.createToggleButton(vGrid, "ESP Tracers", false, function(state) safeCall(VisualsMod, "toggleTracers", state) end)
Elements.createToggleButton(vGrid, "Fullbright", false, function(state) safeCall(VisualsMod, "toggleFullbright", state) end)
Elements.createToggleButton(vGrid, "Chams", false, function(state) safeCall(VisualsMod, "toggleChams", state) end)

-- ==================== טאב 5: WORLD ====================
local worldTab = MenuInterface.createTab("World", 5)

Elements.createSlider(worldTab, "Gravity Level", 0, 400, 196, function(v) safeCall(WorldMod, "setGravity", v) end)
Elements.createSlider(worldTab, "Field of View", 50, 120, 70, function(v) safeCall(WorldMod, "setFOV", v) end)
Elements.createSlider(worldTab, "Time of Day", 0, 24, 12, function(v) safeCall(WorldMod, "setTime", v) end)

local wGrid = Instance.new("Frame", worldTab)
wGrid.Size = UDim2.new(0.95, 0, 0, 80)
wGrid.BackgroundTransparency = 1
local gw = Instance.new("UIGridLayout", wGrid) 
gw.CellSize = UDim2.new(0.48, 0, 0, 32) 
gw.CellPadding = UDim2.new(0, 8, 0, 8)

Elements.createToggleButton(wGrid, "Remove Fog", false, function(state) safeCall(WorldMod, "toggleFog", state) end)
Elements.createToggleButton(wGrid, "Freeze World Time", false, function(state) safeCall(WorldMod, "toggleFreezeTime", state) end)
Elements.createToggleButton(wGrid, "Destroy Map Elements", false, function(state) safeCall(WorldMod, "destroyMap", state) end)

-- ==================== טאב 6: SERVERS ====================
local serversTab = MenuInterface.createTab("Servers", 6)

local rjButton = Instance.new("TextButton", serversTab)
rjButton.Size = UDim2.new(0.95, 0, 0, 32)
rjButton.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
rjButton.TextColor3 = Color3.fromRGB(240, 240, 245)
rjButton.Font = Enum.Font.GothamBold
rjButton.TextSize = 12
rjButton.Text = "QUICK REJOIN"
Elements.addCorner(rjButton, UDim.new(0, 5))
Elements.addStroke(rjButton, Color3.fromRGB(35, 35, 45), 1)
rjButton.MouseButton1Click:Connect(function() safeCall(TeleportMod, "rejoin") end)

local spacer2 = Instance.new("Frame", serversTab)
spacer2.Size = UDim2.new(1, 0, 0, 4)
spacer2.BackgroundTransparency = 1

local hopButton = Instance.new("TextButton", serversTab)
hopButton.Size = UDim2.new(0.95, 0, 0, 32)
hopButton.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
hopButton.TextColor3 = Color3.fromRGB(240, 240, 245)
hopButton.Font = Enum.Font.GothamBold
hopButton.TextSize = 12
hopButton.Text = "SERVER HOP"
Elements.addCorner(hopButton, UDim.new(0, 5))
Elements.addStroke(hopButton, Color3.fromRGB(35, 35, 45), 1)
hopButton.MouseButton1Click:Connect(function() safeCall(TeleportMod, "serverHop") end)

-- ==================== טאב 7: SETTINGS ====================
local settingsTab = MenuInterface.createTab("Settings", 7)

UIReferences.themeLabel = Instance.new("TextLabel", settingsTab)
UIReferences.themeLabel.Size = UDim2.new(0.95, 0, 0, 25)
UIReferences.themeLabel.Text = Localization.HE.ThemeSelect
UIReferences.themeLabel.TextColor3 = Color3.fromRGB(200, 200, 205)
UIReferences.themeLabel.Font = Enum.Font.SourceSansBold
UIReferences.themeLabel.TextSize = 14
UIReferences.themeLabel.TextXAlignment = Enum.TextXAlignment.Left
UIReferences.themeLabel.BackgroundTransparency = 1

local colorGrid = Instance.new("Frame", settingsTab)
colorGrid.Size = UDim2.new(0.95, 0, 0, 40)
colorGrid.BackgroundTransparency = 1
local clayout = Instance.new("UIListLayout", colorGrid)
clayout.FillDirection = Enum.FillDirection.Horizontal
clayout.Padding = UDim.new(0, 6)

local colors = {
    {Name = "Green", Color = Color3.fromRGB(30, 215, 96)},
    {Name = "Blue", Color = Color3.fromRGB(30, 144, 255)},
    {Name = "Red", Color = Color3.fromRGB(255, 75, 75)},
    {Name = "Purple", Color = Color3.fromRGB(155, 89, 182)}
}

for _, theme in ipairs(colors) do
    local cBtn = Instance.new("TextButton", colorGrid)
    cBtn.Size = UDim2.new(0, 55, 0, 26)
    cBtn.Text = theme.Name
    cBtn.Font = Enum.Font.SourceSansBold
    cBtn.TextSize = 12
    cBtn.TextColor3 = Color3.new(1,1,1)
    cBtn.BackgroundColor3 = theme.Color
    Elements.addCorner(cBtn, UDim.new(0, 4))
    
    cBtn.MouseButton1Click:Connect(function()
        safeCall(SettingsMod, "changeTheme", theme.Color, UIReferences.versionLabel)
    end)
end

local spaceSettings = Instance.new("Frame", settingsTab)
spaceSettings.Size = UDim2.new(1, 0, 0, 15)
spaceSettings.BackgroundTransparency = 1

UIReferences.keyLabel = Instance.new("TextLabel", settingsTab)
UIReferences.keyLabel.Size = UDim2.new(0.95, 0, 0, 25)
UIReferences.keyLabel.Text = Localization.HE.ToggleKeyLabel
UIReferences.keyLabel.TextColor3 = Color3.fromRGB(200, 200, 205)
UIReferences.keyLabel.Font = Enum.Font.SourceSansBold
UIReferences.keyLabel.TextSize = 14
UIReferences.keyLabel.TextXAlignment = Enum.TextXAlignment.Left
UIReferences.keyLabel.BackgroundTransparency = 1

local keyTextBox = Instance.new("TextBox", settingsTab)
keyTextBox.Size = UDim2.new(0, 60, 0, 32)
keyTextBox.Text = "RCTRL"
keyTextBox.TextColor3 = Color3.fromRGB(30, 215, 96)
keyTextBox.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
keyTextBox.Font = Enum.Font.SourceSansBold
keyTextBox.TextSize = 16
Elements.addCorner(keyTextBox, UDim.new(0, 5))
Elements.addStroke(keyTextBox, Color3.fromRGB(45, 45, 55), 1)

keyTextBox:GetPropertyChangedSignal("Text"):Connect(function()
    safeCall(SettingsMod, "setToggleKey", keyTextBox.Text, keyTextBox)
end)

---------------------------------------------------------
-- מערכת האזנה למקש פתיחה/סגירה דינמי
---------------------------------------------------------
UIS.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == shared.toggleKey then
        local mainFrame = MenuInterface.MainFrame
        if not mainFrame then
            local coreGui = game:GetService("CoreGui")
            local gui = coreGui:FindFirstChild("ModernMenuGui") or coreGui:FindFirstChild("ScreenGui")
            if gui then mainFrame = gui:FindFirstChildOfClass("Frame") end
        end
        if mainFrame then mainFrame.Visible = not mainFrame.Visible end
    end
end)

-- עדכון שפות התחלתי
updateLanguage("HE")

print("🚀 [Ori Dev] קובץ init.lua עודכן וסונכרן בהצלחה!")
