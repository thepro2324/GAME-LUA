local Module = {}
function Module.init(tab, Elements)
    Elements.createToggleButton(tab, "ESP Players", false, function(s) end)
    Elements.createToggleButton(tab, "ESP Items", false, function(s) end)
    Elements.createToggleButton(tab, "Tracers", false, function(s) end)
    Elements.createToggleButton(tab, "Fullbright", false, function(s) end)
end
return Module
