local Players = game:GetService("Players")
local player = Players.LocalPlayer
local camera = workspace.CurrentCamera
local runService = game:GetService("RunService")

-- --- 設定 ---
local FOV_RADIUS = 130 
local FOV_COLOR = Color3.fromRGB(255, 255, 255)
local LOCK_COLOR = Color3.fromRGB(255, 0, 0)

-- --- UI作成 ---
if game.CoreGui:FindFirstChild("AdminAimsV17") then
    game.CoreGui.AdminAimsV17:Destroy()
end

local screenGui = Instance.new("ScreenGui", game.CoreGui)
screenGui.Name = "AdminAimsV17"

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

-- ボタン1: Target Lock (壁貫通ロック)
local btnLock = Instance.new("TextButton", screenGui)
btnLock.Size = UDim2.new(0, 160, 0, 40)
btnLock.Position = UDim2.new(0.05, 0, 0.1, 0)
btnLock.Text = "Target Lock: OFF"
btnLock.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
btnLock.TextColor3 = Color3.fromRGB(255, 255, 255)
btnLock.Draggable = true

-- ボタン2: Rapid Fire (高速連射) 【新設】
local btnRapid = Instance.new("TextButton", screenGui)
btnRapid.Size = UDim2.new(0, 160, 0, 40)
btnRapid.Position = UDim2.new(0.05, 0, 0.16, 0)
btnRapid.Text = "Rapid Fire: OFF"
btnRapid.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
btnRapid.TextColor3 = Color3.fromRGB(255, 255, 255)
btnRapid.Draggable = true

local lockEnabled = false
local rapidEnabled = false
local currentTarget = nil

btnLock.MouseButton1Click:Connect(function()
    lockEnabled = not lockEnabled
    btnLock.Text = lockEnabled and "Target Lock: ON" or "Target Lock: OFF"
    btnLock.BackgroundColor3 = lockEnabled and Color3.fromRGB(200, 0, 0) or Color3.fromRGB(50, 50, 50)
    if not lockEnabled then currentTarget = nil end
end)

btnRapid.MouseButton1Click:Connect(function()
    rapidEnabled = not rapidEnabled
    btnRapid.Text = rapidEnabled and "Rapid Fire: ON" or "Rapid Fire: OFF"
    btnRapid.BackgroundColor3 = rapidEnabled and Color3.fromRGB(200, 150, 0) or Color3.fromRGB(50, 50, 50)
end)

-- --- 高速連射ロジック ---
-- 多くの武器スクリプトで使われる「Cooldown」「ReloadTime」等の変数を強制書き換え
task.spawn(function()
    while task.wait(0.5) do
        if rapidEnabled then
            for _, v in pairs(getgc(true)) do
                if type(v) == "table" then
                    -- 一般的な武器スクリプトの変数名を狙い撃ち
                    if v.Cooldown or v.ReloadTime or v.FireRate or v.ShootRate then
                        v.Cooldown = 0.1
                        v.ReloadTime = 0.1
                        v.FireRate = 0.1
                        v.ShootRate = 0.1
                    end
                end
            end
        end
    end
end)

-- --- 壁チェック & ESP 略 (前回のロジックを継続) ---
local function isVisible(part)
    local ray = Ray.new(camera.CFrame.Position, (part.Position - camera.CFrame.Position).Unit * 500)
    local hit = workspace:FindPartOnRayWithIgnoreList(ray, {player.Character})
    return hit and hit:IsDescendantOf(part.Parent)
end

-- --- メインループ ---
runService.RenderStepped:Connect(function()
    if currentTarget and (not currentTarget.Character or not currentTarget.Character:FindFirstChild("Humanoid") or currentTarget.Character.Humanoid.Health <= 0) then
        currentTarget = nil
    end

    local shortestDist = FOV_RADIUS
    local potentialTarget = nil

    for _, p in pairs(Players:GetPlayers()) do
        if p ~= player and p.Team ~= player.Team and p.Character and p.Character:FindFirstChild("Head") then
            local head = p.Character.Head
            local pos, onScreen = camera:WorldToViewportPoint(head.Position)
            if onScreen then
                local dist = (Vector2.new(pos.X, pos.Y) - camera.ViewportSize / 2).Magnitude
                if dist < shortestDist then
                    if lockEnabled or isVisible(head) then
                        potentialTarget = p
                        shortestDist = dist
                    end
                end
            end
        end
    end

    if not currentTarget then currentTarget = potentialTarget end

    if currentTarget and currentTarget.Character and currentTarget.Character:FindFirstChild("Head") then
        uiStroke.Color = LOCK_COLOR
        camera.CFrame = CFrame.new(camera.CFrame.Position, currentTarget.Character.Head.Position)
        if not lockEnabled and not isVisible(currentTarget.Character.Head) then
            currentTarget = nil
        end
    else
        uiStroke.Color = FOV_COLOR
    end
end)
