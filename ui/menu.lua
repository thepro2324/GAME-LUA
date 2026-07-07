local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
if playerGui:FindFirstChild("ModernMenu") then playerGui:FindFirstChild("ModernMenu"):Destroy() end

local screen = Instance.new("ScreenGui", playerGui)
screen.Name = "ModernMenu"
screen.DisplayOrder = 999
screen.IgnoreGuiInset = true

-- פונקציה לעיצוב מהיר
local function create(class, props, parent)
    local obj = Instance.new(class)
    for i, v in pairs(props) do obj[i] = v end
    obj.Parent = parent
    return obj
end

-- פריים ראשי
local main = create("Frame", {
    Size = UDim2.new(0, 550, 0, 350),
    Position = UDim2.new(0.5, -275, 0.5, -175),
    BackgroundColor3 = Color3.fromRGB(20, 20, 20),
    BorderSizePixel = 0
}, screen)
create("UICorner", {CornerRadius = UDim.new(0, 12)}, main)
create("UIStroke", {Color = Color3.fromRGB(40, 40, 40), Thickness = 2}, main)

-- סיידבר
local sidebar = create("Frame", {
    Size = UDim2.new(0, 140, 1, 0),
    BackgroundTransparency = 1
}, main)
create("UIListLayout", {Padding = UDim.new(0, 5), HorizontalAlignment = Enum.HorizontalAlignment.Center, PaddingTop = UDim.new(0, 10)}, sidebar)

-- קונטיינר תוכן
local content = create("Frame", {
    Size = UDim2.new(1, -150, 1, -20),
    Position = UDim2.new(0, 145, 0, 10),
    BackgroundTransparency = 1
}, main)

local function AddTab(name)
    local btn = create("TextButton", {
        Size = UDim2.new(0.85, 0, 0, 40),
        BackgroundColor3 = Color3.fromRGB(35, 35, 35),
        Text = name,
        TextColor3 = Color3.fromRGB(200, 200, 200),
        Font = Enum.Font.GothamBold,
        TextSize = 14
    }, sidebar)
    create("UICorner", {CornerRadius = UDim.new(0, 6)}, btn)

    local page = create("ScrollingFrame", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Visible = false,
        ScrollBarThickness = 2
    }, content)
    create("UIListLayout", {Padding = UDim.new(0, 8), PaddingTop = UDim.new(0, 5)}, page)

    btn.MouseButton1Click:Connect(function()
        for _, p in pairs(content:GetChildren()) do if p:IsA("ScrollingFrame") then p.Visible = false end end
        page.Visible = true
    end)
    return page
end

local function AddToggle(page, text)
    local btn = create("TextButton", {
        Size = UDim2.new(0.9, 0, 0, 35),
        BackgroundColor3 = Color3.fromRGB(40, 40, 40),
        Text = text,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        Font = Enum.Font.Gotham
    }, page)
    create("UICorner", {CornerRadius = UDim.new(0, 6)}, btn)
end

-- הוספת קטגוריות
local combat = AddTab("Combat")
local visual = AddTab("Visual")

-- הוספת כפתורים
AddToggle(combat, "Kill Aura")
AddToggle(combat, "Auto Clicker")
AddToggle(visual, "ESP Box")
AddToggle(visual, "Chams")

print("✅ UI Loaded Successfully!")
