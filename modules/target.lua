local TargetMod = {}
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

TargetMod.isTeleporting = false
TargetMod.targetPlayer = nil
TargetMod.targetConnection = nil

-- לוגיקה
function TargetMod.stopTargeting()
    TargetMod.isTeleporting = false
    if TargetMod.targetConnection then 
        TargetMod.targetConnection:Disconnect() 
        TargetMod.targetConnection = nil 
    end
    
    local localChar = Players.LocalPlayer.Character
    if localChar then
        local localRootPart = localChar:FindFirstChild("HumanoidRootPart")
        local humanoid = localChar:FindFirstChildOfClass("Humanoid")
        if localRootPart then
            localRootPart.Anchored = true
            if humanoid then humanoid:ChangeState(Enum.HumanoidStateType.Running) end
            task.wait(0.05)
            localRootPart.Anchored = false
        end
    end
end

function TargetMod.startTargeting(targetName)
    local found = nil
    for _, p in ipairs(Players:GetPlayers()) do
        if p.Name:lower():find(targetName:lower()) and p ~= Players.LocalPlayer then
            found = p
            break
        end
    end
    
    if not found then return false end
    
    TargetMod.targetPlayer = found
    TargetMod.isTeleporting = true
    
    TargetMod.targetConnection = RunService.Heartbeat:Connect(function()
        if not TargetMod.isTeleporting or not TargetMod.targetPlayer or not TargetMod.targetPlayer.Parent then
            TargetMod.stopTargeting()
            return
        end
        
        local localChar = Players.LocalPlayer.Character
        local targetChar = TargetMod.targetPlayer.Character
        if localChar and targetChar then
            local targetRootPart = targetChar:FindFirstChild("HumanoidRootPart")
            local localRootPart = localChar:FindFirstChild("HumanoidRootPart")
            if targetRootPart and localRootPart then
                localRootPart.CFrame = targetRootPart.CFrame * CFrame.new(0, 0, 3.5)
            end
        end
    end)
    return true
end

-- בניית ה-UI (עם Layout מסודר)
function TargetMod.init(tab, Elements, UIReferences, Localization, safeCall)
    tab:ClearAllChildren()
    
    local layout = Instance.new("UIListLayout", tab)
    layout.Padding = UDim.new(0, 10)
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    layout.PaddingTop = UDim.new(0, 10)

    local textBox = Instance.new("TextBox", tab)
    textBox.Size = UDim2.new(0.9, 0, 0, 35)
    textBox.PlaceholderText = Localization.HE.Placeholder
    textBox.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    textBox.TextColor3 = Color3.new(1, 1, 1)
    Elements.addCorner(textBox, UDim.new(0, 6))
    Elements.addStroke(textBox, Color3.fromRGB(45, 45, 55), 1)

    local startButton = Instance.new("TextButton", tab)
    startButton.Size = UDim2.new(0.9, 0, 0, 40)
    startButton.Text = Localization.HE.StartTarget
    startButton.BackgroundColor3 = Color3.fromRGB(30, 130, 40)
    startButton.TextColor3 = Color3.new(1, 1, 1)
    startButton.Font = Enum.Font.GothamBold
    Elements.addCorner(startButton, UDim.new(0, 6))

    startButton.MouseButton1Click:Connect(function()
        if TargetMod.isTeleporting then
            TargetMod.stopTargeting()
            startButton.Text = Localization.HE.StartTarget
            startButton.BackgroundColor3 = Color3.fromRGB(30, 130, 40)
        else
            if TargetMod.startTargeting(textBox.Text) then
                startButton.Text = Localization.HE.StopTarget
                startButton.BackgroundColor3 = Color3.fromRGB(150, 40, 40)
            end
        end
    end)
end

return TargetMod
