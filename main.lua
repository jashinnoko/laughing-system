local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local LeftNav = Instance.new("Frame")
local RightContent = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local TabHolder = Instance.new("ScrollingFrame")
local UIListLayout = Instance.new("UIListLayout")

-- GUI設定
ScreenGui.Parent = game.CoreGui
ScreenGui.Name = "MyCustomHub"

MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.Position = UDim2.new(0.5, -250, 0.5, -150)
MainFrame.Size = UDim2.new(0, 500, 0, 300)
MainFrame.Active = true
MainFrame.Draggable = true -- 画面内をドラッグで移動可能

-- 角を丸くする
local UICorner = Instance.new("UICorner", MainFrame)
UICorner.CornerRadius = UDim.new(0, 8)

-- 左側メニュー (Navigation)
LeftNav.Name = "LeftNav"
LeftNav.Parent = MainFrame
LeftNav.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
LeftNav.Size = UDim2.new(0, 150, 1, 0)

local LeftCorner = Instance.new("UICorner", LeftNav)
LeftCorner.CornerRadius = UDim.new(0, 8)

Title.Parent = LeftNav
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Text = "MY HUB v1.0"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 18
Title.BackgroundTransparency = 1

TabHolder.Parent = LeftNav
TabHolder.Position = UDim2.new(0, 0, 0, 40)
TabHolder.Size = UDim2.new(1, 0, 1, -45)
TabHolder.BackgroundTransparency = 1
TabHolder.CanvasSize = UDim2.new(0, 0, 2, 0)
TabHolder.ScrollBarThickness = 0

UIListLayout.Parent = TabHolder
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 5)

-- 右側コンテンツエリア
RightContent.Name = "RightContent"
RightContent.Parent = MainFrame
RightContent.Position = UDim2.new(0, 155, 0, 10)
RightContent.Size = UDim2.new(1, -165, 1, -20)
RightContent.BackgroundTransparency = 1

-- タブ切り替えシステム
local function CreateTab(name, contentFunc)
    local TabBtn = Instance.new("TextButton", TabHolder)
    TabBtn.Size = UDim2.new(0.9, 0, 0, 35)
    TabBtn.Position = UDim2.new(0.05, 0, 0, 0)
    TabBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    TabBtn.Text = name
    TabBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
    TabBtn.Font = Enum.Font.SourceSans
    TabBtn.TextSize = 16

    local BtnCorner = Instance.new("UICorner", TabBtn)

    TabBtn.MouseButton1Click:Connect(function()
        -- 一度右側をクリアにする
        for _, child in pairs(RightContent:GetChildren()) do
            child:Destroy()
        end
        -- 指定された機能を実行
        contentFunc()
    end)
end

-- --- ここから下に「追加したいタブ」を書いていく ---

-- メインタブ
CreateTab("メイン", function()
    local label = Instance.new("TextLabel", RightContent)
    label.Size = UDim2.new(1, 0, 0, 50)
    label.Text = "ここがメインページです"
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.BackgroundTransparency = 1
end)

-- プレイヤー設定タブ
CreateTab("プレイヤー", function()
    local btn = Instance.new("TextButton", RightContent)
    btn.Size = UDim2.new(0, 150, 0, 40)
    btn.Text = "スピードアップ"
    btn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    btn.MouseButton1Click:Connect(function()
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 50
    end)
end)

-- 閉じるボタン
local CloseBtn = Instance.new("TextButton", MainFrame)
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -35, 0, 5)
CloseBtn.Text = "X"
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)
