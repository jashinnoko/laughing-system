local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local isTransparent = false

-- 通知
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "隠密モード強化",
    Text = "名前と影の削除を試みます",
    Duration = 5
})

local function applyInvisibility()
    local c = player.Character
    if c and isTransparent then
        for _, obj in pairs(c:GetDescendants()) do
            -- パーツとデカールを透明に
            if obj:IsA("BasePart") then
                obj.Transparency = 1
                obj.CastShadow = false -- 影を消す
            elseif obj:IsA("Decal") then
                obj.Transparency = 1
            -- 名前タグ（Humanoid）の設定を変更して名前を隠す
            elseif obj:IsA("Humanoid") then
                obj.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
            end
        end
    end
end

-- 以下、前回のUI作成コードと同じ（省略せずにGitHubに貼ってください）
-- ... (前回のUIとRenderSteppedのループ部分)
