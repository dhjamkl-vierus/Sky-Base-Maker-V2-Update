--[[
  🚀 Sky-Base-Maker (Full LocalScript)
  - Put this as a LocalScript in StarterPlayerScripts
  - Features:
    • Intro animation (TweenService)
    • Clean UI (white-ish highlight and buttons)
    • Slider to adjust selected BasePart height
    • Add / Remove target under player's feet (raycast)
    • Drag UI via UserInputService (no deprecated Draggable)
    • Defensive checks for respawn / locked parts / destroyed parts
  Author: adjusted for you (MidoriMidoru style)
--]]

-- ===========================
-- 🔧 Services & Utils
-- ===========================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local StarterGui = game:GetService("StarterGui")

local LocalPlayer = Players.LocalPlayer

-- Safety: wait for PlayerGui (script is LocalScript so LocalPlayer exists in client)
local playerGui = LocalPlayer:WaitForChild("PlayerGui")

-- small helper
local function safeWait(seconds)
    if seconds and seconds > 0 then
        task.wait(seconds)
    end
end

-- ===========================
-- 🛰 Environment protection (unchanged logic but safe)
-- ===========================
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
for _, c in ipairs(Lighting:GetChildren()) do
    neuterAtmosphere(c)
end
Lighting.ChildAdded:Connect(neuterAtmosphere)
Lighting:GetPropertyChangedSignal("FogStart"):Connect(clearFog)
Lighting:GetPropertyChangedSignal("FogEnd"):Connect(clearFog)

-- notification (startup)
pcall(function()
    StarterGui:SetCore("SendNotification", {
        Title = "loading...";
        Text = "made by MidoriMidoru_73816";
        Duration = 4;
    })
end)

-- ===========================
-- 🧩 GUI Creation (full, self-contained)
-- ===========================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "SkyBaseMakerGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- ---------- Intro cover (full screen)
local introFrame = Instance.new("Frame")
introFrame.Name = "IntroCover"
introFrame.Size = UDim2.new(1, 0, 1, 0)
introFrame.Position = UDim2.new(0, 0, 0, 0)
introFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
introFrame.BackgroundTransparency = 1 -- start invisible -> tween in
introFrame.ZIndex = 50
introFrame.Parent = screenGui

local introLabel = Instance.new("TextLabel")
introLabel.Size = UDim2.new(1, 0, 0, 120)
introLabel.Position = UDim2.new(0, 0, 0.44, 0)
introLabel.BackgroundTransparency = 1
introLabel.Font = Enum.Font.GothamBold
introLabel.TextScaled = true
introLabel.Text = "☁️ SKY-BASE-MAKER ☁️"
introLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
introLabel.TextTransparency = 1 -- start invisible -> tween in
introLabel.ZIndex = 51
introLabel.Parent = introFrame

-- ---------- Main small draggable panel
local frame = Instance.new("Frame")
frame.Name = "MainPanel"
frame.Size = UDim2.new(0, 300, 0, 160)
frame.Position = UDim2.new(0.5, -150, 0.06, 0)
frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
frame.BorderSizePixel = 0
frame.ZIndex = 20
frame.Parent = screenGui
frame.Visible = false -- hidden until intro finishes

-- Title bar (we'll use this for drag handle)
local titleBar = Instance.new("Frame")
titleBar.Name = "TitleBar"
titleBar.Size = UDim2.new(1, 0, 0, 34)
titleBar.Position = UDim2.new(0, 0, 0, 0)
titleBar.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
titleBar.BorderSizePixel = 0
titleBar.Parent = frame

local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "TitleLabel"
titleLabel.Size = UDim2.new(1, -8, 1, 0)
titleLabel.Position = UDim2.new(0, 8, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Font = Enum.Font.GothamBold
titleLabel.Text = "SKY BASE MAKER_v1"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextSize = 14
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = titleBar

-- Slider area
local sliderFrame = Instance.new("Frame")
sliderFrame.Name = "SliderFrame"
sliderFrame.Size = UDim2.new(1, -20, 0, 44)
sliderFrame.Position = UDim2.new(0, 10, 0, 44)
sliderFrame.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
sliderFrame.BorderSizePixel = 0
sliderFrame.Parent = frame

local sliderBar = Instance.new("Frame")
sliderBar.Name = "SliderBar"
sliderBar.Size = UDim2.new(1, -24, 0, 12)
sliderBar.Position = UDim2.new(0, 12, 0.5, -6)
sliderBar.BackgroundColor3 = Color3.fromRGB(120, 120, 120)
sliderBar.BorderSizePixel = 0
sliderBar.Parent = sliderFrame

local sliderButton = Instance.new("TextButton")
sliderButton.Name = "SliderButton"
sliderButton.Size = UDim2.new(0, 20, 0, 20)
sliderButton.Position = UDim2.new(0, 0, 0.5, -10)
sliderButton.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
sliderButton.BorderSizePixel = 0
sliderButton.Text = ""
sliderButton.Parent = sliderFrame

local sliderValueLabel = Instance.new("TextLabel")
sliderValueLabel.Name = "SliderValue"
sliderValueLabel.Size = UDim2.new(0, 60, 0, 18)
sliderValueLabel.Position = UDim2.new(1, -70, 0.5, -9)
sliderValueLabel.BackgroundTransparency = 1
sliderValueLabel.Font = Enum.Font.GothamSemibold
sliderValueLabel.Text = "H: 0"
sliderValueLabel.TextColor3 = Color3.fromRGB(230,230,230)
sliderValueLabel.TextSize = 14
sliderValueLabel.Parent = sliderFrame

-- Buttons row
local buttonsFrame = Instance.new("Frame")
buttonsFrame.Name = "ButtonsRow"
buttonsFrame.Size = UDim2.new(1, -20, 0, 40)
buttonsFrame.Position = UDim2.new(0, 10, 0, 98)
buttonsFrame.BackgroundTransparency = 1
buttonsFrame.Parent = frame

local addButton = Instance.new("TextButton")
addButton.Name = "AddBtn"
addButton.Size = UDim2.new(0.48, 0, 1, 0)
addButton.Position = UDim2.new(0, 0, 0, 0)
addButton.Text = "⚓️  ADD"
addButton.Font = Enum.Font.GothamSemibold
addButton.TextSize = 14
addButton.TextColor3 = Color3.fromRGB(40,40,40)
addButton.BackgroundColor3 = Color3.fromRGB(235,235,235) -- trắng nhạt
addButton.BorderSizePixel = 0
addButton.Parent = buttonsFrame

local removeButton = Instance.new("TextButton")
removeButton.Name = "RemoveBtn"
removeButton.Size = UDim2.new(0.48, 0, 1, 0)
removeButton.Position = UDim2.new(0.52, 0, 0, 0)
removeButton.Text = "✂️  REMOVE"
removeButton.Font = Enum.Font.GothamSemibold
removeButton.TextSize = 14
removeButton.TextColor3 = Color3.fromRGB(255,255,255)
removeButton.BackgroundColor3 = Color3.fromRGB(180,80,80)
removeButton.BorderSizePixel = 0
removeButton.Parent = buttonsFrame

-- Toggle small button (to quickly hide/show panel)
local toggleButton = Instance.new("TextButton")
toggleButton.Name = "ToggleMini"
toggleButton.Size = UDim2.new(0, 56, 0, 28)
toggleButton.Position = UDim2.new(0.02, 0, 0.88, 0)
toggleButton.AnchorPoint = Vector2.new(0,0)
toggleButton.Text = "😙"
toggleButton.Font = Enum.Font.SourceSansBold
toggleButton.TextSize = 16
toggleButton.BackgroundColor3 = Color3.fromRGB(100,100,200)
toggleButton.BorderSizePixel = 0
toggleButton.ZIndex = 22
toggleButton.Parent = screenGui
toggleButton.Visible = false -- show after intro

-- ===========================
-- 🎛 State
-- ===========================
local targets = {} -- dictionary keyed by part (value = table with cleanup conns)
local isDragging = false
local dragOffset = Vector2.new(0,0)
local sliderValue = 0
local lastCheck = 0

-- Raycast params (ignore player's character)
local rayParams = RaycastParams.new()
rayParams.FilterDescendantsInstances = {}
rayParams.FilterType = Enum.RaycastFilterType.Blacklist

-- update black list as needed (we'll set when computing ray)
local function getFootPart()
    local char = LocalPlayer.Character
    if not char then return nil end
    local root = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso")
    if not root then return nil end

    -- black list: ignore player's character
    rayParams.FilterDescendantsInstances = {char}
    local origin = root.Position
    local direction = Vector3.new(0, -6, 0)
    local result = Workspace:Raycast(origin, direction, rayParams)
    if result and result.Instance and result.Instance:IsA("BasePart") then
        return result.Instance
    end
    return nil
end

-- ===========================
-- ✨ Highlight management (white-ish)
-- ===========================
local HIGHLIGHT_FILL_COLOR = Color3.fromRGB(220,220,220)
local function attachHighlight(part)
    if not part or not part:IsA("BasePart") then return end
    if targets[part] then return end

    local highlight = Instance.new("Highlight")
    highlight.Name = "PersistentHighlight"
    highlight.Adornee = part
    highlight.FillColor = HIGHLIGHT_FILL_COLOR
    highlight.FillTransparency = 0.45
    highlight.OutlineColor = Color3.fromRGB(255,255,255)
    highlight.OutlineTransparency = 0
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Parent = part

    -- monitor destroyed or parent change to auto-remove from our targets
    local ancestryConn
    ancestryConn = part.AncestryChanged:Connect(function()
        if not part:IsDescendantOf(game) then
            -- cleanup
            if highlight and highlight.Parent then
                highlight:Destroy()
            end
            if targets[part] and targets[part].conn then
                targets[part].conn:Disconnect()
            end
            targets[part] = nil
            if ancestryConn then ancestryConn:Disconnect() end
        end
    end)

    targets[part] = { highlight = highlight, conn = ancestryConn }
end

local function detachHighlight(part)
    if not part then return end
    local meta = targets[part]
    if meta then
        if meta.highlight and meta.highlight.Parent then
            meta.highlight:Destroy()
        end
        if meta.conn then
            meta.conn:Disconnect()
        end
        targets[part] = nil
    end
end

-- ===========================
-- 🔧 Slider logic
-- ===========================
local function updateSliderFromX(inputX)
    local barAbsPos = sliderBar.AbsolutePosition.X
    local barSizeX = sliderBar.AbsoluteSize.X
    if barSizeX <= 0 then return end
    local relX = math.clamp(inputX - barAbsPos, 0, barSizeX)
    local halfBtn = math.floor(sliderButton.AbsoluteSize.X / 2)
    sliderButton.Position = UDim2.new(0, relX - halfBtn, 0.5, - (sliderButton.AbsoluteSize.Y / 2))
    sliderValue = math.floor((relX / barSizeX) * 200) -- max height 200 for safety
    sliderValueLabel.Text = "H: ".. tostring(sliderValue)
    -- apply to targets (defensive)
    for part, _ in pairs(targets) do
        if part and part:IsA("BasePart") and not part.Locked then
            local sx, sy, sz = part.Size.X, part.Size.Y, part.Size.Z
            -- keep X/Z same, change Y
            pcall(function()
                part.Size = Vector3.new(sx, math.max(1, sliderValue), sz)
            end)
        end
    end
end

-- init slider visually at 0 (left)
task.defer(function()
    safeWait(0.1)
    sliderButton.Position = UDim2.new(0, -10, 0.5, -10)
    sliderValueLabel.Text = "H: 0"
end)

-- ===========================
-- 🖱 Drag UI (replace deprecated Draggable)
-- ===========================
do
    local draggingFrame = frame
    local function toScreenPos(gui, pos)
        -- pos is Vector2 (absolute)
        return Vector2.new(pos.X, pos.Y)
    end

    titleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isDragging = true
            local mousePos = UserInputService:GetMouseLocation()
            local absPos = draggingFrame.AbsolutePosition
            dragOffset = Vector2.new(mousePos.X - absPos.X, mousePos.Y - absPos.Y)
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    isDragging = false
                end
            end)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if isDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local mousePos = UserInputService:GetMouseLocation()
            local newX = math.clamp(mousePos.X - dragOffset.X, 0, workspace.CurrentCamera.ViewportSize.X - draggingFrame.AbsoluteSize.X)
            local newY = math.clamp(mousePos.Y - dragOffset.Y, 0, workspace.CurrentCamera.ViewportSize.Y - draggingFrame.AbsoluteSize.Y)
            draggingFrame.Position = UDim2.new(0, newX, 0, newY)
        end
    end)
end

-- ===========================
-- 🔁 Events: slider dragging & clicking
-- ===========================
-- slider button start drag
sliderButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        -- start dragging slider by listening to InputChanged globally
        local conn
        conn = UserInputService.InputChanged:Connect(function(changed)
            if changed.UserInputType == Enum.UserInputType.MouseMovement or changed.UserInputType == Enum.UserInputType.Touch then
                updateSliderFromX(changed.Position.X)
            end
        end)
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                if conn then conn:Disconnect() end
            end
        end)
    end
end)

-- clicking on sliderBar to set value
sliderBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        updateSliderFromX(input.Position.X)
    end
end)

-- ===========================
-- ➕ Add / ➖ Remove button handlers
-- ===========================
addButton.MouseButton1Click:Connect(function()
    local part = getFootPart()
    if not part then
        -- feedback small flash or notification
        pcall(function()
            StarterGui:SetCore("SendNotification", {
                Title = "Sky-Base-Maker";
                Text = "Không tìm thấy part dưới chân.";
                Duration = 2;
            })
        end)
        return
    end

    if part.Locked then
        pcall(function()
            StarterGui:SetCore("SendNotification", {
                Title = "Sky-Base-Maker";
                Text = "Part đang bị Locked. Không thể chỉnh.";
                Duration = 2,
            })
        end)
        return
    end

    -- size threshold from original script (X/Z > 35)
    if part.Size.X > 35 and part.Size.Z > 35 then
        attachHighlight(part)
        pcall(function()
            StarterGui:SetCore("SendNotification", {
                Title = "Sky-Base-Maker";
                Text = "Added target.";
                Duration = 1.5,
            })
        end)
    else
        pcall(function()
            StarterGui:SetCore("SendNotification", {
                Title = "Sky-Base-Maker";
                Text = "Part quá nhỏ để làm sky base.";
                Duration = 1.5,
            })
        end)
    end
end)

removeButton.MouseButton1Click:Connect(function()
    local part = getFootPart()
    if part and targets[part] then
        detachHighlight(part)
        pcall(function()
            StarterGui:SetCore("SendNotification", {
                Title = "Sky-Base-Maker";
                Text = "Removed target.";
                Duration = 1.2,
            })
        end)
    else
        pcall(function()
            StarterGui:SetCore("SendNotification", {
                Title = "Sky-Base-Maker";
                Text = "Không có target để remove.";
                Duration = 1.2,
            })
        end)
    end
end)

-- toggle main frame visible
toggleButton.MouseButton1Click:Connect(function()
    frame.Visible = not frame.Visible
    toggleButton.Text = frame.Visible and "😙" or "😗"
end)

-- ===========================
-- 🔄 RenderStepped safety loop: ensure highlights still exist
-- ===========================
RunService.RenderStepped:Connect(function()
    if tick() - lastCheck >= 2 then
        lastCheck = tick()
        for part, meta in pairs(targets) do
            if not part or not part:IsA("BasePart") or not part:IsDescendantOf(game) then
                -- cleanup
                if meta and meta.highlight and meta.highlight.Parent then
                    meta.highlight:Destroy()
                end
                if meta and meta.conn then meta.conn:Disconnect() end
                targets[part] = nil
            else
                -- ensure highlight still exists
                if not part:FindFirstChild("PersistentHighlight") then
                    attachHighlight(part)
                end
            end
        end
    end
end)

-- ===========================
-- 🎬 Intro Animation (TweenService) + Final UI show
-- ===========================
do
    -- tween introFrame in & text pop
    local tweenInfoShort = TweenInfo.new(0.45, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tweenInfoText = TweenInfo.new(0.6, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out)

    local t1 = TweenService:Create(introFrame, tweenInfoShort, { BackgroundTransparency = 0 })
    local t2 = TweenService:Create(introLabel, tweenInfoText, { TextTransparency = 0 })

    t1:Play()
    t2:Play()
    t2.Completed:Wait()

    safeWait(1.5)

    -- fade out
    local t3 = TweenService:Create(introLabel, tweenInfoShort, { TextTransparency = 1 })
    local t4 = TweenService:Create(introFrame, tweenInfoShort, { BackgroundTransparency = 1 })

    t3:Play()
    t3.Completed:Wait()
    t4:Play()
    t4.Completed:Wait()

    -- destroy intro and show UI
    if introFrame and introFrame.Parent then introFrame:Destroy() end
    frame.Visible = true
    toggleButton.Visible = true
end

-- ===========================
-- 🔁 Handle character respawn (rebind if necessary)
-- ===========================
LocalPlayer.CharacterAdded:Connect(function(char)
    -- clear any stale targets that belonged to previous character
    -- (we keep targets until parts destroyed; just ensure raycast blacklist updates automatically)
    -- no special rebind needed because we use LocalPlayer.Character on each ray.
end)

-- ===========================
-- ✅ Done
-- ===========================
-- Final note: everything is contained here. Copy this LocalScript into StarterPlayerScripts.
-- If you want: I can later change the intro visuals (scale up text, glow, or add sound).
