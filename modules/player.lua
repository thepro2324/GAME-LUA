local PlayerMod = {}

local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local lp = Players.LocalPlayer
local cam = workspace.CurrentCamera

local flyConnection = nil
local bodyVelocity = nil
local bodyGyro = nil
local noclipConnection = nil
local infJumpConnection = nil
local autoResetConnection = nil
local staffConnection = nil

shared.walkSpeedValue = shared.walkSpeedValue or 16
shared.jumpPowerValue = shared.jumpPowerValue or 50

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
        local camera = workspace.CurrentCamera or workspace:FindFirstChildOfClass("Camera")
        if state then
            lp.CameraMaxZoomDistance = math.huge
            lp.CameraMinZoomDistance = 0
            if camera then
                camera.MaxCameraZoomDistance = math.huge
                camera.MinCameraZoomDistance = 0
            end
        else
            lp.CameraMaxZoomDistance = 128
            lp.CameraMinZoomDistance = 0.5
            if camera then
                camera.MaxCameraZoomDistance = 128
                camera.MinCameraZoomDistance = 0.5
            end
        end
    end)
end

lp.CharacterAdded:Connect(function(char)
    local hum = char:WaitForChild("Humanoid")
    task.wait(0.1)
    if shared.walkSpeedValue then hum.WalkSpeed = shared.walkSpeedValue end
    if shared.jumpPowerValue then 
        hum.UseJumpPower = true
        hum.JumpPower = shared.jumpPowerValue 
    end
    
    if shared.infiniteZoomActive then
        PlayerMod.toggleInfiniteZoom(true)
    end
    
    if shared.isFlying then
        task.wait(0.5)
        PlayerMod.toggleFly(true)
    end
end)

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
        local lookVector = cam.CFrame.LookVector
        local rightVector = cam.CFrame.RightVector
        local forward = Vector3.new(lookVector.X, 0, lookVector.Z).Unit
        local side = Vector3.new(rightVector.X, 0, rightVector.Z).Unit
        local moveDir = Vector3.new(0, 0, 0)
        
        if UIS:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + forward end
        if UIS:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - forward end
        if UIS:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + side end
        if UIS:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - side end
        if UIS:IsKeyDown(Enum.KeyCode.Space) then moveDir = moveDir + Vector3.new(0, 1, 0) end
        if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then moveDir = moveDir - Vector3.new(0, 1, 0) end
        
        bodyGyro.CFrame = CFrame.new(hrp.Position, hrp.Position + Vector3.new(lookVector.X, 0, lookVector.Z))
        local speed = shared.flySpeed or 100
        if moveDir.Magnitude > 0 then
            bodyVelocity.Velocity = moveDir.Unit * speed
        else
            bodyVelocity.Velocity = Vector3.new(0, 0, 0)
        end
    end)
end

function PlayerMod.toggleInfJump(state)
    if infJumpConnection then infJumpConnection:Disconnect() infJumpConnection = nil end
    if state then
        infJumpConnection = UIS.JumpRequest:Connect(function()
            local char = lp.Character
            if char then
                local hum = char:FindFirstChildOfClass("Humanoid")
                if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
            end
        end)
    end
end

function PlayerMod.toggleNoclip(state)
    if noclipConnection then noclipConnection:Disconnect() noclipConnection = nil end
    if state then
        noclipConnection = RunService.Stepped:Connect(function()
            local char = lp.Character
            if char then
                for _, part in ipairs(char:GetChildren()) do
                    if part:IsA("BasePart") then part.CanCollide = false end
                end
            end
        end)
    end
end

function PlayerMod.toggleAutoReset(state)
    if autoResetConnection then autoResetConnection:Disconnect() autoResetConnection = nil end
    if state then
        local char = lp.Character or lp.CharacterAdded:Wait()
        local hum = char:WaitForChild("Humanoid")
        autoResetConnection = hum.HealthChanged:Connect(function(health)
            if health > 0 and health <= 15 then hum.Health = 0 end
        end)
    end
end

function PlayerMod.toggleAntiAFK(state)
    if state then
        local virtualUser = game:GetService("VirtualUser")
        lp.Idled:Connect(function()
            virtualUser:CaptureController()
            virtualUser:ClickButton2(Vector2.new(0,0))
        end)
    end
end

function PlayerMod.toggleGodMode(state)
    local char = lp.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.MaxHealth = state and math.huge or 100
            hum.Health = state and math.huge or 100
        end
    end
end

function PlayerMod.toggleInvisible(state)
    local char = lp.Character
    if char then
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") or part:IsA("Decal") then
                if part.Name ~= "HumanoidRootPart" then part.Transparency = state and 1 or 0 end
            end
        end
    end
end

-- ==================== גרסה סופית ונקייה (ללא שגיאות סינטקס או לאגים) ====================
-- ==================== גרסה חלקה וחסכונית לזיוף צוות (0% לאגים - גרסה סופית) ====================
function PlayerMod.toggleFakeStaff(state)
    if staffConnection then staffConnection:Disconnect() staffConnection = nil end
    if not state then return end
    
    local function doSpook()
        pcall(function()
            -- 1. שינוי ה-Team הרשמי מקומית
            local teams = game:GetService("Teams")
            for _, team in ipairs(teams:GetTeams()) do
                local nameLower = team.Name:lower()
                if nameLower:find("צוות") or nameLower:find("מנהל") or nameLower:find("staff") or nameLower:find("admin") then
                    if lp.Team ~= team then lp.Team = team end
                    break
                end
            end
            
            -- 2. שינוי ויזואלי של הלידרבורד המותאם אישית (Custom UI)
            local playerGui = lp:FindFirstChild("PlayerGui")
            if playerGui then
                local myRow = nil
                for _, obj in ipairs(playerGui:GetDescendants()) do
                    if obj:IsA("Frame") and (obj.Name == lp.Name or obj.Name == tostring(lp.UserId) or obj:FindFirstChild(lp.Name)) then
                        myRow = obj
                        break
                    end
                end
                
                if myRow then
                    local targetContainer = nil
                    for _, obj in ipairs(playerGui:GetDescendants()) do
                        local nameLower = obj.Name:lower()
                        local textLower = (obj:IsA("TextLabel") or obj:IsA("TextButton")) and obj.Text:lower() or ""
                        
                        if nameLower:find("צוות") or textLower:find("צוות") or nameLower:find("staff") or textLower:find("staff") or nameLower:find("מנהל") or textLower:find("מנהל") then
                            if obj:IsA("Frame") or obj:IsA("ScrollingFrame") then
                                targetContainer = obj
                            elseif obj.Parent and (obj.Parent:IsA("Frame") or obj.Parent:IsA("ScrollingFrame") or obj.Parent:FindFirstChildOfClass("UIListLayout")) then
                                targetContainer = obj.Parent
                            end
                            if targetContainer then break end
                        end
                    end
                    
                    if targetContainer and myRow.Parent ~= targetContainer then
                        myRow.Parent = targetContainer
                        if myRow:IsA("Frame") or myRow:IsA("GuiObject") then
                            myRow.LayoutOrder = -100
                        end
                    end
                end
            end
        end)
    end

    -- הפעלה ראשונה מיידית
    doSpook()
    
    -- לולאת בדיקה אופטימלית פעם ב-1.5 שניות למניעת לאגים
    staffConnection = RunService.Stepped:Connect(function()
        local now = os.clock()
        if not shared.lastStaffUpdate or (now - shared.lastStaffUpdate) >= 1.5 then
            shared.lastStaffUpdate = now
            doSpook()
        end
    end)

    -- 3. סורק דיאגנוסטיקה אוטומטי - רץ במקביל פעם אחת בלבד
    task.spawn(function()
        pcall(function()
            local playerGui = lp:FindFirstChild("PlayerGui")
            if playerGui then
                print("--- 🔍 מתחיל סריקת לידרבורד של המשחק ---")
                for _, v in ipairs(playerGui:GetDescendants()) do
                    if v:IsA("TextLabel") and (v.Text:find("צוות") or v.Text:find("מנהל") or v.Text:find("שחקנים")) then
                        print("Found Label: " .. v:GetFullName() .. " | Text: " .. v.Text)
                        if v.Parent then
                            print("   Parent container name: " .. v.Parent.Name .. " (" .. v.Parent.ClassName .. ")")
                        end
                    end
                end
                print("--- 🔍 סיום סריקת לידרבורד ---")
            end
        end)
    end)
end

function PlayerMod.toggleNoRagdoll(state) end
function PlayerMod.toggleAutoHeal(state) end

return PlayerMod
