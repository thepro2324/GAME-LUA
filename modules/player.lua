local PlayerMod = {}

local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local lp = Players.LocalPlayer
local staffConnection = nil

function PlayerMod.toggleFakeStaff(state)
    print("[DEBUG] toggleFakeStaff מופעלת: ", tostring(state))

    if staffConnection then 
        staffConnection:Disconnect() 
        staffConnection = nil 
    end
    
    if not state then return end
    
    local function doSpook()
        pcall(function()
            -- 1. שינוי Teams (לגיבוי)
            local teams = game:GetService("Teams")
            for _, team in ipairs(teams:GetTeams()) do
                local nameLower = team.Name:lower()
                if nameLower:find("צוות") or nameLower:find("מנהל") or nameLower:find("staff") or nameLower:find("admin") or nameLower:find("owner") then
                    if lp.Team ~= team then lp.Team = team end
                    if lp.TeamColor ~= team.TeamColor then lp.TeamColor = team.TeamColor end
                    break
                end
            end
            
            -- 2. סריקה עם הדפסת פרטים מלאה (כאן החקירה שלנו)
            local playerGui = lp:FindFirstChild("PlayerGui")
            if playerGui then
                local function searchAndPrint(parent)
                    for _, obj in ipairs(parent:GetChildren()) do
                        -- אם זה טקסט או תמונה, נדפיס את הפרטים שלו לקונסול כדי שנוכל לחקור
                        if obj:IsA("TextLabel") or obj:IsA("ImageLabel") then
                            local objContent = obj:IsA("TextLabel") and obj.Text or "IMAGE"
                            
                            -- נדפיס רק אם זה נראה רלוונטי (מכיל את השם שלך או משהו שקשור לצוות)
                            if objContent:find(lp.Name) or obj.Name:lower():find("name") or obj.Name:lower():find("rank") or obj.Name:lower():find("role") then
                                print("--- חקירת אובייקט ---")
                                print("שם: " .. obj.Name)
                                print("סוג: " .. obj.ClassName)
                                print("נתיב מלא: " .. obj:GetFullName())
                                print("תוכן/טקסט: " .. objContent)
                                print("הורה (Parent): " .. obj.Parent.Name)
                            end
                        end
                        
                        -- אם מצאנו את השם שלך, ננסה לשנות (בנוסף להדפסה)
                        if obj:IsA("TextLabel") and (obj.Text:find(lp.Name)) then
                            local row = obj.Parent
                            if row then
                                for _, child in ipairs(row:GetChildren()) do
                                    if child:IsA("TextLabel") and child ~= obj then
                                        child.Text = "צוות"
                                        child.TextColor3 = Color3.fromRGB(255, 0, 0)
                                    end
                                end
                            end
                        end
                        
                        searchAndPrint(obj)
                    end
                end
                searchAndPrint(playerGui)
            end
        end)
    end

    doSpook()
    staffConnection = RunService.Stepped:Connect(doSpook)
end

function PlayerMod.toggleNoRagdoll(state) end
function PlayerMod.toggleAutoHeal(state) end

return PlayerMod
