-- modules/target.lua
local TargetMod = {}
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local localPlayer = Players.LocalPlayer
local targetConnection = nil
local isTeleporting = false
local targetPlayer = nil

-- פונקציה שנקראת מה-TextBox כדי לעדכן מי השחקן הנבחר
function TargetMod.setTargetByName(name)
    if name == "" then
        targetPlayer = nil
        return
    end
    
    local found = game.Players:FindFirstChild(name)
    if not found then
        for _, p in ipairs(game.Players:GetPlayers()) do
            if p.Name:lower():find(name:lower()) and p ~= localPlayer then
                found = p 
                break
            end
        end
    end
    targetPlayer = found
end

-- הפעלה/כיבוי של ה-Targeter בדיוק כמו בקוד הישן שלך
function TargetMod.toggleTPToTarget(state)
    isTeleporting = state
    if targetConnection then targetConnection:Disconnect() targetConnection = nil end
    
    if isTeleporting then
        targetConnection = RunService.Heartbeat:Connect(function()
            if not isTeleporting or not targetPlayer or not game.Players:FindFirstChild(targetPlayer.Name) then
                if targetConnection then targetConnection:Disconnect() targetConnection = nil end
                isTeleporting = false
                return
            end
            
            local localChar = localPlayer.Character
            local targetChar = targetPlayer.Character
            if localChar and targetChar then
                local targetRootPart = targetChar:FindFirstChild("HumanoidRootPart")
                local localRootPart = localChar:FindFirstChild("HumanoidRootPart")
                local humanoid = localChar:FindFirstChildOfClass("Humanoid")
                
                if targetRootPart and localRootPart then
                    -- איפוס מהירויות ומעבר למצב פיזיקה למניעת רעידות (בדיוק מהקוד הישן)
                    localRootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                    localRootPart.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
                    if humanoid then humanoid:ChangeState(Enum.HumanoidStateType.Physics) end
                    
                    -- ביטול התנגשויות כדי לעבור דרך קירות אל השחקן
                    for _, myPart in ipairs(localChar:GetDescendants()) do
                        if myPart:IsA("BasePart") then myPart.CanCollide = false end
                    end
                    
                    -- מיקום מאחורי השחקן
                    localRootPart.CFrame = targetRootPart.CFrame * CFrame.new(0, 0, 3.5)
                end
            end
        end)
    else
        -- החזרת השחקן למצב רגיל כשהצ'יט כבוי
        local localChar = localPlayer.Character
        if localChar then
            local localRootPart = localChar:FindFirstChild("HumanoidRootPart")
            local humanoid = localChar:FindFirstChildOfClass("Humanoid")
            if localRootPart then
                localRootPart.Anchored = true
                localRootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                localRootPart.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
                if humanoid then humanoid:ChangeState(Enum.HumanoidStateType.Running) end
                task.wait(0.05)
                localRootPart.Anchored = false
            end
        end
    end
end

-- פונקציות גיבוי ריקות לשאר הכפתורים כדי שלא יגרמו לשגיאות
function TargetMod.toggleSilentAim(state) end
function TargetMod.toggleKillAura(state) end
function TargetMod.toggleLoopKill(state) end
function TargetMod.toggleSpectate(state) end
function TargetMod.toggleFling(state) end

return TargetMod
