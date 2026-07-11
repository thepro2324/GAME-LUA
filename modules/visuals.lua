local Module = {}
function Module.init(parent, Elements)
    Elements.createToggleButton(parent, "ESP Players", false, function(s) end)
    Elements.createToggleButton(parent, "ESP Items", false, function(s) end)
    Elements.createToggleButton(parent, "Chams", false, function(s) end)
end
return Module
