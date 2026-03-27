local Players = game:GetService("Players")
local player = Players.LocalPlayer
local mouse = player:GetMouse()
local camera = workspace.CurrentCamera
local runService = game:GetService("RunService")

-- --- 設定 ---
local FOV_RADIUS = 130 -- 円の大きさ
local FOV_COLOR = Color3.fromRGB(255, 0, 0) -- 捕捉なしは赤
local TARGET_COLOR = Color3.fromRGB(0, 255, 0) -- 捕捉したら緑

-- --- UI削除 ---
if game.CoreGui:FindFirstChild("AdminAimsV10") then
    game.CoreGui.AdminAimsV10:Destroy()
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AdminAimsV10"
screenGui.Parent = game.CoreGui

-- FOV円（見た目・【修正】中央に固定）
local fovCircle = Instance.new("Frame")
fovCircle.Name = "FOVCircle"
fovCircle.Size = UDim2.new(0, FOV_RADIUS * 2, 0, FOV_RADIUS * 2)
-- 【重要】画面の中央（0.5, 0.5）に配置
fovCircle.Position = UDim2.new(0.5, 0, 0.5, -18) -- 18はトップバーのズレ補正
fovCircle.AnchorPoint = Vector2.new(0.5, 0.5)
fovCircle.BackgroundTransparency = 1
fovCircle.Visible = false
fovCircle.Parent = screenGui

local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(1, 0)
uiCorner.Parent = fovCircle

local uiStroke = Instance.new("UIStroke")
uiStroke.Color = FOV_COLOR
uiStroke.Thickness = 2
uiStroke.Parent = fovCircle

-- ターゲット捕捉時の赤い線（ESP）
local tracer = Drawing.new("Line")
tracer.Visible = false
tracer.Thickness = 1
tracer.Color = Color3.fromRGB(255, 0, 0) -- 赤い線
tracer.Transparency = 1

-- ON/OFFボタン
local button = Instance.new("TextButton")
button.Size = UDim2.new(0, 150, 0, 45)
button.Position = UDim2.new(0.05, 0, 0.1, 0)
button.Text = "Silent Aim: OFF"
button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
button.TextColor3 = Color3.fromRGB(255, 255, 255)
button.Draggable = true
button.Parent = screenGui

local aimEnabled = false
button.MouseButton1Click:Connect(function()
    aimEnabled = not aimEnabled
    button.Text = aimEnabled and "Silent Aim: ON" or "Silent Aim: OFF"
    button.BackgroundColor3 = aimEnabled and Color3.fromRGB(0, 180, 0) or Color3.fromRGB(50, 50, 50)
    fovCircle.Visible = aimEnabled
    tracer.Visible = false -- OFFの時は線を消す
end)

-- --- ターゲット選定 ---
local function getClosestPlayer()
    local target = nil
    local dist = FOV_RADIUS

    for _, p in pairs(Players:GetPlayers()) do
        if p ~= player and p.Character and p.Character:FindFirstChild("Head") and p.Character:FindFirstChild("HumanoidRootPart") then
            -- 敵の座標を画面上の座標に変換
            local pos, onScreen = camera:WorldToViewportPoint(p.Character.HumanoidRootPart.Position)
            if onScreen then
                -- 画面中央からの距離を計算
                local magnitude = (Vector2.new(pos.X, pos.Y) - camera.ViewportSize / 2).Magnitude
                if magnitude < dist then
                    target = p
                    dist = magnitude
                end
            end
        end
    end
    return target
end

-- --- エイム処理 & 円・線のループ ---
runService.RenderStepped:Connect(function()
    if aimEnabled then
        local target = getClosestPlayer()
        
        -- アバターの芯（HumanoidRootPart）
        local myChar = player.Character
        local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")

        if target and target.Character and target.Character:FindFirstChild("Head") and target.Character:FindFirstChild("HumanoidRootPart") and myRoot then
            -- 円の色を緑に
            uiStroke.Color = TARGET_COLOR
            
            -- 【重要】視点を少し吸い寄せる
            local targetPos = target.Character.Head.Position
            camera.CFrame = camera.CFrame:Lerp(CFrame.new(camera.CFrame.Position, targetPos), 0.1)
            
            -- 【追加】赤い線を表示
            -- 線のスタート：ターゲットの頭を画面上の座標に変換
            local headPos, headOnScreen = camera:WorldToViewportPoint(target.Character.Head.Position)
            -- 線のエンド：あなたの本体を画面上の座標に変換
            local myPos, myOnScreen = camera:WorldToViewportPoint(myRoot.Position)
            
            if headOnScreen and myOnScreen then
                tracer.From = Vector2.new(myPos.X, myPos.Y)
                tracer.To = Vector2.new(headPos.X, headPos.Y)
                tracer.Visible = true
            else
                tracer.Visible = false
            end
        else
            -- 捕捉なし
            uiStroke.Color = FOV_COLOR
            tracer.Visible = false
        end
    else
        uiStroke.Color = FOV_COLOR
        tracer.Visible = false
    end
end)
