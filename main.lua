local Players = game:GetService("Players")
local player = Players.LocalPlayer
local mouse = player:GetMouse()
local camera = workspace.CurrentCamera
local runService = game:GetService("RunService")

-- --- 設定（検知されにくい数値） ---
local FOV_RADIUS = 100 
local SMOOTHNESS = 0.05 -- 数値を小さくするほど滑らか（バレにくい）

-- --- UI ---
if game.CoreGui:FindFirstChild("SafeAim") then
    game.CoreGui.SafeAim:Destroy()
end
local screenGui = Instance.new("ScreenGui", game.CoreGui)
screenGui.Name = "SafeAim"

local fovCircle = Instance.new("Frame", screenGui)
fovCircle.Size = UDim2.new(0, FOV_RADIUS * 2, 0, FOV_RADIUS * 2)
fovCircle.Position = UDim2.new(0.5, 0, 0.5, -18)
fovCircle.AnchorPoint = Vector2.new(0.5, 0.5)
fovCircle.BackgroundTransparency = 1
fovCircle.Visible = false

local uiStroke = Instance.new("UIStroke", fovCircle)
uiStroke.Color = Color3.fromRGB(255, 255, 255)
uiStroke.Thickness = 1

local button = Instance.new("TextButton", screenGui)
button.Size = UDim2.new(0, 140, 0, 40)
button.Position = UDim2.new(0.05, 0, 0.1, 0)
button.Text = "Safe Aim: OFF"
button.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
button.TextColor3 = Color3.fromRGB(255, 255, 255)

local aimEnabled = false
button.MouseButton1Click:Connect(function()
    aimEnabled = not aimEnabled
    button.Text = aimEnabled and "Safe Aim: ON" or "Safe Aim: OFF"
    button.BackgroundColor3 = aimEnabled and Color3.fromRGB(0, 120, 200) or Color3.fromRGB(30, 30, 30)
    fovCircle.Visible = aimEnabled
end)

-- --- ターゲット選定（味方除外） ---
local function getTarget()
    local target = nil
    local dist = FOV_RADIUS
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= player and p.Team ~= player.Team and p.Character and p.Character:FindFirstChild("Head") then
            local pos, onScreen = camera:WorldToViewportPoint(p.Character.Head.Position)
            if onScreen then
                local mag = (Vector2.new(pos.X, pos.Y) - camera.ViewportSize / 2).Magnitude
                if mag < dist then
                    target = p
                    dist = mag
                end
            end
        end
    end
    return target
end

-- --- 処理ループ（通信をいじらず、カメラだけを動かす） ---
runService.RenderStepped:Connect(function()
    if aimEnabled then
        local target = getTarget()
        if target and target.Character then
            -- 通信(hook)を使わず、カメラの向きを「じわっ」と敵に向けるだけ
            local targetPos = target.Character.Head.Position
            camera.CFrame = camera.CFrame:Lerp(CFrame.new(camera.CFrame.Position, targetPos), SMOOTHNESS)
            uiStroke.Color = Color3.fromRGB(0, 255, 100)
        else
            uiStroke.Color = Color3.fromRGB(255, 255, 255)
        end
    end
end)
