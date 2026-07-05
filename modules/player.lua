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

-- ==================== פונקציית FakeStaff עם סריקה ושינוי ממוקד שחקן ====================
function PlayerMod.toggleFakeStaff(state)
    print("[DEBUG] toggleFakeStaff נקראה עם מצב: ", tostring(state))

    if staffConnection then 
        staffConnection:Disconnect() 
        staffConnection = nil 
    end
    
    if not state then return end
    
    local function doSpook()
        pcall(function()
            -- 1. שינוי דרך מערכת ה-Teams הרגילה (לגיבוי)
            local teams = game:GetService("Teams")
            for _, team in ipairs(teams:GetTeams()) do
                local nameLower = team.Name:lower()
                if nameLower:find("צוות") or nameLower:find("מנהל") or nameLower:find("staff") or nameLower:find("admin") or nameLower:find("owner") then
                    if lp.Team ~= team then lp.Team = team end
                    if lp.TeamColor ~= team.TeamColor then lp.TeamColor = team.TeamColor end
                    break
                end
            end
            
            -- 2. תקיפה ממוקדת ובטוחה של מערכת ה-TagSystemGui
            local playerGui = lp:FindFirstChild("PlayerGui")
            if playerGui then
                local tagGui = playerGui:FindFirstChild("TagSystemGui")
                if tagGui then
                    -- אנחנו מחפשים אלמנט שקשור ספציפית אלייך (לפי השם או ה-DisplayName)
                    for _, desc in ipairs(tagGui:GetDescendants()) do
                        -- בדיקה אם מדובר בטקסט שמציג את השם שלך במשחק
                        if desc:IsA("TextLabel") and (desc.Text == lp.Name or desc.Text == lp.DisplayName or desc.Text:find(lp.Name)) then
                            -- מצאנו את השורה שלך! עכשיו נחפש את ה-TextLabel של התגית באותו ה-Frame
                            local parentFrame = desc.Parent
                            if parentFrame then
                                -- נחפש רכיבי טקסט פנימיים באותו הבלוק כדי לשנות רק אותם ל"צוות"
                                for _, child in ipairs(parentFrame:GetChildren()) do
                                    if child:IsA("TextLabel") and child ~= desc then
                                        child.Text = "צוות"
                                        child.TextColor3 = Color3.fromRGB(255, 0, 0) -- אדום של מנהלים
                                    end
                                end
                            end
                        end
                    end
                end
                
                -- 3. סריקה ושינוי ממוקד של הלידרבורד הויזואלי הראשי
                local coreLeaderboard = playerGui:FindFirstChild("Leaderboard") or playerGui:FindFirstChild("PlayerList") or playerGui:FindFirstChild("Menus")
                if coreLeaderboard then
                    for _, desc in ipairs(coreLeaderboard:GetDescendants()) do
                        -- איתור השם שלך בתוך הלידרבורד
                        if desc:IsA("TextLabel") and (desc.Text == lp.Name or desc.Text == lp.DisplayName) then
                            local parentFrame = desc.Parent
                            if parentFrame then
                                -- חיפוש תווית הדרגה/סטטוס (כמו שחקן/טאג) שצמודה לשם שלך
                                local roleLabel = parentFrame:FindFirstChild("Role") or parentFrame:FindFirstChild("Rank") or parentFrame:FindFirstChild("Tag") or parentFrame:FindFirstChild("Status")
                                
                                if roleLabel and roleLabel:IsA("TextLabel") then
                                    roleLabel.Text = "צוות"
                                    roleLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
                                else
                                    -- גיבוי: אם אין שם ברור לדרגה, נחפש כל TextLabel אחר בתוך ה-Frame שאינו השם שלך
                                    for _, child in ipairs(parentFrame:GetChildren()) do
                                        if child:IsA("TextLabel") and child ~= desc and not child.Text:find(lp.Name) then
                                            child.Text = "צוות"
                                            child.TextColor3 = Color3.fromRGB(255, 0, 0)
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end)
    end

    doSpook()
    print("[DEBUG] לולאת הנעילה הממוקדת עובדת")
    
    staffConnection = RunService.Stepped:Connect(function()
        doSpook()
    end)
end

function PlayerMod.toggleNoRagdoll(state) end
function PlayerMod.toggleAutoHeal(state) end

return PlayerMod
