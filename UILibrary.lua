local UILibrary = {}

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

function UILibrary:CreateWindow(config)
	config = config or {}

	local Window = {}
	local WindowTitle = config.Title or "UI Library"

	local ScreenGui = Instance.new("ScreenGui")
	ScreenGui.Name = "ModernUILibrary"
	ScreenGui.ResetOnSpawn = false
	ScreenGui.Parent = PlayerGui

	local Main = Instance.new("Frame")
	Main.Size = UDim2.new(0, 620, 0, 420)
	Main.Position = UDim2.new(0.5, -310, 0.5, -210)
	Main.BackgroundColor3 = Color3.fromRGB(22,22,22)
	Main.BorderSizePixel = 0
	Main.Parent = ScreenGui

	local MainCorner = Instance.new("UICorner")
	MainCorner.CornerRadius = UDim.new(0,10)
	MainCorner.Parent = Main

	local Sidebar = Instance.new("Frame")
    Sidebar.Size = UDim2.new(0,150,1,0)	Sidebar.BackgroundColor3 = Color3.fromRGB(16,16,16)
	Sidebar.BorderSizePixel = 0
	Sidebar.Parent = Main

	local SidebarCorner = Instance.new("UICorner")
	SidebarCorner.CornerRadius = UDim.new(0,10)
	SidebarCorner.Parent = Sidebar

	local Title = Instance.new("TextLabel")
	Title.Size = UDim2.new(1,0,0,50)
	Title.BackgroundTransparency = 1
	Title.Text = WindowTitle
	Title.Font = Enum.Font.GothamBold
	Title.TextSize = 20
	Title.TextColor3 = Color3.fromRGB(255,255,255)
	Title.Parent = Sidebar

	local TabHolder = Instance.new("Frame")
	TabHolder.Size = UDim2.new(1,0,1,-60)
	TabHolder.Position = UDim2.new(0,0,0,60)
	TabHolder.BackgroundTransparency = 1
	TabHolder.Parent = Sidebar

	local TabLayout = Instance.new("UIListLayout")
	TabLayout.Padding = UDim.new(0,6)
	TabLayout.Parent = TabHolder

	local Content = Instance.new("Frame")
	Content.Size = UDim2.new(1,-160,1,-20)
	Content.Position = UDim2.new(0,155,0,10)
	Content.BackgroundTransparency = 1
	Content.Parent = Main

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
