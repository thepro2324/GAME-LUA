local Module = {}
function Module.init(parent, Elements)
    Elements.createToggleButton(parent, "Fullbright", false, function(s) end)
    Elements.createToggleButton(parent, "No Fog", false, function(s) end)
end
return Module
