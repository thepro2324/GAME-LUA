function Menu.init(parent, Elements, UIReferences, Localization, updateLangFunc, safeCall, PlayerMod, VisualsMod, WorldMod)
    print("🎨 מעצב את ה-UI...")

    -- 1. יצירת ה-ScreenGui
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "MyModernMenu"
    screenGui.Parent = parent

    -- 2. יצירת ה-Frame (התפריט)
    local frame = Instance.new("Frame")
    frame.Name = "MainFrame"
    frame.Size = UDim2.new(0, 350, 0, 450) -- גודל קצת יותר גדול ונוח
    frame.Position = UDim2.new(0.5, -175, 0.5, -225) -- ממורכז
    frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30) -- צבע אפור כהה יוקרתי
    frame.BorderSizePixel = 0 -- ביטול גבול רגיל
    frame.Parent = screenGui

    -- 3. הוספת פינות מעוגלות (UICorner)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 15) -- עיגול יפה בפינות
    corner.Parent = frame

    -- 4. הוספת מסגרת עדינה (UIStroke)
    local stroke = Instance.new("UIStroke")
    stroke.Thickness = 2
    stroke.Color = Color3.fromRGB(50, 50, 50) -- צבע מסגרת קצת יותר בהיר מהרקע
    stroke.Parent = frame

    -- 5. הוספת כותרת (TextLabel)
    local title = Instance.new("TextLabel")
    title.Text = "Menu"
    title.Size = UDim2.new(1, 0, 0, 50)
    title.BackgroundTransparency = 1
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.Font = Enum.Font.GothamBold
    title.TextSize = 24
    title.Parent = frame

    print("✨ ה-UI עוצב בהצלחה!")
end
