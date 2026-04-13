local WEBHOOK_URL = "https://discord.com/api/webhooks/1493133594716016730/sSv9qbs6IvhfMBbc6NedIXawC_I5oLUfRziJXcwK2K3-W84HRl362DEx_zs0wA8wNL11"

local response = request({
    Url = WEBHOOK_URL,
    Method = "POST",
    Headers = {
        ["Content-Type"] = "application/json"
    },
    Body = game:GetService("HttpService"):JSONEncode({
        ["content"] = "デルタから送信テスト成功！"
    })
})
