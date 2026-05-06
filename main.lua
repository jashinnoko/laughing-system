-- 二重起動防止
local oldGui = game.CoreGui:FindFirstChild("KumaaHub")
if oldGui then oldGui:Destroy() end
if _G.SpeedConn then _G.SpeedConn:Disconnect() end

local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local MiniFrame = Instance.new("Frame")
local OpenBtn = Instance.new("TextButton")

-- GUI設定
ScreenGui.Parent = game.CoreGui
ScreenGui.Name = "KumaaHub"
ScreenGui.ResetOnSpawn = false

-- --- 1. Openボタン ---
OpenBtn.Name = "OpenButton"
OpenBtn.Parent = ScreenGui
OpenBtn.Visible = false
OpenBtn.Size = UDim2.new(0, 60, 0, 60)
OpenBtn.Position = UDim2.new(0, 10, 0.5, -30)
OpenBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
OpenBtn.Text = "Open"
OpenBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
OpenBtn.Font = Enum.Font.SourceSansBold
OpenBtn.TextSize = 18
Instance.new("UICorner", OpenBtn).CornerRadius = UDim.new(1, 0)
local OpenStroke = Instance.new("UIStroke", OpenBtn)
OpenStroke.Color = Color3.fromRGB(255, 255, 255)
OpenStroke.Thickness = 2

-- --- 2. メイン画面 ---
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.Position = UDim2.new(0.5, -250, 0.5, -150)
MainFrame.Size = UDim2.new(0, 500, 0, 350)
MainFrame.Active = true
MainFrame.Draggable = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)

-- 左側ナビゲーション
local LeftNav = Instance.new("Frame", MainFrame)
LeftNav.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
LeftNav.Size = UDim2.new(0, 150, 1, 0)
Instance.new("UICorner", LeftNav).CornerRadius = UDim.new(0, 8)

local Title = Instance.new("TextLabel", LeftNav)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Text = "くまあ HUB v1.1"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 18
Title.BackgroundTransparency = 1

-- 右側コンテンツエリア（スクロール可能にしておく）
local RightScroll = Instance.new("ScrollingFrame", MainFrame)
RightScroll.Name = "RightContent"
RightScroll.Position = UDim2.new(0, 160, 0, 45) -- タイトル分を下げる
RightScroll.Size = UDim2.new(1, -170, 1, -55)
RightScroll.BackgroundTransparency = 1
RightScroll.CanvasSize = UDim2.new(0, 0, 0, 0) -- 自動調整
RightScroll.ScrollBarThickness = 2

local UIList = Instance.new("UIListLayout", RightScroll)
UIList.Padding = UDim.new(0, 8)
UIList.SortOrder = Enum.SortOrder.LayoutOrder

-- コンテンツエリア内のタイトル
local ContentTitle = Instance.new("TextLabel", MainFrame)
ContentTitle.Size = UDim2.new(0, 200, 0, 40)
ContentTitle.Position = UDim2.new(0, 160, 0, 5)
ContentTitle.Text = "プレイヤー設定"
ContentTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
ContentTitle.Font = Enum.Font.SourceSansBold
ContentTitle.TextSize = 22
ContentTitle.TextXAlignment = Enum.TextXAlignment.Left
ContentTitle.BackgroundTransparency = 1

-- --- 3. 最小化バー (画像のデザイン) ---
MiniFrame.Name = "MiniFrame"
MiniFrame.Parent = ScreenGui
MiniFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MiniFrame.Position = UDim2.new(0.5, -200, 0.2, 0)
MiniFrame.Size = UDim2.new(0, 400, 0, 45)
MiniFrame.Visible = false
MiniFrame.Active = true
MiniFrame.Draggable = true
Instance.new("UICorner", MiniFrame).CornerRadius = UDim.new(0, 10)

local MiniTitle = Instance.new("TextLabel", MiniFrame)
MiniTitle.Size = UDim2.new(0.7, 0, 1, 0)
MiniTitle.Position = UDim2.new(0, 15, 0, 0)
MiniTitle.Text = "くまあ HUB v1.1 | FPS: 60"
MiniTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
MiniTitle.Font = Enum.Font.SourceSansBold
MiniTitle.TextSize = 18
MiniTitle.TextXAlignment = Enum.TextXAlignment.Left
MiniTitle.BackgroundTransparency = 1

local MiniBtnHolder = Instance.new("Frame", MiniFrame)
MiniBtnHolder.Size = UDim2.new(0, 80, 0, 30)
MiniBtnHolder.Position = UDim2.new(1, -90, 0.5, -15)
MiniBtnHolder.BackgroundTransparency = 1
Instance.new("UIListLayout", MiniBtnHolder).FillDirection = Enum.FillDirection.Horizontal
Instance.new("UIListLayout", MiniBtnHolder).Padding = UDim.new(0, 5)

-- --- 4. 関数定義 (レイアウト修正済み) ---

-- トグル作成関数 (空中ジャンプなど)
local function CreateToggle(parent, text, default, callback)
    local Frame = Instance.new("Frame", parent)
    Frame.Size = UDim2.new(1, -10, 0, 40)
    Frame.BackgroundTransparency = 0.9
    Frame.BackgroundColor3 = Color3.fromRGB(255,255,255)
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 6)

    local Label = Instance.new("TextLabel", Frame)
    Label.Size = UDim2.new(1, -60, 1, 0)
    Label.Position = UDim2.new(0, 10, 0, 0)
    Label.Text = text
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.TextSize = 16
    Label.Font = Enum.Font.SourceSans
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.BackgroundTransparency = 1

    local Btn = Instance.new("TextButton", Frame)
    Btn.Size = UDim2.new(0, 45, 0, 22)
    Btn.Position = UDim2.new(1, -50, 0.5, -11)
    Btn.Text = default and "ON" or "OFF"
    Btn.BackgroundColor3 = default and Color3.fromRGB(0, 180, 0) or Color3.fromRGB(80, 80, 80)
    Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    Instance.new("UICorner", Btn)

    local state = default
    Btn.MouseButton1Click:Connect(function()
        state = not state
        Btn.Text = state and "ON" or "OFF"
        Btn.BackgroundColor3 = state and Color3.fromRGB(0, 180, 0) or Color3.fromRGB(80, 80, 80)
        callback(state)
    end)
end

-- スライダー作成関数
local function CreateSlider(parent, text, min, max, default, callback)
    local Frame = Instance.new("Frame", parent)
    Frame.Size = UDim2.new(1, -10, 0, 55)
    Frame.BackgroundTransparency = 1

    local Label = Instance.new("TextLabel", Frame)
    Label.Size = UDim2.new(1, 0, 0, 20)
    Label.Position = UDim2.new(0, 10, 0, 5)
    Label.Text = text .. ": " .. default
    Label.TextColor3 = Color3.fromRGB(200, 200, 200)
    Label.TextSize = 14
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.BackgroundTransparency = 1

    local Bar = Instance.new("Frame", Frame)
    Bar.Size = UDim2.new(1, -20, 0, 4)
    Bar.Position = UDim2.new(0, 10, 0, 35)
    Bar.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    Bar.BorderSizePixel = 0

    local Fill = Instance.new("Frame", Bar)
    Fill.Size = UDim2.new((default-min)/(max-min), 0, 1, 0)
    Fill.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    Fill.BorderSizePixel = 0

    local Dot = Instance.new("TextButton", Bar)
    Dot.Size = UDim2.new(0, 14, 0, 14)
    Dot.Position = UDim2.new((default-min)/(max-min), -7, 0.5, -7)
    Dot.Text = ""
    Dot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Instance.new("UICorner", Dot).CornerRadius = UDim.new(1, 0)

    local dragging = false
    local function update(input)
        local pos = math.clamp((input.Position.X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)
        Fill.Size = UDim2.new(pos, 0, 1, 0)
        Dot.Position = UDim2.new(pos, -7, 0.5, -7)
        local val = math.floor(min + (pos * (max - min)))
        Label.Text = text .. ": " .. val
        callback(val)
    end
    Dot.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = true end
    end)
    game:GetService("UserInputService").InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end
    end)
    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then update(input) end
    end)
end

-- --- 5. 機能の追加と初期化 ---

-- 空中ジャンプ
_G.InfJump = false
game:GetService("UserInputService").JumpRequest:Connect(function()
    if _G.InfJump then
        game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
    end
end)

-- リストへの追加 (ここを増やせばどんどん下に並びます)
CreateSlider(RightScroll, "WalkSpeed", 16, 200, 16, function(v)
    local h = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if h then h.WalkSpeed = v end
end)

CreateSlider(RightScroll, "JumpPower", 50, 300, 50, function(v)
    local h = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if h then h.UseJumpPower = true h.JumpPower = v end
end)

CreateToggle(RightScroll, "空中ジャンプ", _G.InfJump, function(s)
    _G.InfJump = s
end)

-- --- 6. ボタン類のイベント ---
local function showOpen() MainFrame.Visible = false MiniFrame.Visible = false OpenBtn.Visible = true end
local function showMini() MainFrame.Visible = false MiniFrame.Visible = true end
local function showMain() MainFrame.Visible = true MiniFrame.Visible = false OpenBtn.Visible = false end

OpenBtn.MouseButton1Click:Connect(showMain)

local M1 = Instance.new("TextButton", MainFrame)
M1.Size = UDim2.new(0, 30, 0, 30) M1.Position = UDim2.new(1, -70, 0, 5)
M1.Text = "-" M1.BackgroundColor3 = Color3.fromRGB(50, 50, 50) M1.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", M1)
M1.MouseButton1Click:Connect(showMini)

local X1 = Instance.new("TextButton", MainFrame)
X1.Size = UDim2.new(0, 30, 0, 30) X1.Position = UDim2.new(1, -35, 0, 5)
X1.Text = "X" X1.BackgroundColor3 = Color3.fromRGB(200, 0, 0) X1.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", X1)
X1.MouseButton1Click:Connect(showOpen)

local M2 = Instance.new("TextButton", MiniBtnHolder)
M2.Size = UDim2.new(0, 35, 0, 30) M2.Text = "+" M2.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
M2.TextColor3 = Color3.fromRGB(255, 255, 255) Instance.new("UICorner", M2)
M2.MouseButton1Click:Connect(showMain)

local X2 = Instance.new("TextButton", MiniBtnHolder)
X2.Size = UDim2.new(0, 35, 0, 30) X2.Text = "X" X2.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
X2.TextColor3 = Color3.fromRGB(255, 255, 255) Instance.new("UICorner", X2)
X2.MouseButton1Click:Connect(showOpen)

-- FPS更新
spawn(function()
    while wait(1) do
        local fps = math.floor(1/game:GetService("RunService").RenderStepped:Wait())
        MiniTitle.Text = "くまあ HUB v1.1 | FPS: "..fps
    end
end)
