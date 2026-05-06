-- --- スライダー作成関数 (修正版) ---
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
    Label.Font = Enum.Font.SourceSans

    local Bar = Instance.new("Frame", SliderFrame)
    Bar.Size = UDim2.new(0.9, 0, 0, 5)
    Bar.Position = UDim2.new(0, 0, 0.7, 0)
    Bar.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    Bar.BorderSizePixel = 0

    local Fill = Instance.new("Frame", Bar)
    Fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    Fill.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    Fill.BorderSizePixel = 0

    local Button = Instance.new("TextButton", Bar)
    Button.Size = UDim2.new(0, 15, 0, 15)
    Button.Position = UDim2.new((default - min) / (max - min), -7, 0.5, -7)
    Button.Text = ""
    Button.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    
    local BtnCorner = Instance.new("UICorner", Button)
    BtnCorner.CornerRadius = UDim.new(1, 0) -- 丸くする

    local dragging = false

    local function update(input)
        -- マウスまたはタッチの位置を正規化 (0から1の間)
        local inputPos = input.Position.X
        local barPos = Bar.AbsolutePosition.X
        local barSize = Bar.AbsoluteSize.X
        local move = math.clamp((inputPos - barPos) / barSize, 0, 1)
        
        Fill.Size = UDim2.new(move, 0, 1, 0)
        Button.Position = UDim2.new(move, -7, 0.5, -7)
        
        local value = math.floor(min + (move * (max - min)))
        Label.Text = text .. ": " .. value
        callback(value)
    end

    -- ボタンだけでなくバー全体で入力を開始できるように修正
    Button.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
        end
    end)

    -- 入力終了を検知
    game:GetService("UserInputService").InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    -- 入力移動を検知 (タッチ操作にも対応)
    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            update(input)
        end
    end)
end
