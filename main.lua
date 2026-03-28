local Players = game:GetService("Players")
local player = Players.LocalPlayer
local camera = workspace.CurrentCamera
local runService = game:GetService("RunService")
local vim = game:GetService("VirtualInputManager") -- クリック代行用

-- --- 設定 ---
local FOV_RADIUS = 130 
local FOV_COLOR = Color3.fromRGB(255, 0, 0)
local TARGET_COLOR = Color3.fromRGB(0, 255, 0)
local AUTO_SHOOT_DELAY = 0.05 -- 発砲までのディレイ（秒）

-- --- UI ---
if game.CoreGui:FindFirstChild("AdminAimsV14") then
    game.CoreGui.AdminAimsV14:Destroy()
end

local screenGui = Instance.new("ScreenGui", game.CoreGui)
screenGui.Name = "AdminAimsV14"

local fovCircle = Instance.new("Frame", screenGui)
fovCircle.Size = UDim2.new(0, FOV_RADIUS * 2, 0, FOV_RADIUS * 2)
fovCircle.Position = UDim2.new(0.5, 0, 0.5, -18)
fovCircle.AnchorPoint = Vector2.new(0.5, 0.5)
fovCircle.BackgroundTransparency = 1
fovCircle.Visible = false

local uiCorner = Instance.new("UICorner", fovCircle)
uiCorner.CornerRadius = UDim.new(1, 0)

local uiStroke = Instance.new("UIStroke", fovCircle)
uiStroke.Color = FOV_COLOR
uiStroke.Thickness = 2

local tracer = Drawing.new("Line")
tracer.Visible = false
tracer.Thickness = 1.5
tracer.Color = Color3.fromRGB(255, 50, 50)

local button = Instance.new("TextButton", screenGui)
button.Size = UDim2.new(0, 150, 0, 45)
button.Position = UDim2.new(0.05, 0, 0.1, 0)
button.Text = "Auto Shoot: OFF"
button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
button.TextColor3 = Color3.fromRGB(255, 255, 255)
button.Draggable = true

local aimEnabled = false
button.MouseButton1Click:Connect(function()
    aimEnabled = not aimEnabled
    button.Text = aimEnabled and "Auto Shoot: ON" or "Auto Shoot: OFF"
    button.BackgroundColor3 = aimEnabled and Color3.fromRGB(0, 180, 0) or Color3.fromRGB(50, 50, 50)
    fovCircle.Visible = aimEnabled
end)

-- --- 壁チェック ---
local function isVisible(targetPart)
    local char = player.Character
    if not char then return false end
    local startPos = camera.CFrame.Position
    local endPos = targetPart.Position
    local raycastParams = RaycastParams.new()
    raycastParams.FilterDescendantsInstances = {char}
    raycastParams.FilterType = Enum.RaycastFilterType.Exclude
    local raycastResult = workspace:Raycast(startPos, (endPos - startPos), raycastParams)
    if not raycastResult or raycastResult.Instance:IsDescendantOf(targetPart.Parent) then
        return true
    end
    return false
end

-- --- ターゲット選定 ---
local function getClosestPlayer()
    local target = nil
    local dist = FOV_RADIUS
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= player and p.Team ~= player.Team and p.Character and p.Character:FindFirstChild("Head") then
            local head = p.Character.Head
            local pos, onScreen = camera:WorldToViewportPoint(head.Position)
            if onScreen then
                local magnitude = (Vector2.new(pos.X, pos.Y) - camera.ViewportSize / 2).Magnitude
                if magnitude < dist and isVisible(head) then
                    target = p
                    dist = magnitude
                end
            end
        end
    end
    return target
end

-- --- メインループ ---
local lastShoot = 0
runService.RenderStepped:Connect(function()
    if aimEnabled then
        local target = getClosestPlayer()
        local myChar = player.Character
        local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")

        if target and target.Character and myRoot then
            uiStroke.Color = TARGET_COLOR
            
            -- エイム固定
            local targetPos = target.Character.Head.Position
            camera.CFrame = CFrame.new(camera.CFrame.Position, targetPos)
            
            -- 赤い線
            local headPos, headOnScreen = camera:WorldToViewportPoint(target.Character.Head.Position)
            local myPos, myOnScreen = camera:WorldToViewportPoint(myRoot.Position)
            if headOnScreen and myOnScreen then
                tracer.From = Vector2.new(myPos.X, myPos.Y)
                tracer.To = Vector2.new(headPos.X, headPos.Y)
                tracer.Visible = true
            end

            -- 【新機能】オートシュート
            if tick() - lastShoot > AUTO_SHOOT_DELAY then
                -- 画面中央をクリックしたことにする
                vim:SendMouseButtonEvent(camera.ViewportSize.X/2, camera.ViewportSize.Y/2, 0, true, game, 0)
                task.wait(0.02)
                vim:SendMouseButtonEvent(camera.ViewportSize.X/2, camera.ViewportSize.Y/2, 0, false, game, 0)
                lastShoot = tick()
            end
        else
            uiStroke.Color = FOV_COLOR
            tracer.Visible = false
        end
    else
        uiStroke.Color = FOV_COLOR
        tracer.Visible = false
    end
end)
