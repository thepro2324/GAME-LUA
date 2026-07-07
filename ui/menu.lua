local Menu = {}

function Menu.init(parent)
    -- ניקוי קודם כדי למנוע כפילויות
    if parent:FindFirstChild("ModernMenu") then
        parent:FindFirstChild("ModernMenu"):Destroy()
    end

    local screenGui = Instance.new("ScreenGui", parent)
    screenGui.Name = "ModernMenu"

    local frame = Instance.new("Frame", screenGui)
    frame.Size = UDim2.new(0, 600, 0, 400)
    frame.Position = UDim2.new(0.5, -300, 0.5, -200)
    frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    frame.BorderSizePixel = 0
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 15)
    Instance.new("UIStroke", frame).Color = Color3.fromRGB(60, 60, 60)

    print("✅ UI Created Successfully!")
end

-- !!! השורה הזאת חובה כדי שה-init.lua יקבל את המודול !!!
return Menu
