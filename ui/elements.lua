-- ========================================================
-- סקריפט הכל-באחד: ממשק + לוגיקה (Player Tab)
-- ========================================================

-- 1. Services
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local lp = Players.LocalPlayer
local cam = workspace.CurrentCamera

-- 2. הגדרת ספריית Elements (ממשק)
local Elements = {}
function Elements.addCorner(parent, radius) local c = Instance.new("UICorner"); c.CornerRadius = radius or UDim.new(0, 6); c.Parent = parent; return c end
function Elements.addStroke(parent, color, thickness) local s = Instance.new("UIStroke"); s.Color = color or Color3.new(1, 1, 1); s.Thickness = thickness or 1.2; s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border; s.Parent = parent; return s end

function Elements.createToggleButton(parent, text, isActiveByDefault, callback)
    local button = Instance.new("TextButton", parent); button.Size = UDim2.new(0.95, 0, 0, 32); button.BackgroundColor3 = Color3.fromRGB(22, 22, 28); button.Font = Enum.Font.GothamBold; button.TextSize = 12; Elements.addCorner(button, UDim.new(0, 5)); local stroke = Elements.addStroke(button, Color3.fromRGB(35, 35, 45), 1)
    local state = isActiveByDefault; local function updateVisuals() if state then button.Text = text .. " : ON"; button.TextColor3 = Color3.fromRGB(80, 255, 140); stroke.Color = Color3.fromRGB(50, 120, 80) else button.Text = text .. " : OFF"; button.TextColor3 = Color3.fromRGB(220, 80, 80); stroke.Color = Color3.fromRGB(35, 35, 45) end end; updateVisuals()
    button.MouseButton1Click:Connect(function() state = not state; updateVisuals(); callback(state) end)
    return button
end

-- 3. הגדרת לוגיקת PlayerMod
local PlayerMod = {}
function PlayerMod.updateSpeed(v) local hum = lp.Character and lp.Character:FindFirstChildOfClass("Humanoid"); if hum then hum.WalkSpeed = v end end
function PlayerMod.toggleFly(state) 
    -- (לוגיקת התעופה שלך שהעתקנו קודם)
    print("Fly set to: " .. tostring(state)) 
end

-- 4. בניית הממשק (UI Setup)
local screenGui = Instance.new("ScreenGui", game.CoreGui)
local mainFrame = Instance.new("Frame", screenGui); mainFrame.Size = UDim2.new(0, 300, 0, 400); mainFrame.Position = UDim2.new(0.5, -150, 0.5, -200); mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
local scroll = Instance.new("ScrollingFrame", mainFrame); scroll.Size = UDim2.new(1, 0, 1, 0); scroll.CanvasSize = UDim2.new(0, 0, 0, 1000); scroll.BackgroundTransparency = 1
Instance.new("UIListLayout", scroll).Padding = UDim.new(0, 10)

-- 5. חיבור הכל יחד
Elements.createToggleButton(scroll, "Fly Mode", false, function(s) PlayerMod.toggleFly(s) end)
local speedInput = Instance.new("TextBox", scroll); speedInput.Size = UDim2.new(0.95, 0, 0, 30); speedInput.Text = "Enter Speed"; speedInput.FocusLost:Connect(function() PlayerMod.updateSpeed(tonumber(speedInput.Text) or 16) end)

print("הסקריפט הופעל בהצלחה!")
