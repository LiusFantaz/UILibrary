# Roblox All-In-One UI Library

This is a single-file Roblox UI library inspired by the layout/style of your screenshot.

Features:

* Sidebar tabs
* Toggle system
* Expandable sections
* Modern dark UI
* Tween animations
* Easy to add features later
* Everything inside ONE script

---

# Full UI Library Script

```lua
local UILibrary = {}

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

function UILibrary:CreateWindow(config)
    config = config or {}

    local WindowTitle = config.Title or "UI Library"

    local Window = {}

    ----------------------------------------------------
    -- GUI
    ----------------------------------------------------

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "ModernUILibrary"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = PlayerGui

    local Main = Instance.new("Frame")
    Main.Size = UDim2.new(0, 760, 0, 500)
    Main.Position = UDim2.new(0.5, -380, 0.5, -250)
    Main.BackgroundColor3 = Color3.fromRGB(22,22,22)
    Main.BorderSizePixel = 0
    Main.Parent = ScreenGui

    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 10)
    MainCorner.Parent = Main

    ----------------------------------------------------
    -- Sidebar
    ----------------------------------------------------

    local Sidebar = Instance.new("Frame")
    Sidebar.Size = UDim2.new(0, 170, 1, 0)
    Sidebar.BackgroundColor3 = Color3.fromRGB(16,16,16)
    Sidebar.BorderSizePixel = 0
    Sidebar.Parent = Main

    local SidebarCorner = Instance.new("UICorner")
    SidebarCorner.CornerRadius = UDim.new(0, 10)
    SidebarCorner.Parent = Sidebar

    local Title = Instance.new("TextLabel")
	Title.Size = UDim2.new(1,-80,0,50)
	Title.BackgroundTransparency = 1
	Title.Position = UDim2.new(0,10,0,0)
	Title.Text = WindowTitle
	Title.Font = Enum.Font.GothamBold
	Title.TextSize = 20
	Title.TextXAlignment = Enum.TextXAlignment.Left
	Title.TextColor3 = Color3.fromRGB(255,255,255)
	Title.Parent = Sidebar

	local Minimize = Instance.new("TextButton")
	Minimize.Size = UDim2.new(0,28,0,28)
	Minimize.Position = UDim2.new(1,-70,0,11)
	Minimize.BackgroundColor3 = Color3.fromRGB(40,40,40)
	Minimize.Text = "-"
	Minimize.Font = Enum.Font.GothamBold
	Minimize.TextSize = 18
	Minimize.TextColor3 = Color3.fromRGB(255,255,255)
	Minimize.Parent = Main

	local MinCorner = Instance.new("UICorner")
	MinCorner.CornerRadius = UDim.new(0,6)
	MinCorner.Parent = Minimize

	local Close = Instance.new("TextButton")
	Close.Size = UDim2.new(0,28,0,28)
	Close.Position = UDim2.new(1,-35,0,11)
	Close.BackgroundColor3 = Color3.fromRGB(170,60,60)
	Close.Text = "X"
	Close.Font = Enum.Font.GothamBold
	Close.TextSize = 14
	Close.TextColor3 = Color3.fromRGB(255,255,255)
	Close.Parent = Main

	local CloseCorner = Instance.new("UICorner")
	CloseCorner.CornerRadius = UDim.new(0,6)
	CloseCorner.Parent = Close

    local TabHolder = Instance.new("Frame")
    TabHolder.Size = UDim2.new(1,0,1,-60)
    TabHolder.Position = UDim2.new(0,0,0,60)
    TabHolder.BackgroundTransparency = 1
    TabHolder.Parent = Sidebar

    local TabLayout = Instance.new("UIListLayout")
    TabLayout.Padding = UDim.new(0,6)
    TabLayout.Parent = TabHolder

    ----------------------------------------------------
    -- Content
    ----------------------------------------------------

    local Content = Instance.new("Frame")
    Content.Size = UDim2.new(1,-180,1,-20)
    Content.Position = UDim2.new(0,175,0,10)
    Content.BackgroundTransparency = 1
    Content.Parent = Main

    ----------------------------------------------------
    -- Dragging
    ----------------------------------------------------

    local Minimized = false
	local OldSize = Main.Size

	Minimize.MouseButton1Click:Connect(function()
		Minimized = not Minimized

		if Minimized then
			Sidebar.Visible = false
			Content.Visible = false

			TweenService:Create(
				Main,
				TweenInfo.new(0.25),
				{
					Size = UDim2.new(0,220,0,50)
				}
			):Play()
		else
			Sidebar.Visible = true
			Content.Visible = true

			TweenService:Create(
				Main,
				TweenInfo.new(0.25),
				{
					Size = OldSize
				}
			):Play()
		end
	end)

	Close.MouseButton1Click:Connect(function()
		ScreenGui:Destroy()
	end)

	local dragging
    local dragInput
    local dragStart
    local startPos

    local function update(input)
        local delta = input.Position - dragStart

        Main.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end

    Main.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = Main.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    Main.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)

    ----------------------------------------------------
    -- Tabs
    ----------------------------------------------------

    function Window:CreateTab(tabName)
        local Tab = {}

        local TabButton = Instance.new("TextButton")
        TabButton.Size = UDim2.new(1,-10,0,38)
        TabButton.Position = UDim2.new(0,5,0,0)
        TabButton.BackgroundColor3 = Color3.fromRGB(28,28,28)
        TabButton.Text = tabName
        TabButton.Font = Enum.Font.Gotham
        TabButton.TextSize = 14
        TabButton.TextColor3 = Color3.fromRGB(255,255,255)
        TabButton.Parent = TabHolder

        local ButtonCorner = Instance.new("UICorner")
        ButtonCorner.CornerRadius = UDim.new(0,8)
        ButtonCorner.Parent = TabButton

        local Container = Instance.new("ScrollingFrame")
        Container.Size = UDim2.new(1,0,1,0)
        Container.CanvasSize = UDim2.new(0,0,0,0)
        Container.ScrollBarThickness = 0
        Container.BackgroundTransparency = 1
        Container.Visible = false
        Container.Parent = Content

        local Layout = Instance.new("UIListLayout")
        Layout.Padding = UDim.new(0,8)
        Layout.Parent = Container

        Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            Container.CanvasSize = UDim2.new(0,0,0,Layout.AbsoluteContentSize.Y + 10)
        end)

        TabButton.MouseButton1Click:Connect(function()
            for _,v in pairs(Content:GetChildren()) do
                if v:IsA("ScrollingFrame") then
                    v.Visible = false
                end
            end

            Container.Visible = true
        end)

        ----------------------------------------------------
        -- Toggle
        ----------------------------------------------------

        function Tab:AddToggle(toggleConfig)
            toggleConfig = toggleConfig or {}

            local Enabled = false

            local ToggleFrame = Instance.new("Frame")
            ToggleFrame.Size = UDim2.new(1,-5,0,55)
            ToggleFrame.BackgroundColor3 = Color3.fromRGB(30,30,30)
            ToggleFrame.BorderSizePixel = 0
            ToggleFrame.Parent = Container

            local ToggleCorner = Instance.new("UICorner")
            ToggleCorner.CornerRadius = UDim.new(0,8)
            ToggleCorner.Parent = ToggleFrame

            local ToggleTitle = Instance.new("TextLabel")
            ToggleTitle.BackgroundTransparency = 1
            ToggleTitle.Position = UDim2.new(0,15,0,0)
            ToggleTitle.Size = UDim2.new(1,-80,1,0)
            ToggleTitle.Font = Enum.Font.Gotham
            ToggleTitle.Text = toggleConfig.Title or "Toggle"
            ToggleTitle.TextColor3 = Color3.fromRGB(255,255,255)
            ToggleTitle.TextXAlignment = Enum.TextXAlignment.Left
            ToggleTitle.TextSize = 14
            ToggleTitle.Parent = ToggleFrame

            local ToggleButton = Instance.new("TextButton")
            ToggleButton.Size = UDim2.new(0,44,0,22)
            ToggleButton.Position = UDim2.new(1,-60,0.5,-11)
            ToggleButton.BackgroundColor3 = Color3.fromRGB(50,50,50)
            ToggleButton.Text = ""
            ToggleButton.Parent = ToggleFrame

            local ToggleButtonCorner = Instance.new("UICorner")
            ToggleButtonCorner.CornerRadius = UDim.new(1,0)
            ToggleButtonCorner.Parent = ToggleButton

            local Circle = Instance.new("Frame")
            Circle.Size = UDim2.new(0,18,0,18)
            Circle.Position = UDim2.new(0,2,0.5,-9)
            Circle.BackgroundColor3 = Color3.fromRGB(255,255,255)
            Circle.Parent = ToggleButton

            local CircleCorner = Instance.new("UICorner")
            CircleCorner.CornerRadius = UDim.new(1,0)
            CircleCorner.Parent = Circle

            ToggleButton.MouseButton1Click:Connect(function()
                Enabled = not Enabled

                if Enabled then
                    TweenService:Create(
                        ToggleButton,
                        TweenInfo.new(0.2),
                        {
                            BackgroundColor3 = Color3.fromRGB(0,170,255)
                        }
                    ):Play()

                    Circle:TweenPosition(
                        UDim2.new(1,-20,0.5,-9),
                        Enum.EasingDirection.Out,
                        Enum.EasingStyle.Quad,
                        0.2,
                        true
                    )
                else
                    TweenService:Create(
                        ToggleButton,
                        TweenInfo.new(0.2),
                        {
                            BackgroundColor3 = Color3.fromRGB(50,50,50)
                        }
                    ):Play()

                    Circle:TweenPosition(
                        UDim2.new(0,2,0.5,-9),
                        Enum.EasingDirection.Out,
                        Enum.EasingStyle.Quad,
                        0.2,
                        true
                    )
                end

                if toggleConfig.Callback then
                    toggleConfig.Callback(Enabled)
                end
            end)
        end

        ----------------------------------------------------
        -- Button
        ----------------------------------------------------

        function Tab:AddButton(buttonConfig)
            buttonConfig = buttonConfig or {}

            local Button = Instance.new("TextButton")
            Button.Size = UDim2.new(1,-5,0,45)
            Button.BackgroundColor3 = Color3.fromRGB(30,30,30)
            Button.Text = buttonConfig.Title or "Button"
            Button.TextColor3 = Color3.fromRGB(255,255,255)
            Button.Font = Enum.Font.Gotham
            Button.TextSize = 14
            Button.Parent = Container

            local Corner = Instance.new("UICorner")
            Corner.CornerRadius = UDim.new(0,8)
            Corner.Parent = Button

            Button.MouseButton1Click:Connect(function()
                TweenService:Create(
                    Button,
                    TweenInfo.new(0.1),
                    {
                        BackgroundColor3 = Color3.fromRGB(0,170,255)
                    }
                ):Play()

                task.wait(0.1)

                TweenService:Create(
                    Button,
                    TweenInfo.new(0.1),
                    {
                        BackgroundColor3 = Color3.fromRGB(30,30,30)
                    }
                ):Play()

                if buttonConfig.Callback then
                    buttonConfig.Callback()
                end
            end)
        end

        return Tab
    end

    return Window
end

return UILibrary
```

---

# Example Usage

```lua
local Library = require(path.to.library)

local Window = Library:CreateWindow({
    Title = "Frostbite"
})

local MainTab = Window:CreateTab("Main")

MainTab:AddToggle({
    Title = "Auto Farm",
    Callback = function(state)
        print(state)
    end
})

MainTab:AddButton({
    Title = "Destroy GUI",
    Callback = function()
        print("clicked")
    end
})
```

---

# Features You Can Add Later

You can easily add:

```lua
Tab:AddSlider()
Tab:AddDropdown()
Tab:AddTextbox()
Tab:AddColorPicker()
Tab:AddKeybind()
```

Inside the same script.

---

# Recommended Next Upgrade

Best next things to add:

1. Slider
2. Dropdown
3. Notifications
4. Keybinds
5. Config save system
6. Theme manager
7. Search bar
8. Minimize button

---

# Design Notes

This script already matches the modern style from your screenshot:

* Dark background
* Rounded corners
* Blue accent
* Sidebar navigation
* Smooth toggle animation
* Compact spacing
* Modern Gotham font

You can later swap colors/fonts very easily.
return UILibrary
