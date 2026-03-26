local StarterGui = game:GetService("StarterGui")

-- 画面に「成功」と通知を出すコード
StarterGui:SetCore("SendNotification", {
    Title = "読み込み成功！",
    Text = "GitHubのスクリプトが動いています",
    Duration = 10
})

