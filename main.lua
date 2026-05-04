local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local LeftNav = Instance.new("Frame")
local RightContent = Instance.new("Frame")
local TitleBar = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local TabHolder = Instance.new("ScrollingFrame")
local UIListLayout = Instance.new("UIListLayout")

-- GUI設定
ScreenGui.Parent = game.CoreGui
ScreenGui.Name = "KumaaHubV13"

MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.Position = UDim2.new(0.5, -250, 0.5, -150)
MainFrame.Size = UDim2.new(0, 500, 0, 350)
MainFrame.Active = true
MainFrame.Draggable = false -- 干渉を防ぐため標準機能はOFF

-- 【改善】カスタムドラッグ機能 (タイトルバーのみ)
local dragToggle, dragInput, dragStart, startPos
TitleBar.Name = "TitleBar"
TitleBar.Parent = MainFrame
TitleBar.Size = UDim2.new(1, 0, 0, 40)
TitleBar.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
TitleBar.BorderSizePixel = 0

TitleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragToggle = true
        dragStart = input.Position
        startPos = MainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragToggle = false end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement and dragToggle then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- 角丸設定
local UICorner = Instance.new("UICorner", MainFrame)
UICorner.CornerRadius = UDim.new(0, 8)

-- 左側メニュー
LeftNav.Name = "LeftNav"
LeftNav.Parent = MainFrame
LeftNav.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
LeftNav.Size = UDim2.new(0, 150, 1, 0)
local LeftCorner = Instance.new("UICorner", LeftNav)
LeftCorner.CornerRadius = UDim.new(0, 8)

Title.Parent = TitleBar
Title.Size = UDim2.new(1, -40, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.Text = "くまあ HUB v1.3"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 18
Title.BackgroundTransparency = 1
Title.TextXAlignment = Enum.TextXAlignment.Left

TabHolder.Parent = LeftNav
TabHolder.Position = UDim2.new(0, 0, 0, 45)
TabHolder.Size = UDim2.new(1, 0, 1, -50)
TabHolder.BackgroundTransparency = 1
TabHolder.ScrollBarThickness = 0

UIListLayout.Parent = TabHolder
UIListLayout.Padding = UDim.new(0, 5)

RightContent.Name = "RightContent"
RightContent.Parent = MainFrame
RightContent.Position = UDim2.new(0, 160, 0, 50)
RightContent.Size = UDim2.new(1, -170, 1, -60)
RightContent.BackgroundTransparency = 1

-- --- スライダー作成関数 ---
local function CreateSlider(parent, text, min, max, default, callback)
    local SliderFrame = Instance.new("Frame", parent)
    SliderFrame.Size = UDim2.new(1, 0, 0, 60)
    SliderFrame.BackgroundTransparency = 1

    local Label = Instance.new("TextLabel", SliderFrame)
    Label.Size = UDim2.new(0.6, 0, 0, 20)
    Label.Text = text .. ": " .. default
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.BackgroundTransparency = 1
    Label.TextXAlignment = Enum.TextXAlignment.Left

    local ResetBtn = Instance.new("TextButton", SliderFrame)
    ResetBtn.Size = UDim2.new(0, 60, 0, 20)
    ResetBtn.Position = UDim2.new(0.7, 0, 0, 0)
    ResetBtn.Text = "Reset"
    ResetBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    ResetBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    Instance.new("UICorner", ResetBtn).CornerRadius = UDim.new(0, 4)

    local Bar = Instance.new("Frame", SliderFrame)
    Bar.Size = UDim2.new(0.9, 0, 0, 6)
    Bar.Position = UDim2.new(0, 0, 0.6, 0)
    Bar.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    Bar.BorderSizePixel = 0

    local Fill = Instance.new("Frame", Bar)
    Fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    Fill.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    Fill.BorderSizePixel = 0

    local Button = Instance.new("TextButton", Bar)
    Button.Size = UDim2.new(0, 18, 0, 18)
    Button.Position = UDim2.new((default - min) / (max - min), -9, 0.5, -9)
    Button.Text = ""
    Button.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Instance.new("UICorner", Button).CornerRadius = UDim.new(1, 0)

    local function update(input)
        local pos = math.clamp((input.Position.X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)
        Fill.Size = UDim2.new(pos, 0, 1, 0)
        Button.Position = UDim2.new(pos, -9, 0.5, -9)
        local value = math.floor(min + (pos * (max - min)))
        Label.Text = text .. ": " .. value
        callback(value)
    end

    Button.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            local connection
            connection = UserInputService.InputChanged:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseMovement then
                    update(input)
                end
            end)
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    connection:Disconnect()
                end
            end)
        end
    end)

    ResetBtn.MouseButton1Click:Connect(function()
        local pos = (default - min) / (max - min)
        Fill.Size = UDim2.new(pos, 0, 1, 0)
        Button.Position = UDim2.new(pos, -9, 0.5, -9)
        Label.Text = text .. ": " .. default
        callback(default)
    end)
end

-- タブ作成
local function CreateTab(name, contentFunc)
    local TabBtn = Instance.new("TextButton", TabHolder)
    TabBtn.Size = UDim2.new(0.9, 0, 0, 35)
    TabBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    TabBtn.Text = name
    TabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    Instance.new("UICorner", TabBtn)
    TabBtn.MouseButton1Click:Connect(function()
        for _, child in pairs(RightContent:GetChildren()) do child:Destroy() end
        contentFunc()
    end)
end

CreateTab("プレイヤー設定", function()
    local UIList = Instance.new("UIListLayout", RightContent)
    UIList.Padding = UDim.new(0, 15)
    CreateSlider(RightContent, "WalkSpeed", 16, 200, 16, function(val)
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.WalkSpeed = val
        end
    end)
    CreateSlider(RightContent, "JumpPower", 50, 300, 50, function(val)
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.JumpPower = val
        end
    end)
end)

-- 閉じるボタン
local CloseBtn = Instance.new("TextButton", TitleBar)
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -35, 0, 5)
CloseBtn.Text = "X"
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", CloseBtn)
CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)
