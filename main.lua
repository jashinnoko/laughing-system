local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local LeftNav = Instance.new("Frame")
local RightContent = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local TabHolder = Instance.new("ScrollingFrame")
local UIListLayout = Instance.new("UIListLayout")

-- GUI設定
ScreenGui.Parent = game.CoreGui
ScreenGui.Name = "KumaaHub"

MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.Position = UDim2.new(0.5, -250, 0.5, -150)
MainFrame.Size = UDim2.new(0, 500, 0, 350)
MainFrame.Active = true
MainFrame.Draggable = true

local UICorner = Instance.new("UICorner", MainFrame)
UICorner.CornerRadius = UDim.new(0, 8)

-- 左側メニュー
LeftNav.Name = "LeftNav"
LeftNav.Parent = MainFrame
LeftNav.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
LeftNav.Size = UDim2.new(0, 150, 1, 0)

local LeftCorner = Instance.new("UICorner", LeftNav)
LeftCorner.CornerRadius = UDim.new(0, 8)

Title.Parent = LeftNav
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Text = "くまあ HUB v1.1" -- 名前を変更
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

RightContent.Name = "RightContent"
RightContent.Parent = MainFrame
RightContent.Position = UDim2.new(0, 160, 0, 10)
RightContent.Size = UDim2.new(1, -170, 1, -20)
RightContent.BackgroundTransparency = 1

-- --- スライダー作成関数 ---
local function CreateSlider(parent, text, min, max, default, callback)
    local SliderFrame = Instance.new("Frame", parent)
    SliderFrame.Size = UDim2.new(1, 0, 0, 50)
    SliderFrame.BackgroundTransparency = 1

    local Label = Instance.new("TextLabel", SliderFrame)
    Label.Size = UDim2.new(1, 0, 0, 20)
    Label.Text = text .. ": " .. default
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.BackgroundTransparency = 1
    Label.TextXAlignment = Enum.TextXAlignment.Left

    local Bar = Instance.new("Frame", SliderFrame)
    Bar.Size = UDim2.new(0.9, 0, 0, 5)
    Bar.Position = UDim2.new(0, 0, 0.7, 0)
    Bar.BackgroundColor3 = Color3.fromRGB(60, 60, 60)

    local Fill = Instance.new("Frame", Bar)
    Fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    Fill.BackgroundColor3 = Color3.fromRGB(0, 150, 255)

    local Button = Instance.new("TextButton", Bar)
    Button.Size = UDim2.new(0, 15, 0, 15)
    Button.Position = UDim2.new((default - min) / (max - min), -7, 0.5, -7)
    Button.Text = ""
    Button.BackgroundColor3 = Color3.fromRGB(255, 255, 255)

    local function update(input)
        local pos = math.clamp((input.Position.X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)
        Fill.Size = UDim2.new(pos, 0, 1, 0)
        Button.Position = UDim2.new(pos, -7, 0.5, -7)
        local value = math.floor(min + (pos * (max - min)))
        Label.Text = text .. ": " .. value
        callback(value)
    end

    local dragging = false
    Button.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true end
    end)
    game:GetService("UserInputService").InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)
    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then update(input) end
    end)
end

-- --- タブ作成 ---
local function CreateTab(name, contentFunc)
    local TabBtn = Instance.new("TextButton", TabHolder)
    TabBtn.Size = UDim2.new(0.9, 0, 0, 35)
    TabBtn.Position = UDim2.new(0.05, 0, 0, 0)
    TabBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    TabBtn.Text = name
    TabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    local BtnCorner = Instance.new("UICorner", TabBtn)

    TabBtn.MouseButton1Click:Connect(function()
        for _, child in pairs(RightContent:GetChildren()) do child:Destroy() end
        contentFunc()
    end)
end

-- プレイヤー設定タブ
CreateTab("プレイヤー設定", function()
    local UIList = Instance.new("UIListLayout", RightContent)
    UIList.Padding = UDim.new(0, 10)

    -- 移動速度スライダー
    CreateSlider(RightContent, "WalkSpeed", 16, 200, 16, function(val)
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = val
    end)

    -- ジャンプ力スライダー
    CreateSlider(RightContent, "JumpPower", 50, 300, 50, function(val)
        game.Players.LocalPlayer.Character.Humanoid.JumpPower = val
    end)
end)

-- 閉じるボタン
local CloseBtn = Instance.new("TextButton", MainFrame)
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -35, 0, 5)
CloseBtn.Text = "X"
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)
