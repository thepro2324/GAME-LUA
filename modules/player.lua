-- modules/player.lua
local PlayerMod = {}
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local workspace = game:GetService("Workspace")

local playerObj = Players.LocalPlayer
local camera = workspace.CurrentCamera

-- משתני לוגיקה משותפים
shared.walkSpeedValue = 16
shared.jumpPowerValue = 50
shared.flySpeed = 100

_G.Fly_Enabled = false
_G.Noclip_Enabled = false
_G.InfJump_Enabled = false
_G.GodMode_Enabled = false

-- 1. מערכת תעופה (Fly Mode)
local flyBv, flyBg
function PlayerMod.toggleFly(state)
    _G.Fly_Enabled = state
    local char = playerObj.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    
    if state then
        char:FindFirstChildOfClass("Humanoid").PlatformStand = true
        flyBv = Instance.new("BodyVelocity", char.HumanoidRootPart)
        flyBv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        flyBg = Instance.new("BodyGyro", char.HumanoidRootPart)
        flyBg.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
        
        task.spawn(function()
            while _G.Fly_Enabled and char.HumanoidRootPart and char.HumanoidRootPart.Parent do
                local dir = Vector3.new(0,0,0)
                if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir = dir + camera.CFrame.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir = dir - camera.CFrame.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir = dir - camera.CFrame.RightVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir = dir + camera.CFrame.RightVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.Space) then dir = dir + Vector3.new(0,1,0) end
                if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then dir = dir - Vector3.new(0,1,0) end
                
                flyBv.Velocity = dir.Magnitude > 0 and dir.Unit * shared.flySpeed or Vector3.new(0,0,0)
                flyBg.CFrame = camera.CFrame
                task.wait()
            end
        end)
    else
        if flyBv then flyBv:Destroy() end 
        if flyBg then flyBg:Destroy() end
        if char:FindFirstChildOfClass("Humanoid") then 
            char:FindFirstChildOfClass("Humanoid").PlatformStand = false 
        end
    end
end

-- 2. מעבר קירות (Noclip) & אכיפת מהירות/קפיצה
RunService.Stepped:Connect(function()
    if _G.Noclip_Enabled and playerObj.Character then
        for _, p in ipairs(playerObj.Character:GetDescendants()) do 
            if p:IsA("BasePart") then p.CanCollide = false end 
        end
    end
    -- מוודא שהערכים של הסליידרים נשארים בתוקף ולא מתאפסים ע"י המשחק
    if playerObj.Character and playerObj.Character:FindFirstChildOfClass("Humanoid") then
        local hum = playerObj.Character:FindFirstChildOfClass("Humanoid")
        hum.WalkSpeed = shared.walkSpeedValue
        if hum.UseJumpPower then
            hum.JumpPower = shared.jumpPowerValue
        else
            hum.JumpHeight = (shared.jumpPowerValue * 0.144) -- המרה גנרית ל-Height אם המשחק לא משתמש ב-Power
        end
    end
end)

function PlayerMod.toggleNoclip(state)
    _G.Noclip_Enabled = state
end

-- 3. קפיצה אינסופית
function PlayerMod.toggleInfJump(state)
    _G.InfJump_Enabled = state
end

UserInputService.JumpRequest:Connect(function()
    if _G.InfJump_Enabled and playerObj.Character and playerObj.Character:FindFirstChildOfClass("Humanoid") then
        playerObj.Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

-- 4. מצב אלוהים (God Mode בסיסי ומקומי)
function PlayerMod.toggleGodMode(state)
    _G.GodMode_Enabled = state
end

RunService.Heartbeat:Connect(function()
    if _G.GodMode_Enabled and playerObj.Character and playerObj.Character:FindFirstChildOfClass("Humanoid") then
        local hum = playerObj.Character:FindFirstChildOfClass("Humanoid")
        hum.MaxHealth = math.huge
        hum.Health = math.huge
    end
end)

-- 5. שחקן בלתי נראה (Invisible במצב שרת מקומי)
local invisClone
function PlayerMod.toggleInvisible(state)
    local char = playerObj.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    
    if state then
        char.Archivable = true 
        invisClone = char:Clone() 
        invisClone.Parent = workspace
        
        for _, p in ipairs(invisClone:GetDescendants()) do 
            if p:IsA("BasePart") then p.Transparency = 0.4 p.CanCollide = false end 
        end
        
        camera.CameraSubject = invisClone:FindFirstChildOfClass("Humanoid")
        
        for _, p in ipairs(char:GetDescendants()) do 
            if p:IsA("BasePart") then p.Transparency = 1 p.CanCollide = false 
            elseif p:IsA("Decal") then p.Transparency = 1 end 
        end
        
        task.spawn(function()
            while invisClone and char and char:FindFirstChild("HumanoidRootPart") do
                if invisClone:FindFirstChild("HumanoidRootPart") then
                    char.HumanoidRootPart.CFrame = invisClone.HumanoidRootPart.CFrame * CFrame.new(0, -25, 0)
                    invisClone:FindFirstChildOfClass("Humanoid"):Move(char:FindFirstChildOfClass("Humanoid").MoveDirection, false)
                end
                task.wait()
            end
        end)
    else
        if invisClone then 
            char.HumanoidRootPart.CFrame = invisClone.HumanoidRootPart.CFrame 
            invisClone:Destroy() 
            invisClone = nil 
        end
        camera.CameraSubject = char:FindFirstChildOfClass("Humanoid")
        for _, p in ipairs(char:GetDescendants()) do 
            if p:IsA("BasePart") then p.Transparency = 0 p.CanCollide = true 
            elseif p:IsA("Decal") then p.Transparency = 0 end 
        end
    end
end

return PlayerMod
