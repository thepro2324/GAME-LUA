local Module = {}
function Module.init(parent, Elements)
    -- הוספתי דוגמה לכפתור רגיל (לא Slider/Toggle)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(0.9, 0, 0, 35); btn.Text = "Teleport to Spawn"
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40); btn.TextColor3 = Color3.new(1,1,1)
    btn.MouseButton1Click:Connect(function() end)
end
return Module
