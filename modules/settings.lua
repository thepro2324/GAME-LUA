local Module = {}
function Module.init(parent, Elements)
    Elements.createToggleButton(parent, "UI Toggle", true, function(s) end)
    local resetBtn = Instance.new("TextButton", parent)
    resetBtn.Size = UDim2.new(0.9, 0, 0, 35); resetBtn.Text = "Destroy UI"
    resetBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50); resetBtn.TextColor3 = Color3.new(1,1,1)
    resetBtn.MouseButton1Click:Connect(function() game:GetService("CoreGui").OriHub:Destroy() end)
end
return Module
