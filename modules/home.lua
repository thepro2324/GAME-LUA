local Module = {}
function Module.init(tab, Elements)
    Elements.createLabel(tab, "Welcome to Ori Hub V12")
    Elements.createLabel(tab, "Status: Online")
    Elements.createButton(tab, "Join Discord", function() print("Discord link") end)
end
return Module
