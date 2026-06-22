-- modules/target.lua
local TargetMod = {}
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

TargetMod.isTeleporting = false
TargetMod.targetPlayer = nil
TargetMod.targetConnection = nil

-- פונקציה לעדכון רשימת החיפוש והתאמות השם
function TargetMod.getMatches(text)
    if text == "" then return {} end
    local matches = {}
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= Players.LocalPlayer and p.Name:lower():find(text:lower()) then
            table.insert(matches, p.Name)
        end
    end
    return matches
end

-- עצירת ה-Targeter והחזרת השחקן למצב רגיל
function TargetMod.stopTargeting(startButton)
    TargetMod.isTeleporting = false
    if TargetMod.targetConnection then 
        TargetMod.targetConnection:Disconnect() 
        TargetMod.targetConnection = nil 
    end
    
    if startButton then
        startButton.Text = "Start Targeter"
        startButton.BackgroundColor3 = Color3.new(0.1, 0.5, 0.1)
    end
    
    local localChar = Players.LocalPlayer.Character
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

-- הפעלת ה-Targeter בלולאת Heartbeat חלקה
function TargetMod.startTargeting(targetName, startButton, searchFrame)
    TargetMod.targetPlayer = Players:FindFirstChild(targetName)
    if not TargetMod.targetPlayer then
        for _, p in ipairs(Players:GetPlayers()) do
            if p.Name:lower():find(targetName:lower()) and p ~= Players.LocalPlayer then
                TargetMod.targetPlayer = p 
                break
            end
        end
    end
    
    if TargetMod.targetPlayer then
        TargetMod.isTeleporting = true
        if searchFrame then searchFrame.Visible = false end
        startButton.Text = "Stop Targeter"
        startButton.BackgroundColor3 = Color3.new(0.6, 0.1, 0.1)
        
        TargetMod.targetConnection = RunService.Heartbeat:Connect(function()
            if not TargetMod.isTeleporting or not TargetMod.targetPlayer or not Players:FindFirstChild(TargetMod.targetPlayer.Name) then
                TargetMod.stopTargeting(startButton) 
                return
            end
            
            local localChar = Players.LocalPlayer.Character
            local targetChar = TargetMod.targetPlayer.Character
            if localChar and targetChar then
                local targetRootPart = targetChar:FindFirstChild("HumanoidRootPart")
                local localRootPart = localChar:FindFirstChild("HumanoidRootPart")
                local humanoid = localChar:FindFirstChildOfClass("Humanoid")
                
                if targetRootPart and localRootPart then
                    localRootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                    localRootPart.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
                    if humanoid then humanoid:ChangeState(Enum.HumanoidStateType.Physics) end
                    
                    for _, myPart in ipairs(localChar:GetDescendants()) do
                        if myPart:IsA("BasePart") then myPart.CanCollide = false end
                    end
                    localRootPart.CFrame = targetRootPart.CFrame * CFrame.new(0, 0, 3.5)
                end
            end
        end)
    else
        startButton.Text = "Player Not Found"
        task.wait(1)
        if not TargetMod.isTeleporting then startButton.Text = "Start Targeter" end
    end
end

return TargetMod
