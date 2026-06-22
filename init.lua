-- init.lua (גרסת ה-Mega Hub המשולבת עם ה-Target המקורי של אורי)

-- הגדרות ה-GitHub שלך
local GITHUB_USER = "thepro2324"
local REPO_NAME   = "GAME-LUA"

local function import(path)
    local url = "https://raw.githubusercontent.com/" .. GITHUB_USER .. "/" .. REPO_NAME .. "/main/" .. path
    local success, result = pcall(function()
        return game:HttpGet(url, true)
    end)
    if success and result and result ~= "" then
        local func, err = loadstring(result)
        if func then
            return func()
        end
    end
end

-- 1. טעינת רכיבי ה-UI והמודולים
local Elements = import("ui/elements.lua")
local Menu = import("ui/menu.lua")
local PlayerMod    = import("modules/player.lua") or {}
local VisualsMod   = import("modules/visuals.lua") or {}
local WorldMod     = import("modules/world.lua") or {}
local TeleportMod  = import("modules/teleport.lua") or {}
local TargetMod    = import("modules/target.lua") or {}

if not Elements or not Menu then 
    error("🔴 [Ori Dev] שגיאה בטעינת קבצי ה-UI מה-GitHub!")
end

-- אתחול ה-Menu הראשי
local MenuInterface = Menu.init(Elements)

---------------------------------------------------------
-- יצירת הטאבים
---------------------------------------------------------

-- ==================== טאב 1: HOME ====================
local homeTab = MenuInterface.createTab("Home", 1)

local hGrid = Instance.new("Frame", homeTab)
hGrid.Size = UDim2.new(0.95, 0, 0, 120)
hGrid.BackgroundTransparency = 1
local gh = Instance.new("UIGridLayout", hGrid) 
gh.CellSize = UDim2.new(0.48, 0, 0, 32) 
gh.CellPadding = UDim2.new(0, 8, 0, 8)

Elements.createToggleButton(hGrid, "Anti-AFK", true, PlayerMod.toggleAntiAFK or function() end)
Elements.createToggleButton(hGrid, "Auto-Reset (Low HP)", false, PlayerMod.toggleAutoReset or function() end)
Elements.createToggleButton(hGrid, "Hide Username", false, VisualsMod.toggleHideName or function() end)
Elements.createToggleButton(hGrid, "FPS Unlocker", false, WorldMod.toggleFPS or function() end)


-- ==================== טאב 2: TARGET (העיצוב המקורי המשוחזר שלך!) ====================
-- ==================== טאב 2: TARGET (משודרג עם תמונות סקין) ====================
local targetTab = MenuInterface.createTab("Target", 2)

-- יצירת ה-TextBox המקורי שלך
local textBox = Instance.new("TextBox")
textBox.Parent = targetTab
textBox.Size = UDim2.new(0.9, 0, 0, 35)
textBox.Position = UDim2.new(0.05, 0, 0, 10)
textBox.PlaceholderText = "Target Nickname"
textBox.Text = ""
textBox.TextColor3 = Color3.fromRGB(240, 240, 245)
textBox.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
textBox.Font = Enum.Font.SourceSans
textBox.TextSize = 16
textBox.ClearTextOnFocus = false
Elements.addCorner(textBox, UDim.new(0, 6))
Elements.addStroke(textBox, Color3.fromRGB(45, 45, 55), 1)

-- חלון גלילה לתוצאות החיפוש בזמן אמת
local searchResultsFrame = Instance.new("ScrollingFrame")
searchResultsFrame.Parent = targetTab
searchResultsFrame.Size = UDim2.new(0.9, 0, 0, 120) -- הגדלנו מעט כדי שיתאים לאייקונים
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
searchListLayout.Padding = UDim.new(0, 4) -- ריווח נקי בין הכפתורים

-- רווח קטן כדי שהחיפוש לא יתנגש בכפתור הסטארט
local spacer = Instance.new("Frame", targetTab)
spacer.Size = UDim2.new(1, 0, 0, 135) 
spacer.BackgroundTransparency = 1

-- כפתור הסטארט/סטופ הגדול והצבעוני שלך
local startButton = Instance.new("TextButton")
startButton.Parent = targetTab
startButton.Size = UDim2.new(0.9, 0, 0, 40)
startButton.Position = UDim2.new(0.05, 0, 0, 0)
startButton.Text = "Start Targeter"
startButton.TextColor3 = Color3.new(1, 1, 1)
startButton.BackgroundColor3 = Color3.new(0.1, 0.5, 0.1)
startButton.Font = Enum.Font.SourceSansBold
startButton.TextSize = 18
Elements.addCorner(startButton, UDim.new(0, 6))

-- חיבור הלוגיקה והחיפוש של ה-Target כולל הוספת תמונת פרופיל
textBox:GetPropertyChangedSignal("Text"):Connect(function()
    -- מחיקת התוצאות הקודמות
    for _, child in ipairs(searchResultsFrame:GetChildren()) do
        if child:IsA("Frame") or child:IsA("TextButton") then child:Destroy() end
    end
    
    if not TargetMod.getMatches then return end
    local matches = TargetMod.getMatches(textBox.Text)
    
    if #matches > 0 then
        searchResultsFrame.Visible = true
        searchResultsFrame.CanvasSize = UDim2.new(0, 0, 0, #matches * 32) -- מותאם לגובה הכפתור החדש
        
        for i, name in ipairs(matches) do
            -- פריים מחזיק לכל שחקן ברשימה
            local itemFrame = Instance.new("Frame")
            itemFrame.Parent = searchResultsFrame
            itemFrame.Size = UDim2.new(1, 0, 0, 28)
            itemFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
            itemFrame.BorderSizePixel = 0
            itemFrame.ZIndex = 11
            Elements.addCorner(itemFrame, UDim.new(0, 4))
            
            -- תמונת האווטאר (ראש השחקן) מצד שמאל של השם
            local avatarImage = Instance.new("ImageLabel")
            avatarImage.Parent = itemFrame
            avatarImage.Size = UDim2.new(0, 24, 0, 24)
            avatarImage.Position = UDim2.new(0, 4, 0.5, -12)
            avatarImage.BackgroundTransparency = 1
            avatarImage.ZIndex = 12
            
            -- השגת האייקון ישירות מרובלוקס לפי ה-UserId
            local targetPlrObj = game.Players:FindFirstChild(name)
            if targetPlrObj then
                pcall(function()
                    local thumbType = Enum.ThumbnailType.HeadShot
                    local thumbSize = Enum.ThumbnailSize.Size48x48
                    local content, isReady = game.Players:GetUserThumbnailAsync(targetPlrObj.UserId, thumbType, thumbSize)
                    avatarImage.Image = content
                end)
            end
            
            -- כפתור שקוף מעל הכל כדי שהלחיצה תעבוד בצורה חלקה
            local btn = Instance.new("TextButton")
            btn.Parent = itemFrame
            btn.Size = UDim2.new(1, 0, 1, 0)
            btn.BackgroundTransparency = 1
            -- הזזת הטקסט ימינה כדי שלא יעלה על התמונה
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
    if not TargetMod.startTargeting then return end
    if TargetMod.isTeleporting then
        TargetMod.stopTargeting(startButton)
    else
        TargetMod.startTargeting(textBox.Text, startButton, searchResultsFrame)
    end
end)


-- ==================== טאב 3: PLAYER ====================
local playerTab = MenuInterface.createTab("Player", 3)

Elements.createSlider(playerTab, "Walk Speed", 16, 500, 16, function(v) 
    shared.walkSpeedValue = v 
    if PlayerMod.updateSpeed then PlayerMod.updateSpeed(v) end
end)

Elements.createSlider(playerTab, "Jump Power", 50, 1000, 50, function(v) 
    shared.jumpPowerValue = v 
    if PlayerMod.updateJump then PlayerMod.updateJump(v) end
end)

Elements.createSlider(playerTab, "Fly Speed", 20, 500, 100, function(v) shared.flySpeed = v end)
Elements.createSlider(playerTab, "Hip Height", 0, 50, 2, function(v) if PlayerMod.updateHipHeight then PlayerMod.updateHipHeight(v) end end)

local pGrid = Instance.new("Frame", playerTab)
pGrid.Size = UDim2.new(0.95, 0, 0, 160)
pGrid.BackgroundTransparency = 1
local g1 = Instance.new("UIGridLayout", pGrid) 
g1.CellSize = UDim2.new(0.48, 0, 0, 32) 
g1.CellPadding = UDim2.new(0, 8, 0, 8)

Elements.createToggleButton(pGrid, "Fly Mode", false, PlayerMod.toggleFly or function() end)
Elements.createToggleButton(pGrid, "Infinite Jump", false, PlayerMod.toggleInfJump or function() end)
Elements.createToggleButton(pGrid, "Noclip", false, PlayerMod.toggleNoclip or function() end)
Elements.createToggleButton(pGrid, "Ctrl+Click TP", false, TeleportMod.toggleCtrlClick or function() end)
Elements.createToggleButton(pGrid, "God Mode", false, PlayerMod.toggleGodMode or function() end)
Elements.createToggleButton(pGrid, "Invisible", false, PlayerMod.toggleInvisible or function() end)
Elements.createToggleButton(pGrid, "No Ragdoll", false, PlayerMod.toggleNoRagdoll or function() end)
Elements.createToggleButton(pGrid, "Auto-Heal", false, PlayerMod.toggleAutoHeal or function() end)


-- ==================== טאב 4: VISUALS ====================
local visualsTab = MenuInterface.createTab("Visuals", 4)

local vGrid = Instance.new("Frame", visualsTab)
vGrid.Size = UDim2.new(0.95, 0, 0, 120)
vGrid.BackgroundTransparency = 1
local g2 = Instance.new("UIGridLayout", vGrid) 
g2.CellSize = UDim2.new(0.48, 0, 0, 32) 
g2.CellPadding = UDim2.new(0, 8, 0, 8)

Elements.createToggleButton(vGrid, "Master ESP", false, VisualsMod.toggleMasterESP or function() end)
Elements.createToggleButton(vGrid, "ESP Box", false, VisualsMod.toggleESPBox or function() end)
Elements.createToggleButton(vGrid, "ESP Names", false, VisualsMod.toggleESPNames or function() end)
Elements.createToggleButton(vGrid, "ESP Tracers", false, VisualsMod.toggleTracers or function() end)
Elements.createToggleButton(vGrid, "Fullbright", false, VisualsMod.toggleFullbright or function() end)
Elements.createToggleButton(vGrid, "Chams", false, VisualsMod.toggleChams or function() end)


-- ==================== טאב 5: WORLD ====================
local worldTab = MenuInterface.createTab("World", 5)

Elements.createSlider(worldTab, "Gravity Level", 0, 400, 196, WorldMod.setGravity or function() end)
Elements.createSlider(worldTab, "Field of View", 50, 120, 70, WorldMod.setFOV or function() end)
Elements.createSlider(worldTab, "Time of Day", 0, 24, 12, function(v) if WorldMod.setTime then WorldMod.setTime(v) end end)

local wGrid = Instance.new("Frame", worldTab)
wGrid.Size = UDim2.new(0.95, 0, 0, 80)
wGrid.BackgroundTransparency = 1
local gw = Instance.new("UIGridLayout", wGrid) 
gw.CellSize = UDim2.new(0.48, 0, 0, 32) 
gw.CellPadding = UDim2.new(0, 8, 0, 8)

Elements.createToggleButton(wGrid, "Remove Fog", false, WorldMod.toggleFog or function() end)
Elements.createToggleButton(wGrid, "Freeze World Time", false, WorldMod.toggleFreezeTime or function() end)
Elements.createToggleButton(wGrid, "Destroy Map Elements", false, WorldMod.destroyMap or function() end)


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
rjButton.MouseButton1Click:Connect(TeleportMod.rejoin or function() end)

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
hopButton.MouseButton1Click:Connect(TeleportMod.serverHop or function() end)

print("🚀 [Ori Dev] ה-Mega Hub מוכן עם הטאבים המלאים והטארגט המשוחזר!")
