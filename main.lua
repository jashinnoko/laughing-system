local Players = game:GetService("Players")
local player = Players.LocalPlayer
local camera = workspace.CurrentCamera
local runService = game:GetService("RunService")

-- --- 設定 ---
local FOV_RADIUS = 130 -- 円の大きさ
local FOV_COLOR = Color3.fromRGB(255, 0, 0) -- 捕捉なしは赤
local TARGET_COLOR = Color3.fromRGB(0, 255, 0) -- 捕捉したら緑

-- --- UI削除 ---
if game.CoreGui:FindFirstChild("AdminAimsV12") then
    game.CoreGui.AdminAimsV12:Destroy()
end

local screenGui = Instance.new("ScreenGui", game.CoreGui)
screenGui.Name = "AdminAimsV12"

-- FOV円（見た目・【修正】元の円に戻す）
local fovCircle = Instance.new("Frame", screenGui)
fovCircle.Name = "FOVCircle"
fovCircle.Size = UDim2.new(0, FOV_RADIUS * 2, 0, FOV_RADIUS * 2)
-- 【修正】画面の中央（0.5, 0.5）に完全に固定
fovCircle.Position = UDim2.new(0.5, 0, 0.5, -18) -- トップバーのズレ補正
fovCircle.AnchorPoint = Vector2.new(0.5, 0.5)
fovCircle.BackgroundTransparency = 1
fovCircle.Visible = false

-- 角を丸くするパーツ
local uiCorner = Instance.new("UICorner", fovCircle)
uiCorner.CornerRadius = UDim.new(1, 0)

-- 枠線を描くパーツ
local uiStroke = Instance.new("UIStroke", fovCircle)
uiStroke.Color = FOV_COLOR
uiStroke.Thickness = 2

-- 【修正】ターゲット捕捉時の赤い線（ESP/DrawingAPIを復活）
local tracer = Drawing.new("Line")
tracer.Visible = false
tracer.Thickness = 1.5
tracer.Color = Color3.fromRGB(255, 50, 50) -- 赤い線
tracer.Transparency = 1

-- ON/OFFボタン
local button = Instance.new("TextButton", screenGui)
button.Size = UDim2.new(0, 150, 0, 45)
button.Position = UDim2.new(0.05, 0, 0.1, 0)
button.Text = "Silent Aim: OFF"
button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
button.TextColor3 = Color3.fromRGB(255, 255, 255)
button.Draggable = true

local aimEnabled = false
button.MouseButton1Click:Connect(function()
    aimEnabled = not aimEnabled
    button.Text = aimEnabled and "Silent Aim: ON" or "Silent Aim: OFF"
    button.BackgroundColor3 = aimEnabled and Color3.fromRGB(0, 180, 0) or Color3.fromRGB(50, 50, 50)
    fovCircle.Visible = aimEnabled
    tracer.Visible = false -- OFFの時は線を消す
end)

-- --- ターゲット選定（味方除外） ---
local function getClosestPlayer()
    local target = nil
    local dist = FOV_RADIUS

    for _, p in pairs(Players:GetPlayers()) do
        -- 自分以外 且つ 同じチームではない 且つ キャラクターが存在する 且つ 頭が存在する
        if p ~= player and p.Team ~= player.Team and p.Character and p.Character:FindFirstChild("Head") and p.Character:FindFirstChild("HumanoidRootPart") then
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
            
            -- 【追加】カメラを敵の頭に強制固定（倒すまで外さないハードエイム）
            local targetHeadPos = target.Character.Head.Position
            camera.CFrame = CFrame.new(camera.CFrame.Position, targetHeadPos)
            
            -- 【修正】赤い線を表示
            -- 線のスタート：ターゲットの頭を画面上の座標に変換
            local headPos, headOnScreen = camera:WorldToViewportPoint(target.Character.Head.Position)
            -- 線のエンド：あなたの本体（芯）を画面上の座標に変換
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
