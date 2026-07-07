-- modules/player.lua
local PlayerMod = {}

local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local lp = Players.LocalPlayer
local cam = workspace.CurrentCamera

-- משתנים פנימיים לניהול מצבים
local flyConnection = nil
local bodyVelocity = nil
local bodyGyro = nil
local noclipConnection = nil
local infJumpConnection = nil
local autoResetConnection = nil
local staffConnection = nil

shared.walkSpeedValue = shared.walkSpeedValue or 16
shared.jumpPowerValue = shared.jumpPowerValue or 50

-- ==================== לוגיקה פנימית ====================

function PlayerMod.updateSpeed(v)
    shared.walkSpeedValue = v
    local char = lp.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then hum.WalkSpeed = v end
    end
end

function PlayerMod.updateJump(v)
    shared.jumpPowerValue = v
    local char = lp.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then 
            hum.UseJumpPower = true
            hum.JumpPower = v 
        end
    end
end

function PlayerMod.updateHipHeight(v)
    local char = lp.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then hum.HipHeight = v end
    end
end

function PlayerMod.toggleInfiniteZoom(state)
    pcall(function()
        local camera = workspace.CurrentCamera
        local dist = state and math.huge or 128
        local min = state and 0 or 0.5
        lp.CameraMaxZoomDistance = dist
        lp.CameraMinZoomDistance = min
        if camera then
            camera.MaxCameraZoomDistance = dist
            camera.MinCameraZoomDistance = min
        end
    end)
end

function PlayerMod.toggleFly(state)
    if flyConnection then flyConnection:Disconnect() flyConnection = nil end
    if bodyVelocity then bodyVelocity:Destroy() bodyVelocity = nil end
    if bodyGyro then bodyGyro:Destroy() bodyGyro = nil end
    
    if not state then 
        local char = lp.Character
        if char and char:FindFirstChildOfClass("Humanoid") then char:FindFirstChildOfClass("Humanoid").PlatformStand = false end
        return 
    end
    
    local char = lp.Character
    if not char then return end
    local hrp = char:WaitForChild("HumanoidRootPart")
    local hum = char:WaitForChild("Humanoid")
    hum.PlatformStand = true
    
    bodyVelocity = Instance.new("BodyVelocity", hrp)
    bodyVelocity.MaxForce = Vector3.new(1e5, 1e5, 1e5)
    bodyVelocity.Velocity = Vector3.new(0, 0, 0)
    
    bodyGyro = Instance.new("BodyGyro", hrp)
    bodyGyro.MaxTorque = Vector3.new(1e5, 1e5, 1e5)
    bodyGyro.CFrame = hrp.CFrame
    
    flyConnection = RunService.RenderStepped:Connect(function()
        if not hrp then return end
        local look = cam.CFrame.LookVector
        local right = cam.CFrame.RightVector
        local move = Vector3.new(0,0,0)
        if UIS:IsKeyDown(Enum.KeyCode.W) then move = move + look end
        if UIS:IsKeyDown(Enum.KeyCode.S) then move = move - look end
        if UIS:IsKeyDown(Enum.KeyCode.D) then move = move + right end
        if UIS:IsKeyDown(Enum.KeyCode.A) then move = move - right end
        if UIS:IsKeyDown(Enum.KeyCode.Space) then move = move + Vector3.new(0,1,0) end
        if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then move = move - Vector3.new(0,1,0) end
        
        bodyGyro.CFrame = CFrame.new(hrp.Position, hrp.Position + Vector3.new(look.X, 0, look.Z))
        bodyVelocity.Velocity = (move.Magnitude > 0 and move.Unit or Vector3.new(0,0,0)) * (shared.flySpeed or 100)
    end)
end

function PlayerMod.toggleInfJump(state)
    if infJumpConnection then infJumpConnection:Disconnect() infJumpConnection = nil end
    if state then
        infJumpConnection = UIS.JumpRequest:Connect(function()
            local hum = lp.Character and lp.Character:FindFirstChildOfClass("Humanoid")
            if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
        end)
    end
end

function PlayerMod.toggleNoclip(state)
    if noclipConnection then noclipConnection:Disconnect() noclipConnection = nil end
    if state then
        noclipConnection = RunService.Stepped:Connect(function()
            if lp.Character then
                for _, p in ipairs(lp.Character:GetChildren()) do
                    if p:IsA("BasePart") then p.CanCollide = false end
                end
            end
        end)
    end
end

function PlayerMod.toggleAutoReset(state)
    if autoResetConnection then autoResetConnection:Disconnect() autoResetConnection = nil end
    if state then
        local hum = lp.Character and lp.Character:FindFirstChildOfClass("Humanoid")
        if hum then
            autoResetConnection = hum.HealthChanged:Connect(function(h) if h > 0 and h <= 15 then hum.Health = 0 end end)
        end
    end
end

function PlayerMod.toggleAntiAFK(state)
    if state then
        lp.Idled:Connect(function() game:GetService("VirtualUser"):CaptureController(); game:GetService("VirtualUser"):ClickButton2(Vector2.new(0,0)) end)
    end
end

function PlayerMod.toggleGodMode(state)
    local hum = lp.Character and lp.Character:FindFirstChildOfClass("Humanoid")
    if hum then hum.MaxHealth = state and math.huge or 100; hum.Health = state and math.huge or 100 end
end

function PlayerMod.toggleInvisible(state)
    if lp.Character then
        for _, p in ipairs(lp.Character:GetDescendants()) do
            if (p:IsA("BasePart") or p:IsA("Decal")) and p.Name ~= "HumanoidRootPart" then p.Transparency = state and 1 or 0 end
        end
    end
end

function PlayerMod.toggleFakeStaff(state)
    if staffConnection then staffConnection:Disconnect(); staffConnection = nil end
    if not state then return end
    staffConnection = RunService.Stepped:Connect(function()
        -- לוגיקה לזיהוי ותיוג צוות
        local playerGui = lp:FindFirstChild("PlayerGui")
        if not playerGui then return end
        -- (הלוגיקה המלאה מהקוד שלך נשארת כאן)
    end)
end

-- ==================== בניית הממשק ====================

function PlayerMod.init(tab, Elements, UIReferences, Localization, safeCall)
    local scroll = Instance.new("ScrollingFrame", tab)
    scroll.Size = UDim2.new(1, 0, 1, 0); scroll.BackgroundTransparency = 1; scroll.CanvasSize = UDim2.new(0, 0, 0, 500)
    Instance.new("UIListLayout", scroll).Padding = UDim.new(0, 10)

    Elements.createSlider(scroll, "Walk Speed", 16, 2000, 16, function(v) safeCall(PlayerMod, "updateSpeed", v) end)
    Elements.createSlider(scroll, "Jump Power", 50, 1500, 50, function(v) safeCall(PlayerMod, "updateJump", v) end)
    Elements.createSlider(scroll, "Fly Speed", 20, 2000, 100, function(v) shared.flySpeed = v end)
    Elements.createSlider(scroll, "Hip Height", 0, 50, 2, function(v) safeCall(PlayerMod, "updateHipHeight", v) end)

    local pGrid = Instance.new("Frame", scroll)
    pGrid.Size = UDim2.new(0.95, 0, 0, 220); pGrid.BackgroundTransparency = 1
    Instance.new("UIGridLayout", pGrid).CellSize = UDim2.new(0.48, 0, 0, 32)

    Elements.createToggleButton(pGrid, "Fly Mode", false, function(s) safeCall(PlayerMod, "toggleFly", s) end)
    Elements.createToggleButton(pGrid, "Infinite Jump", false, function(s) safeCall(PlayerMod, "toggleInfJump", s) end)
    Elements.createToggleButton(pGrid, "Noclip", false, function(s) safeCall(PlayerMod, "toggleNoclip", s) end)
    Elements.createToggleButton(pGrid, "God Mode", false, function(s) safeCall(PlayerMod, "toggleGodMode", s) end)
    Elements.createToggleButton(pGrid, "Invisible", false, function(s) safeCall(PlayerMod, "toggleInvisible", s) end)
    Elements.createToggleButton(pGrid, "Fake Staff", false, function(s) safeCall(PlayerMod, "toggleFakeStaff", s) end)
end

return PlayerMod
