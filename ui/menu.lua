local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
if playerGui:FindFirstChild("ModernMenu") then playerGui:FindFirstChild("ModernMenu"):Destroy() end

local screenGui = Instance.new("ScreenGui", playerGui)
screenGui.Name = "ModernMenu"

-- הפריים הראשי
local mainFrame = Instance.new("Frame", screenGui)
mainFrame.Size = UDim2.new(0, 300, 0, 300)
mainFrame.Position = UDim2.new(0.5, -150, 0.5, -150)
mainFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
mainFrame.Visible = true

-- כפתור בדיקה - נוצר ישירות בתוך הפריים
local testBtn = Instance.new("TextButton", mainFrame)
testBtn.Size = UDim2.new(0, 200, 0, 50)
testBtn.Position = UDim2.new(0.5, -100, 0.5, -25) -- בדיוק באמצע
testBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0) -- אדום בולט
testBtn.Text = "אני עובד!"
testBtn.TextColor3 = Color3.new(1, 1, 1)
testBtn.Visible = true
testBtn.ZIndex = 10 -- להיות בטוחים שהוא מעל הפריים

print("✅ UI Created - Should see a Red Button now!")

return {init = function() end} -- סתם כדי שלא יצעק שגיאות ב-init
