local player = game.Players.LocalPlayer
local mouse = player:GetMouse()

-- 通知
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "遠隔掴みシステム",
    Text = "クリックした相手を掴みに行きます",
    Duration = 5
})

-- 遠隔で掴むためのメイン関数
local function remoteGrab()
    local target = mouse.Target
    if target and target.Parent:FindFirstChild("Humanoid") then
        local targetChar = target.Parent
        local targetRoot = targetChar:FindFirstChild("HumanoidRootPart")
        local myChar = player.Character
        local tool = myChar:FindFirstChild("巨人の人形") or player.Backpack:FindFirstChild("巨人の人形")

        if targetRoot and tool then
            -- 1. 一瞬だけ相手の目の前にワープする
            local oldCFrame = myChar.HumanoidRootPart.CFrame
            myChar.HumanoidRootPart.CFrame = targetRoot.CFrame * CFrame.new(0, 0, 3)
            
            -- 2. 人形を装備して使う（掴む判定を出す）
            tool.Parent = myChar
            tool:Activate()
            
            -- 3. ほんの少し待ってから元の場所に戻る
            task.wait(0.1)
            myChar.HumanoidRootPart.CFrame = oldCFrame
        end
    end
end

-- 画面に「遠隔掴みモード」の切り替えボタンを作成
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "GrabGui"
screenGui.Parent = game.CoreGui

local button = Instance.new("TextButton")
button.Size = UDim2.new(0, 150, 0, 50)
button.Position = UDim2.new(0.05, 0, 0.2, 0)
button.BackgroundColor3 = Color3.fromRGB(100, 0, 150) -- 紫色
button.Text = "遠隔掴み：OFF"
button.TextColor3 = Color3.fromRGB(255, 255, 255)
button.Draggable = true
button.Parent = screenGui

local enabled = false
button.MouseButton1Click:Connect(function()
    enabled = not enabled
    button.Text = enabled and "遠隔掴み：ON" or "遠隔掴み：OFF"
    button.BackgroundColor3 = enabled and Color3.fromRGB(255, 0, 255) or Color3.fromRGB(100, 0, 150)
end)

-- クリックした時に実行
mouse.Button1Down:Connect(function()
    if enabled then
        remoteGrab()
    end
end)
