-- הגנה מפני הרצה כפולה
local CoreGui = game:GetService("CoreGui")
if CoreGui:FindFirstChild("MyMenu") then 
    CoreGui:FindFirstChild("MyMenu"):Destroy() 
end

-- יצירת ה-GUI
local screen = Instance.new("ScreenGui", CoreGui)
screen.Name = "MyMenu"

local frame = Instance.new("Frame", screen)
frame.Size = UDim2.new(0, 200, 0, 150)
frame.Position = UDim2.new(0.5, -100, 0.5, -75)
frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Instance.new("UICorner", frame)

local btn = Instance.new("TextButton", frame)
btn.Size = UDim2.new(0.8, 0, 0, 40)
btn.Position = UDim2.new(0.1, 0, 0.3, 0)
btn.Text = "Kill Aura"
btn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
btn.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", btn)

btn.MouseButton1Click:Connect(function()
    print("Kill Aura activated!")
end)

-- השורה הזאת משתיקה את השגיאה ב-Console
return true
