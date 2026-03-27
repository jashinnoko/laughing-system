local Players = game:GetService("Players")
local player = Players.LocalPlayer
local mouse = player:GetMouse()
local camera = workspace.CurrentCamera
local runService = game:GetService("RunService")

-- --- 設定 ---
local FOV_RADIUS = 120 -- 円の大きさ

-- --- UI作成 (DrawingAPIを使わず、普通のパーツで円を作る) ---
if game.CoreGui:FindFirstChild("AimSystem") then
    game.CoreGui.AimSystem:Destroy()
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AimSystem"
screenGui.Parent = game.CoreGui

-- FOV円（見た目）
local fovCircle = Instance.new("Frame")
fovCircle.Name = "FOVCircle"
fovCircle.Size = UDim2.new(0, FOV_RADIUS * 2, 0, FOV_RADIUS * 2)
fovCircle.AnchorPoint = Vector2.new(0.5, 0.5)
fovCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
fovCircle.BackgroundTransparency = 1
fovCircle.Visible = false
fovCircle.Parent = screenGui

-- 円の線（枠線として作成）
local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(1, 0)
uiCorner.Parent = fovCircle

local uiStroke = Instance.new("UIStroke")
uiStroke.Color = Color3.fromRGB(255, 0, 0)
uiStroke.Thickness = 2
uiStroke.Parent = fovCircle

-- ON/OFFボタン
local button = Instance.new("TextButton")
button.Size = UDim2.new(0, 150, 0, 45)
button.Position = UDim2.new(0.05, 0, 0.1, 0)
button.Text = "Silent Aim: OFF"
button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
button.TextColor3 = Color3.fromRGB(255, 255, 255)
button.Parent = screenGui

local aimEnabled = false
button.MouseButton1Click:Connect(function()
    aimEnabled = not aimEnabled
    button.Text = aimEnabled and "Silent Aim: ON" or "Silent Aim: OFF"
    button.BackgroundColor3 = aimEnabled and Color3.fromRGB(0, 180, 0) or Color3.fromRGB(50, 50, 50)
    fovCircle.Visible = aimEnabled
end)

-- --- ターゲット選定 ---
local function getClosestPlayer()
    local target = nil
    local dist = FOV_RADIUS

    for _, p in pairs(Players:GetPlayers()) do
        if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local pos, onScreen = camera:WorldToViewportPoint(p.Character.HumanoidRootPart.Position)
            if onScreen then
                local mousePos = Vector2.new(mouse.X, mouse.Y)
                local magnitude = (Vector2.new(pos.X, pos.Y) - mousePos).Magnitude
                if magnitude < dist then
                    target = p
                    dist = magnitude
                end
            end
        end
    end
    return target
end

-- --- エイム処理 (視点を少し吸い寄せる方式) ---
-- 通信を書き換えると音が消えるので、今回は「視点を一瞬敵に向ける」安全な方式にします
runService.RenderStepped:Connect(function()
    fovCircle.Position = UDim2.new(0, mouse.X, 0, mouse.Y + 36)
    
    if aimEnabled and mouse.Target then -- クリック中や構え中を想定
        local target = getClosestPlayer()
        if target and target.Character and target.Character:FindFirstChild("Head") then
            uiStroke.Color = Color3.fromRGB(0, 255, 0) -- 捕捉したら緑
            -- 弾を撃つ瞬間に視点を少し敵の頭に近づける（これで当たりやすくなります）
            local targetPos = target.Character.Head.Position
            camera.CFrame = camera.CFrame:Lerp(CFrame.new(camera.CFrame.Position, targetPos), 0.1)
        else
            uiStroke.Color = Color3.fromRGB(255, 0, 0) -- 捕捉なしは赤
        end
    end
end)
