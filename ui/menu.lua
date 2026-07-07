-- הגדרות בסיסיות
local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
if playerGui:FindFirstChild("ModernMenu") then playerGui:FindFirstChild("ModernMenu"):Destroy() end

local screenGui = Instance.new("ScreenGui", playerGui)
screenGui.Name = "ModernMenu"
screenGui.IgnoreGuiInset = true -- מוודא שזה מופיע על כל המסך

local mainFrame = Instance.new("Frame", screenGui)
mainFrame.Size = UDim2.new(0, 600, 0, 400)
mainFrame.Position = UDim2.new(0.5, -300, 0.5, -200)
mainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40) -- צבע בולט יותר
mainFrame.BorderSizePixel = 0
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 15)

-- Sidebar
local sideBar = Instance.new("Frame", mainFrame)
sideBar.Size = UDim2.new(0, 150, 1, 0)
sideBar.Position = UDim2.new(0, 0, 0, 0)
sideBar.BackgroundColor3 = Color3.fromRGB(60, 60, 60) -- צבע שונה כדי שנראה אותו
sideBar.BorderSizePixel = 0

-- פונקציה לבדיקת יצירת כפתור
local function AddCategory(name, yPos)
    warn("Creating button for: " .. name) -- נדפיס לקונסול כדי לראות שזה רץ
    
    local btn = Instance.new("TextButton", sideBar)
    btn.Size = UDim2.new(0.8, 0, 0, 40)
    btn.Position = UDim2.new(0.1, 0, 0, yPos) -- מיקום ידני
    btn.BackgroundColor3 = Color3.fromRGB(200, 50, 50) -- אדום בולט
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.ZIndex = 10 -- להבטיח שזה מעל הכל
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    
    return btn
end

-- --- יצירה ---
AddCategory("Combat", 10)  -- יופיע למעלה
AddCategory("Visuals", 60) -- יופיע קצת מתחת

print("✅ Script finished executing.")
