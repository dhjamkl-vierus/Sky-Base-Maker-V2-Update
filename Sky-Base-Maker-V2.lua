-- ======= LOADING ANIMATION =======
local StarterGui = game:GetService("StarterGui")
local Lighting = game:GetService("Lighting")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

-- Tạo màn hình loading
local LocalPlayer = Players.LocalPlayer
local playerGui = LocalPlayer:WaitForChild("PlayerGui")

local loadingGui = Instance.new("ScreenGui")
loadingGui.Name = "LoadingGui"
loadingGui.ResetOnSpawn = false
loadingGui.Parent = playerGui

local loadingFrame = Instance.new("Frame")
loadingFrame.Size = UDim2.new(1, 0, 1, 0)
loadingFrame.Position = UDim2.new(0, 0, 0, 0)
loadingFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
loadingFrame.BorderSizePixel = 0
loadingFrame.ZIndex = 100
loadingFrame.Parent = loadingGui

local loadingText = Instance.new("TextLabel")
loadingText.Size = UDim2.new(0, 400, 0, 100)
loadingText.Position = UDim2.new(0.5, -200, 0.4, -50)
loadingText.Text = "SKY BASE MAKER"
loadingText.TextColor3 = Color3.fromRGB(200, 220, 255)
loadingText.TextScaled = true
loadingText.Font = Enum.Font.GothamBlack
loadingText.BackgroundTransparency = 1
loadingText.ZIndex = 101
loadingText.Parent = loadingFrame

local subText = Instance.new("TextLabel")
subText.Size = UDim2.new(0, 300, 0, 40)
subText.Position = UDim2.new(0.5, -150, 0.5, 0)
subText.Text = "by MidoriMidoru_73816"
subText.TextColor3 = Color3.fromRGB(180, 200, 230)
subText.TextScaled = true
subText.Font = Enum.Font.Gotham
subText.BackgroundTransparency = 1
subText.ZIndex = 101
subText.Parent = loadingFrame

-- Animation loading
spawn(function()
    local tweenInfo = TweenInfo.new(1.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    
    -- Fade in
    local textTween = TweenService:Create(loadingText, tweenInfo, {TextTransparency = 0})
    local subTextTween = TweenService:Create(subText, tweenInfo, {TextTransparency = 0})
    textTween:Play()
    subTextTween:Play()
    
    wait(2)
    
    -- Fade out
    local fadeOut = TweenService:Create(loadingFrame, TweenInfo.new(1.5), {BackgroundTransparency = 1})
    local textFadeOut = TweenService:Create(loadingText, TweenInfo.new(1.5), {TextTransparency = 1})
    local subTextFadeOut = TweenService:Create(subText, TweenInfo.new(1.5), {TextTransparency = 1})
    
    fadeOut:Play()
    textFadeOut:Play()
    subTextFadeOut:Play()
    
    fadeOut.Completed:Connect(function()
        loadingGui:Destroy()
    end)
end)

-- ======= ORIGINAL FUNCTIONALITY WITH ENHANCED GUI =======
StarterGui:SetCore("SendNotification", { 
    Title = "loading...", 
    Text = "made by MidoriMidoru_73816", 
    Duration = 5 
})

local function clearFog() 
    Lighting.FogStart = 0 
    Lighting.FogEnd = 1e9 
end

local function neuterAtmosphere(a) 
    if a and a:IsA("Atmosphere") then 
        a.Density = 0 
        pcall(function() a.Haze = 0 end) 
        pcall(function() a.Glare = 0 end) 
        a:GetPropertyChangedSignal("Density"):Connect(function() a.Density = 0 end) 
        pcall(function() a:GetPropertyChangedSignal("Haze"):Connect(function() a.Haze = 0 end) end) 
        pcall(function() a:GetPropertyChangedSignal("Glare"):Connect(function() a.Glare = 0 end) end) 
    end 
end

clearFog() 
for _, child in ipairs(Lighting:GetChildren()) do 
    neuterAtmosphere(child) 
end

Lighting.ChildAdded:Connect(neuterAtmosphere) 
Lighting:GetPropertyChangedSignal("FogStart"):Connect(clearFog) 
Lighting:GetPropertyChangedSignal("FogEnd"):Connect(clearFog)

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "HeightAdjusterGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- Modern frame design
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 200)  -- Increased height for input box
frame.Position = UDim2.new(0.5, -150, 0.1, 0)
frame.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
frame.BorderSizePixel = 0
frame.Active = true
frame.Parent = screenGui

-- Add rounded corners
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = frame

-- Add subtle shadow effect
local shadow = Instance.new("UIStroke")
shadow.Color = Color3.fromRGB(80, 80, 90)
shadow.Thickness = 2
shadow.Parent = frame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.Text = "SKY BASE MAKER v2.0"
title.TextColor3 = Color3.fromRGB(220, 220, 220)
title.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
title.Font = Enum.Font.GothamBold
title.TextSize = 14
title.Parent = frame

-- Add rounded corners to title
local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 8)
titleCorner.Parent = title

local sliderFrame = Instance.new("Frame")
sliderFrame.Size = UDim2.new(1, -20, 0, 40)
sliderFrame.Position = UDim2.new(0, 10, 0, 40)
sliderFrame.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
sliderFrame.BorderSizePixel = 0
sliderFrame.Parent = frame

local sliderBar = Instance.new("Frame")
sliderBar.Size = UDim2.new(1, -20, 0, 10)
sliderBar.Position = UDim2.new(0, 10, 0.5, -5)
sliderBar.BackgroundColor3 = Color3.fromRGB(100, 100, 110)
sliderBar.BorderSizePixel = 0
sliderBar.Parent = sliderFrame

local sliderButton = Instance.new("TextButton")
sliderButton.Size = UDim2.new(0, 20, 0, 20)
sliderButton.Position = UDim2.new(0, 0, 0.5, -10)
sliderButton.Text = ""
sliderButton.BackgroundColor3 = Color3.fromRGB(220, 220, 220)
sliderButton.Parent = sliderFrame

-- Height value display
local valueDisplay = Instance.new("TextLabel")
valueDisplay.Size = UDim2.new(0, 40, 0, 20)
valueDisplay.Position = UDim2.new(1, -45, 0.5, -10)
valueDisplay.Text = "0"
valueDisplay.TextColor3 = Color3.fromRGB(220, 220, 220)
valueDisplay.BackgroundTransparency = 1
valueDisplay.Font = Enum.Font.GothamBold
valueDisplay.TextSize = 14
valueDisplay.Parent = sliderFrame

-- NEW: Height input box
local inputFrame = Instance.new("Frame")
inputFrame.Size = UDim2.new(1, -20, 0, 30)
inputFrame.Position = UDim2.new(0, 10, 0, 90)
inputFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
inputFrame.BorderSizePixel = 0
inputFrame.Parent = frame

local inputCorner = Instance.new("UICorner")
inputCorner.CornerRadius = UDim.new(0, 6)
inputCorner.Parent = inputFrame

local heightInput = Instance.new("TextBox")
heightInput.Size = UDim2.new(0.5, -5, 1, 0)
heightInput.Position = UDim2.new(0, 5, 0, 0)
heightInput.Text = "0"
heightInput.PlaceholderText = "Enter height (1-100)"
heightInput.TextColor3 = Color3.fromRGB(220, 220, 220)
heightInput.BackgroundTransparency = 1
heightInput.Font = Enum.Font.Gotham
heightInput.TextSize = 14
heightInput.Parent = inputFrame

local inputLabel = Instance.new("TextLabel")
inputLabel.Size = UDim2.new(0.5, -5, 1, 0)
inputLabel.Position = UDim2.new(0.5, 0, 0, 0)
inputLabel.Text = "Height Input"
inputLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
inputLabel.BackgroundTransparency = 1
inputLabel.Font = Enum.Font.Gotham
inputLabel.TextSize = 14
inputLabel.TextXAlignment = Enum.TextXAlignment.Left
inputLabel.Parent = inputFrame

local addButton = Instance.new("TextButton")
addButton.Size = UDim2.new(0.45, -5, 0, 30)
addButton.Position = UDim2.new(0, 10, 0, 130)
addButton.Text = "⚓️ ADD"
addButton.TextColor3 = Color3.fromRGB(240, 240, 240)
addButton.BackgroundColor3 = Color3.fromRGB(70, 150, 70)
addButton.Font = Enum.Font.GothamBold
addButton.TextSize = 14
addButton.Parent = frame

local addCorner = Instance.new("UICorner")
addCorner.CornerRadius = UDim.new(0, 6)
addCorner.Parent = addButton

local removeButton = Instance.new("TextButton")
removeButton.Size = UDim2.new(0.45, -5, 0, 30)
removeButton.Position = UDim2.new(0.55, 0, 0, 130)
removeButton.Text = "✂️ REMOVE"
removeButton.TextColor3 = Color3.fromRGB(240, 240, 240)
removeButton.BackgroundColor3 = Color3.fromRGB(180, 70, 70)
removeButton.Font = Enum.Font.GothamBold
removeButton.TextSize = 14
removeButton.Parent = frame

local removeCorner = Instance.new("UICorner")
removeCorner.CornerRadius = UDim.new(0, 6)
removeCorner.Parent = removeButton

local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0, 80, 0, 30)
toggleButton.Position = UDim2.new(0, 10, 0, 170)
toggleButton.Text = "😙 TOGGLE"
toggleButton.TextColor3 = Color3.fromRGB(240, 240, 240)
toggleButton.BackgroundColor3 = Color3.fromRGB(80, 100, 180)
toggleButton.Font = Enum.Font.GothamBold
toggleButton.TextSize = 14
toggleButton.Parent = screenGui

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0, 6)
toggleCorner.Parent = toggleButton

local targets = {} 
local dragging = false 
local sliderValue = 0 
local lastCheck = 0

-- Modern drag implementation (better than Draggable)
local dragStart, startPos
frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
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
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, 
                                  startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

local function getFootPart() 
    local character = LocalPlayer.Character 
    if not character then return nil end 
    local root = character:FindFirstChild("HumanoidRootPart") 
    if not root then return nil end 
    local ray = Ray.new(root.Position, Vector3.new(0, -5, 0)) 
    local part = workspace:FindPartOnRay(ray, character) 
    return part 
end

local function ensureHighlight(part) 
    if not part or not part:IsA("BasePart") then return end 
    local highlight = part:FindFirstChild("PersistentHighlight") 
    if not highlight then 
        highlight = Instance.new("Highlight") 
        highlight.Name = "PersistentHighlight" 
        highlight.Adornee = part 
        highlight.FillColor = Color3.fromRGB(220, 220, 220)  -- Light white
        highlight.FillTransparency = 0.4
        highlight.OutlineColor = Color3.fromRGB(255, 255, 255) 
        highlight.OutlineTransparency = 0 
        highlight.Parent = part 
    end 
end

local function removeHighlight(part) 
    local highlight = part and part:FindFirstChild("PersistentHighlight") 
    if highlight then 
        highlight:Destroy() 
    end 
end

local function updateSlider(inputX) 
    local barPos = sliderBar.AbsolutePosition.X 
    local barSize = sliderBar.AbsoluteSize.X 
    local relativeX = math.clamp(inputX - barPos, 0, barSize) 
    sliderButton.Position = UDim2.new(0, relativeX - 10, 0.5, -10) 
    sliderValue = math.floor((relativeX / barSize) * 100) 
    valueDisplay.Text = tostring(sliderValue)
    heightInput.Text = tostring(sliderValue)
    
    for part, _ in pairs(targets) do 
        if part and part:IsA("BasePart") then 
            part.Size = Vector3.new(part.Size.X, sliderValue, part.Size.Z) 
        end 
    end 
end

-- NEW: Update from text input
local function updateFromInput()
    local num = tonumber(heightInput.Text)
    if num and num >= 1 and num <= 100 then
        sliderValue = num
        valueDisplay.Text = tostring(sliderValue)
        
        -- Update slider position
        local barSize = sliderBar.AbsoluteSize.X
        if barSize > 0 then
            local relativeX = (num / 100) * barSize
            sliderButton.Position = UDim2.new(0, relativeX - 10, 0.5, -10)
        end
        
        -- Update parts
        for part, _ in pairs(targets) do 
            if part and part:IsA("BasePart") then 
                part.Size = Vector3.new(part.Size.X, sliderValue, part.Size.Z) 
            end 
        end
    else
        heightInput.Text = tostring(sliderValue)  -- Reset to current value
    end
end

sliderButton.InputBegan:Connect(function(input) 
    if input.UserInputType == Enum.UserInputType.MouseButton1 then 
        dragging = true 
    end 
end)

UserInputService.InputEnded:Connect(function(input) 
    if input.UserInputType == Enum.UserInputType.MouseButton1 then 
        dragging = false 
    end 
end)

UserInputService.InputChanged:Connect(function(input) 
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then 
        updateSlider(input.Position.X) 
    end 
end)

sliderBar.InputBegan:Connect(function(input) 
    if input.UserInputType == Enum.UserInputType.MouseButton1 then 
        updateSlider(input.Position.X) 
    end 
end)

-- NEW: Text input event
heightInput.FocusLost:Connect(function()
    updateFromInput()
end)

addButton.MouseButton1Click:Connect(function() 
    local part = getFootPart() 
    if part and not targets[part] then 
        if part.Size.X > 35 and part.Size.Z > 35 then 
            targets[part] = true 
            ensureHighlight(part) 
        end 
    end 
end)

removeButton.MouseButton1Click:Connect(function() 
    local part = getFootPart() 
    if part and targets[part] then 
        targets[part] = nil 
        removeHighlight(part) 
    end 
end)

toggleButton.MouseButton1Click:Connect(function() 
    frame.Visible = not frame.Visible 
    toggleButton.Text = frame.Visible and "😙 HIDE" or "😗 SHOW" 
end)

RunService.RenderStepped:Connect(function() 
    if tick() - lastCheck >= 2 then 
        lastCheck = tick() 
        for part, _ in pairs(targets) do 
            if part and part:IsA("BasePart") then 
                if not part:FindFirstChild("PersistentHighlight") then 
                    ensureHighlight(part) 
                end 
            end 
        end 
    end 
end)
