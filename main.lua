local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local isTransparent = false

-- 通知
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "R6/R15 両対応！",
    Text = "透明化スクリプト読み込み完了",
    Duration = 5
})

-- 透明化を切り替える関数（R6/R15/アクセサリー対応）
local function toggleTransparency()
    isTransparent = not isTransparent
    local targetTransparency = isTransparent and 1 or 0
    
    -- キャラクター内の全オブジェクトをループ
    for _, obj in pairs(character:GetDescendants()) do
        -- パーツ(BasePart)か、顔などのステッカー(Decal)なら透明にする
        if obj:IsA("BasePart") or obj:IsA("Decal") then
            -- ルートパーツ（移動の基準点）だけは0.1くらい残さないとバグることがあるので除外
            if obj.Name ~= "HumanoidRootPart" then
                obj.Transparency = targetTransparency
            end
        end
    end
end

-- UI作成（既存のUIがあれば消してから作成）
if game.CoreGui:FindFirstChild("TransparentGui") then
    game.CoreGui.TransparentGui:Destroy()
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "TransparentGui"
screenGui.Parent = game.CoreGui

local button = Instance.new("TextButton")
button.Parent = screenGui
button.Size = UDim2.new(0, 140, 0, 45)
button.Position = UDim2.new(0.05, 0, 0.4, 0)
button.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
button.BorderSizePixel = 2
button.TextColor3 = Color3.fromRGB(255, 255, 255)
button.TextSize = 18
button.Text = "透明化: OFF"
button.Draggable = true -- 好きな場所に動かせます

button.MouseButton1Click:Connect(function()
    toggleTransparency()
    if isTransparent then
        button.Text = "透明化: ON"
        button.BackgroundColor3 = Color3.fromRGB(0, 150, 255) -- ONの時は青っぽく
    else
        button.Text = "透明化: OFF"
        button.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    end
end)
