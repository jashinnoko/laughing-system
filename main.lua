-- Admin Bring Panel (Custom for Giant Doll)
local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- 通知を表示
game:GetService("StarterGui"):SetCore("SendNotification", {
	Title = "管理者パネル起動",
	Text = "巨人の人形を装備して名前を入力！",
	Duration = 5
})

-- UI作成 (Gensparkのデザインをベースに調整)
if game.CoreGui:FindFirstChild("AdminBringGui") then
	game.CoreGui.AdminBringGui:Destroy()
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AdminBringGui"
screenGui.Parent = game.CoreGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 260, 0, 140)
frame.Position = UDim2.new(0.5, -130, 0.5, -70)
frame.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = screenGui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundColor3 = Color3.fromRGB(50, 50, 65)
title.Text = "Admin Bring Panel"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextScaled = true
title.Parent = frame

local targetBox = Instance.new("TextBox")
targetBox.Size = UDim2.new(1, -20, 0, 35)
targetBox.Position = UDim2.new(0, 10, 0, 45)
targetBox.BackgroundColor3 = Color3.fromRGB(60, 60, 75)
targetBox.TextColor3 = Color3.fromRGB(255, 255, 255)
targetBox.PlaceholderText = "相手の名前を入力"
targetBox.Text = ""
targetBox.TextScaled = true
targetBox.Parent = frame

local bringButton = Instance.new("TextButton")
bringButton.Size = UDim2.new(1, -20, 0, 35)
bringButton.Position = UDim2.new(0, 10, 0, 85)
bringButton.BackgroundColor3 = Color3.fromRGB(70, 120, 255)
bringButton.TextColor3 = Color3.fromRGB(255, 255, 255)
bringButton.Text = "連れてくる (Bring)"
bringButton.TextScaled = true
bringButton.Parent = frame

-- 実際に連れてくる処理 (ワープ道連れ方式)
bringButton.MouseButton1Click:Connect(function()
	local targetName = targetBox.Text:lower()
	local targetPlayer = nil
	
	-- プレイヤーを探す（名前の一部でもOK）
	for _, p in pairs(Players:GetPlayers()) do
		if p ~= player and (p.Name:lower():find(targetName) or p.DisplayName:lower():find(targetName)) then
			targetPlayer = p
			break
		end
	end

	if targetPlayer and targetPlayer.Character then
		local myChar = player.Character
		local myRoot = myChar:FindFirstChild("HumanoidRootPart")
		local targetRoot = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
		local tool = myChar:FindFirstChild("巨人の人形")

		if myRoot and targetRoot and tool then
			local oldCFrame = myRoot.CFrame
			
			-- 1. 相手の目の前へワープ
			myRoot.CFrame = targetRoot.CFrame * CFrame.new(0, 0, 2)
			task.wait(0.1)
			
			-- 2. 巨人の人形で掴む
			tool:Activate()
			task.wait(0.2)
			
			-- 3. 元の場所へ戻る（相手を道連れにする）
			myRoot.CFrame = oldCFrame
		else
			-- 失敗時の通知
			game:GetService("StarterGui"):SetCore("SendNotification", {
				Title = "エラー",
				Text = "巨人の人形を手に持ってください！",
				Duration = 3
			})
		end
	end
end)
