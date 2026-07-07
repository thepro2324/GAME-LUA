-- ניקוי של התפריט הקודם (אם קיים)
local CoreGui = game:GetService("CoreGui")
if CoreGui:FindFirstChild("MyMenu") then 
    CoreGui:FindFirstChild("MyMenu"):Destroy() 
end

-- יצירת ה-UI
local screen = Instance.new("ScreenGui", CoreGui)
screen.Name = "MyMenu"

local main = Instance.new("Frame", screen)
main.Size = UDim2.new(0, 300, 0, 200)
main.Position = UDim2.new(0.5, -150, 0.5, -100)
main.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 10)

-- הוספת כפתור בדיקה
local btn = Instance.new("TextButton", main)
btn.Size = UDim2.new(0.8, 0, 0, 50)
btn.Position = UDim2.new(0.1, 0, 0.3, 0)
btn.Text = "Kill Aura (ON)"
btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
btn.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

btn.MouseButton1Click:Connect(function()
    print("Kill Aura Pressed!")
end)

print("✅ UI Created Successfully!")
