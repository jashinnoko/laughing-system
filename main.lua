local Players = game:GetService("Players")
local player = Players.LocalPlayer
local runService = game:GetService("RunService")

-- 通知
game:GetService("StarterGui"):SetCore("SendNotification", {
	Title = "ステルス潜伏モード",
	Text = "アバターを地底に隠しました",
	Duration = 5
})

-- UI削除
if game.CoreGui:FindFirstChild("StealthGui") then
	game.CoreGui.StealthGui:Destroy()
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "StealthGui"
screenGui.Parent = game.CoreGui

local button = Instance.new("TextButton")
button.Size = UDim2.new(0, 160, 0, 45)
button.Position = UDim2.new(0.05, 0, 0.1, 0)
button.BackgroundColor3 = Color3.fromRGB(0, 50, 100)
button.Text = "地底潜伏: OFF"
button.TextColor3 = Color3.fromRGB(255, 255, 255)
button.Draggable = true
button.Parent = screenGui

local isStealth = false
local offset = Vector3.new(0, -20, 0) -- 地下20メートルに隠す設定

-- 地底に固定し続けるループ
runService.RenderStepped:Connect(function()
	if isStealth then
		local char = player.Character
		if char then
			-- HumanoidRootPart（本体の芯）以外の全てのパーツを下にずらす
			for _, part in pairs(char:GetDescendants()) do
				if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
					part.CFrame = char.HumanoidRootPart.CFrame * CFrame.new(offset)
				elseif part:IsA("Decal") then
					part.Transparency = 1 -- 顔なども消す
				end
			end
			-- 名前を隠す
			if char:FindFirstChild("Humanoid") then
				char.Humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
			end
		end
	end
end)

button.MouseButton1Click:Connect(function()
	isStealth = not isStealth
	if isStealth then
		button.Text = "地底潜伏: ON"
		button.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
	else
		button.Text = "地底潜伏: OFF"
		button.BackgroundColor3 = Color3.fromRGB(0, 50, 100)
		-- 元に戻す
		local char = player.Character
		if char then
			for _, part in pairs(char:GetDescendants()) do
				if part:IsA("BasePart") then
					part.Transparency = 0 -- 念のため
				end
			end
			if char:FindFirstChild("Humanoid") then
				char.Humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.Viewer
			end
		end
	end
end)

-- 前回までの「リストから選んでワープ」の機能も合体させたい場合は、
-- この下に前回の「skyDropPlayer」などの関数を追加してください。
