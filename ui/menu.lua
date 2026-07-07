local HomeMod = {}

function HomeMod.init(tab, Elements, UIReferences, Localization, updateLangFunc, safeCall, PlayerMod, VisualsMod, WorldMod)
    -- הגנה: אם Localization לא הגיע, אנחנו מגדירים אותו כטבלה ריקה כדי לא לקרוס
    if not Localization then 
        warn("Localization is NIL! Using default.") 
        Localization = { HE = { Welcome = "Default Welcome" } } 
    end

    -- הגנה על HE
    local lang = Localization.HE or { Welcome = "Default Welcome" }

    -- עכשיו הקוד שלך בטוח לשימוש
    UIReferences.welcomeLabel = Instance.new("TextLabel", tab)
    UIReferences.welcomeLabel.Text = lang.Welcome -- זה לא יקרוס יותר!
    
    print("HomeMod initialized successfully")
end

return HomeMod
