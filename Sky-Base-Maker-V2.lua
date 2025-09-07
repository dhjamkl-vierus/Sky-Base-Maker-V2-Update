--[[ 
  Sky-Base-Maker-V2.lua
  Full Local/client script (sẵn cho loadstring(game:HttpGet(...))())
  - Tự động dọn GUI cũ
  - _G flag để tránh chạy trùng
  - Tween intro, UI trắng nhạt, highlight trắng nhạt
  - Raycast thay vì Ray.new
  - Drag bằng UserInputService (không dùng Frame.Draggable)
  - Ghi chú (Việt) trong code để bạn dễ theo dõi
--]]

-- ======= Prevent double-run =======
if _G.SkyBaseMakerV2Loaded then
    -- Nếu muốn reload: trước khi chạy lại, chạy _G.SkyBaseMakerV2Loaded = nil
    return
end
_G.SkyBaseMakerV2Loaded = true

-- ======= Services =======
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local StarterGui = game:GetService("StarterGui")

-- ======= Local player / PlayerGui (chờ sẵn) =======
local LocalPlayer = Players.LocalPlayer
if not LocalPlayer then
    warn("[SkyBaseMaker] Không tìm thấy LocalPlayer (script cần chạy trên client).")
    return
end
local playerGui = LocalPlayer:WaitForChild("PlayerGui")

-- ======= Cleanup previous GUI nếu có =======
local existing = playerGui:FindFirstChild("SkyBaseMakerGui")
if existing then
    existing:Destroy()
    safeWait = function() end -- noop if not defined yet
end

-- ======= Small helpers =======
local function safeWait(t)
    if t and t > 0 then task.wait(t) end
end

local function tryNotify(title, text, dur)
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = title or "Sky-Base-Maker",
            Text = text or "",
            Duration = dur or 2,
        })
    end)
end

-- ======= Environment tweaks (fog/atmosphere) =======
local function clearFog()
    pcall(function()
        Lighting.FogStart = 0
        Lighting.FogEnd = 1e9
    end)
end

local function neuterAtmosphere(a)
    if a and a:IsA("Atmosphere") then
        pcall(function() a.Density = 0 end)
        pcall(function() if a:GetAttribute then a.Haze = 0 end end)
        pcall(function() a:GetPropertyChangedSignal("Density"):Connect(function() a.Density = 0 end) end)
        -- Haze/Glare not always present; pcall safe
        pcall(function() a:GetPropertyChangedSignal("Haze"):Connect(function() a.Haze = 0 end) end)
        pcall(function() a:GetPropertyChangedSignal("Glare"):Connect(function() a.Glare = 0 end) end)
    end
end

clearFog()
for _, c in ipairs(Lighting:GetChildren()) do neuterAtmosphere(c) end
Lighting.ChildAdded:Connect(neuterAtmosphere)
Lighting:GetPropertyChangedSignal("FogStart"):Connect(clearFog)
Lighting:GetPropertyChangedSignal("FogEnd"):Connect(clearFog)

-- Start notification
tryNotify("loading...", "made by MidoriMidoru_73816", 3)

-- ======= Create main ScreenGui =======
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "SkyBaseMakerGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- ======= Intro (TweenService) - SKY BASE MAKER STYLE =======
local introFrame = Instance.new("Frame")
introFrame.Name = "IntroCover"
introFrame.Size = UDim2.new(1, 0, 1, 0)
introFrame.Position = UDim2.new(0, 0, 0, 0)
introFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 18) -- Nền tối, hơi xanh dương
introFrame.BackgroundTransparency = 1
introFrame.BorderSizePixel = 0
introFrame.ZIndex = 50
introFrame.Parent = screenGui

-- Tạo một frame chứa toàn bộ nội dung loading để căn giữa dễ dàng
local loadingContainer = Instance.new("Frame")
loadingContainer.Name = "LoadingContainer"
loadingContainer.Size = UDim2.new(0, 400, 0, 180)
loadingContainer.Position = UDim2.new(0.5, -200, 0.5, -90) -- Căn giữa màn hình
loadingContainer.BackgroundTransparency = 1
loadingContainer.ZIndex = 51
loadingContainer.Parent = introFrame

-- Logo/Title chính
local mainTitle = Instance.new("TextLabel")
mainTitle.Name = "MainTitle"
mainTitle.Size = UDim2.new(1, 0, 0, 60)
mainTitle.Position = UDim2.new(0, 0, 0, 0)
mainTitle.BackgroundTransparency = 1
mainTitle.Font = Enum.Font.GothamBlack
mainTitle.TextScaled = true
mainTitle.Text = "☁️ SKY-BASE-MAKER ☁️"
mainTitle.TextColor3 = Color3.fromRGB(200, 220, 255) -- Màu xanh trắng sáng
mainTitle.TextTransparency = 1
mainTitle.ZIndex = 52
mainTitle.TextStrokeTransparency = 0.7
mainTitle.TextStrokeColor3 = Color3.fromRGB(100, 100, 150)
mainTitle.Parent = loadingContainer

-- Khung checklist
local checklistFrame = Instance.new("Frame")
checklistFrame.Name = "Checklist"
checklistFrame.Size = UDim2.new(1, -40, 0, 80)
checklistFrame.Position = UDim2.new(0, 20, 0, 70)
checklistFrame.BackgroundTransparency = 1
checklistFrame.ZIndex = 52
checklistFrame.Parent = loadingContainer

-- Tạo 3 dòng checklist
local checkLines = {}
for i = 1, 3 do
    local lineFrame = Instance.new("Frame")
    lineFrame.Name = "Line" .. i
    lineFrame.Size = UDim2.new(1, 0, 0, 20)
    lineFrame.Position = UDim2.new(0, 0, 0, (i-1)*26)
    lineFrame.BackgroundTransparency = 1
    lineFrame.ZIndex = 52
    lineFrame.Parent = checklistFrame

    local checkBox = Instance.new("Frame")
    checkBox.Name = "Box"
    checkBox.Size = UDim2.new(0, 16, 0, 16)
    checkBox.Position = UDim2.new(0, 0, 0, 2)
    checkBox.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    checkBox.BorderColor3 = Color3.fromRGB(120, 140, 180)
    checkBox.ZIndex = 53
    checkBox.Parent = lineFrame

    local checkText = Instance.new("TextLabel")
    checkText.Name = "Text"
    checkText.Size = UDim2.new(1, -25, 1, 0)
    checkText.Position = UDim2.new(0, 22, 0, 0)
    checkText.BackgroundTransparency = 1
    checkText.Font = Enum.Font.Gotham
    checkText.Text = "Initializing system " .. i
    checkText.TextColor3 = Color3.fromRGB(200, 200, 220)
    checkText.TextSize = 14
    checkText.TextXAlignment = Enum.TextXAlignment.Left
    checkText.TextTransparency = 0.7
    checkText.ZIndex = 53
    checkText.Parent = lineFrame

    checkLines[i] = {box = checkBox, text = checkText}
end

-- Biến để điều khiển animation
local loadSteps = {
    {"Loading core modules", 0.8},
    {"Connecting to services", 1.2},
    {"Preparing your sky base", 1.6}
}

-- ======= Main Panel (hidden until intro done) =======
local frame = Instance.new("Frame")
frame.Name = "MainPanel"
frame.Size = UDim2.new(0, 320, 0, 190) -- Tăng chiều cao để chứa ô nhập
frame.Position = UDim2.new(0.5, -160, 0.06, 0)
frame.BackgroundColor3 = Color3.fromRGB(40,40,40)
frame.BorderSizePixel = 0
frame.ZIndex = 20
frame.Visible = false
frame.Parent = screenGui

-- TitleBar (drag handle)
local titleBar = Instance.new("Frame")
titleBar.Name = "TitleBar"
titleBar.Size = UDim2.new(1,0,0,34)
titleBar.Position = UDim2.new(0,0,0,0)
titleBar.BackgroundColor3 = Color3.fromRGB(60,60,60)
titleBar.BorderSizePixel = 0
titleBar.Parent = frame

local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "TitleLabel"
titleLabel.Size = UDim2.new(1,-8,1,0)
titleLabel.Position = UDim2.new(0,8,0,0)
titleLabel.BackgroundTransparency = 1
titleLabel.Font = Enum.Font.GothamBold
titleLabel.Text = "SKY BASE MAKER_v2"
titleLabel.TextColor3 = Color3.fromRGB(255,255,255)
titleLabel.TextSize = 14
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = titleBar

-- Slider area
local sliderFrame = Instance.new("Frame")
sliderFrame.Name = "SliderFrame"
sliderFrame.Size = UDim2.new(1,-20,0,44)
sliderFrame.Position = UDim2.new(0,10,0,44)
sliderFrame.BackgroundColor3 = Color3.fromRGB(80,80,80)
sliderFrame.BorderSizePixel = 0
sliderFrame.Parent = frame

local sliderBar = Instance.new("Frame")
sliderBar.Name = "SliderBar"
sliderBar.Size = UDim2.new(1,-24,0,12)
sliderBar.Position = UDim2.new(0,12,0.5,-6)
sliderBar.BackgroundColor3 = Color3.fromRGB(120,120,120)
sliderBar.BorderSizePixel = 0
sliderBar.Parent = sliderFrame

local sliderButton = Instance.new("TextButton")
sliderButton.Name = "SliderButton"
sliderButton.Size = UDim2.new(0,20,0,20)
sliderButton.Position = UDim2.new(0, -10, 0.5, -10)
sliderButton.BackgroundColor3 = Color3.fromRGB(200,200,200)
sliderButton.BorderSizePixel = 0
sliderButton.Text = ""
sliderButton.Parent = sliderFrame

local sliderValueLabel = Instance.new("TextLabel")
sliderValueLabel.Name = "SliderValue"
sliderValueLabel.Size = UDim2.new(0,60,0,18)
sliderValueLabel.Position = UDim2.new(1,-70,0.5,-9)
sliderValueLabel.BackgroundTransparency = 1
sliderValueLabel.Font = Enum.Font.GothamSemibold
sliderValueLabel.Text = "H: 0"
sliderValueLabel.TextColor3 = Color3.fromRGB(230,230,230)
sliderValueLabel.TextSize = 14
sliderValueLabel.Parent = sliderFrame

-- Text input for precise height
local heightInput = Instance.new("TextBox")
heightInput.Name = "HeightInput"
heightInput.Size = UDim2.new(0, 50, 0, 20)
heightInput.Position = UDim2.new(0, 12, 0, 94)
heightInput.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
heightInput.BorderSizePixel = 0
heightInput.Font = Enum.Font.Gotham
heightInput.PlaceholderText = "1-100"
heightInput.Text = ""
heightInput.TextColor3 = Color3.fromRGB(230, 230, 230)
heightInput.TextSize = 14
heightInput.TextXAlignment = Enum.TextXAlignment.Center
heightInput.ZIndex = 21
heightInput.Parent = frame

local heightLabel = Instance.new("TextLabel")
heightLabel.Name = "HeightLabel"
heightLabel.Size = UDim2.new(0, 80, 0, 20)
heightLabel.Position = UDim2.new(0, 66, 0, 94)
heightLabel.BackgroundTransparency = 1
heightLabel.Font = Enum.Font.Gotham
heightLabel.Text = "Height (1-100)"
heightLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
heightLabel.TextSize = 12
heightLabel.TextXAlignment = Enum.TextXAlignment.Left
heightLabel.ZIndex = 21
heightLabel.Parent = frame

-- Buttons row
local buttonsFrame = Instance.new("Frame")
buttonsFrame.Name = "ButtonsRow"
buttonsFrame.Size = UDim2.new(1,-20,0,40)
buttonsFrame.Position = UDim2.new(0,10,0,120) -- Điều chỉnh vị trí do thêm ô nhập
buttonsFrame.BackgroundTransparency = 1
buttonsFrame.Parent = frame

local addButton = Instance.new("TextButton")
addButton.Name = "AddBtn"
addButton.Size = UDim2.new(0.48,0,1,0)
addButton.Position = UDim2.new(0,0,0,0)
addButton.Text = "⚓️  ADD"
addButton.Font = Enum.Font.GothamSemibold
addButton.TextSize = 14
addButton.TextColor3 = Color3.fromRGB(40,40,40)
addButton.BackgroundColor3 = Color3.fromRGB(235,235,235)
addButton.BorderSizePixel = 0
addButton.Parent = buttonsFrame

local removeButton = Instance.new("TextButton")
removeButton.Name = "RemoveBtn"
removeButton.Size = UDim2.new(0.48,0,1,0)
removeButton.Position = UDim2.new(0.52,0,0,0)
removeButton.Text = "✂️  REMOVE"
removeButton.Font = Enum.Font.GothamSemibold
removeButton.TextSize = 14
removeButton.TextColor3 = Color3.fromRGB(255,255,255)
removeButton.BackgroundColor3 = Color3.fromRGB(180,80,80)
removeButton.BorderSizePixel = 0
removeButton.Parent = buttonsFrame

-- Toggle button (mini)
local toggleButton = Instance.new("TextButton")
toggleButton.Name = "ToggleMini"
toggleButton.Size = UDim2.new(0,56,0,28)
toggleButton.Position = UDim2.new(0.02,0,0.88,0)
toggleButton.Text = "😙"
toggleButton.Font = Enum.Font.SourceSansBold
toggleButton.TextSize = 16
toggleButton.BackgroundColor3 = Color3.fromRGB(100,100,200)
toggleButton.BorderSizePixel = 0
toggleButton.ZIndex = 22
toggleButton.Parent = screenGui
toggleButton.Visible = false

-- ======= State =======
local targets = {} -- part -> { highlight, conn }
local isDragging = false
local dragOffset = Vector2.new(0,0)
local sliderValue = 0
local lastCheck = 0

-- raycast params
local rayParams = RaycastParams.new()
rayParams.FilterType = Enum.RaycastFilterType.Blacklist

-- ======= Raycast to find part under feet =======
local function getFootPart()
    local char = LocalPlayer.Character
    if not (char and char.Parent) then return nil end
    local root = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso")
    if not root then return nil end
    rayParams.FilterDescendantsInstances = {char}
    local origin = root.Position
    local dir = Vector3.new(0, -6, 0)
    local hit = Workspace:Raycast(origin, dir, rayParams)
    if hit and hit.Instance and hit.Instance:IsA("BasePart") then
        return hit.Instance
    end
    return nil
end

-- ======= Highlight functions (white-ish) =======
local HIGHLIGHT_COLOR = Color3.fromRGB(220,220,220)
local function attachHighlight(part)
    if not (part and part:IsA("BasePart")) then return end
    if targets[part] then return end
    local highlight = Instance.new("Highlight")
    highlight.Name = "PersistentHighlight"
    highlight.Adornee = part
    highlight.FillColor = HIGHLIGHT_COLOR
    highlight.FillTransparency = 0.45
    highlight.OutlineColor = Color3.fromRGB(255,255,255)
    highlight.OutlineTransparency = 0
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Parent = part

    local conn = part.AncestryChanged:Connect(function()
        if not part:IsDescendantOf(game) then
            if highlight and highlight.Parent then highlight:Destroy() end
            if targets[part] and targets[part].conn then targets[part].conn:Disconnect() end
            targets[part] = nil
        end
    end)

    targets[part] = { highlight = highlight, conn = conn }
end

local function detachHighlight(part)
    if not part then return end
    local meta = targets[part]
    if meta then
        if meta.highlight and meta.highlight.Parent then meta.highlight:Destroy() end
        if meta.conn then meta.conn:Disconnect() end
        targets[part] = nil
    end
end

-- ======= Slider update =======
local function updateSliderFromX(inputX)
    local barPos = sliderBar.AbsolutePosition.X
    local barSize = sliderBar.AbsoluteSize.X
    if barSize <= 0 then return end
    local relX = math.clamp(inputX - barPos, 0, barSize)
    local halfBtn = math.floor(sliderButton.AbsoluteSize.X / 2)
    sliderButton.Position = UDim2.new(0, relX - halfBtn, 0.5, - (sliderButton.AbsoluteSize.Y / 2))
    sliderValue = math.floor((relX / barSize) * 100) -- max 100
    sliderValueLabel.Text = "H: "..tostring(sliderValue)
    heightInput.Text = tostring(sliderValue) -- Cập nhật ô nhập
    for part, _ in pairs(targets) do
        if part and part:IsA("BasePart") and not part.Locked then
            local sx, sy, sz = part.Size.X, part.Size.Y, part.Size.Z
            pcall(function()
                part.Size = Vector3.new(sx, math.max(1, sliderValue), sz)
            end)
        end
    end
end

-- Cập nhật từ ô nhập
local function updateFromInput()
    local num = tonumber(heightInput.Text)
    if num and num >= 1 and num <= 100 then
        sliderValue = num
        sliderValueLabel.Text = "H: "..tostring(sliderValue)
        
        -- Cập nhật vị trí slider
        local barSize = sliderBar.AbsoluteSize.X
        if barSize > 0 then
            local relX = (num / 100) * barSize
            local halfBtn = math.floor(sliderButton.AbsoluteSize.X / 2)
            sliderButton.Position = UDim2.new(0, relX - halfBtn, 0.5, - (sliderButton.AbsoluteSize.Y / 2))
        end
        
        -- Áp dụng cho tất cả parts
        for part, _ in pairs(targets) do
            if part and part:IsA("BasePart") and not part.Locked then
                local sx, sy, sz = part.Size.X, part.Size.Y, part.Size.Z
                pcall(function()
                    part.Size = Vector3.new(sx, math.max(1, sliderValue), sz)
                end)
            end
        end
    else
        heightInput.Text = tostring(sliderValue) -- Khôi phục giá trị cũ nếu nhập sai
    end
end

-- init slider pos
task.defer(function()
    safeWait(0.05)
    sliderButton.Position = UDim2.new(0, -10, 0.5, -10)
    sliderValueLabel.Text = "H: 0"
    heightInput.Text = "0"
end)

-- ======= Drag (titleBar) =======
do
    titleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isDragging = true
            local mouse = UserInputService:GetMouseLocation()
            local absPos = frame.AbsolutePosition
            dragOffset = Vector2.new(mouse.X - absPos.X, mouse.Y - absPos.Y)
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    isDragging = false
                end
            end)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if isDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local mouse = UserInputService:GetMouseLocation()
            local newX = math.clamp(mouse.X - dragOffset.X, 0, workspace.CurrentCamera.ViewportSize.X - frame.AbsoluteSize.X)
            local newY = math.clamp(mouse.Y - dragOffset.Y, 0, workspace.CurrentCamera.ViewportSize.Y - frame.AbsoluteSize.Y)
            frame.Position = UDim2.new(0, newX, 0, newY)
        end
    end)
end

-- ======= Slider interactions =======
sliderButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        local conn
        conn = UserInputService.InputChanged:Connect(function(ch)
            if ch.UserInputType == Enum.UserInputType.MouseMovement or ch.UserInputType == Enum.UserInputType.Touch then
                updateSliderFromX(ch.Position.X)
            end
        end)
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                if conn then conn:Disconnect() end
            end
        end)
    end
end)

sliderBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        updateSliderFromX(input.Position.X)
    end
end)

-- ======= Text input handling =======
heightInput.FocusLost:Connect(function(enterPressed)
    updateFromInput()
end)

-- ======= Add / Remove buttons =======
addButton.MouseButton1Click:Connect(function()
    local part = getFootPart()
    if not part then
        tryNotify("Sky-Base-Maker","Không tìm thấy part dưới chân.",2)
        return
    end
    if part.Locked then
        tryNotify("Sky-Base-Maker","Part bị Locked, không thể chỉnh.",2)
        return
    end
    if part.Size.X > 35 and part.Size.Z > 35 then
        attachHighlight(part)
        tryNotify("Sky-Base-Maker","Added target.",1.2)
    else
        tryNotify("Sky-Base-Maker","Part quá nhỏ để làm sky base.",1.2)
    end
end)

removeButton.MouseButton1Click:Connect(function()
    local part = getFootPart()
    if part and targets[part] then
        detachHighlight(part)
        tryNotify("Sky-Base-Maker","Removed target.",1.0)
    else
        tryNotify("Sky-Base-Maker","No target to remove.",1.0)
    end
end)

toggleButton.MouseButton1Click:Connect(function()
    frame.Visible = not frame.Visible
    toggleButton.Text = frame.Visible and "😙" or "😗"
end)

-- ======= RenderStepped check (cleanup) =======
RunService.RenderStepped:Connect(function()
    if tick() - lastCheck >= 2 then
        lastCheck = tick()
        for part, meta in pairs(targets) do
            if not part or not part:IsA("BasePart") or not part:IsDescendantOf(game) then
                if meta and meta.highlight and meta.highlight.Parent then meta.highlight:Destroy() end
                if meta and meta.conn then meta.conn:Disconnect() end
                targets[part] = nil
            else
                if not part:FindFirstChild("PersistentHighlight") then
                    attachHighlight(part)
                end
            end
        end
    end
end)

-- ======= Intro Tween & Loading Animation =======
do
    local tweenInInfo = TweenInfo.new(0.8, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
    local tweenOutInfo = TweenInfo.new(0.7, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
    local quickFade = TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

    -- 1. Fade in background và main title
    local t1 = TweenService:Create(introFrame, tweenInInfo, { BackgroundTransparency = 0 })
    local t2 = TweenService:Create(mainTitle, quickFade, { TextTransparency = 0 })

    t1:Play(); t2:Play()
    t1.Completed:Wait()

    -- 2. Lặp qua các bước loading và tick checklist
    for i, stepInfo in ipairs(loadSteps) do
        local text, waitTime = stepInfo[1], stepInfo[2]
        local line = checkLines[i]

        -- Cập nhật text
        line.text.Text = text
        local tText = TweenService:Create(line.text, quickFade, {TextTransparency = 0})
        tText:Play()

        -- Giả lập công việc đang làm
        safeWait(waitTime)

        -- Tick hoàn thành
        local tBox = TweenService:Create(line.box, quickFade, {BackgroundColor3 = Color3.fromRGB(120, 220, 120)})
        tBox:Play()
        safeWait(0.2)
    end

    safeWait(0.5) -- Dừng một chút để người dùng nhìn thấy đã hoàn thành

    -- 3. Fade out toàn bộ intro
    local t4 = TweenService:Create(mainTitle, tweenOutInfo, { TextTransparency = 1 })
    t4:Play(); t4.Completed:Wait()

    for _, line in pairs(checkLines) do
        local tLine = TweenService:Create(line.text, quickFade, {TextTransparency = 1})
        local tBox = TweenService:Create(line.box, quickFade, {BackgroundTransparency = 1})
        tLine:Play(); tBox:Play()
    end
    safeWait(0.3)

    local t6 = TweenService:Create(introFrame, tweenOutInfo, { BackgroundTransparency = 1 })
    t6:Play(); t6.Completed:Wait()

    -- 4. Dọn dẹp và hiện UI chính
    if introFrame and introFrame.Parent then
        introFrame:Destroy()
    end
    frame.Visible = true
    toggleButton.Visible = true

    -- Thông báo hoàn thành
    tryNotify("SKY BASE MAKER", "Ready to build!", 2)
end

-- ======= Done =======
-- (Nếu muốn reload script: run `_G.SkyBaseMakerV2Loaded = nil` then re-run)
