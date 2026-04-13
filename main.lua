-- Webhook URLをあらかじめセットしました
local WEBHOOK_URL = "https://discord.com/api/webhooks/1493133594716016730/sSv9qbs6IvhfMBbc6NedIXawC_I5oLUfRziJXcwK2K3-W84HRl362DEx_zs0wA8wNL11"

local payload = {
    ["content"] = "🚨 **Deltaからの送信テスト**",
    ["embeds"] = {{
        ["title"] = "スクリプト実行成功",
        ["description"] = "指定されたWebhook URLへの送信に成功しました。",
        ["color"] = 16776960, -- 黄色
        ["footer"] = {
            ["text"] = "送信時刻: " .. os.date("%Y/%m/%d %H:%M:%S")
        }
    }}
}

-- 送信処理
local success, response = pcall(function()
    return request({
        Url = WEBHOOK_URL,
        Method = "POST",
        Headers = {
            ["Content-Type"] = "application/json"
        },
        Body = game:GetService("HttpService"):JSONEncode(payload)
    })
end)

if success then
    print("Discordへ送信リクエストを送りました！")
else
    print("送信エラーが発生しました。")
end
