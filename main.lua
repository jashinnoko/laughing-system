local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- 通知
game:GetService("StarterGui"):SetCore("SendNotification", {
	Title = "管理者パネル v5",
	Text = "リストからターゲットを選んでください",
	Duration = 5
})

-- UI削除（重複防止）
if game.CoreGui:FindFirstChild("AdminListGui") then
	game.CoreGui.AdminListGui:Destroy()
end

-- メインGUI作成
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AdminListGui"
screenGui.Parent = game.CoreGui

-- メインフレーム
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 220, 0, 300)
frame.Position = UDim2.new(0.5, -110, 0.5, -150)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = screenGui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 35)
title.BackgroundColor3 = Color3.fromRGB(45, 45, 65)
title.Text = "Player Select (Bring)"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextScaled = true
title.Parent = frame

-- スクロールエリア
local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(1, -10, 1, -45)
scroll.Position = UDim2.new(0, 5, 0, 40)
scroll.BackgroundTransparency = 1
scroll.CanvasSize = UDim2.new(0, 0, 0, 0) -- 自動調整
scroll.ScrollBarThickness = 5
scroll.Parent = frame

local layout = Instance.new("UIListLayout")
layout.Parent = scroll
layout.Padding = UDim.new(0, 5)

-- ターゲットを連れてくる関数
local function bringPlayer(targetPlayer)
	local myChar = player.Character
	local myHum = myChar:FindFirstChild("Humanoid")
	
	if myHum and myHum.SeatPart and targetPlayer.Character then
		local targetRoot = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
		-- 操縦している巨人の人形の本体（または座席）
		local vehicleRoot = myHum.SeatPart.Parent:FindFirstChild("HumanoidRootPart") or myHum.SeatPart

		if vehicleRoot and targetRoot then
			local oldPos = vehicleRoot.CFrame
			
			-- 1. 相手の目の前へワープ
			vehicleRoot.CFrame = targetRoot.CFrame * CFrame.new(0, 5, 5)
			
			-- 2. 掴むための待機（この間に手動でボタンを押す！）
			task.wait(1.5)
			
			-- 3. 元の場所へ戻る（道連れ）
			vehicleRoot.CFrame = oldPos
		end
	else
		game:GetService("StarterGui"):SetCore("SendNotification", {
			Title = "エラー",
			Text = "巨人の人形に乗ってから選んでください",
			Duration = 3
		})
	end
end

-- プレイヤーリストの更新関数
local function refreshList()
	for _, child in pairs(scroll:GetChildren()) do
		if child:IsA("TextButton") then child:Destroy() end
	end
	
	for _, p in pairs(Players:GetPlayers()) do
		if p ~= player then
			local btn = Instance.new("TextButton")
			btn.Size = UDim2.new(1, -10, 0, 30)
			btn.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
			btn.Text = p.DisplayName .. " (@" .. p.Name .. ")"
			btn.TextColor3 = Color3.fromRGB(255, 255, 255)
			btn.TextScaled = true
			btn.Parent = scroll
			
			btn.MouseButton1Click:Connect(function()
				bringPlayer(p)
			end)
		end
	end
	scroll.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y)
end

-- 初回更新とプレイヤー入退室時の更新
refreshList()
Players.PlayerAdded:Connect(refreshList)
Players.PlayerRemoving:Connect(refreshList)
