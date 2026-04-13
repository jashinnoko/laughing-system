local HttpService = game:GetService("HttpService")

-- あなたのWebhook URLをここに貼り付け

local WEBHOOK_URL = "https://discord.com/api/webhooks/1493133594716016730/sSv9qbs6IvhfMBbc6NedIXawC_I5oLUfRziJXcwK2K3-W84HRl362DEx_zs0wA8wNL11"

-- 送信するデータを作成
local data = {
    ["content"] = "🚨 **システム起動通知**",
    ["embeds"] = {{
        ["title"] = "スクリプトが実行されました",
        ["description"] = "ゲームサーバーが起動し、HttpServiceが正常に動作しています。",
        ["fields"] = {
            {
                ["name"] = "実行時刻",
                ["value"] = os.date("%Y/%m/%d %H:%M:%S"), -- 現在の時刻
                ["inline"] = true
            },
            {
                ["name"] = "Place ID",
                ["value"] = tostring(game.PlaceId),
                ["inline"] = true
            }
        },
        ["color"] = 16711680 -- 赤色
    }}
}

local jsonData = HttpService:JSONEncode(data)

-- 実行した瞬間に一度だけ送信
local success, err = pcall(function()
    HttpService:PostAsync(WEBHOOK_URL, jsonData)
end)

if success then
    print("【成功】実行直後の送信が完了しました！")
else
    warn("【失敗】送信できませんでした: " .. err)
end
