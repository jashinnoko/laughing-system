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

-- --- 1. Openボタン (復活) ---
OpenBtn.Name = "OpenButton"
OpenBtn.Parent = ScreenGui
OpenBtn.Visible = false -- 最初は隠しておく
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

local RightContent = Instance.new("Frame", MainFrame)
RightContent.Position = UDim2.new(0, 160, 0, 10)
RightContent.Size = UDim2.new(1, -170, 1, -20)
RightContent.BackgroundTransparency = 1

-- --- 3. 最小化バー ---
MiniFrame.Name = "MiniFrame"
MiniFrame.Parent = ScreenGui
MiniFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MiniFrame.Position = UDim2.new(0.5, -200, 0.2, 0)
MiniFrame.Size = UDim2.new(0, 400, 0, 50)
MiniFrame.Visible = false
MiniFrame.Active = true
MiniFrame.Draggable = true
Instance.new("UICorner", MiniFrame).CornerRadius = UDim.new(0, 12)

local MiniTitle = Instance.new("TextLabel", MiniFrame)
MiniTitle.Size = UDim2.new(0.7, 0, 1, 0)
MiniTitle.Position = UDim2.new(0, 15, 0, 0)
MiniTitle.Text = "くまあ HUB v1.1 | FPS: 60"
MiniTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
MiniTitle.Font = Enum.Font.SourceSansBold
MiniTitle.TextSize = 20
MiniTitle.TextXAlignment = Enum.TextXAlignment.Left
MiniTitle.BackgroundTransparency = 1

-- FPS更新
spawn(function()
    local RunService = game:GetService("RunService")
    while wait(1) do
        local fps = math.floor(1 / RunService.RenderStepped:Wait())
        MiniTitle.Text = "くまあ HUB v1.1 | FPS: " .. fps
    end
end)

local MiniButtons = Instance.new("Frame", MiniFrame)
MiniButtons.Size = UDim2.new(0, 80, 0, 35)
MiniButtons.Position = UDim2.new(1, -90, 0.5, -17)
MiniButtons.BackgroundTransparency = 1
local MiniLayout = Instance.new("UIListLayout", MiniButtons)
MiniLayout.FillDirection = Enum.FillDirection.Horizontal
MiniLayout.Padding = UDim.new(0, 5)

local MaximizeBtn = Instance.new("TextButton", MiniButtons)
MaximizeBtn.Size = UDim2.new(0, 35, 0, 35)
MaximizeBtn.Text = "+"
MaximizeBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
MaximizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", MaximizeBtn)

local MiniCloseBtn = Instance.new("TextButton", MiniButtons)
MiniCloseBtn.Size = UDim2.new(0, 35, 0, 35)
MiniCloseBtn.Text = "X"
MiniCloseBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
MiniCloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", MiniCloseBtn)

-- --- 4. ロジック設定 ---
OpenBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = true
    OpenBtn.Visible = false
end)

local MainMinimizeBtn = Instance.new("TextButton", MainFrame)
MainMinimizeBtn.Size = UDim2.new(0, 30, 0, 30)
MainMinimizeBtn.Position = UDim2.new(1, -70, 0, 5)
MainMinimizeBtn.Text = "-"
MainMinimizeBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
MainMinimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", MainMinimizeBtn)

MainMinimizeBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    MiniFrame.Visible = true
end)

MaximizeBtn.MouseButton1Click:Connect(function()
    MiniFrame.Visible = false
    MainFrame.Visible = true
end)

local function CloseAll()
    MainFrame.Visible = false
    MiniFrame.Visible = false
    OpenBtn.Visible = true
end

local MainCloseBtn = Instance.new("TextButton", MainFrame)
MainCloseBtn.Size = UDim2.new(0, 30, 0, 30)
MainCloseBtn.Position = UDim2.new(1, -35, 0, 5)
MainCloseBtn.Text = "X"
MainCloseBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
MainCloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", MainCloseBtn)

MainCloseBtn.MouseButton1Click:Connect(CloseAll)
MiniCloseBtn.MouseButton1Click:Connect(CloseAll)

-- --- 5. 機能用関数 ---

-- タブ・スライダー作成
local TabHolder = Instance.new("ScrollingFrame", LeftNav)
TabHolder.Position = UDim2.new(0, 0, 0, 40)
TabHolder.Size = UDim2.new(1, 0, 1, -45)
TabHolder.BackgroundTransparency = 1
TabHolder.CanvasSize = UDim2.new(0, 0, 2, 0)
TabHolder.ScrollBarThickness = 0
Instance.new("UIListLayout", TabHolder).Padding = UDim.new(0, 5)

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
    Instance.new("UICorner", Button).CornerRadius = UDim.new(1, 0)
    local dragging = false
    local function update(input)
        local pos = math.clamp((input.Position.X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)
        Fill.Size = UDim2.new(pos, 0, 1, 0)
        Button.Position = UDim2.new(pos, -7, 0.5, -7)
        local value = math.floor(min + (pos * (max - min)))
        Label.Text = text .. ": " .. value
        callback(value)
    end
    Button.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = true end
    end)
    game:GetService("UserInputService").InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end
    end)
    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then update(input) end
    end)
end

local function CreateToggle(parent, text, default, callback)
    local ToggleFrame = Instance.new("Frame", parent)
    ToggleFrame.Size = UDim2.new(1, 0, 0, 40)
    ToggleFrame.BackgroundTransparency = 1
    
    local Label = Instance.new("TextLabel", ToggleFrame)
    Label.Size = UDim2.new(0.7, 0, 1, 0)
    Label.Text = text
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.BackgroundTransparency = 1
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.TextSize = 16

    local Button = Instance.new("TextButton", ToggleFrame)
    Button.Size = UDim2.new(0, 50, 0, 25)
    Button.Position = UDim2.new(1, -55, 0.5, -12)
    Button.Text = default and "ON" or "OFF"
    Button.BackgroundColor3 = default and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(100, 100, 100)
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Instance.new("UICorner", Button)

    local state = default
    Button.MouseButton1Click:Connect(function()
        state = not state
        Button.Text = state and "ON" or "OFF"
        Button.BackgroundColor3 = state and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(100, 100, 100)
        callback(state)
    end)
end

local function CreateTab(name, contentFunc)
    local TabBtn = Instance.new("TextButton", TabHolder)
    TabBtn.Size = UDim2.new(0.9, 0, 0, 35)
    TabBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    TabBtn.Text = name
    TabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    Instance.new("UICorner", TabBtn)
    TabBtn.MouseButton1Click:Connect(function()
        for _, child in pairs(RightContent:GetChildren()) do if not child:IsA("UIListLayout") then child:Destroy() end end
        contentFunc()
    end)
end

-- 空中ジャンプ用変数
_G.InfJump = false
game:GetService("UserInputService").JumpRequest:Connect(function()
    if _G.InfJump then
        game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
    end
end)

-- 初期タブ作成
CreateTab("プレイヤー設定", function()
    local UIList = Instance.new("UIListLayout", RightContent)
    UIList.Padding = UDim.new(0, 10)
    
    -- 空中ジャンプ
    CreateToggle(RightContent, "空中ジャンプ", _G.InfJump, function(state)
        _G.InfJump = state
    end)

    -- スピード
    CreateSlider(RightContent, "WalkSpeed", 16, 200, 16, function(val)
        local lp = game.Players.LocalPlayer
        local function set() if lp.Character and lp.Character:FindFirstChild("Humanoid") then lp.Character.Humanoid.WalkSpeed = val end end
        if _G.SpeedConn then _G.SpeedConn:Disconnect() end
        set()
        _G.SpeedConn = lp.Character.Humanoid:GetPropertyChangedSignal("WalkSpeed"):Connect(set)
    end)

    -- ジャンプ力
    CreateSlider(RightContent, "JumpPower", 50, 300, 50, function(val)
        local lp = game.Players.LocalPlayer
        if lp.Character and lp.Character:FindFirstChild("Humanoid") then
            lp.Character.Humanoid.UseJumpPower = true
            lp.Character.Humanoid.JumpPower = val
        end
    end)
end)
