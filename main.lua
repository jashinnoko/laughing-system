local player = game.Players.LocalPlayer
local runService = game:GetService("RunService")
local noclipEnabled = false
local noclipConnection

-- 通知
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "壁すり抜けシステム",
    Text = "準備完了！ボタンで切り替えてください",
    Duration = 5
})

-- 壁すり抜けを実行する関数
local function doNoclip()
    local char = player.Character
    if char and noclipEnabled then
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false -- 当たり判定をオフにする
            end
        end
    end
end

-- UI作成
if game.CoreGui:FindFirstChild("NoclipGui") then
    game.CoreGui.NoclipGui:Destroy()
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "NoclipGui"
screenGui.Parent = game.CoreGui

local button = Instance.new("TextButton")
button.Parent = screenGui
button.Size = UDim2.new(0, 140, 0, 45)
button.Position = UDim2.new(0.05, 0, 0.3, 0) -- 透明化ボタンより少し上に配置
button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
button.BorderSizePixel = 2
button.TextColor3 = Color3.fromRGB(255, 255, 255)
button.Text = "壁抜け: OFF"
button.Draggable = true

-- ボタンクリック時の処理
button.MouseButton1Click:Connect(function()
    noclipEnabled = not noclipEnabled
    
    if noclipEnabled then
        button.Text = "壁抜け: ON"
        button.BackgroundColor3 = Color3.fromRGB(0, 180, 0) -- ONは緑
        -- 常に判定をオフにし続けるループを開始
        noclipConnection = runService.Stepped:Connect(doNoclip)
    else
        button.Text = "壁抜け: OFF"
        button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        -- ループを止める
        if noclipConnection then
            noclipConnection:Disconnect()
            noclipConnection = nil
        end
        -- 当たり判定を元に戻す（リセット用）
        local char = player.Character
        if char then
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
        end
    end
end)
