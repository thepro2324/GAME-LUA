local Menu = {}

function Menu.init(parent)
    -- ניקוי GUI ישן אם קיים
    if parent:FindFirstChild("ModernMenuUI") then
        parent:FindFirstChild("ModernMenuUI"):Destroy()
    end

    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "ModernMenuUI"
    screenGui.Parent = parent

    local frame = Instance.new("Frame")
    frame.Name = "MainFrame"
    frame.Size = UDim2.new(0, 350, 0, 450)
    frame.Position = UDim2.new(0.5, -175, 0.5, -225)
    frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    frame.BorderSizePixel = 0
    frame.Parent = screenGui

    local corner = Instance.new("UICorner", frame)
    corner.CornerRadius = UDim.new(0, 15)

    local stroke = Instance.new("UIStroke", frame)
    stroke.Thickness = 2
    stroke.Color = Color3.fromRGB(50, 50, 50)
    
    print("UI Created Successfully")
end

-- השורה הזאת היא הכי חשובה!
return Menu
