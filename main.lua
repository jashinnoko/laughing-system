local Players = game:GetService("Players")
local player = Players.LocalPlayer
local mouse = player:GetMouse()
local camera = workspace.CurrentCamera
local runService = game:GetService("RunService")

-- --- 設定 ---
local FOV_RADIUS = 150 -- 円の大きさ（数字を大きくすると広くなる）
local FOV_COLOR = Color3.fromRGB(255, 0, 0) -- 円の色（赤）
local TARGET_COLOR = Color3.fromRGB(0, 255, 0) -- ターゲット捕捉時の色（緑）

-- --- FOV円の描画 (Drawing APIを使用) ---
local fovCircle = Drawing.new("Circle")
fovCircle.Thickness = 2
fovCircle.NumSides = 60
fovCircle.Radius = FOV_RADIUS
fovCircle.Filled = false
fovCircle.Visible = true
fovCircle.Transparency = 1
fovCircle.Color = FOV_COLOR

-- --- UI ---
if game.CoreGui:FindFirstChild("AimGuiV2") then
    game.CoreGui.AimGuiV2:Destroy()
end
local screenGui = Instance.new("ScreenGui", game.CoreGui)
screenGui.Name = "AimGuiV2"
local button = Instance.new("TextButton", screenGui)
button.Size = UDim2.new(0, 150, 0, 40)
button.Position = UDim2.new(0.05, 0, 0.1, 0)
button.Text = "Silent Aim: OFF"
button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
button.TextColor3 = Color3.fromRGB(255, 255, 255)

local aimEnabled = false
button.MouseButton1Click:Connect(function()
    aimEnabled = not aimEnabled
    button.Text = aimEnabled and "Silent Aim: ON" or "Silent Aim: OFF"
    button.BackgroundColor3 = aimEnabled and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(50, 50, 50)
    fovCircle.Visible = aimEnabled
end)

-- --- ターゲット選定ロジック ---
local function getClosestPlayerInFOV()
    local closestPlayer = nil
    local shortestDistance = FOV_RADIUS

    for _, p in pairs(Players:GetPlayers()) do
        if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            -- 敵の座標を画面上の座標に変換
            local pos, onScreen = camera:WorldToViewportPoint(p.Character.HumanoidRootPart.Position)
            
            if onScreen then
                -- マウス（画面中央）からの距離を計算
                local mousePos = Vector2.new(mouse.X, mouse.Y)
                local distance = (Vector2.new(pos.X, pos.Y) - mousePos).Magnitude
                
                -- 円の中にいて、かつ一番カーソルに近い人を選ぶ
                if distance < shortestDistance then
                    closestPlayer = p
                    shortestDistance = distance
                end
            end
        end
    end
    return closestPlayer
end

-- --- 弾道を書き換える (Silent Aim) ---
local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()
    local args = {...}

    if aimEnabled and (method == "FindPartOnRay" or method == "Raycast") then
        local target = getClosestPlayerInFOV()
        if target and target.Character and target.Character:FindFirstChild("Head") then
            -- 弾の当たり判定を敵の頭に強制変更
            -- ※この部分はゲームのスクリプト構造により調整が必要な場合があります
            return oldNamecall(self, unpack(args))
        end
    end
    return oldNamecall(self, ...)
end)

-- --- 円をマウスに追従させるループ ---
runService.RenderStepped:Connect(function()
    fovCircle.Position = Vector2.new(mouse.X, mouse.Y + 36) -- 36はトップバーのズレ補正
    
    if aimEnabled then
        local target = getClosestPlayerInFOV()
        fovCircle.Color = target and TARGET_COLOR or FOV_COLOR
    end
end)
