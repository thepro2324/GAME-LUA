local Module = {}

function Module.init(tab, Elements)
    Elements.createLabel(tab, "Welcome to Ori Hub V12")
    
    Elements.createButton(tab, "Copy Discord Link", function()
        setclipboard("https://discord.gg/fFwaNja5tj")
        print("Discord link copied to clipboard!")
    end)
end

return Module
