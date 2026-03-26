local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local isTransparent = false

-- 通知を出す（読み込み成功の確認）
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "読み込み成功！",
    Text = "透明化スクリプトが有効です",
    Duration = 5
})

-- 透明化を切り替える関数
local function toggleTransparency()
    isTransparent = not isTransparent
    local transparencyValue = isTransparent and 1 or 0
    
    -- キャラクターのパーツを全部探して透明度を変える
    for _, part in pairs(character:GetDescendants()) do
        if part:IsA("BasePart") or part:IsA("Decal") then
            -- 「HumanoidRootPart」だけは透明なままでないと変になるので除外
            if part.Name ~= "HumanoidRootPart" then
                part.Transparency = transparencyValue
            end
        end
    end
end

-- 画面にボタンを作成する
local screenGui = Instance.new("ScreenGui")
local button = Instance.new("TextButton")

screenGui.Parent = game.CoreGui
button.Parent = screenGui
button.Size = UDim2.new(0, 150, 0, 50)
button.Position = UDim2.new(0.1, 0, 0.5, 0) -- 画面左側の中央付近
button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
button.TextColor3 = Color3.fromRGB(255, 255, 255)
button.Text = "透明化：OFF"
button.Draggable = true -- ボタンを指で動かせるようにする

-- ボタンを押した時の動作
button.MouseButton1Click:Connect(function()
    toggleTransparency()
    if isTransparent then
        button.Text = "透明化：ON"
        button.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
    else
        button.Text = "透明化：OFF"
        button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    end
end)
