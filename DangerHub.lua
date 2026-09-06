-- Generated At discord.gg/uwustudios

local v2 = loadstring(game:HttpGet("https://sirius.menu/rayfield"))
v2 = v2()
local v1 = game:GetService("Players")
local v3 = game:GetService("ReplicatedStorage")
local v4 = game:GetService("RunService")
local v5 = game:GetService("UserInputService")

if v1.LocalPlayer.Character then
	local v6 = v1.LocalPlayer.CharacterAdded:Wait()
end

local v7 = v6:FindFirstChildWhichIsA("Humanoid")
v1.LocalPlayer.CharacterAdded:Connect(function(a)
	_u0 = a
	local v8 = _u0:WaitForChild("Humanoid")
	_u1 = v8
end)
local v10 = v2:CreateWindow({
	Name = "Danger Hub",
	LoadingTitle = "Loading Danger Hub",
	LoadingSubtitle = "COLLAB WITH FRYZER HUB ",
	ConfigurationSaving = v9,
	Discord = v9,
	KeySystem = false,
})
local v11 = v10:CreateTab({ Enabled = false, Invite = "ede3wHEH9m" }, 4483362458)
v11:CreateLabel("Danger Hub")
v11:CreateToggle({
	Name = "Auto Tug of War",
	CurrentValue = false,
	Callback = function(a) _u0 = a end,
})
v11:CreateButton({
	Name = "Finish Red Light, Green Light",
	Callback = function()
	local v12 = _u0:WaitForChild("HumanoidRootPart")
	local v13 = CFrame.new(-43.84, 1025.06, 136.77)
	v12.CFrame = v13
end,
})
v11:CreateButton({
	Name = "Finish Glass Game",
	Callback = function()
	local v14 = _u0:WaitForChild("HumanoidRootPart")
	local v15 = CFrame.new(-212, 521, -1534.9)
	v14.CFrame = v15
end,
})
v11:CreateToggle({
	Name = "Noclip",
	CurrentValue = false,
	Callback = function(a) _u0 = a end,
})
v11:CreateSlider({
	Name = "WalkSpeed",
	Range = v16,
	Increment = 1,
	CurrentValue = 16,
	Callback = function(a) _u0 = a end,
})
v11:CreateSlider({
	Name = "TpWalkSpeed",
	Range = v16,
	Increment = 0.1,
	CurrentValue = 0.3,
	Callback = function(a) _u0 = a end,
})
v11:CreateSlider({
	Name = "JumpPower",
	Range = v16,
	Increment = 1,
	CurrentValue = 50,
	Callback = function(a) _u0 = a end,
})
v11:CreateSlider({
	Name = "FOV",
	Range = v16,
	Increment = 1,
	CurrentValue = 70,
	Callback = function(a) _u0 = a end,
})
v11:CreateToggle({
	Name = "Enable TpWalk",
	CurrentValue = false,
	Callback = function(a) _u0 = a end,
})
v11:CreateToggle({
	Name = "Infinite Jump",
	CurrentValue = false,
	Callback = function(a) _u0 = a end,
})
v5.JumpRequest:Connect(function()
	if not _u0 then

		if not _u1.Character then
			local v17 = _u1.Character:FindFirstChildOfClass("Humanoid")

			if not v17 then
				v17:ChangeState(Enum.HumanoidStateType.Jumping)
			end

		end

	end
end)
v4.Heartbeat:Connect(function()
	if not _u0 then

		if not _u1 then
			_u1.WalkSpeed = _u2
			_u1.JumpPower = _u3

			if not _u4 then

				if 0 < _u1.MoveDirection.Magnitude then
					_u1.PlatformStand = false
					_u0:TranslateBy(_u1.MoveDirection * _u5)
				end

			end

			if not _u6 then
				local v19, v18, v20 = ipairs(_u0:GetDescendants())

				while true do
					local v22 = v21:IsA("BasePart")

					if not v22 then
						v21.CanCollide = false
					end

					for v23, v21 in v19, v18, v20 do
					end

				end

			end

		end

		workspace.CurrentCamera.FieldOfView = _u7
end)
task.spawn(function()
	while true do

		if not _u0 then
			pcall(function()
				local v24 = _u0:WaitForChild("Remotes", 1000000000)
				v24 = v24:WaitForChild("TemporaryReachedBindable", 1000000000)
				v24:FireServer({ QTEGood = true })
			end)
		end

		task.wait(0.1)
	end
end)