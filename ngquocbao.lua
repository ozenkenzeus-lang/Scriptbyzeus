-- GUI BY ZEUS - MENU FRAM BOSS (kéo + nút đóng)

-- GUI setup
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FramBossGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

-- Toggle Button để mở menu
local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0, 120, 0, 30)
toggleButton.Position = UDim2.new(0, 10, 0, 10)
toggleButton.Text = "🤚🏻Fram Bos"
toggleButton.TextColor3 = Color3.new(1,1,1)
toggleButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
toggleButton.Parent = ScreenGui

-- Main Menu Frame
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 300, 0, 200)
mainFrame.Position = UDim2.new(0, 10, 0, 50)
mainFrame.BackgroundColor3 = Color3.fromRGB(255, 210, 220)
mainFrame.BorderSizePixel = 3
mainFrame.Visible = false
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = ScreenGui

-- Close Button (❌)
local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 30, 0, 30)
closeButton.Position = UDim2.new(1, -35, 0, 5)
closeButton.Text = "❌"
closeButton.TextColor3 = Color3.new(1, 1, 1)
closeButton.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
closeButton.Parent = mainFrame
closeButton.MouseButton1Click:Connect(function()
	mainFrame.Visible = false
end)

-- Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -40, 0, 40)
title.Position = UDim2.new(0, 0, 0, 0)
title.Text = "MENU FRAM BOSS"
title.TextScaled = true
title.TextColor3 = Color3.new(1,1,1)
title.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
title.Parent = mainFrame

-- Button generator
local function createOptionButton(text, posY)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, -20, 0, 30)
	btn.Position = UDim2.new(0, 10, 0, posY)
	btn.Text = text
	btn.TextColor3 = Color3.new(1,1,1)
	btn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
	btn.Parent = mainFrame
	return btn
end

-- Nút chức năng
local autoHitBtn = createOptionButton("-Auto Đánh Boss", 50)
local aroundBtn = createOptionButton("-chạy xung quanh boss", 90)
local autoPickBtn = createOptionButton("-tự động nhặt vật phẩm", 130)

-- Trạng thái chức năng
local autoHit = false
local runAround = false
local autoPick = false

-- Toggle hiện menu
toggleButton.MouseButton1Click:Connect(function()
	mainFrame.Visible = not mainFrame.Visible
end)

-- Vũ khí cho phép
local allowedWeapons = {
	["PhongLon"] = true,
	["Trường Thương"] = true,
}

-- Tìm boss NPC2
local function getBoss()
	for _,v in pairs(workspace:GetDescendants()) do
		if v:IsA("Model") and v.Name == "NPC2" and v:FindFirstChild("HumanoidRootPart") then
			return v
		end
	end
end

-- Đánh boss mỗi 3.1s
task.spawn(function()
	while task.wait(3.1) do
		if autoHit then
			local boss = getBoss()
			if boss then
				local tool = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool")
				if tool and allowedWeapons[tool.Name] then
					for _,v in pairs(tool:GetDescendants()) do
						if v:IsA("RemoteEvent") or v:IsA("RemoteFunction") then
							pcall(function()
								v:FireServer(boss.Humanoid)
							end)
						end
					end
				end
			end
		end
	end
end)

-- Chạy quanh boss (bán kính 21)
task.spawn(function()
	while task.wait(0.1) do
		if runAround then
			local boss = getBoss()
			if boss then
				local angle = tick() % (2 * math.pi)
				local radius = 21
				local offset = Vector3.new(math.cos(angle) * radius, 0, math.sin(angle) * radius)
				game.Players.LocalPlayer.Character:MoveTo(boss.HumanoidRootPart.Position + offset)
			end
		end
	end
end)

-- Tự nhặt vật phẩm
task.spawn(function()
	while task.wait(1) do
		if autoPick then
			for _,v in pairs(workspace:GetDescendants()) do
				if v:IsA("Tool") and v:FindFirstChild("Handle") then
					firetouchinterest(game.Players.LocalPlayer.Character.HumanoidRootPart, v.Handle, 0)
					firetouchinterest(game.Players.LocalPlayer.Character.HumanoidRootPart, v.Handle, 1)
				end
			end
		end
	end
end)

-- Toggle chức năng
autoHitBtn.MouseButton1Click:Connect(function()
	autoHit = not autoHit
	autoHitBtn.Text = (autoHit and "✅ " or "-").."Auto Đánh Boss"
end)

aroundBtn.MouseButton1Click:Connect(function()
	runAround = not runAround
	aroundBtn.Text = (runAround and "✅ " or "-").."chạy xung quanh boss"
end)

autoPickBtn.MouseButton1Click:Connect(function()
	autoPick = not autoPick
	autoPickBtn.Text = (autoPick and "✅ " or "-").."tự động nhặt vật phẩm"
end)

-- Hiển thị máu boss
local bossHealthLabel = Instance.new("TextLabel")
bossHealthLabel.Size = UDim2.new(0, 300, 0, 30)
bossHealthLabel.Position = UDim2.new(0, 140, 0, 10)
bossHealthLabel.BackgroundTransparency = 0.3
bossHealthLabel.BackgroundColor3 = Color3.fromRGB(100, 0, 0)
bossHealthLabel.TextColor3 = Color3.new(1,1,1)
bossHealthLabel.TextScaled = true
bossHealthLabel.Text = "Đang tìm boss..."
bossHealthLabel.Parent = ScreenGui

task.spawn(function()
	while task.wait(0.5) do
		local boss = getBoss()
		if boss and boss:FindFirstChild("Humanoid") then
			local hp = math.floor(boss.Humanoid.Health)
			local max = math.floor(boss.Humanoid.MaxHealth)
			bossHealthLabel.Text = "Máu boss NPC2: " .. hp .. " / " .. max
		else
			bossHealthLabel.Text = "Boss NPC2 không tồn tại!"
		end
	end
end)
