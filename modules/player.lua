-- =========================================================================
-- INTEGRATED PLAYER SCRIPT (ONE FILE)
-- =========================================================================

local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local lp = Players.LocalPlayer
local cam = workspace.CurrentCamera

-- 1. הגדרת ספריית Elements
local Elements = {}
function Elements.addCorner(parent, radius) local c = Instance.new("UICorner"); c.CornerRadius = radius or UDim.new(0, 6); c.Parent = parent; return c end
function Elements.addStroke(parent, color, thickness) local s = Instance.new("UIStroke"); s.Color = color or Color3.new(1, 1, 1); s.Thickness = thickness or 1.2; s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border; s.Parent = parent; return s end

function Elements.createToggleButton(parent, text, isActiveByDefault, callback)
    local button = Instance.new("TextButton", parent); button.Size = UDim2.new(0.95, 0, 0, 32); button.BackgroundColor3 = Color3.fromRGB(22, 22, 28); button.Font = Enum.Font.GothamBold; button.TextSize = 12; Elements.addCorner(button, UDim.new(0, 5)); local stroke = Elements.addStroke(button, Color3.fromRGB(35, 35, 45), 1)
    local state = isActiveByDefault; local function updateVisuals() if state then button.Text = text .. " : ON"; button.TextColor3 = Color3.fromRGB(80, 255, 140); stroke.Color = Color3.fromRGB(50, 120, 80) else button.Text = text .. " : OFF"; button.TextColor3 = Color3.fromRGB(220, 80, 80); stroke.Color = Color3.fromRGB(35, 35, 45) end end; updateVisuals()
    button.MouseButton1Click:Connect(function() state = not state; updateVisuals(); callback(state) end)
    return button
end

function Elements.createSlider(parent, text, min, max, default, callback)
    local sliderFrame = Instance.new("Frame", parent); sliderFrame.Size = UDim2.new(0.95, 0, 0, 42); sliderFrame.BackgroundTransparency = 1
    local label = Instance.new("TextLabel", sliderFrame); label.Size = UDim2.new(1, 0, 0, 14); label.Text = text .. " - " .. default; label.TextColor3 = Color3.fromRGB(200, 200, 205); label.Font = Enum.Font.GothamBold; label.TextSize = 11; label.BackgroundTransparency = 1; label.TextXAlignment = Enum.TextXAlignment.Left
    local sliderBG = Instance.new("Frame", sliderFrame); sliderBG.Size = UDim2.new(1, 0, 0, 6); sliderBG.Position = UDim2.new(0, 0, 0, 22); sliderBG.BackgroundColor3 = Color3.fromRGB(25, 25, 32); Elements.addCorner(sliderBG, UDim.new(1, 0)); Elements.addStroke(sliderBG, Color3.fromRGB(35, 35, 45), 1)
    local sliderFill = Instance.new("Frame", sliderBG); sliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0); sliderFill.BackgroundColor3 = Color3.fromRGB(85, 110, 240); Elements.addCorner(sliderFill, UDim.new(1, 0))
    local sliderBtn = Instance.new("TextButton", sliderBG); sliderBtn.Size = UDim2.new(0, 12, 0, 12); sliderBtn.Position = UDim2.new((default - min) / (max - min), -6, 0.5, -6); sliderBtn.BackgroundColor3 = Color3.fromRGB(240, 240, 245); sliderBtn.Text = ""; Elements.addCorner(sliderBtn, UDim.new(1, 0))
    local dragging = false; sliderBtn.MouseButton1Down:Connect(function() dragging = true end); UIS.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)
    RunService.Heartbeat:Connect(function() if dragging then local mPos = UIS:GetMouseLocation().X; local bPos = sliderBG.AbsolutePosition.X; local bSize = sliderBG.AbsoluteSize.X; local p = math.clamp((mPos - bPos) / bSize, 0, 1); sliderFill.Size = UDim2.new(p, 0, 1, 0); sliderBtn.Position = UDim2.new(p, -6, 0.5, -6); local val = math.floor(min + (p * (max - min))); label.Text = text .. " - " .. val; callback(val) end end)
end

-- 2. הגדרת PlayerMod (הלוגיקה שלך)
local PlayerMod = {}
shared.walkSpeedValue = 16; shared.jumpPowerValue = 50; shared.flySpeed = 100
local flyConnection, bodyVelocity, bodyGyro, noclipConnection, infJumpConnection

function PlayerMod.updateSpeed(v) shared.walkSpeedValue = v; local h = lp.Character and lp.Character:FindFirstChildOfClass("Humanoid"); if h then h.WalkSpeed = v end end
function PlayerMod.updateJump(v) shared.jumpPowerValue = v; local h = lp.Character and lp.Character:FindFirstChildOfClass("Humanoid"); if h then h.UseJumpPower = true; h.JumpPower = v end end
function PlayerMod.toggleFly(state)
    if flyConnection then flyConnection:Disconnect(); flyConnection = nil end
    if bodyVelocity then bodyVelocity:Destroy(); bodyVelocity = nil end
    if bodyGyro then bodyGyro:Destroy(); bodyGyro = nil end
    local h = lp.Character and lp.Character:FindFirstChildOfClass("Humanoid")
    if not state then if h then h.PlatformStand = false end return end
    local hrp = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    h.PlatformStand = true; bodyVelocity = Instance.new("BodyVelocity", hrp); bodyVelocity.MaxForce = Vector3.new(1e5, 1e5, 1e5); bodyGyro = Instance.new("BodyGyro", hrp); bodyGyro.MaxTorque = Vector3.new(1e5, 1e5, 1e5); bodyGyro.CFrame = hrp.CFrame
    flyConnection = RunService.RenderStepped:Connect(function()
        local look = cam.CFrame.LookVector; local right = cam.CFrame.RightVector; local move = Vector3.new(0,0,0)
        if UIS:IsKeyDown(Enum.KeyCode.W) then move = move + look end
        if UIS:IsKeyDown(Enum.KeyCode.S) then move = move - look end
        if UIS:IsKeyDown(Enum.KeyCode.D) then move = move + right end
        if UIS:IsKeyDown(Enum.KeyCode.A) then move = move - right end
        if UIS:IsKeyDown(Enum.KeyCode.Space) then move = move + Vector3.new(0,1,0) end
        if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then move = move - Vector3.new(0,1,0) end
        bodyGyro.CFrame = CFrame.new(hrp.Position, hrp.Position + Vector3.new(look.X, 0, look.Z)); bodyVelocity.Velocity = (move.Magnitude > 0 and move.Unit or Vector3.new(0,0,0)) * shared.flySpeed
    end)
end
function PlayerMod.toggleInfJump(state)
    if infJumpConnection then infJumpConnection:Disconnect(); infJumpConnection = nil end
    if state then infJumpConnection = UIS.JumpRequest:Connect(function() local h = lp.Character and lp.Character:FindFirstChildOfClass("Humanoid"); if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end end) end
end
function PlayerMod.toggleNoclip(state)
    if noclipConnection then noclipConnection:Disconnect(); noclipConnection = nil end
    if state then noclipConnection = RunService.Stepped:Connect(function() if lp.Character then for _, p in ipairs(lp.Character:GetChildren()) do if p:IsA("BasePart") then p.CanCollide = false end end end end) end
end
function PlayerMod.toggleGodMode(state) local h = lp.Character and lp.Character:FindFirstChildOfClass("Humanoid"); if h then h.MaxHealth = state and math.huge or 100; h.Health = state and math.huge or 100 end end
function PlayerMod.toggleInvisible(state) if lp.Character then for _, p in ipairs(lp.Character:GetDescendants()) do if (p:IsA("BasePart") or p:IsA("Decal")) and p.Name ~= "HumanoidRootPart" then p.Transparency = state and 1 or 0 end end end end

-- 3. פונקציית העזר SafeCall
local function safeCall(mod, func, ...)
    local success, err = pcall(function(...) return mod[func](...) end, ...)
    if not success then warn("Error in " .. func .. ": " .. tostring(err)) end
end

-- 4. הטמעה בתוך ה-UI שלך
-- (כאן תשים את ה-mainContent שלך או תשתמש ב-UI הקיים)
function PlayerMod.init(parentFrame)
    local scroll = Instance.new("ScrollingFrame", parentFrame)
    scroll.Size = UDim2.new(1, 0, 1, 0); scroll.BackgroundTransparency = 1; scroll.CanvasSize = UDim2.new(0, 0, 0, 500)
    Instance.new("UIListLayout", scroll).Padding = UDim.new(0, 10)

    Elements.createSlider(scroll, "Walk Speed", 16, 2000, 16, function(v) safeCall(PlayerMod, "updateSpeed", v) end)
    Elements.createSlider(scroll, "Jump Power", 50, 1500, 50, function(v) safeCall(PlayerMod, "updateJump", v) end)
    Elements.createSlider(scroll, "Fly Speed", 20, 2000, 100, function(v) shared.flySpeed = v end)
    
    local pGrid = Instance.new("Frame", scroll); pGrid.Size = UDim2.new(0.95, 0, 0, 220); pGrid.BackgroundTransparency = 1
    Instance.new("UIGridLayout", pGrid).CellSize = UDim2.new(0.48, 0, 0, 32)
    
    Elements.createToggleButton(pGrid, "Fly Mode", false, function(s) safeCall(PlayerMod, "toggleFly", s) end)
    Elements.createToggleButton(pGrid, "Infinite Jump", false, function(s) safeCall(PlayerMod, "toggleInfJump", s) end)
    Elements.createToggleButton(pGrid, "Noclip", false, function(s) safeCall(PlayerMod, "toggleNoclip", s) end)
    Elements.createToggleButton(pGrid, "God Mode", false, function(s) safeCall(PlayerMod, "toggleGodMode", s) end)
    Elements.createToggleButton(pGrid, "Invisible", false, function(s) safeCall(PlayerMod, "toggleInvisible", s) end)
end

-- =========================================================================
-- הרצה (תחליף את mainContent בטאב האמיתי שלך אם צריך)
-- PlayerMod.init(mainContent)
-- =========================================================================
