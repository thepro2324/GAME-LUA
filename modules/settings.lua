local Module = {}
function Module.init(tab, Elements)
    Elements.createToggleButton(tab, "UI Toggle (Press Insert)", true, function(s) end)
    Elements.createButton(tab, "Destroy GUI", function() game:GetService("CoreGui").OriHub:Destroy() end)
    Elements.createLabel(tab, "Version: 1.2.0")
end
return Module
