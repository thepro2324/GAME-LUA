-- =========================================================================
-- ORI HUB - FIXED & OPTIMIZED
-- =========================================================================
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local lp = Players.LocalPlayer
local cam = workspace.CurrentCamera

-- ניקוי קודם
if CoreGui:FindFirstChild("MyMenu") then CoreGui:FindFirstChild("MyMenu"):Destroy() end

-- יצירת UI בסיסי
local screen = Instance.new("ScreenGui", CoreGui); screen.Name = "MyMenu"
local frame = Instance.new("Frame", screen); frame.Size = UDim2.new(0, 600, 0, 375); frame.Position = UDim2.new(0.5, -300, 0.5, -187.5); frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30); Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)
local sidebar = Instance.new("Frame", frame); sidebar.Size = UDim2.new(0, 140, 1, 0); sidebar.BackgroundColor3 = Color3.fromRGB(40, 40, 40); Instance.new("UICorner", sidebar).CornerRadius = UDim.new(0, 10)
local mainContent = Instance.new("Frame", frame); mainContent.Size = UDim2.new(1, -140, 1, 0); mainContent.Position = UDim2.new(0, 140, 0, 0); mainContent.BackgroundTransparency = 1

-- ספריית אלמנטים
local Elements = {}
function Elements.addCorner(p, r) local c = Instance.new("UICorner", p); c.CornerRadius = r or UDim.new(0, 6) end

function Elements.createToggleButton(parent, text, isActiveByDefault, callback)
    local button = Instance.new("TextButton", parent); button.Size = UDim2.new(0.9, 0, 0, 32); button.BackgroundColor3 = Color3.fromRGB(22, 22, 28); button.Font = Enum.Font.GothamBold; button.TextSize = 12; Elements.addCorner(button, UDim.new(0, 5))
    local state = isActiveByDefault; local function updateVisuals() button.Text = text .. (state and " : ON" or " : OFF"); button.TextColor3 = state and Color3.fromRGB(80, 255, 140) or Color3.fromRGB(220, 80, 80) end; updateVisuals()
    button.MouseButton1Click:Connect(function() state = not state; updateVisuals(); callback(state) end)
    return button
end

function Elements.createSlider(parent, text, min, max, default, callback)
    local frame = Instance.new("Frame", parent); frame.Size = UDim2.new(0.9, 0, 0, 40); frame.BackgroundTransparency = 1
    local label = Instance.new("TextLabel", frame); label.Size = UDim2.new(1, 0, 0, 20); label.Text = text .. " - " .. default; label.TextColor3 = Color3.new(1,1,1); label.BackgroundTransparency = 1
    local bg = Instance.new("Frame", frame); bg.Size = UDim2.new(1, 0, 0, 6); bg.Position = UDim2.new(0, 0, 0, 25); bg.BackgroundColor3 = Color3.fromRGB(25, 25, 32); Elements.addCorner(bg, UDim.new(1, 0))
    local fill = Instance.new("Frame", bg); fill.Size = UDim2.new((default-min)/(max-min), 0, 1, 0); fill.BackgroundColor3 = Color3.fromRGB(85, 110, 240); Elements.addCorner(fill, UDim.new(1, 0))
    bg.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then 
        local pos = math.clamp((input.Position.X - bg.AbsolutePosition.X) / bg.AbsoluteSize.X, 0, 1)
        fill.Size = UDim2.new(pos, 0, 1, 0); local val = math.floor(min + (pos * (max-min))); label.Text = text .. " - " .. val; callback(val)
    end end)
end

-- לוגיקה
local flyConn, bodyVel, bodyGyro
local function updateSpeed(v) local h = lp.Character and lp.Character:FindFirstChildOfClass("Humanoid") if h then h.WalkSpeed = v end end
local function updateJump(v) local h = lp.Character and lp.Character:FindFirstChildOfClass("Humanoid") if h then h.JumpPower = v end end
local function toggleFly(s)
    if flyConn then flyConn:Disconnect(); flyConn = nil end
    if bodyVel then bodyVel:Destroy(); bodyVel = nil end
    if bodyGyro then bodyGyro:Destroy(); bodyGyro = nil end
    local h = lp.Character and lp.Character:FindFirstChildOfClass("Humanoid")
    if not s then if h then h.PlatformStand = false end return end
    local hrp = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    h.PlatformStand = true; bodyVel = Instance.new("BodyVelocity", hrp); bodyVel.MaxForce = Vector3.new(1e5,1e5,1e5); bodyGyro = Instance.new("BodyGyro", hrp); bodyGyro.MaxTorque = Vector3.new(1e5,1e5,1e5); bodyGyro.CFrame = hrp.CFrame
    flyConn = RunService.RenderStepped:Connect(function()
        local l, r = cam.CFrame.LookVector, cam.CFrame.RightVector; local m = Vector3.new()
        if UIS:IsKeyDown(Enum.KeyCode.W) then m = m + l end; if UIS:IsKeyDown(Enum.KeyCode.S) then m = m - l end
        if UIS:IsKeyDown(Enum.KeyCode.D) then m = m + r end; if UIS:IsKeyDown(Enum.KeyCode.A) then m = m - r end
        bodyVel.Velocity = m * 100; bodyGyro.CFrame = CFrame.new(hrp.Position, hrp.Position + Vector3.new(l.X, 0, l.Z))
    end)
end

-- בניית התפריט
local btnY = 50
local function createButton(name, callback)
    local b = Instance.new("TextButton", sidebar); b.Size = UDim2.new(0.8, 0, 0, 35); b.Position = UDim2.new(0.1, 0, 0, btnY); b.Text = name; b.BackgroundColor3 = Color3.fromRGB(60, 60, 60); b.TextColor3 = Color3.new(1,1,1); b.Font = Enum.Font.Gotham; Elements.addCorner(b, UDim.new(0, 6))
    b.MouseButton1Click:Connect(function() mainContent:ClearAllChildren(); callback() end); btnY += 45
end

createButton("Home", function() end)

createButton("Player", function()
    -- 1. יצירת ה-ScrollingFrame (זה הטאב עצמו)
    local scroll = Instance.new("ScrollingFrame", mainContent)
    scroll.Size = UDim2.new(1, 0, 1, 0)
    scroll.BackgroundTransparency = 1      -- שקוף לחלוטין
    scroll.BorderSizePixel = 0             -- בלי גבולות
    scroll.ScrollBarThickness = 4          -- פס גלילה דק ואסתטי
    scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y -- גלילה אוטומטית לפי תוכן
    
    -- 2. סידור האלמנטים
    local layout = Instance.new("UIListLayout", scroll)
    layout.Padding = UDim.new(0, 8)
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    layout.PaddingTop = UDim.new(0, 10)
    
    -- הוספת אלמנטים (הם מתחברים ישירות ל-scroll)
    Elements.createSlider(scroll, "Speed", 16, 200, 16, updateSpeed)
    Elements.createSlider(scroll, "Jump Power", 50, 300, 50, updateJump)
    Elements.createToggleButton(scroll, "Fly", false, toggleFly)
    Elements.createToggleButton(scroll, "Noclip", false, function(s) end)
    Elements.createToggleButton(scroll, "Inf Jump", false, function(s) end)
    
    -- כפתור Reset
    local resetBtn = Instance.new("TextButton", scroll)
    resetBtn.Size = UDim2.new(0.9, 0, 0, 32)
    resetBtn.BackgroundColor3 = Color3.fromRGB(150, 60, 60)
    resetBtn.Text = "Reset Character"
    resetBtn.TextColor3 = Color3.new(1,1,1)
    resetBtn.Font = Enum.Font.GothamBold
    Elements.addCorner(resetBtn, UDim.new(0, 5))
    
    resetBtn.MouseButton1Click:Connect(function() 
        if lp.Character then lp.Character:BreakJoints() end 
    end)
end)
