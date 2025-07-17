
-- NOTE: This is a RECONSTRUCTED version including new features like:
-- Auto Lock Brain, ESP with Distance, Sound Mute, Theme Toggle, etc.
-- You can paste your original BrainHub base code above here if needed.

-- Example placeholder GUI frame, rootPart, and buttons simulation
-- Add the rest of the working BrainHub script above here

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local rootPart = character:WaitForChild("HumanoidRootPart")
local gui = player:WaitForChild("PlayerGui"):WaitForChild("ScreenGui")
local frame = gui:WaitForChild("BackgroundFrame")

-- Example buttons dictionary simulation (this should match your GUI structure)
local buttons = {}
for _, child in ipairs(frame:GetChildren()) do
    if child:IsA("TextButton") then
        buttons[child.Name] = child
    end
end

-- === Fitur Tambahan ===

-- Auto Lock Target Brainot
local lockBrainot = false
buttons["Auto Collect"].Text = "Auto Lock Brain"
buttons["Auto Collect"].MouseButton1Click:Connect(function()
	lockBrainot = not lockBrainot
	while lockBrainot do
		local closest, distance = nil, math.huge
		for _,obj in pairs(workspace:GetDescendants()) do
			if obj:IsA("BasePart") and obj.Name:lower():find("brain") then
				local dist = (rootPart.Position - obj.Position).Magnitude
				if dist < distance then
					closest = obj
					distance = dist
				end
			end
		end
		if closest then
			rootPart.CFrame = closest.CFrame + Vector3.new(0, 3, 0)
		end
		wait(0.2)
	end
end)

-- ESP with Distance Indicator
local espEnabled = false
buttons["ESP Toggle"].MouseButton1Click:Connect(function()
	espEnabled = not espEnabled
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
					label.TextScaled = true
					label.Font = Enum.Font.SourceSansBold
					label.TextColor3 = Color3.fromRGB(255, 255, 0)
					RunService.RenderStepped:Connect(function()
						if obj and rootPart then
							local dist = math.floor((rootPart.Position - obj.Position).Magnitude)
							label.Text = obj.Name .. " ["..dist.." studs]"
						end
					end)
				elseif not espEnabled and obj:FindFirstChild("BrainESP") then
					obj:FindFirstChild("BrainESP"):Destroy()
				end
			end
		end
	end
end)

-- Sound Muter
local muted = false
local muteButton = Instance.new("TextButton", frame)
muteButton.Name = "MuteSound"
muteButton.Size = UDim2.new(0, 180, 0, 30)
muteButton.Position = UDim2.new(0, 10, 0, 400)
muteButton.Text = "Mute Game Sound"
muteButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
muteButton.TextColor3 = Color3.new(1,1,1)
muteButton.MouseButton1Click:Connect(function()
	muted = not muted
	for _, s in pairs(workspace:GetDescendants()) do
		if s:IsA("Sound") then
			s.Playing = not muted
		end
	end
end)

-- Custom GUI Theme
local themeButton = Instance.new("TextButton", frame)
themeButton.Name = "ToggleTheme"
themeButton.Size = UDim2.new(0, 180, 0, 30)
themeButton.Position = UDim2.new(0, 10, 0, 440)
themeButton.Text = "Toggle Theme"
themeButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
themeButton.TextColor3 = Color3.new(1,1,1)

local darkMode = true
themeButton.MouseButton1Click:Connect(function()
	darkMode = not darkMode
	frame.BackgroundColor3 = darkMode and Color3.fromRGB(30,30,30) or Color3.fromRGB(240,240,240)
	for _,btn in pairs(frame:GetChildren()) do
		if btn:IsA("TextButton") then
			btn.BackgroundColor3 = darkMode and Color3.fromRGB(50,50,50) or Color3.fromRGB(200,200,200)
			btn.TextColor3 = darkMode and Color3.new(1,1,1) or Color3.new(0,0,0)
		end
	end
end)


-- === Fitur Tambahan Lanjutan ===

-- Invisibility Toggle
local invisible = false
local invisButton = Instance.new("TextButton", frame)
invisButton.Name = "ToggleInvis"
invisButton.Size = UDim2.new(0, 180, 0, 30)
invisButton.Position = UDim2.new(0, 10, 0, 480)
invisButton.Text = "Toggle Invisibility"
invisButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
invisButton.TextColor3 = Color3.new(1,1,1)
invisButton.MouseButton1Click:Connect(function()
	invisible = not invisible
	for _, part in pairs(character:GetDescendants()) do
		if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
			part.Transparency = invisible and 1 or 0
		end
	end
end)

-- Anti-Ragdoll / Anti-Fall
local function applyAntiFall()
	character:WaitForChild("Humanoid").StateChanged:Connect(function(old, new)
		if new == Enum.HumanoidStateType.Freefall then
			character:WaitForChild("Humanoid"):ChangeState(Enum.HumanoidStateType.Running)
		end
	end)
end
applyAntiFall()

-- Speed Boost Toggle
local speedToggle = false
local speedButton = Instance.new("TextButton", frame)
speedButton.Name = "ToggleSpeed"
speedButton.Size = UDim2.new(0, 180, 0, 30)
speedButton.Position = UDim2.new(0, 10, 0, 520)
speedButton.Text = "Toggle Speed Boost"
speedButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
speedButton.TextColor3 = Color3.new(1,1,1)

local normalSpeed = 16
local boostedSpeed = 100
speedButton.MouseButton1Click:Connect(function()
	local humanoid = character:FindFirstChildWhichIsA("Humanoid")
	if humanoid then
		speedToggle = not speedToggle
		humanoid.WalkSpeed = speedToggle and boostedSpeed or normalSpeed
	end
end)

-- GUI Hide/Show Toggle (F4 Key)
local UIS = game:GetService("UserInputService")
UIS.InputBegan:Connect(function(input, gpe)
	if gpe then return end
	if input.KeyCode == Enum.KeyCode.F4 then
		frame.Visible = not frame.Visible
	end
end)
