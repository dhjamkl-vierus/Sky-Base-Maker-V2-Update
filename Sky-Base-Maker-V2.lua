-- Sky-Base-Maker Loading Animation Script for Roblox
-- Theo phong cách MOONDIETY với tất cả hiệu ứng đẹp

local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Tạo ScreenGui chính
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "SkyBaseLoadingGui"
screenGui.Parent = playerGui
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Background với logo animation làm nền
local backgroundFrame = Instance.new("ImageLabel")
backgroundFrame.Name = "Background"
backgroundFrame.Size = UDim2.new(1, 0, 1, 0)
backgroundFrame.Position = UDim2.new(0, 0, 0, 0)
backgroundFrame.BorderSizePixel = 0
backgroundFrame.BackgroundTransparency = 1
backgroundFrame.Image = "rbxassetid://125022786287705" -- Sử dụng ID logo làm nền
backgroundFrame.ImageTransparency = 0.3 -- Độ trong suốt 0.3
backgroundFrame.ScaleType = Enum.ScaleType.Tile
backgroundFrame.TileSize = UDim2.new(0, 200, 0, 200)
backgroundFrame.Parent = screenGui

-- Gradient overlay cho nền để tạo hiệu ứng đẹp hơn
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

-- Container chính giữa màn hình
local centerFrame = Instance.new("Frame")
centerFrame.Name = "CenterContent"
centerFrame.Size = UDim2.new(0, 500, 0, 400)
centerFrame.Position = UDim2.new(0.5, -250, 0.5, -200)
centerFrame.BackgroundTransparency = 1
centerFrame.Parent = screenGui

-- LOGO ĐÁM MÂY SỬ DỤNG HÌNH ẢNH
local cloudLogo = Instance.new("ImageLabel")
cloudLogo.Name = "CloudLogo"
cloudLogo.Size = UDim2.new(0, 200, 0, 130)
cloudLogo.Position = UDim2.new(0.5, -100, 0, 40)
cloudLogo.BackgroundTransparency = 1
cloudLogo.Image = "rbxassetid://125022786287705" -- Cloud gradient image từ user
cloudLogo.ImageColor3 = Color3.fromRGB(255, 255, 255)
cloudLogo.ScaleType = Enum.ScaleType.Fit
cloudLogo.Parent = centerFrame

-- Container cho hiệu ứng gradient trên logo
local logoContainer = Instance.new("Frame")
logoContainer.Size = UDim2.new(1, 0, 1, 0)
logoContainer.Position = UDim2.new(0, 0, 0, 0)
logoContainer.BackgroundTransparency = 1
logoContainer.Parent = cloudLogo

-- Tạo gradient overlay cho logo
local gradientOverlay = Instance.new("Frame")
gradientOverlay.Size = UDim2.new(1, 0, 1, 0)
gradientOverlay.Position = UDim2.new(0, 0, 0, 0)
gradientOverlay.BackgroundTransparency = 0.3
gradientOverlay.BorderSizePixel = 0
gradientOverlay.ZIndex = cloudLogo.ZIndex + 1
gradientOverlay.Parent = logoContainer

local logoGradient = Instance.new("UIGradient")
logoGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 255, 255)),    -- Cyan
    ColorSequenceKeypoint.new(0.3, Color3.fromRGB(64, 150, 255)), -- Light Blue
    ColorSequenceKeypoint.new(0.6, Color3.fromRGB(138, 43, 226)), -- Purple
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 20, 147))    -- Pink
}
logoGradient.Rotation = 45
logoGradient.Parent = gradientOverlay

-- Hiệu ứng glow cho logo
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

-- CHỮ VỚI FONT LUCKIESTGUY VÀ HIỆU ỨNG
local textContainer = Instance.new("Frame")
textContainer.Name = "TextContainer"
textContainer.Size = UDim2.new(0, 480, 0, 80)
textContainer.Position = UDim2.new(0.5, -240, 0, 180)
textContainer.BackgroundTransparency = 1
textContainer.Parent = centerFrame

-- Text với phân tách rõ ràng: S K Y - B A S E - M A K E R
local textParts = {"S", "K", "Y", "-", "B", "A", "S", "E", "-", "M", "A", "K", "E", "R"}
local letters = {}
local spacing = 34 -- Khoảng cách giữa các ký tự

for i, char in ipairs(textParts) do
    if char ~= "-" then
        local letter = Instance.new("TextLabel")
        letter.Name = "Letter" .. i
        letter.Size = UDim2.new(0, 40, 1, 0)
        letter.Position = UDim2.new(0, (i-1) * spacing - 500, 0, 0) -- Bắt đầu từ ngoài màn hình bên trái
        letter.BackgroundTransparency = 1
        letter.Text = char
        letter.TextSize = 35
        letter.TextScaled = true
        letter.Font = Enum.Font.LuckiestGuy -- Sử dụng font LuckiestGuy
        letter.TextTransparency = 1
        letter.Parent = textContainer
        
        -- Gradient cho từng chữ với màu sắc đẹp hơn
        local letterGradient = Instance.new("UIGradient")
        letterGradient.Color = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 255, 255)),    -- Cyan
            ColorSequenceKeypoint.new(0.25, Color3.fromRGB(64, 150, 255)), -- Light Blue
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(138, 43, 226)),  -- Purple
            ColorSequenceKeypoint.new(0.75, Color3.fromRGB(255, 20, 147)), -- Pink
            ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 165, 0))      -- Orange
        }
        letterGradient.Rotation = 45
        letterGradient.Parent = letter
        
        -- Glow effect cho chữ
        local textStroke = Instance.new("UIStroke")
        textStroke.Color = Color3.fromRGB(0, 255, 255)
        textStroke.Thickness = 4
        textStroke.Transparency = 0.2
        textStroke.Parent = letter
        
        table.insert(letters, {element = letter, finalPos = (i-1) * spacing, type = "letter"})
    else
        -- Tạo dấu gạch ngang với hiệu ứng đẹp hơn
        local dash = Instance.new("Frame")
        dash.Name = "Dash" .. i
        dash.Size = UDim2.new(0, 28, 0, 5)
        dash.Position = UDim2.new(0, (i-1) * spacing + 6 - 500, 0.5, -2.5) -- Bắt đầu từ ngoài màn hình bên trái
        dash.BorderSizePixel = 0
        dash.BackgroundTransparency = 1
        dash.Parent = textContainer
        
        -- Corner radius cho dash
        local dashCorner = Instance.new("UICorner")
        dashCorner.CornerRadius = UDim.new(0, 3)
        dashCorner.Parent = dash
        
        local dashGradient = Instance.new("UIGradient")
        dashGradient.Color = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 255, 255)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(138, 43, 226)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 20, 147))
        }
        dashGradient.Rotation = 45
        dashGradient.Parent = dash
        
        -- Glow effect cho dash
        local dashStroke = Instance.new("UIStroke")
        dashStroke.Color = Color3.fromRGB(0, 255, 255)
        dashStroke.Thickness = 2
        dashStroke.Transparency = 0.3
        dashStroke.Parent = dash
        
        table.insert(letters, {element = dash, finalPos = (i-1) * spacing + 6, type = "dash"})
    end
end

-- HỆ THỐNG HẠT HIỆU ỨNG
local particleFrame = Instance.new("Frame")
particleFrame.Name = "ParticleContainer"
particleFrame.Size = UDim2.new(1, 0, 1, 0)
particleFrame.BackgroundTransparency = 1
particleFrame.Parent = screenGui

local particles = {}
local function createParticle()
    local particle = Instance.new("Frame")
    particle.Size = UDim2.new(0, math.random(3, 8), 0, math.random(3, 8))
    particle.Position = UDim2.new(math.random(), 0, math.random(), 0)
    particle.BackgroundColor3 = Color3.fromRGB(
        math.random(100, 255),
        math.random(150, 255),
        255
    )
    particle.BorderSizePixel = 0
    particle.BackgroundTransparency = math.random(30, 70) / 100
    particle.Parent = particleFrame
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0.5, 0)
    corner.Parent = particle
    
    return particle
end

-- Tạo 100 hạt hiệu ứng
for i = 1, 100 do
    table.insert(particles, createParticle())
end

-- ANIMATION FUNCTIONS
local function animateParticles()
    for i, particle in ipairs(particles) do
        if particle and particle.Parent then
            local moveInfo = TweenInfo.new(
                math.random(10, 20),
                Enum.EasingStyle.Linear,
                Enum.EasingDirection.InOut,
                -1
            )
            
            local moveTween = TweenService:Create(particle, moveInfo, {
                Position = UDim2.new(math.random(), 0, math.random(), 0),
                Rotation = math.random(-180, 180)
            })
            moveTween:Play()
            
            -- Hiệu ứng fade
            local fadeInfo = TweenInfo.new(
                math.random(3, 8),
                Enum.EasingStyle.Sine,
                Enum.EasingDirection.InOut,
                -1, true
            )
            local fadeTween = TweenService:Create(particle, fadeInfo, {
                BackgroundTransparency = math.random(10, 90) / 100
            })
            fadeTween:Play()
        end
    end
end

-- Animation cho logo glow và nền
local function animateLogoGlow()
    local glowInfo = TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true)
    local glowTween = TweenService:Create(logoGlow, glowInfo, {
        ImageTransparency = 0.9,
        Size = UDim2.new(1.6, 0, 1.6, 0),
        Position = UDim2.new(-0.3, 0, -0.3, 0)
    })
    glowTween:Play()
    
    -- Animation cho gradient overlay
    local gradientInfo = TweenInfo.new(3, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1)
    local gradientTween = TweenService:Create(logoGradient, gradientInfo, {
        Rotation = logoGradient.Rotation + 360
    })
    gradientTween:Play()
    
    -- Animation cho nền background
    local backgroundInfo = TweenInfo.new(15, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1)
    local backgroundTween = TweenService:Create(backgroundFrame, backgroundInfo, {
        TileSize = UDim2.new(0, 250, 0, 250),
        ImageTransparency = 0.2
    })
    backgroundTween:Play()
    
    -- Animation gradient cho background overlay
    local bgGradientInfo = TweenInfo.new(8, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1)
    local bgGradientTween = TweenService:Create(backgroundGradient, bgGradientInfo, {
        Rotation = backgroundGradient.Rotation + 360
    })
    bgGradientTween:Play()
end

-- MAIN ANIMATION SEQUENCE (5 giây)
local function startLoadingSequence()
    -- Bắt đầu particle ngay lập tức
    animateParticles()
    
    -- Logo xuất hiện (0-1 giây)
    cloudLogo.Size = UDim2.new(0, 0, 0, 0)
    cloudLogo.Rotation = -90
    cloudLogo.ImageTransparency = 1
    local logoAppearInfo = TweenInfo.new(1, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    local logoAppearTween = TweenService:Create(cloudLogo, logoAppearInfo, {
        Size = UDim2.new(0, 200, 0, 130),
        Rotation = 0,
        ImageTransparency = 0
    })
    logoAppearTween:Play()
    animateLogoGlow()
    
    wait(1)
    
    -- Animation chữ từ trái qua phải (1-3.5 giây)
    local letterDelay = 2.5 / #letters
    for i, letterData in ipairs(letters) do
        local letter = letterData.element
        local finalPos = letterData.finalPos
        local letterType = letterData.type
        
        -- Slide từ trái qua phải với hiệu ứng đẹp
        local slideInfo = TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
        local slideProperties = {}
        
        if letterType == "letter" then
            slideProperties = {
                Position = UDim2.new(0, finalPos, 0, 0),
                TextTransparency = 0,
                Rotation = 0
            }
        else -- dash
            slideProperties = {
                Position = UDim2.new(0, finalPos, 0.5, -2.5),
                BackgroundTransparency = 0
            }
        end
        
        local slideTween = TweenService:Create(letter, slideInfo, slideProperties)
        slideTween:Play()
        
        -- Glow effect khi xuất hiện
        local glowEffect = letter:FindFirstChild("UIStroke")
        if glowEffect then
            local glowInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            local glowTween = TweenService:Create(glowEffect, glowInfo, {
                Thickness = glowEffect.Thickness + 2,
                Transparency = 0
            })
            glowTween:Play()
            
            -- Trở lại bình thường
            wait(0.2)
            local normalGlowTween = TweenService:Create(glowEffect, glowInfo, {
                Thickness = glowEffect.Thickness - 2,
                Transparency = 0.2
            })
            normalGlowTween:Play()
        end
        
        -- Floating effect sau khi xuất hiện
        wait(0.3)
        local floatInfo = TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true)
        if letterType == "letter" then
            local floatTween = TweenService:Create(letter, floatInfo, {
                Position = UDim2.new(0, finalPos, 0, -8),
                Rotation = math.random(-5, 5)
            })
            floatTween:Play()
        end
        
        wait(letterDelay)
    end
    
    wait(0.5)
    
    -- Biến mất từ trái qua phải (3.5-5 giây)
    local disappearDelay = 1.2 / #letters
    for i, letterData in ipairs(letters) do
        local letter = letterData.element
        local letterType = letterData.type
        
        -- Glow effect mạnh trước khi biến mất
        local glowEffect = letter:FindFirstChild("UIStroke")
        if glowEffect then
            local glowInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            local glowTween = TweenService:Create(glowEffect, glowInfo, {
                Thickness = 12,
                Transparency = 0,
                Color = Color3.fromRGB(255, 255, 255)
            })
            glowTween:Play()
        end
        
        wait(0.1)
        
        -- Slide ra ngoài màn hình bên phải với hiệu ứng đẹp
        local disappearInfo = TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.In)
        local disappearProperties = {}
        
        if letterType == "letter" then
            disappearProperties = {
                Position = UDim2.new(0, letterData.finalPos + 800, 0, -30), -- Slide ra ngoài màn hình bên phải
                TextTransparency = 1,
                Rotation = math.random(-45, 45),
                Size = UDim2.new(0, 20, 1, 0) -- Thu nhỏ lại
            }
        else -- dash
            disappearProperties = {
                Position = UDim2.new(0, letterData.finalPos + 800, 0.5, -2.5), -- Slide ra ngoài màn hình bên phải
                BackgroundTransparency = 1,
                Size = UDim2.new(0, 14, 0, 2.5) -- Thu nhỏ lại
            }
        end
        
        local disappearTween = TweenService:Create(letter, disappearInfo, disappearProperties)
        disappearTween:Play()
        
        -- Hiệu ứng particle nhỏ khi biến mất
        spawn(function()
            wait(0.3)
            -- Tạo hiệu ứng sparkle nhỏ
            for j = 1, 5 do
                local sparkle = Instance.new("Frame")
                sparkle.Size = UDim2.new(0, 3, 0, 3)
                sparkle.Position = UDim2.new(0, letterData.finalPos + math.random(-10, 10), 0, math.random(-5, 5))
                sparkle.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
                sparkle.BorderSizePixel = 0
                sparkle.Parent = textContainer
                
                local sparkleCorner = Instance.new("UICorner")
                sparkleCorner.CornerRadius = UDim.new(0.5, 0)
                sparkleCorner.Parent = sparkle
                
                local sparkleInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
                local sparkleTween = TweenService:Create(sparkle, sparkleInfo, {
                    Position = sparkle.Position + UDim2.new(0, math.random(-30, 30), 0, math.random(-30, 30)),
                    BackgroundTransparency = 1,
                    Size = UDim2.new(0, 1, 0, 1)
                })
                sparkleTween:Play()
                sparkleTween.Completed:Connect(function()
                    sparkle:Destroy()
                end)
            end
        end)
        
        wait(disappearDelay)
    end
    
    -- Logo biến mất
    local logoDisappearInfo = TweenInfo.new(0.8, Enum.EasingStyle.Back, Enum.EasingDirection.In)
    local logoDisappearTween = TweenService:Create(cloudLogo, logoDisappearInfo, {
        Size = UDim2.new(0, 0, 0, 0),
        Rotation = 90,
        ImageTransparency = 1,
        Position = cloudLogo.Position + UDim2.new(0, 0, 0, -50)
    })
    logoDisappearTween:Play()
    
    -- Fade out toàn bộ màn hình
    wait(0.3)
    local fadeInfo = TweenInfo.new(0.7, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local fadeTween = TweenService:Create(screenGui, fadeInfo, {
        Enabled = false
    })
    fadeTween:Play()
    
    fadeTween.Completed:Connect(function()
        screenGui:Destroy()
    end)
end

-- Khởi động loading sequence
startLoadingSequence()

print("Sky-Base-Maker Loading Animation với hiệu ứng MOONDIETY đã khởi tạo!")
