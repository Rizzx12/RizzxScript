local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local character = player.Character or player.CharacterAdded:Wait()
local rootPart = character:WaitForChild("HumanoidRootPart")

local toggled = false

-- GUI hanya sekali
local screenGui = playerGui:FindFirstChild("CustomUI") or Instance.new("ScreenGui")
screenGui.Name = "CustomUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- Hapus frame lama jika ada
if screenGui:FindFirstChild("FlyFrame") then
	screenGui.FlyFrame:Destroy()
end

-- Buat Frame
local frame = Instance.new("Frame")
frame.Name = "FlyFrame"
frame.Size = UDim2.new(0, 180, 0, 100)
frame.Position = UDim2.new(0.5, 0, 0.3, 0)
frame.BackgroundColor3 = Color3.new(0, 0, 0)
frame.BackgroundTransparency = 0.5
frame.Parent = screenGui
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)

-- Drag support Mouse + Touch
local dragging = false
local dragStart = Vector2.new()
local startPos = UDim2.new()

local function updateDrag(input)
	local delta = input.Position - dragStart
	frame.Position = UDim2.new(
		startPos.X.Scale, startPos.X.Offset + delta.X,
		startPos.Y.Scale, startPos.Y.Offset + delta.Y
	)
end

frame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = frame.Position

		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
		updateDrag(input)
	end
end)

-- Label
local label = Instance.new("TextLabel")
label.Size = UDim2.new(0, 100, 0, 40)
label.Position = UDim2.new(0.25, 0, 0.05, 0)
label.BackgroundTransparency = 1
label.Text = "Fly"
label.TextColor3 = Color3.new(1, 1, 1)
label.Font = Enum.Font.FredokaOne
label.TextSize = 30
label.Parent = frame
Instance.new("UICorner", label).CornerRadius = UDim.new(0, 8)

-- Tombol
local button = Instance.new("TextButton")
button.Size = UDim2.new(0, 150, 0, 50)
button.Position = UDim2.new(0.079, 0, 0, 43)
button.Text = "Fly: Off"
button.Font = Enum.Font.FredokaOne
button.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
button.BackgroundTransparency = 0.5
button.TextColor3 = Color3.new(1, 1, 1)
button.TextSize = 20
button.Parent = frame
Instance.new("UICorner", button).CornerRadius = UDim.new(0, 8)

-- Fungsi fly
local function setNonclip(state)
	character = player.Character or player.CharacterAdded:Wait()
	rootPart = character:WaitForChild("HumanoidRootPart")

	for _, part in character:GetDescendants() do
		if part:IsA("BasePart") then
			part.CanCollide = not state
			if state then
				part.CustomPhysicalProperties = PhysicalProperties.new(0, 0, 0)
			else
				part.CustomPhysicalProperties = PhysicalProperties.new(1, 0.3, 0.5)
			end
		end
	end

	local humanoid = character:FindFirstChildOfClass("Humanoid")
	if humanoid then
		humanoid.PlatformStand = state
		if state then
			humanoid:ChangeState(Enum.HumanoidStateType.Flying)
		else
			humanoid:ChangeState(Enum.HumanoidStateType.RunningNoPhysics)
		end
	end
end

-- Toggle
button.MouseButton1Click:Connect(function()
	toggled = not toggled
	button.Text = toggled and "Fly: On" or "Fly: Off"
	setNonclip(toggled)
end)

-- Saat character reset
player.CharacterAdded:Connect(function(char)
	character = char
	rootPart = character:WaitForChild("HumanoidRootPart")
	task.wait(0.5)
	if toggled then
		setNonclip(true)
	end
end)

-- Proteksi utama
RunService.RenderStepped:Connect(function()
	if not character or not character.Parent then return end

	if toggled and rootPart and rootPart:IsDescendantOf(character) then
		local moveDir = player:GetMouse().Hit.LookVector
		rootPart.Velocity = moveDir * 40

		local humanoid = character:FindFirstChildOfClass("Humanoid")
		if humanoid then
			humanoid:ChangeState(Enum.HumanoidStateType.Flying)
		end
	end

	local humanoid = character:FindFirstChildOfClass("Humanoid")
	if not humanoid then
		local newHumanoid = Instance.new("Humanoid")
		newHumanoid.Name = "Humanoid"
		newHumanoid.MaxHealth = 100
		newHumanoid.Health = 100
		newHumanoid.BreakJointsOnDeath = false
		newHumanoid.Parent = character
		humanoid = newHumanoid
	end

	if humanoid then
		humanoid.Health = 100
		humanoid.MaxHealth = 100
		humanoid.BreakJointsOnDeath = false
		humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
		humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
		humanoid:SetStateEnabled(Enum.HumanoidStateType.Physics, false)
		humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
	end

	if not rootPart or not rootPart:IsDescendantOf(character) then
		local found = character:FindFirstChild("HumanoidRootPart")
		if found then
			rootPart = found
		else
			local newRoot = Instance.new("Part")
			newRoot.Name = "HumanoidRootPart"
			newRoot.Size = Vector3.new(2, 2, 1)
			newRoot.Anchored = false
			newRoot.CanCollide = false
			newRoot.Transparency = 1
			newRoot.Position = character:GetModelCFrame().Position
			newRoot.Parent = character
			character.PrimaryPart = newRoot
			rootPart = newRoot
		end
	end
end)

-- Loop agar semua part karakter tetap tembus saat Fly aktif
RunService.Stepped:Connect(function()
	if toggled and character then
		for _, part in pairs(character:GetDescendants()) do
			if part:IsA("BasePart") then
				part.CanCollide = false
			end
		end
	end
end)

-- Ubah semua ProximityPrompt jadi 0.5 detik
local function updateAllPrompts()
	for _, prompt in ipairs(workspace:GetDescendants()) do
		if prompt:IsA("ProximityPrompt") then
			prompt.HoldDuration = 0.5
			prompt.Enabled = true
		end
	end
end

updateAllPrompts()

-- Jika ada prompt baru muncul, langsung ubah juga
workspace.DescendantAdded:Connect(function(desc)
	if desc:IsA("ProximityPrompt") then
		task.wait()
		desc.HoldDuration = 0.5
		desc.Enabled = true
	end
end)