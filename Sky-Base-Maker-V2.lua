--[[ 
🎛️ Sky Base Maker v2.0 (Full) với Intro "Moondiety" Loading Animation
✔️ Giữ nguyên toàn bộ GUI & logic gốc
✔️ Loading animation: logo mây + chữ + particle + glow
Flow:
  1) Show Moondiety loading (full-screen)
  2) Chạy animation (~5s)
  3) Destroy loading GUI -> Enable GUI chính (HeightAdjusterGui)
--]]

-- ===== SERVICES =====
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local StarterGui = game:GetService("StarterGui")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- ===== LOADING GUI =====
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "SkyBaseLoadingGui"
screenGui.Parent = playerGui
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Background
local backgroundFrame = Instance.new("ImageLabel")
backgroundFrame.Name = "Background"
backgroundFrame.Size = UDim2.new(1, 0, 2, 0)
backgroundFrame.Position = UDim2.new(0, 0, -0.12, 0)
backgroundFrame.BorderSizePixel = 0
backgroundFrame.BackgroundTransparency = 1
backgroundFrame.Parent = screenGui

-- Overlay + gradient
local backgroundOverlay = Instance.new("Frame")
backgroundOverlay.Size = UDim2.new(1, 0, 1, 0)
backgroundOverlay.Position = UDim2.new(0, 0, 0, 0)
backgroundOverlay.BackgroundTransparency = 0.5
backgroundOverlay.BorderSizePixel = 0
backgroundOverlay.Parent = backgroundFrame

local backgroundGradient = Instance.new("UIGradient")
backgroundGradient.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 255, 255)),
	ColorSequenceKeypoint.new(0.3, Color3.fromRGB(64, 150, 255)),
	ColorSequenceKeypoint.new(0.6, Color3.fromRGB(138, 43, 226)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 20, 147))
}
backgroundGradient.Rotation = 45
backgroundGradient.Parent = backgroundOverlay

-- Center container
local centerFrame = Instance.new("Frame")
centerFrame.Name = "CenterContent"
centerFrame.Size = UDim2.new(0, 500, 0, 400)
centerFrame.Position = UDim2.new(0.5, -250, 0.5, -200)
centerFrame.BackgroundTransparency = 1
centerFrame.Parent = screenGui

-- Cloud logo
local cloudLogo = Instance.new("ImageLabel")
cloudLogo.Name = "CloudLogo"
cloudLogo.Size = UDim2.new(0, 200, 0, 130)
cloudLogo.Position = UDim2.new(0.5, -100, 0, 40)
cloudLogo.BackgroundTransparency = 1
cloudLogo.Image = "rbxassetid://125022786287705"
cloudLogo.ImageColor3 = Color3.fromRGB(255, 255, 255)
cloudLogo.ScaleType = Enum.ScaleType.Fit
cloudLogo.Parent = centerFrame

-- Logo gradient
local logoContainer = Instance.new("Frame")
logoContainer.Size = UDim2.new(0, 400, 0, 260)
logoContainer.Position = UDim2.new(-0.1, 44.9, 0, 1)
logoContainer.BackgroundTransparency = 1
logoContainer.Parent = cloudLogo

local logoGradient = Instance.new("UIGradient")
logoGradient.Parent = logoContainer -- ✅ fix: parent

-- Logo glow
local logoGlow = Instance.new("ImageLabel")
logoGlow.Size = UDim2.new(1.4, 0, 1.4, 0)
logoGlow.Position = UDim2.new(-0.2, 0, -0.2, 0)
logoGlow.BackgroundTransparency = 1
logoGlow.Image = "rbxassetid://125022786287705"
logoGlow.ImageColor3 = Color3.fromRGB(0, 255, 255)
logoGlow.ImageTransparency = 0.8
logoGlow.ScaleType = Enum.ScaleType.Fit
logoGlow.ZIndex = cloudLogo.ZIndex - 1
logoGlow.Parent = logoContainer

-- Text SKY-BASE-MAKER
local textContainer = Instance.new("Frame")
textContainer.Name = "TextContainer"
textContainer.Size = UDim2.new(0, 480, 0, 80)
textContainer.Position = UDim2.new(0.5, -350, 0, 180)
textContainer.BackgroundTransparency = 1
textContainer.Parent = centerFrame

local textParts = {"S", "K", "Y", "-", "B", "A", "S", "E", "-", "M", "A", "K", "E", "R"}
local letters = {}
local spacing = 50

for i, char in ipairs(textParts) do
	if char ~= "-" then
		local letter = Instance.new("TextLabel")
		letter.Name = "Letter" .. i
		letter.Size = UDim2.new(0, 40, 1, 0)
		letter.Position = UDim2.new(-2, (i-1) * spacing - 500, 0, 0)
		letter.BackgroundTransparency = 1
		letter.Text = char
		letter.TextSize = 35
		letter.TextScaled = true
		letter.Font = Enum.Font.LuckiestGuy
		letter.TextTransparency = 1
		letter.Parent = textContainer

		local letterGradient = Instance.new("UIGradient")
		letterGradient.Color = ColorSequence.new{
			ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 255, 255)),
			ColorSequenceKeypoint.new(0.25, Color3.fromRGB(64, 150, 255)),
			ColorSequenceKeypoint.new(0.5, Color3.fromRGB(138, 43, 226)),
			ColorSequenceKeypoint.new(0.75, Color3.fromRGB(255, 20, 147)),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 165, 0))
		}
		letterGradient.Rotation = 45
		letterGradient.Parent = letter

		local textStroke = Instance.new("UIStroke")
		textStroke.Color = Color3.fromRGB(0, 255, 255)
		textStroke.Thickness = 4
		textStroke.Transparency = 0.2
		textStroke.Parent = letter

		table.insert(letters, {element = letter, finalPos = (i-1) * spacing, type = "letter"})
	end
end

-- Particle system
local particleFolder = Instance.new("Folder")
particleFolder.Name = "Particles"
particleFolder.Parent = screenGui

local function createParticle()
	local particle = Instance.new("Frame")
	particle.Size = UDim2.new(0, math.random(3, 8), 0, math.random(3, 8))
	particle.Position = UDim2.new(math.random(), 0, 1, 0)
	particle.BackgroundColor3 = Color3.fromHSV(tick() % 5 / 5, 1, 1)
	particle.BackgroundTransparency = 0
	particle.BorderSizePixel = 0
	particle.Parent = particleFolder
	return particle
end

-- Animate particles
local function animateParticles()
	spawn(function()
		while screenGui.Parent do
			local particle = createParticle()
			local moveTween = TweenService:Create(particle, TweenInfo.new(2, Enum.EasingStyle.Linear), {
				Position = UDim2.new(math.random(), 0, -0.1, 0),
				BackgroundTransparency = 1
			})
			moveTween:Play()
			moveTween.Completed:Connect(function()
				particle:Destroy()
			end)
			wait(0.05)
		end
	end)
end

-- Animate logo glow
local function animateLogoGlow()
	spawn(function()
		while screenGui.Parent do
			local glowTween = TweenService:Create(logoGlow, TweenInfo.new(2, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, -1, true), {
				ImageTransparency = 0.4
			})
			glowTween:Play()
			wait(4)
		end
	end)
end

-- Start loading sequence
local function startLoadingSequence()
	animateParticles()
	animateLogoGlow()

	-- Logo fade-in
	local logoTween = TweenService:Create(cloudLogo, TweenInfo.new(1.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		ImageTransparency = 0
	})
	logoTween:Play()
	wait(1.5)

	-- Letters slide-in
	for i, data in ipairs(letters) do
		local letter = data.element
		local targetPos = data.finalPos

		local slideTween = TweenService:Create(letter, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			Position = UDim2.new(0, targetPos, 0, 0),
			TextTransparency = 0
		})
		slideTween:Play()
		wait(0.1)
	end

	wait(2.5)

	-- Fade out all
	local fadeInfo = TweenInfo.new(1.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	local fadeTweens = {
		TweenService:Create(cloudLogo, fadeInfo, {ImageTransparency = 1}),
		TweenService:Create(logoGlow, fadeInfo, {ImageTransparency = 1}),
		TweenService:Create(backgroundOverlay, fadeInfo, {BackgroundTransparency = 1}),
	}
	for _, letter in ipairs(letters) do
		table.insert(fadeTweens, TweenService:Create(letter.element, fadeInfo, {TextTransparency = 1}))
	end
	for _, tween in ipairs(fadeTweens) do
		tween:Play()
	end

	wait(1.5)
	screenGui:Destroy()
end

-- Run loading
startLoadingSequence()

-- ===== ORIGNAL SKY-BASE-MAKER FUNCTIONALITY =====
StarterGui:SetCore("SendNotification", {
	Title = "loading...",
	Text = "made by MidoriMidoru_73816",
	Duration = 5
})

-- Clear fog etc
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

-- ===== MAIN HEIGHT ADJUSTER GUI =====
-- (toàn bộ phần GUI chính Sky-Base-Maker của bạn sẽ nằm ngay đây, giữ nguyên 100%)
-- ...

StarterGui:SetCore("SendNotification", {
    Title = "loading...",
    Text = "made by MidoriMidoru_73816",
    Duration = 5
})

-- Clear Fog
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

-- ======= MAIN GUI =======
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "HeightAdjusterGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- Modern frame design
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 320, 0, 220) -- Increased size for new buttons
frame.Position = UDim2.new(0.5, -160, 0.1, 0)
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

-- Height input box
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
heightInput.Size = UDim2.new(0.4, -5, 1, 0)
heightInput.Position = UDim2.new(0, 5, 0, 0)
heightInput.Text = "0"
heightInput.PlaceholderText = "1-100"
heightInput.TextColor3 = Color3.fromRGB(220, 220, 220)
heightInput.BackgroundTransparency = 1
heightInput.Font = Enum.Font.Gotham
heightInput.TextSize = 14
heightInput.Parent = inputFrame

local minusButton = Instance.new("TextButton")
minusButton.Size = UDim2.new(0, 30, 1, 0)
minusButton.Position = UDim2.new(0.4, 5, 0, 0)
minusButton.Text = "-"
minusButton.TextColor3 = Color3.fromRGB(220, 220, 220)
minusButton.BackgroundColor3 = Color3.fromRGB(80, 80, 90)
minusButton.Font = Enum.Font.GothamBold
minusButton.TextSize = 18
minusButton.Parent = inputFrame

local plusButton = Instance.new("TextButton")
plusButton.Size = UDim2.new(0, 30, 1, 0)
plusButton.Position = UDim2.new(0.4, 40, 0, 0)
plusButton.Text = "+"
plusButton.TextColor3 = Color3.fromRGB(220, 220, 220)
plusButton.BackgroundColor3 = Color3.fromRGB(80, 80, 90)
plusButton.Font = Enum.Font.GothamBold
plusButton.TextSize = 18
plusButton.Parent = inputFrame

local inputLabel = Instance.new("TextLabel")
inputLabel.Size = UDim2.new(0.2, -5, 1, 0)
inputLabel.Position = UDim2.new(0.4, 75, 0, 0)
inputLabel.Text = "Height"
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
toggleButton.Size = UDim2.new(0, 100, 0, 30)
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

-- ======= LOGIC =======
local targets = {}
local dragging = false
local sliderValue = 0
local lastCheck = 0

-- Kéo GUI bằng tay
frame.Active = true
frame.Draggable = true

local function getFootPart()
    local character = LocalPlayer.Character
    if not character then return nil end
    local root = character:FindFirstChild("HumanoidRootPart")
    if not root then return nil end
    local ray = Ray.new(root.Position, Vector3.new(0, -5, 0))
    local part, position = workspace:FindPartOnRay(ray, character)
    return part
end

local function ensureHighlight(part)
    if not part or not part:IsA("BasePart") then return end
    local highlight = part:FindFirstChild("PersistentHighlight")
    if not highlight then
        highlight = Instance.new("Highlight")
        highlight.Name = "PersistentHighlight"
        highlight.Adornee = part
        highlight.FillColor = Color3.fromRGB(220, 220, 220)
        highlight.FillTransparency = 0.4
        highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
        highlight.OutlineTransparency = 0
        highlight.Parent = part
    end
end

local function removeHighlight(part)
    local highlight = part and part:FindFirstChild("PersistentHighlight")
    if highlight then highlight:Destroy() end
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

-- Update from text input
local function updateFromInput()
    local num = tonumber(heightInput.Text)
    if num and num >= 1 and num <= 100 then
        sliderValue = num
        valueDisplay.Text = tostring(sliderValue)
        local barSize = sliderBar.AbsoluteSize.X
        if barSize > 0 then
            local relativeX = (num / 100) * barSize
            sliderButton.Position = UDim2.new(0, relativeX - 10, 0.5, -10)
        end
        for part, _ in pairs(targets) do
            if part and part:IsA("BasePart") then
                part.Size = Vector3.new(part.Size.X, sliderValue, part.Size.Z)
            end
        end
    else
        heightInput.Text = tostring(sliderValue)
    end
end

-- Increase/Decrease
local function increaseHeight()
    local newValue = math.min(sliderValue + 1, 100)
    sliderValue = newValue
    valueDisplay.Text = tostring(sliderValue)
    heightInput.Text = tostring(sliderValue)
    local barSize = sliderBar.AbsoluteSize.X
    if barSize > 0 then
        local relativeX = (sliderValue / 100) * barSize
        sliderButton.Position = UDim2.new(0, relativeX - 10, 0.5, -10)
    end
    for part, _ in pairs(targets) do
        if part and part:IsA("BasePart") then
            part.Size = Vector3.new(part.Size.X, sliderValue, part.Size.Z)
        end
    end
end

local function decreaseHeight()
    local newValue = math.max(sliderValue - 1, 1)
    sliderValue = newValue
    valueDisplay.Text = tostring(sliderValue)
    heightInput.Text = tostring(sliderValue)
    local barSize = sliderBar.AbsoluteSize.X
    if barSize > 0 then
        local relativeX = (sliderValue / 100) * barSize
        sliderButton.Position = UDim2.new(0, relativeX - 10, 0.5, -10)
    end
    for part, _ in pairs(targets) do
        if part and part:IsA("BasePart") then
            part.Size = Vector3.new(part.Size.X, sliderValue, part.Size.Z)
        end
    end
end

-- Events
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

heightInput.FocusLost:Connect(function()
    updateFromInput()
end)

plusButton.MouseButton1Click:Connect(function()
    increaseHeight()
end)

minusButton.MouseButton1Click:Connect(function()
    decreaseHeight()
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
