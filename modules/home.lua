local Module = {}
function Module.init(parent, Elements)
    local title = Instance.new("TextLabel", parent)
    title.Size = UDim2.new(1, 0, 0, 50); title.Text = "Welcome to script ori_dev_team"
    title.TextColor3 = Color3.fromRGB(255, 255, 255); title.BackgroundTransparency = 1
    title.Font = Enum.Font.GothamBold; title.TextSize = 20
end
return Module
