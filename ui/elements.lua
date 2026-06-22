-- ui/elements.lua
local Elements = {}
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- פונקציה לעיגול פינות
function Elements.addCorner(parent, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = radius or UDim.new(0, 8)
    corner.Parent = parent
    return corner
end

-- פונקציה להוספת מסגרת (Stroke)
function Elements.addStroke(parent, color, thickness)
    local stroke = Instance.new("UIStroke")
    stroke.Color = color or Color3.new(1, 1, 1)
    stroke.Thickness = thickness or 1.5
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Parent = parent
    return stroke
end

-- פונקציה ליצירת כפתור טוגל (ON/OFF)
function Elements.createToggleButton(parent, text, isActiveByDefault, callback)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0.9, 0, 0, 35)
    button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    button.Font = Enum.Font.SourceSansBold
    button.TextSize = 16
    Elements.addCorner(button, UDim.new(0, 6))
    Elements.addStroke(button, Color3.new(0.5, 0.5, 0.5), 1)

    local state = isActiveByDefault
    local function updateVisuals()
        if state then
            button.Text = text .. ": ON"
            button.TextColor3 = Color3.fromRGB(0, 255, 100)
        else
            button.Text = text .. ": OFF"
            button.TextColor3 = Color3.fromRGB(255, 80, 80)
        end
    end
    updateVisuals()

    button.MouseButton1Click:Connect(function()
        state = not state
        updateVisuals()
        callback(state)
    end)
    button.Parent = parent
    return button
end

-- פונקציה ליצירת סליידר (Slider) חלק
function Elements.createSlider(parent, text, min, max, default, callback)
    local sliderFrame = Instance.new("Frame")
    sliderFrame.Size = UDim2.new(0.9, 0, 0, 45)
    sliderFrame.BackgroundTransparency = 1
    sliderFrame.Parent = parent

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0, 15)
    label.Text = text .. ": " .. default
    label.TextColor3 = Color3.new(1, 1, 1)
    label.Font = Enum.Font.SourceSansBold
    label.TextSize = 14
    label.BackgroundTransparency = 1
    label.Parent = sliderFrame

    local sliderBG = Instance.new("Frame")
    sliderBG.Size = UDim2.new(1, 0, 0, 8)
    sliderBG.Position = UDim2.new(0, 0, 0, 22)
    sliderBG.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    Elements.addCorner(sliderBG, UDim.new(1, 0))
    sliderBG.Parent = sliderFrame

    local sliderFill = Instance.new("Frame")
    sliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    sliderFill.BackgroundColor3 = Color3.new(1, 1, 1)
    Elements.addCorner(sliderFill, UDim.new(1, 0))
    sliderFill.Parent = sliderBG

    local sliderBtn = Instance.new("TextButton")
    sliderBtn.Size = UDim2.new(0, 14, 0, 14)
    sliderBtn.Position = UDim2.new((default - min) / (max - min), -7, 0.5, -7)
    sliderBtn.BackgroundColor3 = Color3.new(1, 1, 1)
    sliderBtn.Text = ""
    Elements.addCorner(sliderBtn, UDim.new(1, 0))
    sliderBtn.Parent = sliderBG

    local dragging = false
    sliderBtn.MouseButton1Down:Connect(function() dragging = true end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)

    RunService.Heartbeat:Connect(function()
        if dragging then
            local mousePos = UserInputService:GetMouseLocation().X
            local bgPos = sliderBG.AbsolutePosition.X
            local bgSize = sliderBG.AbsoluteSize.X
            local percent = math.clamp((mousePos - bgPos) / bgSize, 0, 1)
            sliderFill.Size = UDim2.new(percent, 0, 1, 0)
            sliderBtn.Position = UDim2.new(percent, -7, 0.5, -7)
            local value = math.floor(min + (percent * (max - min)))
            label.Text = text .. ": " .. value
            callback(value)
        end
    end)
end

return Elements
