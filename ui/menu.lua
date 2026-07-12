-- =========================================================================
-- ORI HUB - DIAGNOSTIC MODE (בודק רק אם ה-UI עובד)
-- =========================================================================
local CoreGui = game:GetService("CoreGui")
if CoreGui:FindFirstChild("OriHub") then CoreGui:FindFirstChild("OriHub"):Destroy() end

local screen = Instance.new("ScreenGui", CoreGui); screen.Name = "OriHub"
local frame = Instance.new("Frame", screen); frame.Size = UDim2.new(0, 600, 0, 400); frame.Position = UDim2.new(0.5, -300, 0.5, -200)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20); frame.Active = true; frame.Draggable = true
local sidebar = Instance.new("Frame", frame); sidebar.Size = UDim2.new(0, 150, 1, 0); sidebar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
local content = Instance.new("Frame", frame); content.Size = UDim2.new(1, -150, 1, 0); content.Position = UDim2.new(0, 150, 0, 0); content.BackgroundTransparency = 1

local Tabs = {}
local function createTab(name)
    local page = Instance.new("ScrollingFrame", content); page.Size = UDim2.new(1, 0, 1, 0); page.BackgroundTransparency = 1; page.Visible = false; page.AutomaticCanvasSize = Enum.AutomaticSize.Y
    Instance.new("UIListLayout", page).Padding = UDim.new(0, 10)
    Tabs[name] = page
    return page
end

local categories = {"Home", "Player"}
for _, name in pairs(categories) do
    local tab = createTab(name)
    local btn = Instance.new("TextButton", sidebar); btn.Size = UDim2.new(1, 0, 0, 40); btn.Text = name
    btn.MouseButton1Click:Connect(function()
        for _, t in pairs(Tabs) do t.Visible = false end
        tab.Visible = true
        
        -- ניסוי: אם לחצת על Player, אנחנו יוצרים כפתור בדיקה ידני
        if name == "Player" then
            print("Creating test button...")
            local testBtn = Instance.new("TextButton", tab)
            testBtn.Size = UDim2.new(0, 200, 0, 50); testBtn.Text = "כפתור בדיקה עובד!"
            testBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
        end
    end)
end
