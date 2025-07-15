loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local Window = Rayfield:CreateWindow({
	Name = "📡 RadarFarm Script",
	LoadingTitle = "Lade...",
	LoadingSubtitle = "",
	ConfigurationSaving = {
		Enabled = false
	},
	KeySystem = false
})

local MainTab = Window:CreateTab("Main", 4483362458)

local function showNotification(text, duration)
	duration = duration or 3
	pcall(function()
		game:GetService("StarterGui"):SetCore("SendNotification", {
			Title = "Script-Status",
			Text = text,
			Duration = duration
		})
	end)
end

MainTab:CreateButton({
	Name = "Start Script",
	Callback = function()

		local player = game.Players.LocalPlayer
		local char = player.Character or player.CharacterAdded:Wait()
		local hrp = char:WaitForChild("HumanoidRootPart")
		local rs = game:GetService("ReplicatedStorage")
		local vehicles = workspace:WaitForChild("Vehicles")
		local ts = game:GetService("TweenService")
		local runService = game:GetService("RunService")

		task.spawn(function()
			while true do
				task.wait(5)
				if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
					local root = player.Character.HumanoidRootPart
					root.CFrame = root.CFrame + root.CFrame.LookVector * 0.1
				end
			end
		end)

		setclipboard("https://discord.gg/vpK7RK7pM7")
		print("────────────────────────────")
		print("Credits: Dats, LetsManuel, henry")
		print("discord.gg/vpK7RK7pM7 (copied to clipboard)")
		print("────────────────────────────")

		local startPosition = Vector3.new(-1686.76, 5.88, 2755.92)
		local maxDistance = 2000

		local distance = (hrp.Position - startPosition).Magnitude
		if distance > maxDistance then
			showNotification("❌ Bitte nähere dich der Polizei-Station! Du bist zu weit entfernt! ANTICHEAT", 7)
			return
		else
			showNotification("✅ In Reichweite! Script startet. Viel Spaß", 3)
		end

		local noclip = true
		runService.Stepped:Connect(function()
			if noclip and char then
				for _, part in ipairs(char:GetDescendants()) do
					if part:IsA("BasePart") then
						part.CanCollide = false
					end
				end
			end
		end)

		local function flyTo(position, duration)
			local info = TweenInfo.new(duration or 2, Enum.EasingStyle.Linear)
			local tween = ts:Create(hrp, info, {CFrame = CFrame.new(position)})
			tween:Play()
			tween.Completed:Wait()
		end

		local isFlyingVehicle = false
		local function flyVehicleTo(position)
			if isFlyingVehicle then return end
			isFlyingVehicle = true

			local vehicle = vehicles:FindFirstChild(player.Name)
			if not vehicle or not vehicle:FindFirstChild("DriveSeat") then
				isFlyingVehicle = false
				return
			end

			local seat = vehicle.DriveSeat
			if char:FindFirstChild("Humanoid") then
				seat:Sit(char.Humanoid)
			end

			local root = vehicle.PrimaryPart or vehicle:FindFirstChildWhichIsA("BasePart")
			local target = position
			local step = 5.8
			local delayTime = 0.01

			local function moveAxis(startVal, endVal, setter)
				local dir = endVal > startVal and 1 or -1
				local val = startVal
				while (dir == 1 and val < endVal) or (dir == -1 and val > endVal) do
					val = val + dir * step
					if (dir == 1 and val > endVal) or (dir == -1 and val < endVal) then
						val = endVal
					end
					setter(val)
					task.wait(delayTime)
				end
			end

			local function moveXZ(startX, endX, startZ, endZ, setter)
				local dist = math.sqrt((endX - startX)^2 + (endZ - startZ)^2)
				local steps = math.ceil(dist / step)
				for i = 1, steps do
					local t = i / steps
					local x = startX + (endX - startX) * t
					local z = startZ + (endZ - startZ) * t
					setter(x, z)
					task.wait(delayTime)
				end
				setter(endX, endZ)
			end

			local function pivotCFrame(x, y, z)
				vehicle:PivotTo(CFrame.new(x, y, z))
			end

			local startPos = root.Position
			moveAxis(startPos.Y, startPos.Y + 10, function(y)
				pivotCFrame(startPos.X, y, startPos.Z)
			end)

			local current = vehicle.PrimaryPart.Position
			moveXZ(current.X, target.X, current.Z, target.Z, function(x, z)
				pivotCFrame(x, current.Y, z)
				current = vehicle.PrimaryPart.Position
			end)

			current = vehicle.PrimaryPart.Position
			moveAxis(current.Y, target.Y + 3, function(y)
				pivotCFrame(current.X, y, current.Z)
			end)

			current = vehicle.PrimaryPart.Position
			step = 0.2
			delayTime = 0.005
			moveAxis(current.Y, target.Y, function(y)
				pivotCFrame(current.X, y, current.Z)
			end)

			isFlyingVehicle = false
		end

		local function enterVehicle()
			local vehicle = vehicles:FindFirstChild(player.Name)
			if vehicle and char:FindFirstChild("Humanoid") then
				local seat = vehicle:FindFirstChild("DriveSeat")
				if seat then
					seat:Sit(char.Humanoid)
				end
			end
		end

		local function exitVehicle()
			if char:FindFirstChild("Humanoid") then
				char.Humanoid.Jump = true
			end
		end

		local function startJob()
			rs.ZDD["cdf43717-982a-47dd-8f01-a81d9eaa8b3c"]:FireServer("Patrol Police")
			task.wait(1)
		end

		local function spawnPoliceCar()
			rs.ZDD["3e32d17c-23bf-4024-9f4e-9a18bbe56e83"]:FireServer("VW Passat Patrol Police")
			task.wait(1.5)
		end

		local function equipRadarGun()
			rs.ZDD["03b49302-a5f2-4604-918e-098bfbdeb34f"]:FireServer("Radar Gun")
			task.wait(0.5)
			local radar = nil
			for i = 1, 10 do
				radar = char:FindFirstChild("Radar Gun")
				if radar then break end
				task.wait(0.2)
			end
			if radar then
				noclip = false
			end
		end

		local function startRadarFarm()
			local remote = rs.ZDD:FindFirstChild("33b83d12-cf41-43c5-9370-45721b8b0e80")
			_G.RadarFarmEnabled = true
			while _G.RadarFarmEnabled do
				local radarGun = char:FindFirstChild("Radar Gun")
				if radarGun and remote then
					for _, veh in ipairs(workspace.Vehicles:GetChildren()) do
						local ds = veh:FindFirstChild("DriveSeat")
						if ds then
							remote:FireServer(radarGun, ds.Position, (ds.Position - hrp.Position).Unit)
						end
					end
				end
				task.wait(1)
			end
		end

		enterVehicle()
		task.wait(0.5)
		flyVehicleTo(Vector3.new(-1686.76, 5.88, 2755.92))
		task.wait(0.5)
		exitVehicle()
		task.wait(0.5)
		flyTo(Vector3.new(-1678.27, 5.50, 2795.63), 1.5)
		task.wait(0.5)
		startJob()
		flyTo(Vector3.new(-1589.17, 5.63, 2866.31), 3)
		task.wait(0.8)
		local function trySpawnPoliceCarUntilSuccess(maxTries)
	local spawnPos = Vector3.new(-1589.17, 5.63, 2866.31)
	local success = false
	maxTries = maxTries or 5

	for attempt = 1, maxTries do
		spawnPoliceCar()
		task.wait(2)

		local vehicle = vehicles:FindFirstChild(player.Name)
		if vehicle and vehicle:FindFirstChild("DriveSeat") then
			success = true
			break
		else
			showNotification("🚨 Spawn fehlgeschlagen, versuche erneut... (" .. attempt .. ")", 5)
			flyTo(spawnPos, 1.5)
			task.wait(1)
		end
	end

	if not success then
		showNotification("❌ Fahrzeug konnte nicht gespawnt werden!", 5)
		return false
	end

	return true
end

if not trySpawnPoliceCarUntilSuccess(5) then return end

enterVehicle()
task.wait(0.2)
flyVehicleTo(Vector3.new(-1205.60, 5.37, 2789.70))
		task.wait(0.5)
		exitVehicle()
		task.wait(1)
		flyTo(Vector3.new(-1145.31, 5.50, 2802.99), 2.5)
		equipRadarGun()
		startRadarFarm()

	end
})

MainTab:CreateButton({
	Name = "Stopp Script",
	Callback = function()
		local player = game.Players.LocalPlayer
		local char = player.Character or player.CharacterAdded:Wait()
		local hrp = char:WaitForChild("HumanoidRootPart")
		local rs = game:GetService("ReplicatedStorage")
		local vehicles = workspace:WaitForChild("Vehicles")
		local ts = game:GetService("TweenService")

		_G.RadarFarmEnabled = false

		local vehicle = vehicles:FindFirstChild(player.Name)
		if vehicle and char:FindFirstChild("Humanoid") then
			local seat = vehicle:FindFirstChild("DriveSeat")
			if seat then
				seat:Sit(char.Humanoid)
				task.wait(0.5)
			end
		end

		local function flyVehicleTo(pos)
			if not vehicle then return end
			vehicle:PivotTo(CFrame.new(pos))
		end

		flyVehicleTo(Vector3.new(-1686.76, 5.88, 2755.92))
		task.wait(0.5)

		if char:FindFirstChild("Humanoid") then
			char.Humanoid.Jump = true
		end
		task.wait(1)
		hrp.CFrame = CFrame.new(-1678.27, 5.50, 2795.63)
		task.wait(1)

		rs.ZDD["c9f82a7e-bb2b-4fda-908b-5bfa2c118ece"]:FireServer()

		showNotification("Script gestoppt und Job gekündigt!", 4)
	end
})

MainTab:CreateButton({
	Name = "Server Hop",
	Callback = function()
		local ts = game:GetService("TeleportService")
		local http = game:GetService("HttpService")
		local placeId = game.PlaceId
		local currentJobId = game.JobId

		local success, result = pcall(function()
			return http:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. placeId .. "/servers/Public?sortOrder=Asc&limit=100"))
		end)

		if success and result and result.data then
			for _, server in ipairs(result.data) do
				if server.id ~= currentJobId and server.playing < server.maxPlayers then
					ts:TeleportToPlaceInstance(placeId, server.id, game.Players.LocalPlayer)
					return
				end
			end
			showNotification("❌ Kein anderer Server gefunden!", 3)
		else
			showNotification("❌ Fehler beim Laden der Serverliste!", 3)
		end
	end
})

local antiAfkEnabled = false
local antiAfkLoop

MainTab:CreateToggle({
	Name = "Anti - AFK",
	CurrentValue = false,
	Callback = function(state)
		antiAfkEnabled = state

		if antiAfkEnabled then
			game:GetService("StarterGui"):SetCore("SendNotification", {
				Title = "Anti-AFK aktiviert",
				Text = "Charakter bewegt sich leicht & springt regelmäßig.",
				Duration = 4
			})

			antiAfkLoop = task.spawn(function()
				while antiAfkEnabled do
					local player = game.Players.LocalPlayer
					local char = player.Character or player.CharacterAdded:Wait()
					local hrp = char:FindFirstChild("HumanoidRootPart")
					local humanoid = char:FindFirstChildOfClass("Humanoid")

					if hrp and humanoid then
						hrp.CFrame = hrp.CFrame + hrp.CFrame.LookVector * 0.5
						task.wait(0.1)

						humanoid.Jump = true
					end

					task.wait(60)
				end
			end)
		else
			game:GetService("StarterGui"):SetCore("SendNotification", {
				Title = "Anti-AFK deaktiviert",
				Text = "Kein AFK-Schutz mehr aktiv.",
				Duration = 4
			})
		end
	end
}) 
