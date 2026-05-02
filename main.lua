local Players = game:GetService("Players")
local player = Players.LocalPlayer
local camera = workspace.CurrentCamera
local runService = game:GetService("RunService")

-- --- 設定 ---
local FOV_RADIUS = 130 
local FOV_COLOR = Color3.fromRGB(255, 255, 255)
local LOCK_COLOR = Color3.fromRGB(255, 0, 0)

-- --- UI作成 ---
if game.CoreGui:FindFirstChild("AdminAimsV16") then
    game.CoreGui.AdminAimsV16:Destroy()
end

local screenGui = Instance.new("ScreenGui", game.CoreGui)
screenGui.Name = "AdminAimsV16"

-- FOV円
local fovCircle = Instance.new("Frame", screenGui)
fovCircle.Size = UDim2.new(0, FOV_RADIUS * 2, 0, FOV_RADIUS * 2)
fovCircle.Position = UDim2.new(0.5, 0, 0.5, -18)
fovCircle.AnchorPoint = Vector2.new(0.5, 0.5)
fovCircle.BackgroundTransparency = 1
local uiCorner = Instance.new("UICorner", fovCircle)
uiCorner.CornerRadius = UDim.new(1, 0)
local uiStroke = Instance.new("UIStroke", fovCircle)
uiStroke.Color = FOV_COLOR
uiStroke.Thickness = 1

-- ボタン: Target Lock (壁貫通ロック切り替え)
local btnLock = Instance.new("TextButton", screenGui)
btnLock.Size = UDim2.new(0, 160, 0, 45)
btnLock.Position = UDim2.new(0.05, 0, 0.1, 0)
btnLock.Text = "Target Lock: OFF\n(Visual Only)"
btnLock.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
btnLock.TextColor3 = Color3.fromRGB(255, 255, 255)
btnLock.Draggable = true

local lockEnabled = false
local currentTarget = nil

btnLock.MouseButton1Click:Connect(function()
    lockEnabled = not lockEnabled
    btnLock.Text = lockEnabled and "Target Lock: ON\n(Wall Penetrate)" or "Target Lock: OFF\n(Visual Only)"
    btnLock.BackgroundColor3 = lockEnabled and Color3.fromRGB(200, 0, 0) or Color3.fromRGB(50, 50, 50)
    if not lockEnabled then currentTarget = nil end
end)

-- --- 壁チェック関数 ---
local function isVisible(part)
    local ray = Ray.new(camera.CFrame.Position, (part.Position - camera.CFrame.Position).Unit * 500)
    local hit = workspace:FindPartOnRayWithIgnoreList(ray, {player.Character})
    return hit and hit:IsDescendantOf(part.Parent)
end

-- --- ESP (敵の可視化) ---
local function createESP(p)
    local line = Drawing.new("Line")
    runService.RenderStepped:Connect(function()
        if p.Character and p.Character:FindFirstChild("Head") and p ~= player and p.Team ~= player.Team then
            local headPos, onScreen = camera:WorldToViewportPoint(p.Character.Head.Position)
            if onScreen then
                line.Visible = true
                line.From = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y)
                line.To = Vector2.new(headPos.X, headPos.Y)
                line.Color = (currentTarget == p) and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(255, 255, 255)
                line.Thickness = 1
            else
                line.Visible = false
            end
        else
            line.Visible = false
        end
    end)
end

for _, v in pairs(Players:GetPlayers()) do createESP(v) end
Players.PlayerAdded:Connect(createESP)

-- --- メインロジック ---
runService.RenderStepped:Connect(function()
    -- ターゲットが死亡、または存在しない場合は解除
    if currentTarget and (not currentTarget.Character or not currentTarget.Character:FindFirstChild("Humanoid") or currentTarget.Character.Humanoid.Health <= 0) then
        currentTarget = nil
    end

    -- ターゲットを探す処理
    local shortestDist = FOV_RADIUS
    local potentialTarget = nil

    for _, p in pairs(Players:GetPlayers()) do
        if p ~= player and p.Team ~= player.Team and p.Character and p.Character:FindFirstChild("Head") then
            local head = p.Character.Head
            local pos, onScreen = camera:WorldToViewportPoint(head.Position)

            if onScreen then
                local dist = (Vector2.new(pos.X, pos.Y) - camera.ViewportSize / 2).Magnitude
                if dist < shortestDist then
                    -- 【修正点】
                    -- 1. Target LockがONなら、壁に関係なくターゲットにする
                    -- 2. Target LockがOFFなら、見える(Visible)時だけターゲットにする
                    if lockEnabled or isVisible(head) then
                        potentialTarget = p
                        shortestDist = dist
                    end
                end
            end
        end
    end

    -- ターゲットを確定させる（一度ロックしたら、その敵が死ぬまで、または条件から外れるまで優先）
    if not currentTarget then
        currentTarget = potentialTarget
    end

    -- カメラ固定処理
    if currentTarget and currentTarget.Character and currentTarget.Character:FindFirstChild("Head") then
        uiStroke.Color = LOCK_COLOR
        
        -- ロックオン実行
        camera.CFrame = CFrame.new(camera.CFrame.Position, currentTarget.Character.Head.Position)
        
        -- 【補足】Target LockがOFFの時に壁に隠れたら、ターゲットをリセットする
        if not lockEnabled and not isVisible(currentTarget.Character.Head) then
            currentTarget = nil
        end
    else
        uiStroke.Color = FOV_COLOR
