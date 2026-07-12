local Module = {}
function Module.init(tab, Elements)
    Elements.createSlider(tab, "Time of Day", 0, 24, 12, function(v) end)
    Elements.createToggleButton(tab, "No Fog", true, function(s) end)
    Elements.createButton(tab, "Remove Parts", function() end)
end
return Module
