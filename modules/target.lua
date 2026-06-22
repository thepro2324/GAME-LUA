-- modules/target.lua
local TargetMod = {}
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local localPlayer = Players.LocalPlayer
local camera = workspace.CurrentCamera

-- משתנים גלובליים משותפים
shared.aimbotFOV = shared.aimbotFOV or 90
shared.selectedTargetName = shared.selectedTargetName or ""

local killAuraLoop, silentAimLoop, tpLoop, spectateLoop, flingLoop
local lockedTarget = nil

-- פונקציה לבחירת שחקן לפי השם שהוקלד ב-TextBox
function TargetMod.setTargetByName(name)
    shared.selectedTargetName = name
    if name == "" then
        lockedTarget = nil
        print("🎯 [Ori Dev] המטרה הוסרה. חוזר למצב אוטומטי.")
        return
    end

    -- חיפוש שחקן לפי שם מלא או חלקי
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= localPlayer and (player.Name:lower():sub(1, #name) == name:lower() or player.DisplayName:lower():sub(1, #name) == name:lower()) then
            lockedTarget = player
            print("🎯 [Ori Dev] מטרה נעולה על: " .. player.Name)
            return
        end
    end
    
    lockedTarget = nil
    print("❌ [Ori Dev] לא נמצא שחקן בשם: " .. name)
end

-- פונקציית עזר לקבלת המטרה הנוכחית (השחקן שנעלנו עליו, או הכי קרוב לעכבר אם אין נעילה)
local function getActiveTarget()
    if lockedTarget and lockedTarget.Character and lockedTarget.Character:FindFirstChild("HumanoidRootPart") and lockedTarget.Character:FindFirstChildOfClass("Humanoid") and lockedTarget.Character:FindFirstChildOfClass("Humanoid").Health > 0 then
        return lockedTarget
    end
    
    -- אם אין שחקן נעול ב-TextBox, מחפש את הכי קרוב לעכבר כגיבוי
    local closestPlayer = nil
    local shortestDistance = math.huge
    local mousePos = UserInputService:GetMouseLocation()

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= localPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChildOfClass("Humanoid") and player.Character:FindFirstChildOfClass("Humanoid").Health > 0 then
            local pos, onScreen = camera:WorldToViewportPoint(player.Character.HumanoidRootPart.Position)
            if onScreen then
                local distance = (Vector3.new(pos.X, pos.Y, 0) - Vector3.new(mousePos.X, mousePos.Y, 0)).Magnitude
                if distance < shortestDistance and distance <= shared.aimbotFOV then
                    shortestDistance = distance
                    closestPlayer = player
                end
            end
        end
    end
    return closestPlayer
end

-- 1. כפתור KILL AURA
function TargetMod.toggleKillAura(state)
    if killAuraLoop then killAuraLoop:Disconnect() killAuraLoop = nil end
    if state then
        killAuraLoop = RunService.Heartbeat:Connect(function()
            local target = getActiveTarget()
            if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") and localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart") then
                local distance = (localPlayer.Character.HumanoidRootPart.Position - target.Character.HumanoidRootPart.Position).Magnitude
                if distance <= 15 then
                    local tool = localPlayer.Character:FindFirstChildOfClass("Tool")
                    if tool then tool:Activate() end
                end
            end
        end)
    end
end

-- 2. כפתור SILENT AIM
function TargetMod.toggleSilentAim(state)
    if silentAimLoop then silentAimLoop:Disconnect() silentAimLoop = nil end
    if state then
        silentAimLoop = RunService.RenderStepped:Connect(function()
            local target = getActiveTarget()
            if target and target.Character and target.Character:FindFirstChild("Head") then
                camera.CFrame = CFrame.new(camera.CFrame.Position, target.Character.Head.Position)
            end
        end)
    end
end

-- 3. כפתור TELEPORT TO TARGET (משתגר ישירות אל היעד שננעל ב-TextBox)
function TargetMod.toggleTPToTarget(state)
    if tpLoop then tpLoop:Disconnect() tpLoop = nil end
    if state then
        tpLoop = RunService.Heartbeat:Connect(function()
            local target = getActiveTarget()
            if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") and localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart") then
                localPlayer.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
            end
        end)
    end
end

-- 4. כפתור LOOP KILL TARGET / FLING
function TargetMod.toggleLoopKill(state)
    if flingLoop then flingLoop:Disconnect() flingLoop = nil end
    if state then
        flingLoop = RunService.Heartbeat:Connect(function()
            local target = getActiveTarget()
            if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                if localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    local bV = Instance.new("BodyAngularVelocity")
                    bV.AngularVelocity = Vector3.new(0, 99999, 0)
                    bV.MaxTorque = Vector3.new(0, math.huge, 0)
                    bV.Parent = localPlayer.Character.HumanoidRootPart
                    localPlayer.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame
                    task.wait(0.1)
                    bV:Destroy()
                end
            end
        end)
    end
end

-- 5. כפתור SPECTATE TARGET (עוקב עם המצלמה אחרי השחקן שרשמת)
function TargetMod.toggleSpectate(state)
    if spectateLoop then spectateLoop:Disconnect() spectateLoop = nil end
    if state then
        spectateLoop = RunService.RenderStepped:Connect(function()
            local target = getActiveTarget()
            if target and target.Character and target.Character:FindFirstChildOfClass("Humanoid") then
                camera.CameraSubject = target.Character:FindFirstChildOfClass("Humanoid")
            end
        end)
    else
        if localPlayer.Character and localPlayer.Character:FindFirstChildOfClass("Humanoid") then
            camera.CameraSubject = localPlayer.Character:FindFirstChildOfClass("Humanoid")
        end
    end
end

-- 6. כפתור FLING TARGET
function TargetMod.toggleFling(state)
    TargetMod.toggleLoopKill(state)
end

return TargetMod
