local UILibrary = {}

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

function UILibrary:CreateWindow(config)
	config = config or {}

	local Window = {}
	local WindowTitle = config.Title or "Frostbite"

	local ScreenGui = Instance.new("ScreenGui")
	ScreenGui.Name = "FrostbiteUI"
	ScreenGui.ResetOnSpawn = false
	ScreenGui.Parent = PlayerGui

	--------------------------------------------------
	-- MAIN
	--------------------------------------------------

	local Main = Instance.new("Frame")
	Main.Size = UDim2.new(0,580,0,380)
	Main.Position = UDim2.new(0.5,-290,0.5,-190)
	Main.BackgroundColor3 = Color3.fromRGB(18,22,32)
	Main.BackgroundTransparency = 0.08
	Main.BorderSizePixel = 0
	Main.Parent = ScreenGui

	local MainCorner = Instance.new("UICorner")
	MainCorner.CornerRadius = UDim.new(0,12)
	MainCorner.Parent = Main

	local Stroke = Instance.new("UIStroke")
	Stroke.Color = Color3.fromRGB(70,120,255)
	Stroke.Transparency = 0.5
	Stroke.Thickness = 1
	Stroke.Parent = Main

	--------------------------------------------------
	-- SIDEBAR
	--------------------------------------------------

	local Sidebar = Instance.new("Frame")
	Sidebar.Size = UDim2.new(0,150,1,0)
	Sidebar.BackgroundColor3 = Color3.fromRGB(14,18,28)
	Sidebar.BackgroundTransparency = 0.12
	Sidebar.BorderSizePixel = 0
	Sidebar.Parent = Main

	local SideCorner = Instance.new("UICorner")
	SideCorner.CornerRadius = UDim.new(0,12)
	SideCorner.Parent = Sidebar

	local Title = Instance.new("TextLabel")
	Title.Size = UDim2.new(1,-70,0,50)
	Title.Position = UDim2.new(0,14,0,0)
	Title.BackgroundTransparency = 1
	Title.Text = WindowTitle
	Title.Font = Enum.Font.GothamBold
	Title.TextSize = 20
	Title.TextXAlignment = Enum.TextXAlignment.Left
	Title.TextColor3 = Color3.fromRGB(255,255,255)
	Title.Parent = Sidebar

	--------------------------------------------------
	-- BUTTONS
	--------------------------------------------------

	local Minimize = Instance.new("TextButton")
	Minimize.Size = UDim2.new(0,24,0,24)
	Minimize.Position = UDim2.new(1,-58,0,13)
	Minimize.BackgroundTransparency = 1
	Minimize.Text = "—"
	Minimize.Font = Enum.Font.GothamBold
	Minimize.TextSize = 18
	Minimize.TextColor3 = Color3.fromRGB(180,200,255)
	Minimize.Parent = Main

	local Close = Instance.new("TextButton")
	Close.Size = UDim2.new(0,24,0,24)
	Close.Position = UDim2.new(1,-30,0,13)
	Close.BackgroundTransparency = 1
	Close.Text = "✕"
	Close.Font = Enum.Font.GothamBold
	Close.TextSize = 16
	Close.TextColor3 = Color3.fromRGB(255,120,120)
	Close.Parent = Main

	--------------------------------------------------
	-- TAB HOLDER
	--------------------------------------------------

	local TabHolder = Instance.new("Frame")
	TabHolder.Size = UDim2.new(1,0,1,-60)
	TabHolder.Position = UDim2.new(0,0,0,60)
	TabHolder.BackgroundTransparency = 1
	TabHolder.Parent = Sidebar

	local TabLayout = Instance.new("UIListLayout")
	TabLayout.Padding = UDim.new(0,6)
	TabLayout.Parent = TabHolder

	--------------------------------------------------
	-- CONTENT
	--------------------------------------------------

	local Content = Instance.new("Frame")
	Content.Size = UDim2.new(1,-160,1,-20)
	Content.Position = UDim2.new(0,155,0,10)
	Content.BackgroundTransparency = 1
	Content.Parent = Main

	--------------------------------------------------
	-- MINIMIZE
	--------------------------------------------------

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

	--------------------------------------------------
	-- CLOSE
	--------------------------------------------------

	Close.MouseButton1Click:Connect(function()
		ScreenGui:Destroy()
	end)

	--------------------------------------------------
	-- DRAGGING
	--------------------------------------------------

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

	--------------------------------------------------
	-- TABS
	--------------------------------------------------

	function Window:CreateTab(tabName)
		local Tab = {}

		local TabButton = Instance.new("TextButton")
		TabButton.Size = UDim2.new(1,-10,0,36)
		TabButton.Position = UDim2.new(0,5,0,0)
		TabButton.BackgroundColor3 = Color3.fromRGB(30,40,65)
		TabButton.BackgroundTransparency = 0.15
		TabButton.Text = tabName
		TabButton.Font = Enum.Font.Gotham
		TabButton.TextSize = 14
		TabButton.TextColor3 = Color3.fromRGB(255,255,255)
		TabButton.Parent = TabHolder

		local TabCorner = Instance.new("UICorner")
		TabCorner.CornerRadius = UDim.new(0,8)
		TabCorner.Parent = TabButton

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

		--------------------------------------------------
		-- TOGGLE
		--------------------------------------------------

		function Tab:AddToggle(cfg)
			cfg = cfg or {}

			local Enabled = false

			local ToggleFrame = Instance.new("Frame")
			ToggleFrame.Size = UDim2.new(1,-5,0,50)
			ToggleFrame.BackgroundColor3 = Color3.fromRGB(26,34,55)
			ToggleFrame.BackgroundTransparency = 0.1
			ToggleFrame.BorderSizePixel = 0
			ToggleFrame.Parent = Container

			local Corner = Instance.new("UICorner")
			Corner.CornerRadius = UDim.new(0,8)
			Corner.Parent = ToggleFrame

			local Label = Instance.new("TextLabel")
			Label.BackgroundTransparency = 1
			Label.Position = UDim2.new(0,15,0,0)
			Label.Size = UDim2.new(1,-80,1,0)
			Label.Font = Enum.Font.Gotham
			Label.Text = cfg.Title or "Toggle"
			Label.TextColor3 = Color3.fromRGB(255,255,255)
			Label.TextXAlignment = Enum.TextXAlignment.Left
			Label.TextSize = 14
			Label.Parent = ToggleFrame

			local Toggle = Instance.new("TextButton")
			Toggle.Size = UDim2.new(0,42,0,22)
			Toggle.Position = UDim2.new(1,-58,0.5,-11)
			Toggle.BackgroundColor3 = Color3.fromRGB(50,50,50)
			Toggle.Text = ""
			Toggle.Parent = ToggleFrame

			local ToggleCorner = Instance.new("UICorner")
			ToggleCorner.CornerRadius = UDim.new(1,0)
			ToggleCorner.Parent = Toggle

			local Circle = Instance.new("Frame")
			Circle.Size = UDim2.new(0,18,0,18)
			Circle.Position = UDim2.new(0,2,0.5,-9)
			Circle.BackgroundColor3 = Color3.fromRGB(255,255,255)
			Circle.Parent = Toggle

			local CircleCorner = Instance.new("UICorner")
			CircleCorner.CornerRadius = UDim.new(1,0)
			CircleCorner.Parent = Circle

			Toggle.MouseButton1Click:Connect(function()
				Enabled = not Enabled

				if Enabled then
					TweenService:Create(
						Toggle,
						TweenInfo.new(0.2),
						{
							BackgroundColor3 = Color3.fromRGB(70,120,255)
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
						Toggle,
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

				if cfg.Callback then
					cfg.Callback(Enabled)
				end
			end)
		end

		--------------------------------------------------
		-- BUTTON
		--------------------------------------------------

		function Tab:AddButton(cfg)
			cfg = cfg or {}

			local Button = Instance.new("TextButton")
			Button.Size = UDim2.new(1,-5,0,45)
			Button.BackgroundColor3 = Color3.fromRGB(30,40,65)
			Button.BackgroundTransparency = 0.1
			Button.Text = cfg.Title or "Button"
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
					TweenInfo.new(0.12),
					{
						BackgroundColor3 = Color3.fromRGB(70,120,255)
					}
				):Play()

				task.wait(0.12)

				TweenService:Create(
					Button,
					TweenInfo.new(0.12),
					{
						BackgroundColor3 = Color3.fromRGB(30,40,65)
					}
				):Play()

				if cfg.Callback then
					cfg.Callback()
				end
			end)
		end

		return Tab
	end

	return Window
end

return UILibrary
