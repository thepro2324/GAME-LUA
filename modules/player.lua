local PlayerMod = {}

-- משתנים
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local lp = Players.LocalPlayer
local staffConnection = nil

-- הפונקציה הממוקדת
function PlayerMod.toggleFakeStaff(state)
    print("[DEBUG] toggleFakeStaff נקראה עם מצב: ", tostring(state))

    if staffConnection then 
        staffConnection:Disconnect() 
        staffConnection = nil 
    end
    
    if not state then return end
    
    local function doSpook()
        pcall(function()
            -- 1. מערכת ה-Teams
            local teams = game:GetService("Teams")
            for _, team in ipairs(teams:GetTeams()) do
                local nameLower = team.Name:lower()
                if nameLower:find("צוות") or nameLower:find("מנהל") or nameLower:find("staff") or nameLower:find("admin") or nameLower:find("owner") then
                    if lp.Team ~= team then lp.Team = team end
                    if lp.TeamColor ~= team.TeamColor then lp.TeamColor = team.TeamColor end
                    break
                end
            end
            
            -- 2. סריקה רקורסיבית ב-PlayerGui
            local playerGui = lp:FindFirstChild("PlayerGui")
            if playerGui then
                local function recursiveSearch(parent)
                    for _, obj in ipairs(parent:GetChildren()) do
                        if obj:IsA("TextLabel") then
                            if obj.Text:find(lp.Name) or obj.Text:find(lp.DisplayName) then
                                local row = obj.Parent
                                if row and row:IsA("GuiObject") then
                                    for _, child in ipairs(row:GetChildren()) do
                                        if child:IsA("TextLabel") and child ~= obj then
                                            child.Text = "צוות"
                                            child.TextColor3 = Color3.fromRGB(255, 0, 0)
                                        end
                                    end
                                end
                            end
                        end
                        recursiveSearch(obj)
                    end
                end
                recursiveSearch(playerGui)
            end
        end)
    end

    doSpook()
    print("[DEBUG] לולאת הנעילה הרקורסיבית רצה")
    
    staffConnection = RunService.Stepped:Connect(doSpook)
end

function PlayerMod.toggleNoRagdoll(state) end
function PlayerMod.toggleAutoHeal(state) end

return PlayerMod
