local TeleportMod = {}

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")

local lp = Players.LocalPlayer
local ctrlClickEnabled = false
local targetConnection = nil

-- האזנה למקש העכבר (פועל פעם אחת ברקע)
UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if ctrlClickEnabled and input.UserInputType == Enum.UserInputType.MouseButton1 then
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
            local mouse = lp:GetMouse()
            if mouse.Hit then 
                lp.Character:FindFirstChild("HumanoidRootPart").CFrame = CFrame.new(mouse.Hit.Position + Vector3.new(0, 3, 0)) 
            end
        end
    end
end)

-- פונקציות לוגיקה
function TeleportMod.toggleCtrlClick(state) ctrlClickEnabled = state end

function TeleportMod.manageTargeter(state, targetName)
    if not state then
        if targetConnection then targetConnection:Disconnect(); targetConnection = nil end
        return false
    end
    
    local tPlayer = Players:FindFirstChild(targetName)
    if tPlayer and tPlayer.Character and tPlayer.Character:FindFirstChild("HumanoidRootPart") then
        targetConnection = RunService.Heartbeat:Connect(function()
            if tPlayer.Character and tPlayer.Character:FindFirstChild("HumanoidRootPart") and lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
                lp.Character.HumanoidRootPart.CFrame = tPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
            end
        end)
        return true
    end
    return false
end

function TeleportMod.serverHop()
    local req = syn and syn.request or http and http.request or http_request or request
    if req then
        local success, res = pcall(function()
            return req({Url = "https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100"})
        end)
        if success and res.Body then
            local body = HttpService:JSONDecode(res.Body)
            if body and body.data then
                for _, v in ipairs(body.data) do
                    if v.playing < v.maxPlayers and v.id ~= game.JobId then 
                        TeleportService:TeleportToPlaceInstance(game.PlaceId, v.id, lp)
                        return
                    end
                end
            end
        end
    end
    TeleportService:Teleport(game.PlaceId, lp)
end

function TeleportMod.rejoin() TeleportService:Teleport(game.PlaceId, lp) end

-- בניית ה-UI בתוך המערכת
function TeleportMod.init(tab, Elements, UIReferences, Localization, safeCall)
    tab:ClearAllChildren()
    local scroll = Instance.new("ScrollingFrame", tab)
    scroll.Size = UDim2.new(1, 0, 1, 0); scroll.BackgroundTransparency = 1; scroll.CanvasSize = UDim2.new(0, 0, 0, 400)
    
    local layout = Instance.new("UIListLayout", scroll); layout.Padding = UDim.new(0, 10); layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

    -- כפתורי פעולה
    Elements.createToggleButton(scroll, "Ctrl + Click TP", ctrlClickEnabled, function(s) TeleportMod.toggleCtrlClick(s) end)
    
    -- Targeter UI
    local targetInput = Instance.new("TextBox", scroll); targetInput.Size = UDim2.new(0.9, 0, 0, 35); targetInput.PlaceholderText = "Target Username"; targetInput.BackgroundColor3 = Color3.fromRGB(35, 35, 45); targetInput.TextColor3 = Color3.new(1,1,1)
    Elements.addCorner(targetInput, UDim.new(0, 5))
    
    Elements.createToggleButton(scroll, "Targeter", false, function(s) 
        TeleportMod.manageTargeter(s, targetInput.Text)
    end)

    -- כפתורי שרת
    local hopBtn = Instance.new("TextButton", scroll); hopBtn.Size = UDim2.new(0.9, 0, 0, 40); hopBtn.Text = "Server Hop"; hopBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60); hopBtn.TextColor3 = Color3.new(1,1,1)
    Elements.addCorner(hopBtn, UDim.new(0, 5)); hopBtn.MouseButton1Click:Connect(function() TeleportMod.serverHop() end)

    local reBtn = Instance.new("TextButton", scroll); reBtn.Size = UDim2.new(0.9, 0, 0, 40); reBtn.Text = "Rejoin"; reBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60); reBtn.TextColor3 = Color3.new(1,1,1)
    Elements.addCorner(reBtn, UDim.new(0, 5)); reBtn.MouseButton1Click:Connect(function() TeleportMod.rejoin() end)
end

return TeleportMod
