local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- 通知
game:GetService("StarterGui"):SetCore("SendNotification", {
	Title = "管理者パネル v6",
	Text = "自動キャッチ＆放り投げモード",
	Duration = 5
})

if game.CoreGui:FindFirstChild("AdminListGuiV6") then
	game.CoreGui.AdminListGuiV6:Destroy()
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AdminListGuiV6"
screenGui.Parent = game.CoreGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 220, 0, 300)
frame.Position = UDim2.new(0.5, -110, 0.5, -150)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.Draggable = true
frame.Active = true
frame.Parent = screenGui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 35)
title.BackgroundColor3 = Color3.fromRGB(80, 0, 0)
title.Text = "Sky Drop Panel"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextScaled = true
title.Parent = frame

local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(1, -10, 1, -45)
scroll.Position = UDim2.new(0, 5, 0, 40)
scroll.BackgroundTransparency = 1
scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
scroll.ScrollBarThickness = 5
scroll.Parent = frame

local layout = Instance.new("UIListLayout")
layout.Parent = scroll
layout.Padding = UDim.new(0, 5)

-- 【重要】自動で掴んで空へ運ぶ関数
local function skyDropPlayer(targetPlayer)
	local myChar = player.Character
	local myHum = myChar:FindFirstChild("Humanoid")
	
	if myHum and myHum.SeatPart and targetPlayer.Character then
		local targetRoot = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
		local vehicle = myHum.SeatPart.Parent
		local vehicleRoot = vehicle:FindFirstChild("HumanoidRootPart") or myHum.SeatPart

		if vehicleRoot and targetRoot then
			local oldPos = vehicleRoot.CFrame
			
			-- 1. 相手の目の前へワープ
			vehicleRoot.CFrame = targetRoot.CFrame * CFrame.new(0, 2, 4)
			
			-- 2. 【自動掴み】ゲーム内の「掴むイベント」を直接呼び出す試み
			-- 注：リモートイベント名は推測です。動作しない場合は手動でボタンを押してください。
			local grabEvent = vehicle:FindFirstChild("RemoteEvent") or vehicle:FindFirstChild("Click")
			if grabEvent then
				if grabEvent:IsA("RemoteEvent") then
					grabEvent:FireServer("Grab") -- イベント形式
				elseif grabEvent:IsA("ClickDetector") then
					fireclickdetector(grabEvent) -- クリック形式
				end
			end
			
			-- 掴むための猶予
			task.wait(0.5)
			
			-- 3. 上空500メートルへ急上昇！
			vehicleRoot.CFrame = vehicleRoot.CFrame * CFrame.new(0, 500, 0)
			
			task.wait(0.5)
			
			-- 4. 相手を離す（放り投げる）
			-- ここでもう一度イベントを呼んで「離す」動作をさせるか、
			-- もしくは自分が人形から降りることで相手を置き去りにします
			myHum.Jump = true -- 人形から降りる
			
			task.wait(1)
			
			-- 5. 自分だけ元の場所に戻る
			myChar.HumanoidRootPart.CFrame = oldPos
		end
	else
		game:GetService("StarterGui"):SetCore("SendNotification", {
			Title = "エラー",
			Text = "人形に乗ってから選んでください",
			Duration = 3
		})
	end
end

local function refreshList()
	for _, child in pairs(scroll:GetChildren()) do
		if child:IsA("TextButton") then child:Destroy() end
	end
	for _, p in pairs(Players:GetPlayers()) do
		if p ~= player then
			local btn = Instance.new("TextButton")
			btn.Size = UDim2.new(1, -10, 0, 30)
			btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
			btn.Text = p.DisplayName
			btn.TextColor3 = Color3.fromRGB(255, 255, 255)
			btn.TextScaled = true
			btn.Parent = scroll
			btn.MouseButton1Click:Connect(function() skyDropPlayer(p) end)
		end
	end
	scroll.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y)
end

refreshList()
Players.PlayerAdded:Connect(refreshList)
Players.PlayerRemoving:Connect(refreshList)
