-- ניקוי קודם
local player = game.Players.LocalPlayer
local gui = player:WaitForChild("PlayerGui")
if gui:FindFirstChild("MyMenu") then gui:FindFirstChild("MyMenu"):Destroy() end

-- יצירת UI
local screen = Instance.new("ScreenGui", gui)
screen.Name = "MyMenu"
screen.IgnoreGuiInset = true

local main = Instance.new("Frame", screen)
main.Size = UDim2.new(0, 450, 0, 300)
main.Position = UDim2.new(0.5, -225, 0.5, -150)
main.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 10)

-- Sidebar
local side = Instance.new("Frame", main)
side.Size = UDim2.new(0, 120, 1, 0)
side.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Instance.new("UICorner", side).CornerRadius = UDim.new(0, 10)

-- פונקציות עזר
local function createButton(name, parent, color, callback)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(0.9, 0, 0, 40)
    btn.BackgroundColor3 = color
    btn.Text = name
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.GothamBold
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    btn.MouseButton1Click:Connect(callback)
    return btn
end

-- יצירת כפתורים
createButton("Kill Aura", side, Color3.fromRGB(60, 60, 60), function()
    print("Kill Aura ON")
end)

createButton("Speed", side, Color3.fromRGB(60, 60, 60), function()
    print("Speed ON")
end)

createButton("Close", main, Color3.fromRGB(150, 50, 50), function()
    screen:Destroy()
end)
btn_close = main:FindFirstChild("Close")
btn_close.Position = UDim2.new(0, 125, 0, 250)
btn_close.Size = UDim2.new(0, 300, 0, 40)

print("✅ Menu Loaded!")
