-- modules/player.lua (גרסת ה-Fly המשודרגת לפי מצלמה וקישורי מקשים)

local PlayerMod = {}

local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local lp = Players.LocalPlayer
local cam = workspace.CurrentCamera
local flyConnection = nil
local bodyVelocity = nil
local bodyGyro = nil

-- פונקציית עדכון מהירות (עבור הסליידר של ה-WalkSpeed)
function PlayerMod.updateSpeed(v)
    local char = lp.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.WalkSpeed = v
        end
    end
end

-- פונקציית עדכון קפיצה (עבור הסליידר של ה-JumpPower)
function PlayerMod.updateJump(v)
    local char = lp.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.JumpPower = v
        end
    end
end

-- פונקציית עדכון גובה (עבור הסליידר של ה-HipHeight)
function PlayerMod.updateHipHeight(v)
    local char = lp.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.HipHeight = v
        end
    end
end

-- ==================== מערכת התעופה ה-FLY החדשה ====================
function PlayerMod.toggleFly(state)
    -- ניקוי חיבורים קודמים כדי למנוע כפילויות או קריסות
    if flyConnection then flyConnection:Disconnect() flyConnection = nil end
    if bodyVelocity then bodyVelocity:Destroy() bodyVelocity = nil end
    if bodyGyro then bodyGyro:Destroy() bodyGyro = nil end
    
    if not state then 
        -- החזרת ה-Humanoid למצב רגיל כשהתעופה כבויה
        local char = lp.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then hum.PlatformStand = false end
        end
        return 
    end
    
    local char = lp.Character or lp.CharacterAdded:Wait()
    local hrp = char:WaitForChild("HumanoidRootPart")
    local hum = char:WaitForChild("Humanoid")
    
    -- מניעת נפילה או תקיעה של האנימציות הרגילות
    hum.PlatformStand = true
    
    -- יצירת כוח מהירות קבוע (BodyVelocity)
    bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.MaxForce = Vector3.new(1e5, 1e5, 1e5)
    bodyVelocity.Velocity = Vector3.new(0, 0, 0)
    bodyVelocity.Parent = hrp
    
    -- יצירת מייצב סיבוב (BodyGyro) כדי שהשחקן יישאר יציב ולא יתהפך
    bodyGyro = Instance.new("BodyGyro")
    bodyGyro.MaxTorque = Vector3.new(1e5, 1e5, 1e5)
    bodyGyro.CFrame = hrp.CFrame
    bodyGyro.Parent = hrp
    
    -- לולאת הרנדור הראשית - תנועה מבוססת מצלמה ומקשים
    flyConnection = RunService.RenderStepped:Connect(function()
        if not hrp or not bodyVelocity or not bodyVelocity.Parent then return end
        
        local moveDir = Vector3.new(0, 0, 0)
        
        -- 1. תנועה אופקית/אנכית לפי כיוון המצלמה של השחקן (כמו פעם)
        if UIS:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + cam.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - cam.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + cam.CFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - cam.CFrame.RightVector end
        
        -- 2. עלייה למעלה (תמיכה ברווח וגם ב-CTRL שמאלי לפי הבקשה שלך)
        if UIS:IsKeyDown(Enum.KeyCode.Space) or UIS:IsKeyDown(Enum.KeyCode.LeftControl) then
            moveDir = moveDir + Vector3.new(0, 1, 0)
        end
        
        -- 3. ירידה למטה (Shift שמאלי)
        if UIS:IsKeyDown(Enum.KeyCode.LeftShift) then
            moveDir = moveDir - Vector3.new(0, 1, 0)
        end
        
        -- שמירה על כיוון הגוף מיושר עם כיוון המצלמה (רק על ציר ה-Y כדי שלא יתקע באדמה)
        bodyGyro.CFrame = CFrame.new(hrp.Position, hrp.Position + cam.CFrame.LookVector)
        
        -- קריאת המהירות הדינמית מהסליידר של ההאב
        local speed = shared.flySpeed or 100
        
        if moveDir.Magnitude > 0 then
            bodyVelocity.Velocity = moveDir.Unit * speed
        else
            bodyVelocity.Velocity = Vector3.new(0, 0, 0)
        end
    end)
end

-- שאר הפונקציות הריקות של המודול כדי שלא יזרקו שגיאות ב-init
function PlayerMod.toggleAntiAFK(state) print("Anti-AFK:", state) end
function PlayerMod.toggleAutoReset(state) print("Auto-Reset:", state) end
function PlayerMod.toggleInfJump(state) print("Inf Jump:", state) end
function PlayerMod.toggleNoclip(state) print("Noclip:", state) end
function PlayerMod.toggleGodMode(state) print("God Mode:", state) end
function PlayerMod.toggleInvisible(state) print("Invisible:", state) end
function PlayerMod.toggleNoRagdoll(state) print("No Ragdoll:", state) end
function PlayerMod.toggleAutoHeal(state) print("Auto-Heal:", state) end

return PlayerMod
