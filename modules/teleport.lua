local Module = {}
function Module.init(tab, Elements)
    Elements.createButton(tab, "Teleport to Spawn", function() end)
    Elements.createButton(tab, "Teleport to Center", function() end)
    Elements.createToggleButton(tab, "Click TP", false, function(s) end)
end
return Module
