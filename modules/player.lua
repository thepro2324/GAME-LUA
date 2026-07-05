local PlayerMod = {}

local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local lp = Players.LocalPlayer
local staffConnection = nil

function PlayerMod.toggleFakeStaff(state)
    print("[DEBUG] toggleFakeStaff מופעלת: ", tostring(state))

    -- ניקוי לולאה קודמת
    if staffConnection then 
        staffConnection:Disconnect() 
        staffConnection = nil 
    end
    
    if not state then return end
    
    local function doSpook()
        pcall(function()
            -- 1. שינוי קבוצה (Teams)
            local teams = game:GetService("Teams")
            for _, team in ipairs(teams:GetTeams()) do
                local nameLower = team.Name:lower()
                if nameLower:find("צוות") or nameLower:find("מנהל") or nameLower:find("staff") or nameLower:find("admin") or nameLower:find("owner") then
                    if lp.Team ~= team then lp.Team = team end
                    if lp.TeamColor ~= team.TeamColor then lp.TeamColor = team.TeamColor end
                    break
                end
            end
            
            -- 2. סריקה ב-PlayerGui (לידרבורד ופאנלים)
            local playerGui = lp:FindFirstChild("PlayerGui")
            if playerGui then
                local function searchGui(parent)
                    for _, obj in ipairs(parent:GetDescendants()) do
                        if obj:IsA("TextLabel") then
                            if obj.Text:find(lp.Name) or obj.Text:find(lp.DisplayName) then
                                local parentObj = obj.Parent
                                if parentObj and parentObj:IsA("GuiObject") then
                                    for _, child in ipairs(parentObj:GetChildren()) do
                                        if child:IsA("TextLabel") and child ~= obj then
                                            child.Text = "צוות"
                                            child.TextColor3 = Color3.fromRGB(255, 0, 0)
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
                searchGui(playerGui)
            end

            -- 3. סריקה ב-Character (תגיות מעל הראש - BillboardGui)
            local char = lp.Character
            if char then
                for _, descendant in ipairs(char:GetDescendants()) do
                    if descendant:IsA("BillboardGui") or descendant:IsA("SurfaceGui") then
                        for _, textObj in ipairs(descendant:GetDescendants()) do
                            if textObj:IsA("TextLabel") then
                                if textObj.Text:find(lp.Name) or textObj.Text:find("Member") or textObj.Text:find("Player") then
                                    textObj.Text = "צוות"
                                    textObj.TextColor3 = Color3.fromRGB(255, 0, 0)
                                end
                            end
                        end
                    end
                end
            end
        end)
    end

    -- הרצה מיידית + לולאה
    doSpook()
    staffConnection = RunService.Stepped:Connect(doSpook)
end

function PlayerMod.toggleNoRagdoll(state) 
    -- כאן תוסיף את הלוגיקה שלך בהמשך
end

function PlayerMod.toggleAutoHeal(state) 
    -- כאן תוסיף את הלוגיקה שלך בהמשך
end

return PlayerMod
