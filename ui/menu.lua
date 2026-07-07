local Menu = {}

function Menu.init(parent)
    print("🎨 המודול יוצר את ה-UI...")

    -- מחיקת ישן אם קיים
    if parent:FindFirstChild("ModernMenu") then
        parent:FindFirstChild("ModernMenu"):Destroy()
    end

    local screenGui = Instance.new("ScreenGui", parent)
    screenGui.Name = "ModernMenu"

    local frame = Instance.new("Frame", screenGui)
    frame.Size = UDim2.new(0, 300, 0, 400)
    frame.Position = UDim2.new(0.5, -150, 0.5, -200)
    frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    frame.BorderSizePixel = 0

    local corner = Instance.new("UICorner", frame)
    corner.CornerRadius = UDim.new(0, 15)

    local stroke = Instance.new("UIStroke", frame)
    stroke.Color = Color3.fromRGB(100, 100, 100)
    stroke.Thickness = 2
    
    print("✅ ה-UI נוצר!")
end

-- !!! השורה הזאת קריטית - בלעדיה MenuModule יהיה nil !!!
return Menu
