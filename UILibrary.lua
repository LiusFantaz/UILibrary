local UILibrary = {}

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

function UILibrary:CreateWindow(config)
	config = config or {}

	local Window = {}
	local WindowTitle = "LiuzFantaz"

	--------------------------------------------------
	-- GUI
	--------------------------------------------------

	local ScreenGui = Instance.new("ScreenGui")
	ScreenGui.Name = "LiuzFantazUI"
	ScreenGui.ResetOnSpawn = false
	ScreenGui.Parent = PlayerGui

	--------------------------------------------------
	-- MAIN
	--------------------------------------------------

	local Main = Instance.new("Frame")
	Main.Size = UDim2.new(0,580,0,380)
	Main.Position = UDim2.new(0.5,-290,0.5,-190)
	Main.BackgroundColor3 = Color3.fromRGB(18,25,40)
	Main.BackgroundTransparency = 0.3
	Main.BorderSizePixel = 0
	Main.Parent = ScreenGui

	local MainCorner = Instance.new("UICorner")
	MainCorner.CornerRadius = UDim.new(0,14)
	MainCorner.Parent = Main

	local Glow = Instance.new("UIStroke")
	Glow.Color = Color3.fromRGB(70,140,255)
	Glow.Transparency = 0.2
	Glow.Thickness = 1.4
	Glow.Parent = Main

	local Gradient = Instance.new("UIGradient")
	Gradient.Color = ColorSequence.new{
		ColorSequenceKeypoint.new(0, Color3.fromRGB(50,90,255)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(20,35,65))
	}
	Gradient.Rotation = 90
	Gradient.Parent = Main

	--------------------------------------------------
	-- SIDEBAR
	--------------------------------------------------

	local Sidebar = Instance.new("Frame")
	Sidebar.Size = UDim2.new(0,155,1,0)
	Sidebar.BackgroundColor3 = Color3.fromRGB(12,18,30)
	Sidebar.BackgroundTransparency = 0.35
	Sidebar.BorderSizePixel = 0
	Sidebar.Parent = Main

	local SideCorner = Instance.new("UICorner")
	SideCorner.CornerRadius = UDim.new(0,14)
	SideCorner.Parent = Sidebar

	--------------------------------------------------
	-- TITLE
	--------------------------------------------------

	local Title = Instance.new("TextLabel")
	Title.Size = UDim2.new(1,-100,0,50)
	Title.Position = UDim2.new(0,14,0,0)
	Title.BackgroundTransparency = 1
	Title.Text = WindowTitle
	Title.Font = Enum.Font.GothamBold
	Title.TextSize = 21
	Title.TextXAlignment = Enum.TextXAlignment.Left
	Title.TextColor3 = Color3.fromRGB(255,255,255)
	Title.Parent = Sidebar

	--------------------------------------------------
	-- TOP ICONS
	--------------------------------------------------

	local Crown = Instance.new("TextLabel")
	Crown.Size = UDim2.new(0,24,0,24)
	Crown.Position = UDim2.new(1,-95,0,13)
	Crown.BackgroundTransparency = 1
	Crown.Text = "👑"
	Crown.Font = Enum.Font.GothamBold
	Crown.TextSize = 18
	Crown.TextColor3 = Color3.fromRGB(255,220,120)
	Crown.Parent = Main

	local Minimize = Instance.new("TextButton")
	Minimize.Size = UDim2.new(0,24,0,24)
	Minimize.Position = UDim2.new(1,-60,0,13)
	Minimize.BackgroundTransparency = 1
	Minimize.Text = "—"
	Minimize.Font = Enum.Font.GothamBold
	Minimize.TextSize = 18
	Minimize.TextColor3 = Color3.fromRGB(180,210,255)
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
	-- CONTENT
	--------------------------------------------------

	local Content = Instance.new("Frame")
	Content.Size = UDim2.new(1,-165,1,-20)
	Content.Position = UDim2.new(0,160,0,10)
	Content.BackgroundTransparency = 1
	Content.Parent = Main

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
	-- CLOSE CONFIRM
	--------------------------------------------------

	local ConfirmFrame = Instance.new("Frame")
	ConfirmFrame.Size = UDim2.new(0,240,0,120)
	ConfirmFrame.Position = UDim2.new(0.5,-120,0.5,-60)
	ConfirmFrame.BackgroundColor3 = Color3.fromRGB(20,28,45)
	ConfirmFrame.BackgroundTransparency = 0.15
	ConfirmFrame.Visible = false
	ConfirmFrame.Parent = Main

	local ConfirmCorner = Instance.new("UICorner")
	ConfirmCorner.CornerRadius = UDim.new(0,10)
	ConfirmCorner.Parent = ConfirmFrame

	local ConfirmText = Instance.new("TextLabel")
	ConfirmText.Size = UDim2.new(1,-20,0,50)
	ConfirmText.Position = UDim2.new(0,10,0,10)
	ConfirmText.BackgroundTransparency = 1
	ConfirmText.Text = "Do you really want to close?"
	ConfirmText.Font = Enum.Font.Gotham
	ConfirmText.TextSize = 14
	ConfirmText.TextColor3 = Color3.fromRGB(255,255,255)
	ConfirmText.Parent = ConfirmFrame

	local Yes = Instance.new("TextButton")
	Yes.Size = UDim2.new(0,90,0,34)
	Yes.Position = UDim2.new(0,20,1,-45)
	Yes.BackgroundColor3 = Color3.fromRGB(70,120,255)
	Yes.Text = "Yes"
	Yes.Font = Enum.Font.GothamBold
	Yes.TextSize = 14
	Yes.TextColor3 = Color3.fromRGB(255,255,255)
	Yes.Parent = ConfirmFrame

	local YesCorner = Instance.new("UICorner")
	YesCorner.CornerRadius = UDim.new(0,8)
	YesCorner.Parent = Yes

	local No = Instance.new("TextButton")
	No.Size = UDim2.new(0,90,0,34)
	No.Position = UDim2.new(1,-110,1,-45)
	No.BackgroundColor3 = Color3.fromRGB(45,55,80)
	No.Text = "No"
	No.Font = Enum.Font.GothamBold
	No.TextSize = 14
	No.TextColor3 = Color3.fromRGB(255,255,255)
	No.Parent = ConfirmFrame

	local NoCorner = Instance.new("UICorner")
	NoCorner.CornerRadius = UDim.new(0,8)
	NoCorner.Parent = No

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
					Size = UDim2.new(0,65,0,65)
				}
			):Play()

			Crown.Visible = true
			Title.Visible = false
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

			Title.Visible = true
		end
	end)

	--------------------------------------------------
	-- CLOSE
	--------------------------------------------------

	Close.MouseButton1Click:Connect(function()
		ConfirmFrame.Visible = true
	end)

	Yes.MouseButton1Click:Connect(function()
		ScreenGui:Destroy()
	end)

	No.MouseButton1Click:Connect(function()
		ConfirmFrame.Visible = false
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

	return Window
end

return UILibrary
