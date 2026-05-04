local StarterGui = game:GetService("StarterGui")

-- 通知を表示する関数
local function notify(title, text)
    StarterGui:SetCore("SendNotification", {
        Title = title;
        Text = text;
        Duration = 5;
    })
end

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local rootPart = character:WaitForChild("HumanoidRootPart")

-- 実行
rootPart.Anchored = true
notify("スクリプト実行", "プレイヤーを固定しました！")

task.wait(5)

rootPart.Anchored = false
notify("スクリプト実行", "固定を解除しました。")
