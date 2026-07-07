local module = {}

-- ניקוי קודם
local CoreGui = game:GetService("CoreGui")
if CoreGui:FindFirstChild("MyMenu") then 
    CoreGui:FindFirstChild("MyMenu"):Destroy() 
end

-- יצירת מסך
local screen = Instance.new("ScreenGui")
screen.Name = "MyMenu"
screen.Parent = CoreGui

-- פריים ראשי
local frame = Instance.new("Frame", screen)
frame.Size = UDim2.new(0, 200, 0, 150)
frame.Position = UDim2.new(0.5, -100, 0.5, -75)
frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Instance.new("UICorner", frame)

-- כפתור
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

print("✅ UI Created Successfully!")

-- השורה הזו מעלימה את האזהרה:
return module
