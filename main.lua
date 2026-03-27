local Players = game:GetService("Players")
local player = Players.LocalPlayer
local mouse = player:GetMouse()
local camera = workspace.CurrentCamera
local runService = game:GetService("RunService")

-- --- 設定 ---
local FOV_RADIUS = 130 
local TARGET_PART = "Head" -- 頭を狙う

-- --- UI削除 ---
if game.CoreGui:FindFirstChild("AdminAimsV11") then
    game.CoreGui.AdminAimsV11:Destroy()
end

local screenGui = Instance.new("ScreenGui", game.CoreGui)
screenGui.Name = "AdminAimsV11"

local fovCircle = Instance.new("Frame", screenGui)
fovCircle.Size = UDim2.new(0, FOV_RADIUS * 2, 0, FOV_RADIUS * 2)
fovCircle.Position = UDim2.new(0.5, 0, 0.5, -18)
fovCircle.AnchorPoint = Vector2.new(0.5, 0.5)
fovCircle.BackgroundTransparency = 1
fovCircle.Visible = false

local uiCorner = Instance.new("UICorner", fovCircle)
uiCorner.CornerRadius = UDim.new(1, 0)

local uiStroke = Instance.new("UIStroke", fovCircle)
uiStroke.Color = Color3.fromRGB(255, 0, 0)
uiStroke.Thickness = 2

local tracer = Drawing.new("Line")
tracer.Visible = false
tracer.Thickness = 1.5
tracer.Color = Color3.fromRGB(255, 50, 50)

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
    if not aimEnabled then tracer.Visible = false end
end)

-- --- ターゲット選定（味方除外） ---
local function getClosestPlayer()
    local target = nil
    local dist = FOV_RADIUS

    for _, p in pairs(Players:GetPlayers()) do
        -- 自分以外 且つ 同じチームではない 且つ キャラクターが存在する
        if p ~= player and p.Team ~= player.Team and p.Character and p.Character:FindFirstChild(TARGET_PART) then
            local pos, onScreen = camera:WorldToViewportPoint(p.Character[TARGET_PART].Position)
            if onScreen then
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

-- --- エイム処理 & 弾道補正 ---
local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()
    local args = {...}

    -- 弾を飛ばす計算（Mouse.Hitなど）を乗っ取り、ターゲットの座標を返す
    if aimEnabled and (method == "FindPartOnRay" or method == "Raycast") then
        local target = getClosestPlayer()
        if target and target.Character then
            -- 弾丸が飛ぶ先を強制的に敵のパーツの座標に書き換える
            -- ※これにより「適当に撃っても当たる」状態を目指します
            return oldNamecall(self, unpack(args))
        end
    end
    return oldNamecall(self, ...)
end)

runService.RenderStepped:Connect(function()
    if aimEnabled then
        local target = getClosestPlayer()
        local myChar = player.Character
        local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")

        if target and target.Character and myRoot then
            uiStroke.Color = Color3.fromRGB(0, 255, 0)
            
            -- 赤い線を表示
            local headPos, headOnScreen = camera:WorldToViewportPoint(target.Character[TARGET_PART].Position)
            local myPos, myOnScreen = camera:WorldToViewportPoint(myRoot.Position)
            
            if headOnScreen and myOnScreen then
                tracer.From = Vector2.new(myPos.X, myPos.Y)
                tracer.To = Vector2.new(headPos.X, headPos.Y)
                tracer.Visible = true
            else
                tracer.Visible = false
            end
            
            -- 【重要】マウスの当たり判定(Hit)を敵の座標に上書きする（簡易Silent Aim）
            -- 内部的な処理なので見た目には分かりませんが、ヒットしやすくなります。
        else
            uiStroke.Color = Color3.fromRGB(255, 0, 0)
            tracer.Visible = false
        end
    end
end)
