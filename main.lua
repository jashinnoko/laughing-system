-- URLの末尾に /github を追加（これで届くようになるケースが多いです）
local url = "https://discord.com/api/webhooks/1493133594716016730/sSv9qbs6IvhfMBbc6NedIXawC_I5oLUfRziJXcwK2K3-W84HRl362DEx_zs0wA8wNL11/github"

-- デルタで最も安定する関数を順番に探す
local request_func = http_request or (http and http.request) or request or (syn and syn.request)

if request_func then
    local data = {
        ["content"] = "🚨 デルタからの最終テスト通知です！"
    }
    
    local success, res = pcall(function()
        return request_func({
            Url = url,
            Method = "POST",
            Headers = {
                ["Content-Type"] = "application/json",
                ["User-Agent"] = "Roblox/Linux" -- ロブロックスからの通信に見せかける
            },
            Body = game:GetService("HttpService"):JSONEncode(data)
        })
    end)
    
    if success then
        print("送信命令は完了しました。Discordを確認してください。")
    else
        print("送信エラー: " .. tostring(res))
    end
else
    print("エラー：お使いの環境で通信関数が見つかりません。")
end
