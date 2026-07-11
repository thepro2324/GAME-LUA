local Module = {}
function Module.init(parent, Elements)
    Elements.createToggleButton(parent, "Aimbot", false, function(s) end)
    Elements.createSlider(parent, "Smoothing", 1, 10, 1, function(v) end)
    Elements.createToggleButton(parent, "Silent Aim", false, function(s) end)
end
return Module
