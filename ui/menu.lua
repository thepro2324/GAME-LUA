-- הגנה מפני הרצה כפולה
local CoreGui = game:GetService("CoreGui")
if CoreGui:FindFirstChild("MyMenu") then 
    CoreGui:FindFirstChild("MyMenu"):Destroy() 
end

-- בניית ה-UI
local screen = Instance.new("ScreenGui", CoreGui)
screen.Name = "MyMenu"

local frame = Instance.new("Frame", screen)
frame.Size = UDim2.new(0, 500, 0, 300)
frame.Position = UDim2.new(0.5, -100, 0.5, -75)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Instance.new("UICorner", frame)

local btn = Instance.new("TextButton", frame)
btn.Size = UDim2.new(0.25, 0, 0, 40)
btn.Position = UDim2.new(0.01, 0, 0.02, 0)
btn.Text = "Home"
btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
btn.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", btn)

local btn = Instance.new("TextButton", frame)
btn.Size = UDim2.new(0.25, 0, 0, 40)
btn.Position = UDim2.new(0.01, 0, 0.2, 0)
btn.Text = "Targte"
btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
btn.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", btn)

local btn = Instance.new("TextButton", frame)
btn.Size = UDim2.new(0.25, 0, 0, 40)
btn.Position = UDim2.new(0.01, 0, 0.37, 0)
btn.Text = "player"
btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
btn.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", btn)

local btn = Instance.new("TextButton", frame)
btn.Size = UDim2.new(0.25, 0, 0, 40)
btn.Position = UDim2.new(0.01, 0, 0.54, 0)
btn.Text = "world"
btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
btn.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", btn)



-- לוגיקה של הכפתור
local enabled = false
btn.MouseButton1Click:Connect(function()
    enabled = not enabled
    if enabled then
        btn.BackgroundColor3 = Color3.fromRGB(0, 200, 0) -- ירוק כשהוא דולק
        print("Kill Aura: ON")
    else
        btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60) -- אפור כשהוא כבוי
        print("Kill Aura: OFF")
    end
end)

-- השורה הזאת היא מה שפותר את השגיאה ב-Console.
-- היא אומרת ל-Executor "סיימתי, הנה התשובה שלי".
return true
