local Players = game:GetService("Players")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local camera = workspace.CurrentCamera
local runService = game:GetService("RunService")

-- 通知
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "ステルスモード起動",
    Text = "姿を消して視点を固定しました",
    Duration = 5
})

-- UI削除
if game.CoreGui:FindFirstChild("StealthGuiV2") then
    game.CoreGui.StealthGuiV2:Destroy()
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "StealthGuiV2"
screenGui.Parent = game.CoreGui

local button = Instance.new("TextButton")
button.Size = UDim2.new(0, 160, 0, 45)
button.Position = UDim2.new(0.05, 0, 0.1, 0)
button.BackgroundColor3 = Color3.fromRGB(0, 80, 50)
button.Text = "ステルス: OFF"
button.TextColor3 = Color3.fromRGB(255, 255, 255)
button.Draggable = true
button.Parent = screenGui

local isStealth = false

-- 【重要】カメラを地上に固定し続けるループ
runService.RenderStepped:Connect(function()
    if isStealth then
        local char = player.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            -- カメラを地上の本体（芯）の位置に固定
            -- これで地下を映さなくなります
            camera.CFrame = char.HumanoidRootPart.CFrame * CFrame.new(0, 10, 20)
            
            -- 全パーツを強制的に透明にする（v8の移動は削除）
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") or part:IsA("Decal") then
                    part.Transparency = 1
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
        button.Text = "ステルス: ON"
        button.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
    else
        button.Text = "ステルス: OFF"
        button.BackgroundColor3 = Color3.fromRGB(0, 80, 50)
        -- カメラを元に戻す（デフォルトの追従モード）
        camera.CameraType = Enum.CameraType.Custom
        -- 透明化を戻す
        local char = player.Character
        if char then
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.Transparency = 0
                end
            end
            if char:FindFirstChild("Humanoid") then
                char.Humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.Viewer
            end
        end
    end
end)
