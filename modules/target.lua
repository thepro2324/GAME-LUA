local Module = {}
function Module.init(tab, Elements)
    Elements.createToggleButton(tab, "Aimbot", false, function(s) end)
    Elements.createSlider(tab, "FOV Radius", 0, 500, 100, function(v) end)
    Elements.createToggleButton(tab, "Silent Aim", false, function(s) end)
    Elements.createToggleButton(tab, "Show FOV Circle", true, function(s) end)
end
return Module
