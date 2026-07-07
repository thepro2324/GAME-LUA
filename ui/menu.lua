local Menu = {}

function Menu.init(parent, Elements, UIReferences, Localization, updateLangFunc, safeCall, PlayerMod, VisualsMod, WorldMod)
    print("🚀 המודול התחיל ליצור את ה-UI...")

    -- יצירת ה-ScreenGui החדש
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "MyAutoMenuGui"
    screenGui.Parent = parent -- כאן ה-parent הוא ה-PlayerGui ששלחנו מה-loader

    -- יצירת ה-Frame בתוך ה-ScreenGui
    local frame = Instance.new("Frame")
    frame.Name = "MainFrame"
    frame.Size = UDim2.new(0, 300, 0, 400)
    frame.Position = UDim2.new(0.5, -150, 0.5, -200)
    frame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    frame.Parent = screenGui
    
    print("✅ ה-Frame נוצר בהצלחה!")
end

return Menu
