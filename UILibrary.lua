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

local VisualsSection = VisualsTab:AddSection("Visuals")
--[[
    ╔══════════════════════════════════════════════════════╗
    ║              ESP SYSTEM — Liuz HUB                   ║
    ║     Hooks into Fluent Lite (Liuz HUB) UI Library     ║
    ╚══════════════════════════════════════════════════════╝

    HOW TO USE:
      Paste this BELOW your existing UILibrary.lua code
      (after Window/Tabs/Sections are already created)
--]]

-- ──────────────────────────────────────────
--  SERVICES
-- ──────────────────────────────────────────
local Players     = game:GetService("Players")
local RunService  = game:GetService("RunService")
local Camera      = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

-- ──────────────────────────────────────────
--  ESP STATE
-- ──────────────────────────────────────────
local ESP = {
    Enabled      = false,
    Boxes        = true,
    Names        = true,
    Tracers      = true,
    Hitboxes     = false,
    TeamFilter   = true,
    EnemyColor   = Color3.fromRGB(255, 60, 60),
    TeamColor    = Color3.fromRGB(60, 200, 255),
    BoxThickness = 1.5,
    TracerThick  = 1,
    FillOpacity  = 0.08,
    MaxDist      = 1000,
}

-- ──────────────────────────────────────────
--  DRAWING CACHE  { [player] = {objects} }
-- ──────────────────────────────────────────
local Cache = {}

-- ──────────────────────────────────────────
--  HELPERS
-- ──────────────────────────────────────────
local function IsEnemy(player)
    if not ESP.TeamFilter then return true end
    return player.Team ~= LocalPlayer.Team
end

local function GetRoot(player)
    local char = player.Character
    if not char then return nil end
    return char:FindFirstChild("HumanoidRootPart") or char:FindFirstChildOfClass("Part")
end

local function NewDrawing(kind, props)
    local d = Drawing.new(kind)
    for k, v in pairs(props) do d[k] = v end
    return d
end

local function SetVisible(objects, v)
    for _, o in pairs(objects) do o.Visible = v end
end

local function GetBoundingBox(player)
    local char = player.Character
    if not char then return nil end
    local minX, minY =  math.huge,  math.huge
    local maxX, maxY = -math.huge, -math.huge
    local any = false
    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
            local h = part.Size / 2
            for sx = -1, 1, 2 do for sy = -1, 1, 2 do for sz = -1, 1, 2 do
                local cf = part.CFrame * CFrame.new(h.X*sx, h.Y*sy, h.Z*sz)
                local sp, on = Camera:WorldToViewportPoint(cf.Position)
                if on then
                    any  = true
                    minX = math.min(minX, sp.X); minY = math.min(minY, sp.Y)
                    maxX = math.max(maxX, sp.X); maxY = math.max(maxY, sp.Y)
                end
            end end end
        end
    end
    if not any then return nil end
    return minX, minY, maxX, maxY
end

-- ──────────────────────────────────────────
--  CREATE / REMOVE ESP OBJECTS PER PLAYER
-- ──────────────────────────────────────────
local function CreateObjects(player)
    if Cache[player] then return end
    local c = IsEnemy(player) and ESP.EnemyColor or ESP.TeamColor
    Cache[player] = {
        BoxTop    = NewDrawing("Line",   { Thickness=ESP.BoxThickness, Color=c, Visible=false, ZIndex=5 }),
        BoxBottom = NewDrawing("Line",   { Thickness=ESP.BoxThickness, Color=c, Visible=false, ZIndex=5 }),
        BoxLeft   = NewDrawing("Line",   { Thickness=ESP.BoxThickness, Color=c, Visible=false, ZIndex=5 }),
        BoxRight  = NewDrawing("Line",   { Thickness=ESP.BoxThickness, Color=c, Visible=false, ZIndex=5 }),
        BoxFill   = NewDrawing("Square", { Filled=true, Color=c, Transparency=ESP.FillOpacity, Visible=false, ZIndex=4 }),
        NameText  = NewDrawing("Text",   { Text=player.DisplayName, Size=13, Center=true, Outline=true, Color=Color3.new(1,1,1), Visible=false, ZIndex=6 }),
        Tracer    = NewDrawing("Line",   { Thickness=ESP.TracerThick, Color=c, Visible=false, ZIndex=3 }),
        Hitbox    = NewDrawing("Circle", { Thickness=1, Color=Color3.fromRGB(255,255,0), Filled=false, Visible=false, ZIndex=7 }),
    }
end

local function RemoveObjects(player)
    local o = Cache[player]
    if not o then return end
    for _, d in pairs(o) do d:Remove() end
    Cache[player] = nil
end

-- ──────────────────────────────────────────
--  PER-FRAME UPDATE
-- ──────────────────────────────────────────
local function Update()
    local vp = Camera.ViewportSize
    for _, player in ipairs(Players:GetPlayers()) do
        if player == LocalPlayer then continue end
        local o = Cache[player]
        if not o then continue end

        if ESP.TeamFilter and not IsEnemy(player) then
            SetVisible(o, false); continue
        end

        local root = GetRoot(player)
        if not root then SetVisible(o, false); continue end

        local lroot = GetRoot(LocalPlayer)
        if lroot and (root.Position - lroot.Position).Magnitude > ESP.MaxDist then
            SetVisible(o, false); continue
        end

        local rsp, onScreen = Camera:WorldToViewportPoint(root.Position)
        local rs2 = Vector2.new(rsp.X, rsp.Y)
        if not onScreen then SetVisible(o, false); continue end

        local color = IsEnemy(player) and ESP.EnemyColor or ESP.TeamColor
        local minX, minY, maxX, maxY = GetBoundingBox(player)

        -- BOX
        local showBox = ESP.Boxes and minX
        if showBox then
            o.BoxTop.From=Vector2.new(minX,minY);   o.BoxTop.To=Vector2.new(maxX,minY);    o.BoxTop.Color=color;    o.BoxTop.Visible=true
            o.BoxBottom.From=Vector2.new(minX,maxY); o.BoxBottom.To=Vector2.new(maxX,maxY); o.BoxBottom.Color=color; o.BoxBottom.Visible=true
            o.BoxLeft.From=Vector2.new(minX,minY);  o.BoxLeft.To=Vector2.new(minX,maxY);   o.BoxLeft.Color=color;   o.BoxLeft.Visible=true
            o.BoxRight.From=Vector2.new(maxX,minY); o.BoxRight.To=Vector2.new(maxX,maxY);  o.BoxRight.Color=color;  o.BoxRight.Visible=true
            o.BoxFill.Position=Vector2.new(minX,minY); o.BoxFill.Size=Vector2.new(maxX-minX,maxY-minY)
            o.BoxFill.Color=color; o.BoxFill.Transparency=ESP.FillOpacity; o.BoxFill.Visible=true
        else
            o.BoxTop.Visible=false; o.BoxBottom.Visible=false
            o.BoxLeft.Visible=false; o.BoxRight.Visible=false; o.BoxFill.Visible=false
        end

        -- NAME
        if ESP.Names and minY then
            o.NameText.Text     = player.DisplayName
            o.NameText.Position = Vector2.new(rs2.X, minY - 16)
            o.NameText.Visible  = true
        else
            o.NameText.Visible = false
        end

        -- TRACER
        if ESP.Tracers then
            o.Tracer.From    = Vector2.new(vp.X/2, vp.Y)
            o.Tracer.To      = Vector2.new(rs2.X, maxY or rs2.Y)
            o.Tracer.Color   = color
            o.Tracer.Visible = true
        else
            o.Tracer.Visible = false
        end

        -- HITBOX
        if ESP.Hitboxes then
            local char = player.Character
            local head = char and char:FindFirstChild("Head")
            if head then
                local hsp, hon, hdepth = Camera:WorldToViewportPoint(head.Position)
                if hon and hdepth > 0 then
                    local r = math.clamp((head.Size.X/2 / hdepth) * vp.Y, 4, 60)
                    o.Hitbox.Position = Vector2.new(hsp.X, hsp.Y)
                    o.Hitbox.Radius   = r
                    o.Hitbox.Visible  = true
                else
                    o.Hitbox.Visible = false
                end
            end
        else
            o.Hitbox.Visible = false
        end
    end
end

RunService.RenderStepped:Connect(function()
    if ESP.Enabled then Update() end
end)

-- ──────────────────────────────────────────
--  PLAYER LIFECYCLE
-- ──────────────────────────────────────────
local function OnAdded(player)
    player.CharacterAdded:Connect(function()
        task.wait(0.5)
        RemoveObjects(player)
        CreateObjects(player)
    end)
    if player.Character then
        task.wait(0.5)
        CreateObjects(player)
    end
end

for _, p in ipairs(Players:GetPlayers()) do
    if p ~= LocalPlayer then OnAdded(p) end
end
Players.PlayerAdded:Connect(function(p)
    if p ~= LocalPlayer then OnAdded(p) end
end)
Players.PlayerRemoving:Connect(RemoveObjects)

-- ──────────────────────────────────────────
--  WIRE UP EXISTING FLUENT TOGGLES
-- ──────────────────────────────────────────
VisualsSection:GetToggle("ESP"):OnChanged(function(state)
    ESP.Enabled = state
    if state then
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and not Cache[p] then CreateObjects(p) end
        end
    else
        for _, o in pairs(Cache) do SetVisible(o, false) end
    end
end)

VisualsSection:GetToggle("Box ESP"):OnChanged(function(state)  ESP.Boxes   = state end)
VisualsSection:GetToggle("Name ESP"):OnChanged(function(state) ESP.Names   = state end)
VisualsSection:GetToggle("Tracers"):OnChanged(function(state)  ESP.Tracers = state end)

-- ──────────────────────────────────────────
--  NEW CONTROLS ADDED TO VISUALS TAB
-- ──────────────────────────────────────────
VisualsSection:AddToggle({
    Title       = "Hitbox ESP",
    Description = "Show head hitbox circle",
    Default     = false,
    Callback    = function(state) ESP.Hitboxes = state end,
})

VisualsSection:AddToggle({
    Title       = "Team Filter",
    Description = "Hide teammates from ESP",
    Default     = true,
    Callback    = function(state) ESP.TeamFilter = state end,
})

VisualsSection:AddSlider({
    Title    = "Box Thickness",
    Default  = 2,
    Min      = 1,
    Max      = 5,
    Rounding = 0,
    Callback = function(v)
        ESP.BoxThickness = v
        for _, o in pairs(Cache) do
            for _, k in ipairs({"BoxTop","BoxBottom","BoxLeft","BoxRight"}) do
                if o[k] then o[k].Thickness = v end
            end
        end
    end,
})

VisualsSection:AddSlider({
    Title       = "Fill Opacity",
    Description = "0 = transparent  /  1 = solid",
    Default     = 0,
    Min         = 0,
    Max         = 1,
    Rounding    = 2,
    Callback    = function(v) ESP.FillOpacity = v end,
})

VisualsSection:AddSlider({
    Title    = "Max Distance (studs)",
    Default  = 1000,
    Min      = 50,
    Max      = 2000,
    Rounding = 0,
    Callback = function(v) ESP.MaxDist = v end,
})

VisualsSection:AddColorPicker({
    Title    = "Enemy Color",
    Default  = Color3.fromRGB(255, 60, 60),
    Callback = function(c) ESP.EnemyColor = c end,
})

VisualsSection:AddColorPicker({
    Title    = "Team Color",
    Default  = Color3.fromRGB(60, 200, 255),
    Callback = function(c) ESP.TeamColor = c end,
})

-- ──────────────────────────────────────────
Fluent:Notify({
    Title    = "ESP Ready",
    Content  = "ESP loaded! Enable it in the Visuals tab.",
    Duration = 4,
})


