local Module = {}
function Module.init(tab, Elements)
    Elements.createToggleButton(tab, "WalkSpeed", false, function(s) end)
    Elements.createSlider(tab, "Speed Value", 16, 200, 16, function(v) end)
    Elements.createToggleButton(tab, "Infinite Jump", false, function(s) end)
    Elements.createToggleButton(tab, "Noclip", false, function(s) end)
    Elements.createButton(tab, "Reset Character", function() end)
end
return Module
