local Module = {}
function Module.init(parent, Elements)
    Elements.createSlider(parent, "WalkSpeed", 16, 200, 16, function(v) end)
    Elements.createSlider(parent, "JumpPower", 50, 300, 50, function(v) end)
    Elements.createToggleButton(parent, "Infinite Jump", false, function(s) end)
    Elements.createToggleButton(parent, "Noclip", false, function(s) end)
end
return Module
