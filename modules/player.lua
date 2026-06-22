-- modules/player.lua
local PlayerMod = {}
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer

-- משתני עזר גלובליים/שותפים
shared.walkSpeedValue = shared.walkSpeedValue or 16
shared.jumpPowerValue = shared.jumpPowerValue or 50
shared.flySpeed = shared.flySpeed or 100

local flyLoop, noclipLoop, jumpConnection
local isFlying = false
local isNoclip = false
local isInfJump = false

-- 1. עדכון מהירות וקפיצה בזמן אמת (עבור הסליידרים)
function PlayerMod.updateSpeed(v)
    shared.walkSpeedValue = v
    if player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
        player.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = v
    end
end

function PlayerMod.updateJump(v)
    shared.jumpPowerValue = v
    if player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
        local hum = player.Character:FindFirstChildOfClass("Humanoid")
        hum.JumpPower = v
        hum.UseJumpPower = true
    end
end

-- לולאה קבועה שמוודאת שהמהירות והקפיצה לא מתאפסות ע"י המשחק
RunService.Heartbeat:Connect(function()
    if player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
        local hum = player.Character:FindFirstChildOfClass("Humanoid")
        if hum.WalkSpeed ~= shared.walkSpeedValue and not isFlying then
            hum.WalkSpeed = shared.walkSpeedValue
        end
        if hum.JumpPower ~= shared.jumpPowerValue then
            hum.JumpPower = shared.jumpPowerValue
            hum.UseJumpPower = true
        end
    end
end)

-- 2. כפתור FLY MODE (תעופה חלקה)
function PlayerMod.toggleFly(state)
    isFlying = state
    if flyLoop then flyLoop:Disconnect() flyLoop = nil end
    
    if isFlying then
        local character = player.Character
        if not character or not character:FindFirstChild("HumanoidRootPart") then return end
        local root = character.HumanoidRootPart
        
        -- יצירת כוחות פיזיקליים לתעופה
        local bv = Instance.new("BodyVelocity")
        bv.Name = "FlyBV"
        bv.MaxForce = Vector3.new(1,1,1) * 9e9
        bv.Velocity = Vector3.new(0,0.1,0)
        bv.Parent = root
        
        local bg = Instance.new("BodyGyro")
        bg.Name = "FlyBG"
        bg.MaxTorque = Vector3.new(1,1,1) * 9e9
        bg.CFrame = root.CFrame
        bg.Parent = root
        
        local camera = workspace.CurrentCamera
        
        flyLoop = RunService.RenderStepped:Connect(function()
            if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then return end
            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
            local currentRoot = player.Character.HumanoidRootPart
            
            local flyBv = currentRoot:FindFirstChild("FlyBV")
            local flyBg = currentRoot:FindFirstChild("FlyBG")
            
            if flyBv and flyBg and humanoid then
                humanoid.PlatformStand = true
                flyBg.CFrame = camera.CFrame
                
                local moveDirection = humanoid.MoveDirection
                local velocity = moveDirection * shared.flySpeed
                
                -- הוספת כיוון אנכי עם מקשים (Space לעלות, Shift לרדת)
                if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                    velocity = velocity + Vector3.new(0, shared.flySpeed, 0)
                elseif UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                    velocity = velocity - Vector3.new(0, shared.flySpeed, 0)
                end
                
                flyBv.Velocity = velocity
            end
        end)
    else
        -- כיבוי תעופה וניקוי
        if player.Character then
            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then humanoid.PlatformStand = false end
            
            local root = player.Character:FindFirstChild("HumanoidRootPart")
            if root then
                if root:FindFirstChild("FlyBV") then root.FlyBV:Destroy() end
                if root:FindFirstChild("FlyBG") then root.FlyBG:Destroy() end
            end
        end
    end
end

-- 3. כפתור INFINITE JUMP (קפיצה אינסופית באוויר)
function PlayerMod.toggleInfJump(state)
    isInfJump = state
    if jumpConnection then jumpConnection:Disconnect() jumpConnection = nil end
    
    if isInfJump then
        jumpConnection = UserInputService.JumpRequest:Connect(function()
            if isInfJump and player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
                player.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
            end
        end)
    end
end

-- 4. כפתור NOCLIP (מעבר דרך קירות)
function PlayerMod.toggleNoclip(state)
    isNoclip = state
    if noclipLoop then noclipLoop:Disconnect() noclipLoop = nil end
    
    if isNoclip then
        noclipLoop = RunService.Stepped:Connect(function()
            if isNoclip and player.Character then
                for _, part in ipairs(player.Character:GetDescendants()) do
                    if part:IsA("BasePart") and part.CanCollide then
                        part.CanCollide = false
                    end
                end
            end
        end)
    end
end

-- 5. כפתור GOD MODE (גוד מוד בסיסי - מונע מוות מנזק רגיל בחלק מהמשחקים)
function PlayerMod.toggleGodMode(state)
    if state then
        local cam = workspace.CurrentCamera
        local char = player.Character
        if char and char:FindFirstChildOfClass("Humanoid") then
            char:FindFirstChildOfClass("Humanoid").Name = "BrokenHumanoid"
        end
        local newChar = char:Clone()
        newChar.Parent = workspace
        player.Character = newChar
        cam.CameraSubject = newChar:FindFirstChildOfClass("Humanoid")
        char:Destroy()
    else
        if player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
            player.Character:FindFirstChildOfClass("Humanoid").Health = 0
        end
    end
end

-- 6. כפתור INVISIBLE (הפיכה לבלתי נראה לשחקנים אחרים)
function PlayerMod.toggleInvisible(state)
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local root = player.Character.HumanoidRootPart
        for _, part in ipairs(player.Character:GetDescendants()) do
            if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                part.Transparency = state and 1 or 0
                if part:IsA("Decal") then part.Transparency = state and 1 or 0 end
            end
        end
    end
end

return PlayerMod
