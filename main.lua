-- Discord公式の代わりに中継サーバー（Hyra）を通します
local WEBHOOK_URL = "https://hooks.hyra.io/api/webhooks/1493133594716016730/sSv9qbs6IvhfMBbc6NedIXawC_I5oLUfRziJXcwK2K3-W84HRl362DEx_zs0wA8wNL11"

local payload = {
    ["content"] = "📢 **中継サーバー経由での送信テスト**",
    ["embeds"] = {{
        ["title"] = "接続成功",
        ["description"] = "プロキシを使用してDiscordへメッセージを送信しました。",
        ["color"] = 3447003 -- 青色
    }}
}

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
    print("送信完了！Discordを確認してください。")
else
    print("エラー: " .. tostring(response))
end
