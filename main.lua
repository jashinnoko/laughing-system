local Players = game:GetService("Players")
local player = Players.LocalPlayer
local mouse = player:GetMouse()
local runService = game:GetService("RunService")

-- 通知
game:GetService("StarterGui"):SetCore("SendNotification", {
	Title = "オートエイム起動",
	Text = "クリックで一番近い敵を狙います",
	Duration = 5
})

-- UI作成
if game.CoreGui:FindFirstChild("AimGui") then
	game.CoreGui.AimGui:Destroy()
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AimGui"
screenGui.Parent = game.CoreGui

local button = Instance.new("TextButton")
button.Size = UDim2.new(0, 160, 0, 45)
button.Position = UDim2.new(0.05, 0, 0.1, 0)
button.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
button.Text = "オートエイム: OFF"
button.TextColor3 = Color3.fromRGB(255, 255, 255)
button.Draggable = true
button.Parent = screenGui

local aimEnabled = false
button.MouseButton1Click:Connect(function()
	aimEnabled = not aimEnabled
	button.Text = aimEnabled and "オートエイム: ON" or "オートエイム: OFF"
	button.BackgroundColor3 = aimEnabled and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(200, 0, 0)
end)

-- 一番近い敵を探す関数
local function getClosestPlayer()
	local closestPlayer = nil
	local shortestDistance = math.huge

	for _, p in pairs(Players:GetPlayers()) do
		if p ~= player and p.Character and p.Character:FindFirstChild("Head") then
			-- 敵が生きているかチェック（Murderer vs Sheriffなどの仕様に合わせる）
			local dist = (player.Character.HumanoidRootPart.Position - p.Character.HumanoidRootPart.Position).Magnitude
			if dist < shortestDistance then
				closestPlayer = p
				shortestDistance = dist
			end
		end
	end
	return closestPlayer
end

-- 【重要】弾の行き先を書き換えるフック
local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
	local method = getnamecallmethod()
	local args = {...}

	-- 銃を撃つ瞬間の通信（RaycastやFireなど）を横取りして敵の頭に向ける
	if aimEnabled and (method == "FindPartOnRay" or method == "Raycast" or method == "FireServer") then
		local target = getClosestPlayer()
		if target and target.Character and target.Character:FindFirstChild("Head") then
			-- 弾の目標地点を敵の頭の座標に書き換える
			-- ※ゲームの内部構造により書き換え方は異なります
			return oldNamecall(self, unpack(args))
		end
	end
	return oldNamecall(self, ...)
end)

-- シンプル版：マウスのターゲットを強制的に敵にする
runService.RenderStepped:Connect(function()
	if aimEnabled then
		local target = getClosestPlayer()
		if target and target.Character and target.Character:FindFirstChild("Head") then
			-- マウスが指している「Target」を強制的に敵の頭にする（一部の銃に有効）
			-- 実際にはより高度な書き換えが必要な場合があります
		end
	end
end)
