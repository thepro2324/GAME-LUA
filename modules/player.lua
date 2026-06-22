-- modules/player.lua (גרסה מלאה ומשוחזרת - כל הכפתורים והלוגיקות בפנים!)

local PlayerMod = {}

local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local lp = Players.LocalPlayer
local cam = workspace.CurrentCamera

-- משתני בקרה פנימיים
local flyConnection = nil
local bodyVelocity = nil
local bodyGyro = nil

local noclipConnection = nil
local infJumpConnection = nil
local autoResetConnection = nil

---------------------------------------------------------
-- 1. הגדרות בסיסיות (WalkSpeed, JumpPower, HipHeight)
---------------------------------------------------------
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
        if hum then hum.JumpPower = v end
    end
end

function PlayerMod.updateHipHeight(v)
    local char = lp.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then hum.HipHeight = v end
    end
end

-- שמירה על הערכים גם כשהשחקן עושה ריסט/מת
lp.CharacterAdded:Connect(function(char)
    local hum = char:WaitForChild("Humanoid")
    if shared.walkSpeedValue then hum.WalkSpeed = shared.walkSpeedValue end
    if shared.jumpPowerValue then hum.JumpPower = shared.jumpPowerValue end
    
    -- אם ה-Fly היה מופעל, נפעיל מחדש כדי שלא יתכבה בריספawn
    if shared.isFlying then
        task.wait(0.5)
        PlayerMod.toggleFly(true)
    end
end)

---------------------------------------------------------
-- 2. מערכת התעופה ה-FLY החדשה (מצלמה + CTRL/Space/Shift)
---------------------------------------------------------
function PlayerMod.toggleFly(state)
    if flyConnection then flyConnection:Disconnect() flyConnection = nil end
    if bodyVelocity then bodyVelocity:Destroy() bodyVelocity = nil end
    if bodyGyro then bodyGyro:Destroy() bodyGyro = nil end
    
    if not state then 
        local char = lp.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then hum.PlatformStand = false end
        end
        return 
    end
    
    local char = lp.Character or lp.CharacterAdded:Wait()
    local hrp = char:WaitForChild("HumanoidRootPart")
    local hum = char:WaitForChild("Humanoid")
    
    hum.PlatformStand = true
    
    bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.MaxForce = Vector3.new(1e5, 1e5, 1e5)
    bodyVelocity.Velocity = Vector3.new(0, 0, 0)
    bodyVelocity.Parent = hrp
    
    bodyGyro = Instance.new("BodyGyro")
    bodyGyro.MaxTorque = Vector3.new(1e5, 1e5, 1e5)
    bodyGyro.CFrame = hrp.CFrame
    bodyGyro.Parent = hrp
    
    flyConnection = RunService.RenderStepped:Connect(function()
        if not hrp or not bodyVelocity or not bodyVelocity.Parent then return end
        
        local moveDir = Vector3.new(0, 0, 0)
        
        if UIS:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + cam.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - cam.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + cam.CFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - cam.CFrame.RightVector end
        
        if UIS:IsKeyDown(Enum.KeyCode.Space) or UIS:IsKeyDown(Enum.KeyCode.LeftControl) then
            moveDir = moveDir + Vector3.new(0, 1, 0)
        end
        if UIS:IsKeyDown(Enum.KeyCode.LeftShift) then
            moveDir = moveDir - Vector3.new(0, 1, 0)
        end
        
        bodyGyro.CFrame = CFrame.new(hrp.Position, hrp.Position + cam.CFrame.LookVector)
        local speed = shared.flySpeed or 100
        
        if moveDir.Magnitude > 0 then
            bodyVelocity.Velocity = moveDir.Unit * speed
        else
            bodyVelocity.Velocity = Vector3.new(0, 0, 0)
        end
    end)
end

---------------------------------------------------------
-- 3. קפיצה אינסופית (Infinite Jump)
---------------------------------------------------------
function PlayerMod.toggleInfJump(state)
    if infJumpConnection then infJumpConnection:Disconnect() infJumpConnection = nil end
    
    if state then
        infJumpConnection = UIS.JumpRequest:Connect(function()
            local char = lp.Character
            if char then
                local hum = char:FindFirstChildOfClass("Humanoid")
                if hum then
                    hum:ChangeState(Enum.HumanoidStateType.Jumping)
                end
            end
        end)
    end
end

---------------------------------------------------------
-- 4. מעבר קירות (Noclip)
---------------------------------------------------------
function PlayerMod.toggleNoclip(state)
    if noclipConnection then noclipConnection:Disconnect() noclipConnection = nil end
    
    if state then
        noclipConnection = RunService.Stepped:Connect(function()
            local char = lp.Character
            if char then
                for _, part in ipairs(char:GetChildren()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
    end
end

---------------------------------------------------------
-- 5. איפוס אוטומטי בחיים נמוכים (Auto-Reset Low HP)
---------------------------------------------------------
function PlayerMod.toggleAutoReset(state)
    if autoResetConnection then autoResetConnection:Disconnect() autoResetConnection = nil end
    
    if state then
        local char = lp.Character or lp.CharacterAdded:Wait()
        local hum = char:WaitForChild("Humanoid")
        
        autoResetConnection = hum.HealthChanged:Connect(function(health)
            if health > 0 and health <= 15 then -- אם החיים יורדים מתחת ל-15
                hum.Health = 0 -- עושה ריסט אוטומטי
            end
        end)
    end
end

---------------------------------------------------------
-- 6. אנטי AFK (Anti-AFK) ללא ניתוקים
---------------------------------------------------------
function PlayerMod.toggleAntiAFK(state)
    if state then
        local virtualUser = game:GetService("VirtualUser")
        lp.Idled:Connect(function()
            virtualUser:CaptureController()
            virtualUser:ClickButton2(Vector2.new(0,0))
            print("🛡️ [Ori Dev] מערכת אנטי-AFK מנעה ניתוק!")
        end)
    end
end

---------------------------------------------------------
-- 7. שאר הלוגיקות (God Mode, Invisible, No Ragdoll, Auto-Heal)
---------------------------------------------------------
function PlayerMod.toggleGodMode(state)
    local char = lp.Character
    if char and state then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.MaxHealth = math.huge
            hum.Health = math.huge
        end
    elseif char and not state then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.MaxHealth = 100
            hum.Health = 100
        end
    end
end

function PlayerMod.toggleInvisible(state)
    local char = lp.Character
    if char then
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") or part:IsA("Decal") then
                if part.Name ~= "HumanoidRootPart" then
                    part.Transparency = state and 1 or 0
                end
            end
        end
    end
end

function PlayerMod.toggleNoRagdoll(state)
    local char = lp.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, not state)
            hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, not state)
        end
    end
end

function PlayerMod.toggleAutoHeal(state)
    task.spawn(function()
        while state do
            task.wait(1)
            local char = lp.Character
            if char then
                local hum = char:FindFirstChildOfClass("Humanoid")
                if hum and hum.Health < hum.MaxHealth then
                    hum.Health = math.min(hum.Health + 5, hum.MaxHealth) -- מרפא 5 חיים בכל שנייה
                end
            end
        end
    end)
end

return PlayerMod
