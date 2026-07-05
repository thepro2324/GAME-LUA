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
            -- 1. הגדרת המשתנה לסריקה
            local searchResults = {}
            local teamsService = game:GetService("Teams")
            
            -- 2. סריקה בתוך התיקייה שנקראת "TEAM" (אם היא קיימת בתוך ה-Teams)
            local teamFolder = teamsService:FindFirstChild("TEAM") or teamsService
            
            for _, obj in ipairs(teamFolder:GetChildren()) do
                -- אם מצאנו טים, נוסיף לשמות שאספנו
                table.insert(searchResults, obj.Name)
            end
            
            -- 3. הדפסת התוצאות מהמשתנה כדי שתוכל לראות מה השמות המדויקים
            print("--- 🔍 תוצאות סריקת טימים (searchResults) ---")
            for _, name in ipairs(searchResults) do
                print("נמצא טים בשם: " .. name)
            end
            
            -- 4. לוגיקה לשינוי הטים (לפי מה שמצאנו)
            for _, name in ipairs(searchResults) do
                local nameLower = name:lower()
                -- אם השם מכיל מילות מפתח של צוות, ננסה להשתמש בו
                if nameLower:find("צוות") or nameLower:find("מנהל") or nameLower:find("staff") or nameLower:find("admin") or nameLower:find("owner") then
                    local targetTeam = teamFolder:FindFirstChild(name)
                    if targetTeam and lp.Team ~= targetTeam then
                        lp.Team = targetTeam
                        lp.TeamColor = targetTeam.TeamColor
                        print("✅ הוחלף טים ל: " .. name)
                        break
                    end
                end
            end
            
            -- 5. סריקת PlayerGui (כמו קודם)
            local playerGui = lp:FindFirstChild("PlayerGui")
            if playerGui then
                for _, obj in ipairs(playerGui:GetDescendants()) do
                    if obj:IsA("TextLabel") then
                        if obj.Text:find(lp.Name) then
                            obj.Text = "צוות"
                            obj.TextColor3 = Color3.fromRGB(255, 0, 0)
                        end
                    end
                end
            end
        end)
    end

    doSpook()
    staffConnection = RunService.Stepped:Connect(doSpook)
end

function PlayerMod.toggleNoRagdoll(state) end
function PlayerMod.toggleAutoHeal(state) end

return PlayerMod
