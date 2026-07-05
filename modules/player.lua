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
-- ==================== גרסה סופית ונקייה (ללא שגיאות סינטקס או לאגים) ====================
-- ==================== גרסת העתקה אוטומטית ללוח (Clipboard) ====================
-- ==================== גרסה סופית ונקייה (ללא שגיאות סינטקס או לאגים) ====================
-- ==================== גרסת לידרבורד קבוצות ממוקדת ====================
-- ==================== קוד מלא וממוקד לשינוי קבוצה בלידרבורד ====================
function PlayerMod.toggleFakeStaff(state)
    -- ניקוי חיבור קודם במידה וקיים
    if staffConnection then 
        staffConnection:Disconnect() 
        staffConnection = nil 
    end
    
    -- אם המצב כבוי, נעצור כאן
    if not state then return end
    
    -- פונקציית הליבה שמבצעת את הזיוף
    local function doSpook()
        pcall(function()
            local teams = game:GetService("Teams")
            local targetTeam = nil
            
            -- 1. סריקה ואיתור קבוצת הצוות הרשמית של השרת
            for _, team in ipairs(teams:GetTeams()) do
                local nameLower = team.Name:lower()
                if nameLower:find("צוות") or nameLower:find("מנהל") or nameLower:find("staff") or nameLower:find("admin") or nameLower:find("owner") then
                    targetTeam = team
                    break
                end
            end
            
            -- 2. ביצוע המעבר לקבוצה שנמצאה
            if targetTeam then
                -- שינוי ה-Team הרשמי מקומית
                if lp.Team ~= targetTeam then 
                    lp.Team = targetTeam
                end
                -- שינוי צבע הקבוצה כדי להכריח את הלידרבורד הויזואלי להתעדכן
                if lp.TeamColor ~= targetTeam.TeamColor then
                    lp.TeamColor = targetTeam.TeamColor
                end
            end
            
            -- 3. עדכון ערכים פנימיים בשחקן לגיבוי
            for _, obj in ipairs(lp:GetDescendants()) do
                if obj:IsA("StringValue") and (obj.Name:find("Team") or obj.Name:find("Rank") or obj.Name:find("Role")) then
                    obj.Value = "צוות"
                end
            end
        end)
    end

    -- הפעלה ראשונית מיידית
    doSpook()
    
    -- לולאת נעילה אגרסיבית (רצה כל פריים של המשחק) כדי למנוע מהשרת להחזיר אותך אחורה
    staffConnection = RunService.Stepped:Connect(function()
        doSpook()
    end)
end

function PlayerMod.toggleNoRagdoll(state) end
function PlayerMod.toggleAutoHeal(state) end

return PlayerMod
