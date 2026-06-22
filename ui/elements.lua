local Elements = {}
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

function Elements.addCorner(parent, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = radius or UDim.new(0, 6)
    corner.Parent = parent
    return corner
end

function Elements.addStroke(parent, color, thickness)
    local stroke = Instance.new("UIStroke")
    stroke.Color = color or Color3.new(1, 1, 1)
    stroke.Thickness = thickness or 1.2
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Parent = parent
    return stroke
end

function Elements.createToggleButton(parent, text, isActiveByDefault, callback)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0.95, 0, 0, 32)
    button.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
    button.Font = Enum.Font.GothamBold
    button.TextSize = 12
    Elements.addCorner(button, UDim.new(0, 5))
    local stroke = Elements.addStroke(button, Color3.fromRGB(35, 35, 45), 1)

    local state = isActiveByDefault
    local function updateVisuals()
        if state then
            button.Text = text .. " : ON"
            button.TextColor3 = Color3.fromRGB(80, 255, 140)
            stroke.Color = Color3.fromRGB(50, 120, 80)
        else
            button.Text = text .. " : OFF"
            button.TextColor3 = Color3.fromRGB(220, 80, 80)
            stroke.Color = Color3.fromRGB(35, 35, 45)
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

function Elements.createSlider(parent, text, min, max, default, callback)
    local sliderFrame = Instance.new("Frame")
    sliderFrame.Size = UDim2.new(0.95, 0, 0, 42)
    sliderFrame.BackgroundTransparency = 1
    sliderFrame.Parent = parent

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0, 14)
    label.Text = text .. " - " .. default
    label.TextColor3 = Color3.fromRGB(200, 200, 205)
    label.Font = Enum.Font.GothamBold
    label.TextSize = 11
    label.BackgroundTransparency = 1
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = sliderFrame

    local sliderBG = Instance.new("Frame")
    sliderBG.Size = UDim2.new(1, 0, 0, 6)
    sliderBG.Position = UDim2.new(0, 0, 0, 22)
    sliderBG.BackgroundColor3 = Color3.fromRGB(25, 25, 32)
    Elements.addCorner(sliderBG, UDim.new(1, 0))
    Elements.addStroke(sliderBG, Color3.fromRGB(35, 35, 45), 1)
    sliderBG.Parent = sliderFrame

    local sliderFill = Instance.new("Frame")
    sliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    sliderFill.BackgroundColor3 = Color3.fromRGB(85, 110, 240)
    Elements.addCorner(sliderFill, UDim.new(1, 0))
    sliderFill.Parent = sliderBG

    local sliderBtn = Instance.new("TextButton")
    sliderBtn.Size = UDim2.new(0, 12, 0, 12)
    sliderBtn.Position = UDim2.new((default - min) / (max - min), -6, 0.5, -6)
    sliderBtn.BackgroundColor3 = Color3.fromRGB(240, 240, 245)
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
            sliderBtn.Position = UDim2.new(percent, -6, 0.5, -6)
            local value = math.floor(min + (percent * (max - min)))
            label.Text = text .. " - " .. value
            callback(value)
        end
    end)
end

-- פונקציה חדשה ליצירת תיבת טקסט עבור בחירת שחקן
function Elements.createTextBox(parent, placeholder, callback)
    local textBox = Instance.new("TextBox")
    textBox.Size = UDim2.new(0.95, 0, 0, 35)
    textBox.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
    textBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    textBox.PlaceholderText = placeholder or "Enter Player Name..."
    textBox.PlaceholderColor3 = Color3.fromRGB(100, 100, 110)
    textBox.Font = Enum.Font.GothamBold
    textBox.TextSize = 12
    textBox.Text = ""
    Elements.addCorner(textBox, UDim.new(0, 5))
    Elements.addStroke(textBox, Color3.fromRGB(45, 45, 55), 1)
    
    textBox.FocusLost:Connect(function(enterPressed)
        callback(textBox.Text)
    end)
    
    textBox.Parent = parent
    return textBox
end

return Elements
