--[[
  🚀 Sky-Base-Maker (Full LocalScript)
  - Đặt script này dưới dạng LocalScript trong StarterPlayerScripts
  - Tính năng:
    • Animation intro (TweenService)
    • Giao diện sạch sẽ với highlight màu trắng nhạt
    • Thanh trượt để điều chỉnh chiều cao BasePart
    • Thêm/Xóa phần tử dưới chân người chơi (raycast)
    • Kéo giao diện qua UserInputService
    • Kiểm tra phòng ngừa cho respawn/parts bị khóa/parts bị destroy
  Tác giả: adjusted for you (MidoriMidoru style)
--]]

-- ===========================
-- 🔧 Services & Utils
-- ===========================
local StarterGui = game:GetService("StarterGui")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")

-- Hiệu ứng loading intro
StarterGui:SetCore("SendNotification", {
    Title = "Đang tải...",
    Text = "Sky-Base-Maker by MidoriMidoru_73816",
    Duration = 3,
    Icon = "rbxassetid://0"
})

-- Xóa fog và atmosphere
local function clearFog()
    Lighting.FogStart = 0
    Lighting.FogEnd = 1e9
end

local function neuterAtmosphere(a)
    if a and a:IsA("Atmosphere") then
        a.Density = 0
        pcall(function() a.Haze = 0 end)
        pcall(function() a.Glare = 0 end)
        a:GetPropertyChangedSignal("Density"):Connect(function()
            a.Density = 0
        end)
        pcall(function()
            a:GetPropertyChangedSignal("Haze"):Connect(function()
                a.Haze = 0
            end)
        end)
        pcall(function()
            a:GetPropertyChangedSignal("Glare"):Connect(function()
                a.Glare = 0
            end)
        end)
    end
end

clearFog()
for _, child in ipairs(Lighting:GetChildren()) do
    neuterAtmosphere(child)
end

Lighting.ChildAdded:Connect(neuterAtmosphere)
Lighting:GetPropertyChangedSignal("FogStart"):Connect(clearFog)
Lighting:GetPropertyChangedSignal("FogEnd"):Connect(clearFog)

-- Tạo giao diện chính
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "SkyBaseMakerUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Tạo overlay intro animation
local introFrame = Instance.new("Frame")
introFrame.Size = UDim2.new(1, 0, 1, 0)
introFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
introFrame.BackgroundTransparency = 0
introFrame.ZIndex = 100
introFrame.Parent = screenGui

local introText = Instance.new("TextLabel")
introText.Size = UDim2.new(0, 400, 0, 100)
introText.Position = UDim2.new(0.5, -200, 0.5, -50)
introText.Text = "SKY BASE MAKER"
introText.TextColor3 = Color3.fromRGB(255, 255, 255)
introText.TextScaled = true
introText.Font = Enum.Font.SourceSansBold
introText.BackgroundTransparency = 1
introText.ZIndex = 101
introText.Parent = introFrame

local subText = Instance.new("TextLabel")
subText.Size = UDim2.new(0, 300, 0, 30)
subText.Position = UDim2.new(0.5, -150, 0.5, 40)
subText.Text = "by MidoriMidoru_73816"
subText.TextColor3 = Color3.fromRGB(200, 200, 200)
subText.TextScaled = true
subText.Font = Enum.Font.SourceSans
subText.BackgroundTransparency = 1
subText.ZIndex = 101
subText.Parent = introFrame

-- Animation intro
spawn(function()
    local tweenInfo = TweenInfo.new(1.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    
    -- Fade in text
    local textTween = TweenService:Create(introText, tweenInfo, {TextTransparency = 0})
    local subTextTween = TweenService:Create(subText, tweenInfo, {TextTransparency = 0})
    textTween:Play()
    subTextTween:Play()
    
    wait(2)
    
    -- Fade out everything
    local fadeOutTween = TweenService:Create(introFrame, TweenInfo.new(1.5), {BackgroundTransparency = 1})
    local textFadeOut = TweenService:Create(introText, TweenInfo.new(1.5), {TextTransparency = 1})
    local subTextFadeOut = TweenService:Create(subText, TweenInfo.new(1.5), {TextTransparency = 1})
    
    fadeOutTween:Play()
    textFadeOut:Play()
    subTextFadeOut:Play()
    
    fadeOutTween.Completed:Connect(function()
        introFrame:Destroy()
    end)
end)

-- Tạo frame chính
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 280, 0, 200)
frame.Position = UDim2.new(0.5, -140, 0.5, -100)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
frame.BorderSizePixel = 0
frame.AnchorPoint = Vector2.new(0.5, 0.5)
frame.Active = true
frame.Visible = false  -- Ẩn cho đến khi intro kết thúc
frame.Parent = screenGui

-- Hiệu ứng bóng đổ
local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 8)
uiCorner.Parent = frame

local uiStroke = Instance.new("UIStroke")
uiStroke.Color = Color3.fromRGB(80, 80, 90)
uiStroke.Thickness = 2
uiStroke.Parent = frame

-- Tiêu đề
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.Text = "SKY BASE MAKER v2.0"
title.TextColor3 = Color3.fromRGB(220, 220, 220)
title.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 18
title.BorderSizePixel = 0
title.Parent = frame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 8)
titleCorner.Parent = title

-- Frame thanh trượt
local sliderFrame = Instance.new("Frame")
sliderFrame.Size = UDim2.new(1, -20, 0, 50)
sliderFrame.Position = UDim2.new(0, 10, 0, 50)
sliderFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
sliderFrame.BorderSizePixel = 0
sliderFrame.Parent = frame

local sliderCorner = Instance.new("UICorner")
sliderCorner.CornerRadius = UDim.new(0, 6)
sliderCorner.Parent = sliderFrame

-- Thanh trượt
local sliderBar = Instance.new("Frame")
sliderBar.Size = UDim2.new(1, -20, 0, 6)
sliderBar.Position = UDim2.new(0, 10, 0.5, -3)
sliderBar.BackgroundColor3 = Color3.fromRGB(80, 80, 90)
sliderBar.BorderSizePixel = 0
sliderBar.Parent = sliderFrame

local barCorner = Instance.new("UICorner")
barCorner.CornerRadius = UDim.new(0, 3)
barCorner.Parent = sliderBar

-- Nút trượt
local sliderButton = Instance.new("TextButton")
sliderButton.Size = UDim2.new(0, 20, 0, 20)
sliderButton.Position = UDim2.new(0, 0, 0.5, -10)
sliderButton.Text = ""
sliderButton.BackgroundColor3 = Color3.fromRGB(220, 220, 220)
sliderButton.BorderSizePixel = 0
sliderButton.Parent = sliderFrame

local buttonCorner = Instance.new("UICorner")
buttonCorner.CornerRadius = UDim.new(0, 10)
buttonCorner.Parent = sliderButton

-- Hiển thị giá trị
local valueLabel = Instance.new("TextLabel")
valueLabel.Size = UDim2.new(0, 40, 0, 20)
valueLabel.Position = UDim2.new(1, -40, 0, 5)
valueLabel.Text = "0"
valueLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
valueLabel.BackgroundTransparency = 1
valueLabel.Font = Enum.Font.SourceSansSemibold
valueLabel.TextSize = 16
valueLabel.Parent = sliderFrame

-- Nút thêm
local addButton = Instance.new("TextButton")
addButton.Size = UDim2.new(0.45, -5, 0, 35)
addButton.Position = UDim2.new(0, 10, 0, 110)
addButton.Text = "⚓️ THÊM"
addButton.TextColor3 = Color3.fromRGB(240, 240, 240)
addButton.BackgroundColor3 = Color3.fromRGB(70, 150, 70)
addButton.Font = Enum.Font.SourceSansSemibold
addButton.TextSize = 14
addButton.BorderSizePixel = 0
addButton.Parent = frame

local addCorner = Instance.new("UICorner")
addCorner.CornerRadius = UDim.new(0, 6)
addCorner.Parent = addButton

-- Nút xóa
local removeButton = Instance.new("TextButton")
removeButton.Size = UDim2.new(0.45, -5, 0, 35)
removeButton.Position = UDim2.new(0.55, 0, 0, 110)
removeButton.Text = "✂️ XÓA"
removeButton.TextColor3 = Color3.fromRGB(240, 240, 240)
removeButton.BackgroundColor3 = Color3.fromRGB(180, 70, 70)
removeButton.Font = Enum.Font.SourceSansSemibold
removeButton.TextSize = 14
removeButton.BorderSizePixel = 0
removeButton.Parent = frame

local removeCorner = Instance.new("UICorner")
removeCorner.CornerRadius = UDim.new(0, 6)
removeCorner.Parent = removeButton

-- Nút ẩn/hiện
local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0, 100, 0, 35)
toggleButton.Position = UDim2.new(0.5, -50, 0, 155)
toggleButton.Text = "📋 HIỆN UI"
toggleButton.TextColor3 = Color3.fromRGB(240, 240, 240)
toggleButton.BackgroundColor3 = Color3.fromRGB(60, 100, 150)
toggleButton.Font = Enum.Font.SourceSansSemibold
toggleButton.TextSize = 14
toggleButton.BorderSizePixel = 0
toggleButton.Parent = frame

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0, 6)
toggleCorner.Parent = toggleButton

-- Label hướng dẫn
local helpLabel = Instance.new("TextLabel")
helpLabel.Size = UDim2.new(1, -20, 0, 40)
helpLabel.Position = UDim2.new(0, 10, 0, 195)
helpLabel.Text = "Chọn phần tử dưới chân và điều chỉnh độ cao"
helpLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
helpLabel.BackgroundTransparency = 1
helpLabel.Font = Enum.Font.SourceSans
helpLabel.TextSize = 12
helpLabel.TextWrapped = true
helpLabel.Parent = frame

-- Biến toàn cục
local targets = {}
local dragging = false
local sliderValue = 0
local lastCheck = 0
local isUIVisible = false

-- Hiển thị UI với animation
local function showUI()
    frame.Visible = true
    isUIVisible = true
    toggleButton.Text = "📋 ẨN UI"
    
    -- Animation hiện
    frame.Position = UDim2.new(0.5, -140, 0.3, -100)
    local tween = TweenService:Create(frame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), 
        {Position = UDim2.new(0.5, -140, 0.5, -100)})
    tween:Play()
end

-- Ẩn UI với animation
local function hideUI()
    isUIVisible = false
    toggleButton.Text = "📋 HIỆN UI"
    
    -- Animation ẩn
    local tween = TweenService:Create(frame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.In), 
        {Position = UDim2.new(0.5, -140, 0.3, -100)})
    tween:Play()
    
    tween.Completed:Connect(function()
        frame.Visible = false
    end)
end

-- Hiển thị UI sau khi intro kết thúc
delay(4, function()
    showUI()
    
    -- Thông báo hướng dẫn
    StarterGui:SetCore("SendNotification", {
        Title = "Hướng dẫn",
        Text = "Sử dụng thanh trượt để điều chỉnh độ cao",
        Duration = 5,
    })
end)

-- Lấy phần tử dưới chân người chơi
local function getFootPart()
    local character = LocalPlayer.Character
    if not character then return nil end
    
    local root = character:FindFirstChild("HumanoidRootPart")
    if not root then return nil end
    
    -- Sử dụng Raycast để tìm phần tử chính xác hơn
    local rayOrigin = root.Position
    local rayDirection = Vector3.new(0, -10, 0)
    local raycastParams = RaycastParams.new()
    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
    raycastParams.FilterDescendantsInstances = {character}
    
    local raycastResult = workspace:Raycast(rayOrigin, rayDirection, raycastParams)
    if raycastResult and raycastResult.Instance then
        return raycastResult.Instance
    end
    
    return nil
end

-- Tạo highlight với màu trắng nhạt
local function ensureHighlight(part)
    if not part or not part:IsA("BasePart") then return end
    
    local highlight = part:FindFirstChild("PersistentHighlight")
    if not highlight then
        highlight = Instance.new("Highlight")
        highlight.Name = "PersistentHighlight"
        highlight.Adornee = part
        highlight.FillColor = Color3.fromRGB(255, 255, 255)  -- Màu trắng
        highlight.FillTransparency = 0.7  -- Trong suốt 70%
        highlight.OutlineColor = Color3.fromRGB(200, 200, 200)
        highlight.OutlineTransparency = 0.3
        highlight.Parent = part
    end
end

-- Xóa highlight
local function removeHighlight(part)
    local highlight = part and part:FindFirstChild("PersistentHighlight")
    if highlight then
        highlight:Destroy()
    end
end

-- Cập nhật thanh trượt
local function updateSlider(inputX)
    local barPos = sliderBar.AbsolutePosition.X
    local barSize = sliderBar.AbsoluteSize.X
    local relativeX = math.clamp(inputX - barPos, 0, barSize)
    
    sliderButton.Position = UDim2.new(0, relativeX - 10, 0.5, -10)
    sliderValue = math.floor((relativeX / barSize) * 100)
    valueLabel.Text = tostring(sliderValue)
    
    -- Cập nhật kích thước cho tất cả các phần tử đã chọn
    for part, _ in pairs(targets) do
        if part and part:IsA("BasePart") and part.Parent then
            part.Size = Vector3.new(part.Size.X, sliderValue, part.Size.Z)
        end
    end
end

-- Kéo UI
local dragInput, dragStart, startPos
local function updateInput(input)
    local delta = input.Position - dragStart
    frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, 
                              startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragStart = input.Position
        startPos = frame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

frame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        updateInput(input)
    end
end)

-- Sự kiện cho thanh trượt
sliderButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        updateSlider(input.Position.X)
    end
end)

sliderBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        updateSlider(input.Position.X)
    end
end)

-- Sự kiện cho nút thêm
addButton.MouseButton1Click:Connect(function()
    local part = getFootPart()
    if part and not targets[part] then
        if part:IsA("BasePart") then
            targets[part] = true
            ensureHighlight(part)
            
            -- Thông báo
            StarterGui:SetCore("SendNotification", {
                Title = "Đã thêm",
                Text = "Phần tử đã được thêm vào danh sách",
                Duration = 2,
            })
        end
    end
end)

-- Sự kiện cho nút xóa
removeButton.MouseButton1Click:Connect(function()
    local part = getFootPart()
    if part and targets[part] then
        targets[part] = nil
        removeHighlight(part)
        
        -- Thông báo
        StarterGui:SetCore("SendNotification", {
            Title = "Đã xóa",
            Text = "Phần tử đã được xóa khỏi danh sách",
            Duration = 2,
        })
    end
end)

-- Sự kiện cho nút ẩn/hiện
toggleButton.MouseButton1Click:Connect(function()
    if isUIVisible then
        hideUI()
    else
        showUI()
    end
end)

-- Kiểm tra và bảo trì các phần tử đã chọn
RunService.RenderStepped:Connect(function()
    if tick() - lastCheck >= 2 then
        lastCheck = tick()
        
        local toRemove = {}
        
        for part, _ in pairs(targets) do
            if not part or not part:IsA("BasePart") or not part.Parent then
                table.insert(toRemove, part)
            else
                if not part:FindFirstChild("PersistentHighlight") then
                    ensureHighlight(part)
                end
            end
        end
        
        for _, part in ipairs(toRemove) do
            targets[part] = nil
        end
    end
end)
