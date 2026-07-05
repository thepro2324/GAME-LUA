local PlayerMod = {}

local Teams = game:GetService("Teams")
local Players = game:GetService("Players")
local lp = Players.LocalPlayer

function PlayerMod.toggleFakeStaff(state)
    -- אם המצב הוא false (כיבוי), אפשר להוסיף כאן לוגיקה אם תרצה לחזור לטים הקודם
    if not state then 
        print("[DEBUG] FakeStaff כובה")
        return 
    end

    pcall(function()
        -- חיפוש הטים המדויק לפי השם שמצאנו בקונסול
        local targetTeam = Teams:FindFirstChild("צוות")
        
        if targetTeam then
            -- שינוי הטים
            lp.Team = targetTeam
            lp.TeamColor = targetTeam.TeamColor
            print("✅ הועברת בהצלחה לטים: צוות")
        else
            warn("❌ טים בשם 'צוות' לא נמצא בתיקיית Teams")
        end
    end)
end

-- פונקציות ריקות למניעת שגיאות
function PlayerMod.toggleNoRagdoll(state) end
function PlayerMod.toggleAutoHeal(state) end

return PlayerMod
