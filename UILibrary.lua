local Fluent = loadstring(game:HttpGet("https://github.com/StyearX/Fluent-Modded/releases/download/Fluent/FluentLite"))()

local Window = Fluent:CreateWindow({
    Title = "Liuz HUB",
    SubTitle = "Private Script Hub",
    TabWidth = 160,
    Size = UDim2.fromOffset(600, 480),
    Acrylic = true,
    Theme = "AMOLED",
    MinimizeKey = Enum.KeyCode.RightShift,
    Search = true,
})

Window:AddWatermark("Liuz HUB")

-- ================== TABS ==================
local CombatTab   = Window:AddTab({ Title = "Combat",   Icon = "solar:shield-bold" })
local VisualsTab  = Window:AddTab({ Title = "Visuals",  Icon = "solar:eye-bold" })
local MiscTab     = Window:AddTab({ Title = "Misc",     Icon = "solar:settings-bold" })
local SettingsTab = Window:AddTab({ Title = "Settings", Icon = "solar:settings-bold" })

-- ================== COMBAT ==================
local CombatSection = CombatTab:AddSection("Combat Features")

CombatSection:AddToggle({
    Title = "Aim Assist",
    Description = "Smooth aim assistance",
    Default = false,
    Callback = function(state)
        print("Aim Assist:", state)
    end
})

CombatSection:AddSlider({
    Title = "Aim Smoothness",
    Description = "Lower = Stronger",
    Default = 50,
    Min = 0,
    Max = 100,
    Rounding = 0,
    Callback = function(value)
        print("Smoothness:", value)
    end
})

CombatSection:AddToggle({
    Title = "Silent Aim",
    Description = "Silent aimbot",
    Default = false,
    Callback = function(state)
        print("Silent Aim:", state)
    end
})

-- ================== VISUALS ==================
local VisualsSection = VisualsTab:AddSection("Visuals")

VisualsSection:AddToggle({
    Title = "ESP",
    Description = "Opponent ESP (Boxes + Names)",
    Default = false,
    Callback = function(state)
        print("ESP:", state)
    end
})

VisualsSection:AddToggle({
    Title = "Box ESP",
    Default = true,
    Callback = function(state) end
})

VisualsSection:AddToggle({
    Title = "Name ESP",
    Default = true,
    Callback = function(state) end
})

VisualsSection:AddToggle({
    Title = "Tracers",
    Default = true,
    Callback = function(state) end
})

-- ================== MISC ==================
local MiscSection = MiscTab:AddSection("Miscellaneous")

MiscSection:AddButton({
    Title = "Infinite Jump",
    Callback = function()
        Fluent:Notify({Title = "Infinite Jump", Content = "Coming Soon...", Duration = 3})
    end
})

-- ================== SETTINGS ==================
SettingsTab:AddButton({
    Title = "Destroy GUI",
    Callback = function()
        Window:Destroy()
    end
})

-- ================== NOTIFICATION ==================
Fluent:Notify({
    Title = "Liuz HUB",
    Content = "Successfully Loaded!",
    Duration = 5
})
