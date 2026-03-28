local Players = game:GetService("Players")
local player = Players.LocalPlayer
local camera = workspace.CurrentCamera
local runService = game:GetService("RunService")

-- --- 設定 ---
local FOV_RADIUS = 130 
local FOV_COLOR = Color3.fromRGB(255, 255, 255)
local LOCK_COLOR = Color3.fromRGB(255, 0, 0) -- ロック時は赤

-- --- UI削除・作成 ---
if game.CoreGui:FindFirstChild("AdminAimsV15") then
    game.CoreGui.AdminAimsV15:Destroy()
end

local screenGui = Instance.new("ScreenGui", game.CoreGui)
screenGui.Name = "AdminAimsV15"

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

-- ボタン1: Silent Aim (基本)
local btnAim = Instance.new("TextButton", screenGui)
btnAim.Size = UDim2.new(0, 140, 0, 40)
btnAim.Position = UDim2.new(0.05, 0, 0.1, 0)
btnAim.Text = "Aim Assist: OFF"
btnAim.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
btnAim.TextColor3 = Color3.fromRGB(255, 255, 255)
btnAim.Draggable = true

-- ボタン2: Target Lock (強力固定)
local btnLock = Instance.new("TextButton", screenGui)
btnLock.Size = UDim2.new(0, 140, 0, 40)
btnLock.Position = UDim2.new(0.05, 0, 0.16, 0) -- ボタン1の下
btnLock.Text = "Target Lock: OFF"
btnLock.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
btnLock.TextColor3 = Color3.fromRGB(255, 255, 255)
btnLock.Draggable = true

local aimEnabled = false
local lockEnabled = false
local currentTarget = nil

btnAim.MouseButton1Click:Connect(function()
    aimEnabled = not aimEnabled
    btnAim.Text = aimEnabled and "Aim Assist: ON" or "Aim Assist: OFF"
    btnAim.BackgroundColor3 = aimEnabled and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(50, 50, 50)
end)

btnLock.MouseButton1Click:Connect(function()
    lockEnabled = not lockEnabled
    btnLock.Text = lockEnabled and "Target Lock: ON" or "Target Lock: OFF"
    btnLock.BackgroundColor3 = lockEnabled and Color3.fromRGB(200, 0, 0) or Color3.fromRGB(50, 50, 50)
    if not lockEnabled then currentTarget = nil end
end)

-- --- 壁チェック ---
local function isVisible(part)
    local ray = Ray.new(camera.CFrame.Position, (part.Position - camera.CFrame.Position).Unit * 500)
    local hit = workspace:FindPartOnRayWithIgnoreList(ray, {player.Character})
    return hit and hit:IsDescendantOf(part.Parent)
end

-- --- ESP (敵の可視化) ---
local function createESP(p)
    local line = Drawing.new("Line")
    local text = Drawing.new("Text")
    
    runService.RenderStepped:Connect(function()
        if p.Character and p.Character:FindFirstChild("Head") and p ~= player and p.Team ~= player.Team then
            local headPos, onScreen = camera:WorldToViewportPoint(p.Character.Head.Position)
            if onScreen then
                -- 線（足元から敵へ）
                line.Visible = true
                line.From = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y)
                line.To = Vector2.new(headPos.X, headPos.Y)
                line.Color = (currentTarget == p) and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(255, 255, 255)
                line.Thickness = 1
                
                -- 名前
                text.Visible = true
                text.Position = Vector2.new(headPos.X, headPos.Y - 20)
                text.Text = p.Name
                text.Size = 16
                text.Center = true
                text.Outline = true
                text.Color = Color3.fromRGB(255, 255, 255)
            else
                line.Visible = false
                text.Visible = false
            end
        else
            line.Visible = false
            text.Visible = false
        end
        if not aimEnabled and not lockEnabled then
            line.Visible = false
            text.Visible = false
        end
    end)
end

for _, v in pairs(Players:GetPlayers()) do createESP(v) end
Players.PlayerAdded:Connect(createESP)

-- --- メインロジック ---
runService.RenderStepped:Connect(function()
    if aimEnabled or lockEnabled then
        -- ターゲットが死んだら解除
        if currentTarget and (not currentTarget.Character or not currentTarget.Character:FindFirstChild("Humanoid") or currentTarget.Character.Humanoid.Health <= 0) then
            currentTarget = nil
        end

        -- 新しいターゲットを探す（ロック中じゃない場合）
        if not currentTarget then
            local shortestDist = FOV_RADIUS
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= player and p.Team ~= player.Team and p.Character and p.Character:FindFirstChild("Head") then
                    local head = p.Character.Head
                    local pos, onScreen = camera:WorldToViewportPoint(head.Position)
                    if onScreen and isVisible(head) then
                        local dist = (Vector2.new(pos.X, pos.Y) - camera.ViewportSize / 2).Magnitude
                        if dist < shortestDist then
                            currentTarget = p
                            shortestDist = dist
                        end
                    end
                end
            end
        end

        -- ターゲット固定
        if currentTarget and currentTarget.Character and currentTarget.Character:FindFirstChild("Head") then
            uiStroke.Color = LOCK_COLOR
            if lockEnabled then
                camera.CFrame = CFrame.new(camera.CFrame.Position, currentTarget.Character.Head.Position)
            end
        else
            uiStroke.Color = FOV_COLOR
        end
    end
end)
