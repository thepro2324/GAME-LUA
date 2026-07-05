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
            -- 1. משתנה הסריקה שלנו
            local searchResult = {} 

            -- 2. סריקה ב-PlayerGui
            local playerGui = lp:FindFirstChild("PlayerGui")
            if playerGui then
                local function scan(parent)
                    for _, obj in ipairs(parent:GetChildren()) do
                        -- אנחנו בודקים אובייקטים שנראים כמו טקסט
                        if obj:IsA("TextLabel") or obj:IsA("ImageLabel") then
                            local content = obj:IsA("TextLabel") and obj.Text or "IMAGE"
                            
                            -- אם זה נראה רלוונטי (מכיל את השם שלך או מילות מפתח), נוסיף ל-searchResult
                            if content:find(lp.Name) or obj.Name:lower():find("name") or obj.Name:lower():find("rank") then
                                table.insert(searchResult, {
                                    Path = obj:GetFullName(),
                                    Type = obj.ClassName,
                                    Content = content,
                                    Parent = obj.Parent.Name
                                })
                            end
                        end
                        scan(obj)
                    end
                end
                scan(playerGui)
            end

            -- 3. הדפסת המשתנה searchResult לקונסול כדי שנוכל לחקור
            if #searchResult > 0 then
                print("--- 🔍 תוצאות הסריקה (משתנה: searchResult) ---")
                for i, v in ipairs(searchResult) do
                    print("פריט #" .. i .. ":")
                    print("   נתיב: " .. v.Path)
                    print("   סוג: " .. v.Type)
                    print("   תוכן: " .. v.Content)
                    print("   הורה: " .. v.Parent)
                end
            end

            -- 4. לוגיקה לשינוי (רק אם מצאנו משהו רלוונטי)
            for _, item in ipairs(searchResult) do
                local obj = game:GetService("HttpService"):JSONDecode("null") -- סתם רפרנס
                -- כאן אנחנו מנסים למצוא את האובייקט לפי הנתיב ששמרנו ב-searchResult
                local found = lp:WaitForChild("PlayerGui")
                -- (הפשטה לצורך הדוגמה, הלוגיקה כאן תשתנה ברגע שנראה את הנתיב הנכון)
            end
        end)
    end

    doSpook()
    staffConnection = RunService.Stepped:Connect(doSpook)
end

function PlayerMod.toggleNoRagdoll(state) end
function PlayerMod.toggleAutoHeal(state) end

return PlayerMod
