
-- BrainHub Full Script
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local rootPart = character:WaitForChild("HumanoidRootPart")

-- UI Setup
local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.Name = "BrainHub"
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 200, 0, 300)
frame.Position = UDim2.new(0, 10, 0.5, -150)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.Active = true
frame.Draggable = true

-- Button generator
local function createButton(name, position, parent)
	local button = Instance.new("TextButton", parent)
	button.Size = UDim2.new(1, -20, 0, 30)
	button.Position = UDim2.new(0, 10, 0, position)
	button.Text = name
	button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	button.TextColor3 = Color3.new(1,1,1)
	button.Font = Enum.Font.SourceSansBold
	button.TextScaled = true
	return button
end

-- Buttons
local btnFly = createButton("Fly", 10, frame)
local btnCollect = createButton("Auto Collect", 50, frame)
local btnESP = createButton("ESP Toggle", 90, frame)
local btnSpeed = createButton("Speed Hack", 130, frame)
local btnInvisible = createButton("Invisibility", 170, frame)
local btnRebirth = createButton("Auto Rebirth", 210, frame)
local btnTeleport = createButton("Teleport Spawn", 250, frame)

-- Fly toggle
local flying = false
btnFly.MouseButton1Click:Connect(function()
	flying = not flying
	local bp = Instance.new("BodyPosition", rootPart)
	bp.MaxForce = Vector3.new(1e9, 1e9, 1e9)
	while flying do
		bp.Position = rootPart.Position + Vector3.new(0, 5, 0)
		RunService.RenderStepped:Wait()
	end
	bp:Destroy()
end)

-- Auto Collect
local collecting = false
btnCollect.MouseButton1Click:Connect(function()
	collecting = not collecting
	while collecting do
		for _,obj in pairs(workspace:GetDescendants()) do
			if obj:IsA("BasePart") and obj.Name:lower():find("brain") then
				rootPart.CFrame = obj.CFrame
				wait(0.1)
			end
		end
		wait(0.1)
	end
end)

-- ESP
local espEnabled = false
btnESP.MouseButton1Click:Connect(function()
	espEnabled = not espEnabled

	-- Player ESP
	for _, plr in pairs(Players:GetPlayers()) do
		if plr ~= player and plr.Character and plr.Character:FindFirstChild("Head") then
			local head = plr.Character.Head
			if espEnabled and not head:FindFirstChild("ESP") then
				local bill = Instance.new("BillboardGui", head)
				bill.Name = "ESP"
				bill.Size = UDim2.new(0,100,0,40)
				bill.AlwaysOnTop = true
				local label = Instance.new("TextLabel", bill)
				label.Size = UDim2.new(1,0,1,0)
				label.BackgroundTransparency = 1
				label.Text = plr.Name
				label.TextColor3 = Color3.new(1,0,0)
				label.TextScaled = true
				label.Font = Enum.Font.SourceSansBold
			elseif head:FindFirstChild("ESP") then
				head:FindFirstChild("ESP"):Destroy()
			end
		end
	end

	-- Brain ESP
	for _, obj in pairs(workspace:GetDescendants()) do
		if obj:IsA("BasePart") then
			local name = obj.Name:lower()
			if name:find("brain") or name:find("god") or name:find("secret") then
				if espEnabled and not obj:FindFirstChild("BrainESP") then
					local esp = Instance.new("BillboardGui", obj)
					esp.Name = "BrainESP"
					esp.Size = UDim2.new(0, 100, 0, 25)
					esp.AlwaysOnTop = true
					esp.StudsOffset = Vector3.new(0, 2, 0)

					local label = Instance.new("TextLabel", esp)
					label.Size = UDim2.new(1, 0, 1, 0)
					label.BackgroundTransparency = 1
					label.Text = obj.Name
					label.TextScaled = true
					label.Font = Enum.Font.SourceSansBold

					if name:find("secret") then
						label.TextColor3 = Color3.fromRGB(255, 0, 255)
					elseif name:find("god") then
						label.TextColor3 = Color3.fromRGB(255, 215, 0)
					else
						label.TextColor3 = Color3.fromRGB(0, 255, 255)
					end
				elseif not espEnabled and obj:FindFirstChild("BrainESP") then
					obj:FindFirstChild("BrainESP"):Destroy()
				end
			end
		end
	end
end)

-- Speed Hack
btnSpeed.MouseButton1Click:Connect(function()
	character:WaitForChild("Humanoid").WalkSpeed = 100
end)

-- Invisible
btnInvisible.MouseButton1Click:Connect(function()
	for _,part in pairs(character:GetDescendants()) do
		if part:IsA("BasePart") then
			part.Transparency = 1
			if part:FindFirstChild("face") then
				part.face:Destroy()
			end
		end
	end
end)

-- Auto Rebirth
btnRebirth.MouseButton1Click:Connect(function()
	if workspace:FindFirstChild("Rebirth") then
		rootPart.CFrame = workspace.Rebirth.CFrame
	end
end)

-- Teleport Spawn
btnTeleport.MouseButton1Click:Connect(function()
	local spawn = workspace:FindFirstChild("SpawnLocation")
	if spawn then
		rootPart.CFrame = CFrame.new(spawn.Position)
	end
end)

(function()
	for _,part in pairs(character:GetDescendants()) do
		if part:IsA("BasePart") then
			part.Transparency = 1
			if part:FindFirstChild("face") then
				part.face:Destroy()
			end
		end
	end
end)

-- Auto Rebirth
buttons["Auto Rebirth"].MouseButton1Click:Connect(function()
	if workspace:FindFirstChild("Rebirth") then
		rootPart.CFrame = workspace.Rebirth.CFrame
	end
end)

-- Teleport to Spawn
buttons["Teleport Spawn"].MouseButton1Click:Connect(function()
	local spawn = workspace:FindFirstChild("SpawnLocation")
	if spawn then
		rootPart.CFrame = CFrame.new(spawn.Position)
	end
end)

-- Anti Ragdoll
buttons["Anti Ragdoll"].MouseButton1Click:Connect(function()
	for _,v in pairs(character:GetDescendants()) do
		if v:IsA("Motor6D") then
			v.Enabled = true
		end
	end
end)

-- Anti Fall Damage
buttons["Anti Fall Damage"].MouseButton1Click:Connect(function()
	character:WaitForChild("Humanoid").StateChanged:Connect(function(_, new)
		if new == Enum.HumanoidStateType.Freefall then
			character.Humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
		end
	end)
end)

-- Godmode
buttons["Godmode"].MouseButton1Click:Connect(function()
	character:WaitForChild("Humanoid").Health = math.huge
	character:WaitForChild("Humanoid").MaxHealth = math.huge
end)

-- Noclip
local noclip = false
buttons["Noclip"].MouseButton1Click:Connect(function()
	noclip = not noclip
	RunService.Stepped:Connect(function()
		if noclip then
			for _,v in pairs(character:GetDescendants()) do
				if v:IsA("BasePart") and v.CanCollide then
					v.CanCollide = false
				end
			end
		end
	end)
end)

-- Toggle UI with F4
UserInputService.InputBegan:Connect(function(input, processed)
	if input.KeyCode == Enum.KeyCode.F4 and not processed then
		gui.Enabled = not gui.Enabled
	end
end)
