-- =========================================================================
-- ORI HUB - קוד מלא (להעתיק ולהריץ)
-- =========================================================================
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local lp = Players.LocalPlayer
local cam = workspace.CurrentCamera

-- 1. ניקוי UI ישן
if CoreGui:FindFirstChild("MyMenu") then CoreGui:FindFirstChild("MyMenu"):Destroy() end

-- 2. יצירת ה-GUI הראשי
local screen = Instance.new("ScreenGui", CoreGui); screen.Name = "MyMenu"
local frame = Instance.new("Frame", screen); frame.Size = UDim2.new(0, 600, 0, 375); frame.Position = UDim2.new(0.5, -300, 0.5, -187.5); frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30); Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)

-- 3. גרירה (Draggable) - יציבה
local dragging, dragStart, startPos
frame.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true; dragStart = input.Position; startPos = frame.Position end end)
UIS.InputChanged:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then local delta = input.Position - dragStart; frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y) end end)
UIS.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)

-- 4. עיצוב
local sidebar = Instance.new("Frame", frame); sidebar.Size = UDim2.new(0, 140, 1, 0); sidebar.BackgroundColor3 = Color3.fromRGB(40, 40, 40); Instance.new("UICorner", sidebar).CornerRadius = UDim.new(0, 10)
local mainContent = Instance.new("Frame", frame); mainContent.Size = UDim2.new(1, -140, 1, 0); mainContent.Position = UDim2.new(0, 140, 0, 0); mainContent.BackgroundTransparency = 1

-- 5. פונקציות עזר לכפתורים וסליידרים
local function addCorner(p) local c = Instance.new("UICorner", p); c.CornerRadius = UDim.new(0, 6) end
local function createButton(name, callback)
    local b = Instance.new("TextButton", sidebar); b.Size = UDim2.new(0.8, 0, 0, 35); b.Position = UDim2.new(0.1, 0, 0, (#sidebar:GetChildren() - 1) * 45 + 50); b.Text = name; b.BackgroundColor3 = Color3.fromRGB(60, 60, 60); b.TextColor3 = Color3.new(1,1,1); b.Font = Enum.Font.Gotham; addCorner(b)
    b.MouseButton1Click:Connect(function() mainContent:ClearAllChildren(); callback() end)
end

local function createToggle(text, callback)
    local b = Instance.new("TextButton", mainContent); b.Size = UDim2.new(0.9, 0, 0, 40); b.Text = text; b.BackgroundColor3 = Color3.fromRGB(50, 50, 50); b.TextColor3 = Color3.new(1,1,1); addCorner(b)
    local state = false; b.MouseButton1Click:Connect(function() state = not state; b.Text = text .. (state and " : ON" or " : OFF"); callback(state) end)
    Instance.new("UIListLayout", mainContent).Padding = UDim.new(0, 10)
end

-- 6. לוגיקת שחקן (כאן הכל בפנים!)
createButton("Player", function()
    createToggle("Fly", function(s) 
        local hrp = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
        if hrp then 
            if s then local bv = Instance.new("BodyVelocity", hrp); bv.Name = "FlyV"; bv.MaxForce = Vector3.new(1e5,1e5,1e5); bv.Velocity = Vector3.new(0,0,0)
            else if hrp:FindFirstChild("FlyV") then hrp.FlyV:Destroy() end end
        end
    end)
    
    createToggle("Noclip", function(s)
        RunService.Stepped:Connect(function() if s and lp.Character then for _,p in pairs(lp.Character:GetChildren()) do if p:IsA("BasePart") then p.CanCollide = false end end end end)
    end)
end)

createButton("Home", function()
    local t = Instance.new("TextLabel", mainContent); t.Size = UDim2.new(1,0,1,0); t.Text = "Welcome to Ori Hub"; t.TextColor3 = Color3.new(1,1,1); t.BackgroundTransparency = 1
end)
