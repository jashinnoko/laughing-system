local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- 通知
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "極小ステルス起動",
    Text = "姿を極限まで小さくしました",
    Duration = 5
})

-- UI削除
if game.CoreGui:FindFirstChild("MiniStealthGui") then
    game.CoreGui.MiniStealthGui:Destroy()
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MiniStealthGui"
screenGui.Parent = game.CoreGui

local button = Instance.new("TextButton")
button.Size = UDim2.new(0, 160, 0, 45)
button.Position = UDim2.new(0.05, 0, 0.1, 0)
button.BackgroundColor3 = Color3.fromRGB(50, 0, 50)
button.Text = "極小化: OFF"
button.TextColor3 = Color3.fromRGB(255, 255, 255)
button.Draggable = true
button.Parent = screenGui

local isMini = false

-- サイズを変更する関数
local function changeSize(scale)
    local char = player.Character
    if char and char:FindFirstChild("Humanoid") then
        local hs = char.Humanoid:FindFirstChild("BodyHeightScale")
        local ws = char.Humanoid:FindFirstChild("BodyWidthScale")
        local ds = char.Humanoid:FindFirstChild("BodyDepthScale")
        local hds = char.Humanoid:FindFirstChild("HeadScale")
        
        if hs and ws and ds and hds then
            hs.Value = scale
            ws.Value = scale
            ds.Value = scale
            hds.Value = scale
        end
    end
end

button.MouseButton1Click:Connect(function()
    isMini = not isMini
    if isMini then
        button.Text = "極小化: ON"
        button.BackgroundColor3 = Color3.fromRGB(150, 0, 255)
        changeSize(0.1) -- 0.1倍（ほぼ見えないサイズ）
        
        -- 名前も一応消しておく
        if player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
        end
    else
        button.Text = "極小化: OFF"
        button.BackgroundColor3 = Color3.fromRGB(50, 0, 50)
        changeSize(1) -- 元のサイズ
        
        if player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.Viewer
        end
    end
end)
