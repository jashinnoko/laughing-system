-- 直接のURLに戻し、余計な設定をすべて削りました
local url = "https://discord.com/api/webhooks/1493133594716016730/sSv9qbs6IvhfMBbc6NedIXawC_I5oLUfRziJXcwK2K3-W84HRl362DEx_zs0wA8wNL11"

local function send()
    local request_func = (syn and syn.request) or (http and http.request) or http_request or request
    
    if request_func then
        request_func({
            Url = url,
            Method = "POST",
            Headers = {["Content-Type"] = "application/json"},
            Body = game:GetService("HttpService"):JSONEncode({
                content = "デルタから直接送信テスト！届いたら教えて！"
            })
        })
        return "リクエスト送信関数を実行しました"
    else
        return "通信関数が見つかりません"
    end
end

print(send())
