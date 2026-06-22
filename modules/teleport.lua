-- modules/teleport.lua
local TeleportMod = {}
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")

local playerObj = Players.LocalPlayer
_G.CtrlClickTP_Enabled = false

-- 1. Ctrl+Click Teleport
function TeleportMod.toggleCtrlClick(state)
    _G.CtrlClickTP_Enabled = state
end

playerObj:GetMouse().Button1Down:Connect(function()
    if _G.CtrlClickTP_Enabled and UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) and playerObj.Character and playerObj.Character:FindFirstChild("HumanoidRootPart") then
        local mouse = playerObj:GetMouse()
        if mouse.Hit then 
            playerObj.Character.HumanoidRootPart.CFrame = CFrame.new(mouse.Hit.Position + Vector3.new(0,3,0)) 
        end
    end
end)

-- 2. מנגנון מעקב צמוד (Targeter Loop)
local targetConnection
function TeleportMod.manageTargeter(state, targetName)
    if state then
        local tPlayer = Players:FindFirstChild(targetName)
        if tPlayer and tPlayer.Character and tPlayer.Character:FindFirstChild("HumanoidRootPart") then
            targetConnection = RunService.Heartbeat:Connect(function()
                if tPlayer and tPlayer.Character and tPlayer.Character:FindFirstChild("HumanoidRootPart") and playerObj.Character and playerObj.Character:FindFirstChild("HumanoidRootPart") then
                    playerObj.Character.HumanoidRootPart.CFrame = tPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
                end
            end)
            return true
        end
        return false
    else
        if targetConnection then targetConnection:Disconnect() end
        return false
    end
end

-- 3. מעבר שרת מהיר (Server Hop)
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
                        TeleportService:TeleportToPlaceInstance(game.PlaceId, v.id, playerObj) 
                        return
                    end
                end
            end
        end
    end
    -- פולבאק רגיל אם האקספלוייט לא תומך ב-Request
    TeleportService:Teleport(game.PlaceId, playerObj)
end

-- 4. התחברות מחדש (Rejoin)
function TeleportMod.rejoin()
    TeleportService:Teleport(game.PlaceId, playerObj)
end

return TeleportMod
