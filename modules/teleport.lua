local TeleportMod = {}

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")

local lp = Players.LocalPlayer
local ctrlClickEnabled = false
local targetConnection = nil

-- 1. פונקציית Ctrl+Click (מאזין מופעל פעם אחת)
function TeleportMod.toggleCtrlClick(state)
    ctrlClickEnabled = state
end

-- האזנה למקש העכבר (פועל תמיד ברקע)
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

-- 2. מנגנון מעקב צמוד (Targeter)
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

-- 3. מעבר שרת (Server Hop)
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

-- 4. התחברות מחדש (Rejoin)
function TeleportMod.rejoin()
    TeleportService:Teleport(game.PlaceId, lp)
end

-- בניית ממשק המשתמש (UI)
function TeleportMod.init(tab, Elements, UIReferences, Localization, safeCall)
    local scroll = Instance.new("ScrollingFrame", tab)
    scroll.Size = UDim2.new(1, 0, 1, 0); scroll.BackgroundTransparency = 1; scroll.CanvasSize = UDim2.new(0, 0, 0, 300)
    Instance.new("UIListLayout", scroll).Padding = UDim.new(0, 10)

    -- כפתורי פעולה
    Elements.createToggleButton(scroll, "Ctrl + Click TP", false, function(s) TeleportMod.toggleCtrlClick(s) end)
    
    local hopBtn = Instance.new("TextButton", scroll)
    hopBtn.Size = UDim2.new(0.9, 0, 0, 40); hopBtn.Text = "Server Hop"; hopBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    Elements.addCorner(hopBtn, UDim.new(0, 5))
    hopBtn.MouseButton1Click:Connect(function() TeleportMod.serverHop() end)

    local reBtn = Instance.new("TextButton", scroll)
    reBtn.Size = UDim2.new(0.9, 0, 0, 40); reBtn.Text = "Rejoin"; reBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    Elements.addCorner(reBtn, UDim.new(0, 5))
    reBtn.MouseButton1Click:Connect(function() TeleportMod.rejoin() end)
end

return TeleportMod
