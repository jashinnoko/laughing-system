-- 対象のプレイヤーを指定（自分自身の場合）
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

-- キャラクターの「胴体」を固定して動けなくする
local rootPart = character:WaitForChild("HumanoidRootPart")
rootPart.Anchored = true -- これで物理的に固定される

print("プレイヤーを固定しました！")

-- 5秒後に解除する
task.wait(5)
rootPart.Anchored = false
print("解除しました。")
