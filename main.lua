local WEBHOOK_URL = "https://hooks.hyra.io/api/webhooks/1493133594716016730/sSv9qbs6IvhfMBbc6NedIXawC_I5oLUfRziJXcwK2K3-W84HRl362DEx_zs0wA8wNL11"

-- デルタでよく使われる複数のリクエスト関数を自動選択
local request_func = syn and syn.request or http_request or request or fluxus.request

local payload = {
    ["content"] = "これで届くはず！最終テストです。"
}

if request_func then
    local response = request_func({
        Url = WEBHOOK_URL,
        Method = "POST",
        Headers = {
            ["Content-Type"] = "application/json"
        },
        Body = game:GetService("HttpService"):JSONEncode(payload)
    })
    print("リクエストを送信しました")
else
    print("エラー：お使いのデルタで通信関数が見つかりません")
end
