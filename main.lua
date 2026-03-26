local player = game.Players.LocalPlayer
local isTransparent = false
local connection -- 繰り返し処理を保存する変数

-- 通知
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "強制透明化システム",
    Text = "装備やリセットにも対応しました",
    Duration = 5
})

-- 透明化を実行する中身
local function applyTransparency()
    local char = player.Character
    if char and isTransparent then
        for _, obj in pairs(char:GetDescendants()) do
            if obj:IsA("BasePart") or obj:IsA("Decal") then
                if obj.Name ~= "HumanoidRootPart" then
                    obj.Transparency = 1
                end
            end
        end
    end
end

-- UI作成
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
button.TextColor3 = Color3.fromRGB(255, 255, 255)
button.Text = "透明化: OFF"
button.Draggable = true

-- ボタンを押した時の処理
button.MouseButton1Click:Connect(function()
    isTransparent = not isTransparent
    
    if isTransparent then
        button.Text = "透明化: ON"
        button.BackgroundColor3 = Color3.fromRGB(255, 0, 0) -- ONは赤
        
        -- 常に透明化し続けるループを開始
        if not connection then
            connection = game:GetService("RunService").RenderStepped:Connect(applyTransparency)
        end
    else
        button.Text = "透明化: OFF"
        button.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        
        -- ループを止めて元に戻す
        if connection then
            connection:Disconnect()
            connection = nil
        end
        
        -- 元の姿に戻す
        local char = player.Character
        if char then
            for _, obj in pairs(char:GetDescendants()) do
                if obj:IsA("BasePart") or obj:IsA("Decal") then
                    obj.Transparency = 0
                end
            end
        end
    end
end)
