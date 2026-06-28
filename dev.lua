--==================================================================
-- 🏃 SM1LE HUB — Lurking Giants
-- RightCtrl hides, — minimizes, ✕ closes.
--==================================================================

if game.PlaceId ~= 6328880674 then return end
if _G.Sm1leHub and _G.Sm1leHub.Destroy then pcall(_G.Sm1leHub.Destroy) end

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local VirtualUser = game:GetService("VirtualUser")
local VIM = game:GetService("VirtualInputManager")
local Lighting = game:GetService("Lighting")
local HttpService = game:GetService("HttpService")
local StarterGui = game:GetService("StarterGui")
local lp = Players.LocalPlayer

-- Сохраняем оригинальные настройки освещения до изменений
local originalLighting = {
    Brightness = Lighting.Brightness,
    ClockTime = Lighting.ClockTime,
    FogEnd = Lighting.FogEnd,
    FogStart = Lighting.FogStart,
    GlobalShadows = Lighting.GlobalShadows,
    OutdoorAmbient = Lighting.OutdoorAmbient,
    Ambient = Lighting.Ambient,
    Outlines = Lighting.Outlines,
    Atmosphere = nil,
    Bloom = nil,
    ColorCorrection = nil,
}

if Lighting:FindFirstChild("Atmosphere") then
    local at = Lighting.Atmosphere
    originalLighting.Atmosphere = {
        Density = at.Density,
        Offset = at.Offset,
        Haze = at.Haze,
        Glare = at.Glare,
    }
end
if Lighting:FindFirstChild("Bloom") then
    originalLighting.Bloom = {
        Intensity = Lighting.Bloom.Intensity,
    }
end
if Lighting:FindFirstChild("ColorCorrection") then
    originalLighting.ColorCorrection = {
        Brightness = Lighting.ColorCorrection.Brightness,
        Contrast = Lighting.ColorCorrection.Contrast,
    }
end

local function corner(p, r)
    local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0, r); c.Parent = p; return c
end

local function getAssetId(input)
    local text = tostring(input or "")
    return text:match("rbxassetid://(%d+)") or text:match("asset/(%d+)") or text:match("library/(%d+)") or text:match("[?&]id=(%d+)") or text:match("^(%d+)$")
end

local function toImageContent(input)
    local id = getAssetId(input)
    if id then return "rbxthumb://type=Asset&id=" .. id .. "&w=420&h=420" end
    return tostring(input or "")
end

-- ==================== ИНТРО ====================
local introGui = Instance.new("ScreenGui")
introGui.Name = "Sm1leIntro"; introGui.ResetOnSpawn = false; introGui.IgnoreGuiInset = true
introGui.Parent = (gethui and gethui()) or game:GetService("CoreGui")

local introFrame = Instance.new("Frame")
introFrame.Size = UDim2.new(1, 0, 1, 0); introFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
introFrame.BorderSizePixel = 0; introFrame.Parent = introGui

local snowflakesIntro = {}
for i = 1, 120 do
    local size = math.random(2, 6)
    local flake = Instance.new("Frame", introFrame)
    flake.Size = UDim2.fromOffset(size, size); flake.Position = UDim2.fromScale(math.random(), math.random()*-1)
    flake.BackgroundColor3 = Color3.fromRGB(255,255,255)
    flake.BackgroundTransparency = math.random()*0.5+0.3; flake.BorderSizePixel = 0; corner(flake, size/2)
    local glow = Instance.new("UIStroke", flake)
    glow.Color = Color3.fromRGB(255,255,255); glow.Thickness = 1; glow.Transparency = 0.6
    snowflakesIntro[i] = {dot=flake, glow=glow, x=flake.Position.X.Scale, y=flake.Position.Y.Scale, speed=math.random()*0.35+0.15, wind=math.random()*0.08-0.04, twinkle=math.random()*10}
end

local introTitle = Instance.new("TextLabel", introFrame)
introTitle.Size = UDim2.new(0, 600, 0, 80); introTitle.Position = UDim2.new(0.5, -300, 0.5, -130)
introTitle.BackgroundTransparency = 1; introTitle.Text = "SM1LE HUB"
introTitle.Font = Enum.Font.GothamBlack; introTitle.TextSize = 56
introTitle.TextColor3 = Color3.fromRGB(255,255,255); introTitle.TextTransparency = 1
local introTitleGlow = Instance.new("UIStroke", introTitle); introTitleGlow.Color = Color3.fromRGB(255,255,255); introTitleGlow.Thickness = 2; introTitleGlow.Transparency = 1
local introTitleGrad = Instance.new("UIGradient", introTitle)

local introSubtitle = Instance.new("TextLabel", introFrame)
introSubtitle.Size = UDim2.new(0, 400, 0, 35); introSubtitle.Position = UDim2.new(0.5, -200, 0.5, -40)
introSubtitle.BackgroundTransparency = 1; introSubtitle.Text = "LURKING GIANTS"
introSubtitle.Font = Enum.Font.GothamMedium; introSubtitle.TextSize = 24
introSubtitle.TextColor3 = Color3.fromRGB(255,255,255); introSubtitle.TextTransparency = 1
local introSubGlow = Instance.new("UIStroke", introSubtitle); introSubGlow.Color = Color3.fromRGB(255,255,255); introSubGlow.Thickness = 1.5; introSubGlow.Transparency = 1
local introSubGrad = Instance.new("UIGradient", introSubtitle)

local introAuthor = Instance.new("TextLabel", introFrame)
introAuthor.Size = UDim2.new(0, 300, 0, 25); introAuthor.Position = UDim2.new(0.5, -150, 0.5, 5)
introAuthor.BackgroundTransparency = 1; introAuthor.Text = "by SM1LER"
introAuthor.Font = Enum.Font.Gotham; introAuthor.TextSize = 16
introAuthor.TextColor3 = Color3.fromRGB(255,255,255); introAuthor.TextTransparency = 1
local introAuthorGlow = Instance.new("UIStroke", introAuthor); introAuthorGlow.Color = Color3.fromRGB(255,255,255); introAuthorGlow.Thickness = 1; introAuthorGlow.Transparency = 1
local introAuthorGrad = Instance.new("UIGradient", introAuthor)

local introLine = Instance.new("Frame", introFrame)
introLine.Size = UDim2.fromOffset(0, 1); introLine.Position = UDim2.new(0.5, -100, 0.5, 35)
introLine.BackgroundColor3 = Color3.fromRGB(255,255,255); introLine.BorderSizePixel = 0; introLine.BackgroundTransparency = 1
local introLineGlow = Instance.new("UIStroke", introLine); introLineGlow.Color = Color3.fromRGB(255,255,255); introLineGlow.Thickness = 1.5; introLineGlow.Transparency = 1
local introLineGrad = Instance.new("UIGradient", introLine)

local introClock = 0
local introConn = RunService.Heartbeat:Connect(function(dt)
    introClock += dt
    for _, flake in ipairs(snowflakesIntro) do
        flake.y += flake.speed * dt; flake.x += flake.wind * dt + math.sin(introClock*1.2+flake.twinkle)*0.001
        if flake.y > 1.1 then flake.y = -0.05; flake.x = math.random() end
        if flake.x > 1.05 then flake.x = -0.05 elseif flake.x < -0.05 then flake.x = 1.05 end
        flake.dot.Position = UDim2.fromScale(flake.x, flake.y)
        local brightness = math.sin(introClock*2.5+flake.twinkle)*0.15+0.85
        flake.dot.BackgroundTransparency = 1 - brightness*0.5
        flake.glow.Transparency = 1 - brightness*0.3
    end
    local wave = math.sin(introClock*0.8)*0.15; local whitePos = 0.55+wave
    local gradSequence = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255,255,255)),
        ColorSequenceKeypoint.new(whitePos-0.05, Color3.fromRGB(180,180,180)),
        ColorSequenceKeypoint.new(whitePos+0.05, Color3.fromRGB(40,40,40)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(0,0,0)),
    })
    introTitleGrad.Color = gradSequence; introSubGrad.Color = gradSequence
    introAuthorGrad.Color = gradSequence; introLineGrad.Color = gradSequence
    local glowPulse = math.sin(introClock*1.5)*0.08+0.92
    introTitleGlow.Transparency = introTitle.TextTransparency + (1-glowPulse)
    introSubGlow.Transparency = introSubtitle.TextTransparency + (1-glowPulse)
    introAuthorGlow.Transparency = introAuthor.TextTransparency + (1-glowPulse)
    introLineGlow.Transparency = introLine.BackgroundTransparency + (1-glowPulse)
end)

task.spawn(function()
    TweenService:Create(introTitle, TweenInfo.new(1.2, Enum.EasingStyle.Quint), {TextTransparency = 0}):Play()
    TweenService:Create(introTitleGlow, TweenInfo.new(1.2, Enum.EasingStyle.Quint), {Transparency = 0.8}):Play()
    task.wait(0.7)
    TweenService:Create(introSubtitle, TweenInfo.new(0.9, Enum.EasingStyle.Quint), {TextTransparency = 0.1}):Play()
    TweenService:Create(introSubGlow, TweenInfo.new(0.9, Enum.EasingStyle.Quint), {Transparency = 0.8}):Play()
    task.wait(0.6)
    TweenService:Create(introAuthor, TweenInfo.new(0.7, Enum.EasingStyle.Quint), {TextTransparency = 0.2}):Play()
    TweenService:Create(introAuthorGlow, TweenInfo.new(0.7, Enum.EasingStyle.Quint), {Transparency = 0.8}):Play()
    TweenService:Create(introLine, TweenInfo.new(0.9, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.fromOffset(200, 1), BackgroundTransparency = 0.6}):Play()
    TweenService:Create(introLineGlow, TweenInfo.new(0.9, Enum.EasingStyle.Quad), {Transparency = 0.7}):Play()
    task.wait(1.7)
    TweenService:Create(introTitle, TweenInfo.new(0.7, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {TextSize = 60}):Play()
    TweenService:Create(introTitleGlow, TweenInfo.new(0.7, Enum.EasingStyle.Quad), {Thickness = 3.5, Transparency = 0.6}):Play()
    task.wait(0.7)
    TweenService:Create(introTitle, TweenInfo.new(0.7, Enum.EasingStyle.Quad), {TextSize = 56}):Play()
    TweenService:Create(introTitleGlow, TweenInfo.new(0.7, Enum.EasingStyle.Quad), {Thickness = 2, Transparency = 0.8}):Play()
    task.wait(3.5)
    if introConn then introConn:Disconnect() end
    TweenService:Create(introTitle, TweenInfo.new(0.8, Enum.EasingStyle.Quad), {TextTransparency = 1}):Play()
    TweenService:Create(introTitleGlow, TweenInfo.new(0.8, Enum.EasingStyle.Quad), {Transparency = 1}):Play()
    TweenService:Create(introSubtitle, TweenInfo.new(0.6, Enum.EasingStyle.Quad), {TextTransparency = 1}):Play()
    TweenService:Create(introSubGlow, TweenInfo.new(0.6, Enum.EasingStyle.Quad), {Transparency = 1}):Play()
    TweenService:Create(introAuthor, TweenInfo.new(0.5, Enum.EasingStyle.Quad), {TextTransparency = 1}):Play()
    TweenService:Create(introAuthorGlow, TweenInfo.new(0.5, Enum.EasingStyle.Quad), {Transparency = 1}):Play()
    TweenService:Create(introLine, TweenInfo.new(0.6, Enum.EasingStyle.Quad), {Size = UDim2.fromOffset(0, 1), BackgroundTransparency = 1}):Play()
    TweenService:Create(introLineGlow, TweenInfo.new(0.6, Enum.EasingStyle.Quad), {Transparency = 1}):Play()
    for _, flake in ipairs(snowflakesIntro) do
        TweenService:Create(flake.dot, TweenInfo.new(0.7, Enum.EasingStyle.Quad), {BackgroundTransparency = 1}):Play()
        TweenService:Create(flake.glow, TweenInfo.new(0.7, Enum.EasingStyle.Quad), {Transparency = 1}):Play()
    end
    TweenService:Create(introFrame, TweenInfo.new(0.8, Enum.EasingStyle.Quint), {BackgroundTransparency = 1}):Play()
    task.wait(0.8)
    introGui:Destroy()
end)

task.wait(10.9)

-- ==================== ОСНОВНОЙ СКРИПТ ====================
local START_BACKGROUND = "https://create.roblox.com/store/asset/6660431853/Neon-Roblox-Logo"
local START_PANEL_TRANSPARENCY = 0.5
local START_IMAGE_TRANSPARENCY = 0.05

local S = {
    speed = false, jumppower = false, noclip = false, fly = false, antifling = false,
    antiafk = false, autofarm = false, autowin = false,
    espPlayers = false, espGiants = false, chams = false, rainbowesp = false,
    espName = true, espRole = true, espDistance = true, espHP = true,
    riskmeter = false, fullbright = false, nofog = false,
    thirdperson = false, maxzoom = false, hitboxviewer = false,
    spectate = false, musicplayer = false, snowEffect = false,
    giantarrow = false, fovchanger = false, noscreenshake = false, notifications = false,
    speedVal = 50, jumpVal = 100, musicID = "rbxassetid://1842801835", fovVal = 70,
    theme = "Cosmic", bgTransparency = math.floor(START_PANEL_TRANSPARENCY * 100),
    defaultWalkSpeed = 16, defaultJumpPower = 50,
}

local Themes = {
    Blood = {
        ACCENT = Color3.fromRGB(255,0,0), ACCENT2 = Color3.fromRGB(0,0,0),
        BG = Color3.fromRGB(20,5,5), BG2 = Color3.fromRGB(30,8,8), BG3 = Color3.fromRGB(45,12,12),
        TXT = Color3.fromRGB(255,240,240), SUB = Color3.fromRGB(200,150,150),
        Stroke = Color3.fromRGB(120,15,15), SwitchOff = Color3.fromRGB(45,12,12),
        TitleGrad1 = Color3.fromRGB(255,0,0), TitleGrad2 = Color3.fromRGB(0,0,0),
        ByGrad1 = Color3.fromRGB(255,80,80), ByGrad2 = Color3.fromRGB(0,0,0)
    },
    Ocean = {
        ACCENT = Color3.fromRGB(0,100,255), ACCENT2 = Color3.fromRGB(0,0,40),
        BG = Color3.fromRGB(5,8,20), BG2 = Color3.fromRGB(8,12,30), BG3 = Color3.fromRGB(12,18,45),
        TXT = Color3.fromRGB(235,240,255), SUB = Color3.fromRGB(140,160,200),
        Stroke = Color3.fromRGB(15,40,120), SwitchOff = Color3.fromRGB(12,18,45),
        TitleGrad1 = Color3.fromRGB(0,150,255), TitleGrad2 = Color3.fromRGB(0,0,50),
        ByGrad1 = Color3.fromRGB(0,180,255), ByGrad2 = Color3.fromRGB(0,0,50)
    },
    Midnight = {
        ACCENT = Color3.fromRGB(140,0,255), ACCENT2 = Color3.fromRGB(5,0,20),
        BG = Color3.fromRGB(8,5,20), BG2 = Color3.fromRGB(14,8,30), BG3 = Color3.fromRGB(22,12,45),
        TXT = Color3.fromRGB(240,235,255), SUB = Color3.fromRGB(160,140,200),
        Stroke = Color3.fromRGB(50,10,120), SwitchOff = Color3.fromRGB(22,12,45),
        TitleGrad1 = Color3.fromRGB(170,50,255), TitleGrad2 = Color3.fromRGB(10,0,30),
        ByGrad1 = Color3.fromRGB(180,80,255), ByGrad2 = Color3.fromRGB(10,0,30)
    },
    Forest = {
        ACCENT = Color3.fromRGB(0,200,50), ACCENT2 = Color3.fromRGB(0,15,0),
        BG = Color3.fromRGB(5,15,5), BG2 = Color3.fromRGB(8,22,8), BG3 = Color3.fromRGB(12,32,12),
        TXT = Color3.fromRGB(235,255,235), SUB = Color3.fromRGB(140,200,140),
        Stroke = Color3.fromRGB(15,80,15), SwitchOff = Color3.fromRGB(12,32,12),
        TitleGrad1 = Color3.fromRGB(0,255,80), TitleGrad2 = Color3.fromRGB(0,20,0),
        ByGrad1 = Color3.fromRGB(50,255,100), ByGrad2 = Color3.fromRGB(0,20,0)
    },
    Sunset = {
        ACCENT = Color3.fromRGB(255,120,0), ACCENT2 = Color3.fromRGB(20,3,0),
        BG = Color3.fromRGB(18,8,3), BG2 = Color3.fromRGB(28,12,5), BG3 = Color3.fromRGB(42,18,8),
        TXT = Color3.fromRGB(255,245,235), SUB = Color3.fromRGB(200,160,120),
        Stroke = Color3.fromRGB(100,30,5), SwitchOff = Color3.fromRGB(42,18,8),
        TitleGrad1 = Color3.fromRGB(255,150,30), TitleGrad2 = Color3.fromRGB(30,5,0),
        ByGrad1 = Color3.fromRGB(255,170,50), ByGrad2 = Color3.fromRGB(30,5,0)
    },
    System = {
        ACCENT = Color3.fromRGB(0,200,200), ACCENT2 = Color3.fromRGB(0,20,20),
        BG = Color3.fromRGB(3,15,15), BG2 = Color3.fromRGB(5,22,22), BG3 = Color3.fromRGB(8,32,32),
        TXT = Color3.fromRGB(220,255,255), SUB = Color3.fromRGB(130,200,200),
        Stroke = Color3.fromRGB(10,80,80), SwitchOff = Color3.fromRGB(8,32,32),
        TitleGrad1 = Color3.fromRGB(0,255,255), TitleGrad2 = Color3.fromRGB(0,30,30),
        ByGrad1 = Color3.fromRGB(50,255,255), ByGrad2 = Color3.fromRGB(0,30,30)
    },
    Cosmic = {
        ACCENT = Color3.fromRGB(180,130,255), ACCENT2 = Color3.fromRGB(0,0,0),
        BG = Color3.fromRGB(5,3,12), BG2 = Color3.fromRGB(10,5,22), BG3 = Color3.fromRGB(18,10,35),
        TXT = Color3.fromRGB(245,240,255), SUB = Color3.fromRGB(170,155,210),
        Stroke = Color3.fromRGB(80,50,140), SwitchOff = Color3.fromRGB(18,10,35),
        TitleGrad1 = Color3.fromRGB(200,150,255), TitleGrad2 = Color3.fromRGB(30,10,60),
        ByGrad1 = Color3.fromRGB(210,170,255), ByGrad2 = Color3.fromRGB(30,10,60)
    },
    Grayscale = {
        ACCENT = Color3.fromRGB(255,255,255), ACCENT2 = Color3.fromRGB(0,0,0),
        BG = Color3.fromRGB(30,30,30), BG2 = Color3.fromRGB(45,45,45), BG3 = Color3.fromRGB(60,60,60),
        TXT = Color3.fromRGB(255,255,255), SUB = Color3.fromRGB(180,180,180),
        Stroke = Color3.fromRGB(100,100,100), SwitchOff = Color3.fromRGB(30,30,30),
        TitleGrad1 = Color3.fromRGB(255,255,255), TitleGrad2 = Color3.fromRGB(80,80,80),
        ByGrad1 = Color3.fromRGB(220,220,220), ByGrad2 = Color3.fromRGB(60,60,60)
    }
}

local currentTheme = Themes[S.theme]
local ACCENT = currentTheme.ACCENT; local ACCENT2 = currentTheme.ACCENT2
local BG = currentTheme.BG; local BG2 = currentTheme.BG2; local BG3 = currentTheme.BG3
local TXT = currentTheme.TXT; local SUB = currentTheme.SUB

local function pad(p,t,b,l,r)
    local u=Instance.new("UIPadding"); u.PaddingTop=UDim.new(0,t); u.PaddingBottom=UDim.new(0,b)
    u.PaddingLeft=UDim.new(0,l); u.PaddingRight=UDim.new(0,r); u.Parent=p; return u
end
local function gradient(p,c1,c2,rot)
    local g=Instance.new("UIGradient"); g.Color=ColorSequence.new(c1,c2); g.Rotation=rot or 0; g.Parent=p; return g
end

local gui = Instance.new("ScreenGui"); gui.Name = "Sm1leHub"
gui.ResetOnSpawn = false; gui.IgnoreGuiInset = true
gui.Parent = (gethui and gethui()) or game:GetService("CoreGui")

local main = Instance.new("Frame", gui)
main.Size = UDim2.fromOffset(520,440); main.Position = UDim2.fromScale(0.5,0.5)
main.AnchorPoint = Vector2.new(0.5,0.5); main.BackgroundColor3 = BG
main.BorderSizePixel = 0; main.ClipsDescendants = true; corner(main,16)
main.BackgroundTransparency = 1

local mst = Instance.new("UIStroke",main); mst.Color = currentTheme.Stroke; mst.Thickness = 1.5; mst.Transparency = 0

local bg = Instance.new("ImageLabel", main)
bg.Name = "SM1LE_WorkingBackground"; bg.BackgroundTransparency = 1; bg.BorderSizePixel = 0
bg.Position = UDim2.fromScale(0,0); bg.Size = UDim2.fromScale(1,1)
bg.Image = toImageContent(START_BACKGROUND); bg.ScaleType = Enum.ScaleType.Crop
bg.ImageTransparency = START_IMAGE_TRANSPARENCY; bg.ZIndex = 1; corner(bg,16)

-- СНЕГ
local snowContainer = Instance.new("Frame", main)
snowContainer.Name = "SnowContainer"; snowContainer.Size = UDim2.new(1,0,1,0)
snowContainer.Position = UDim2.fromScale(0,0); snowContainer.BackgroundTransparency = 1
snowContainer.BorderSizePixel = 0; snowContainer.ZIndex = 2; snowContainer.Visible = false

local windowSnowflakes = {}
for i = 1, 60 do
    local size = math.random(2, 5)
    local flake = Instance.new("Frame", snowContainer)
    flake.Size = UDim2.fromOffset(size, size); flake.Position = UDim2.fromScale(math.random(), math.random()*-1)
    flake.BackgroundColor3 = Color3.fromRGB(255,255,255)
    flake.BackgroundTransparency = math.random()*0.5+0.3; flake.BorderSizePixel = 0; corner(flake, size/2)
    local glow = Instance.new("UIStroke", flake)
    glow.Color = Color3.fromRGB(255,255,255); glow.Thickness = 1; glow.Transparency = 0.6
    windowSnowflakes[i] = {dot=flake, glow=glow, x=flake.Position.X.Scale, y=flake.Position.Y.Scale, speed=math.random()*0.35+0.15, wind=math.random()*0.08-0.04, twinkle=math.random()*10}
end

local snowClock = 0; local snowConn
local function startSnow()
    if snowConn then snowConn:Disconnect() end
    snowContainer.Visible = true; snowClock = 0
    snowConn = RunService.Heartbeat:Connect(function(dt)
        snowClock += dt
        for _, flake in ipairs(windowSnowflakes) do
            flake.y += flake.speed * dt; flake.x += flake.wind * dt + math.sin(snowClock*1.2+flake.twinkle)*0.001
            if flake.y > 1.1 then flake.y = -0.05; flake.x = math.random() end
            if flake.x > 1.05 then flake.x = -0.05 elseif flake.x < -0.05 then flake.x = 1.05 end
            flake.dot.Position = UDim2.fromScale(flake.x, flake.y)
            local brightness = math.sin(snowClock*2.5+flake.twinkle)*0.15+0.85
            flake.dot.BackgroundTransparency = 1 - brightness*0.5
            flake.glow.Transparency = 1 - brightness*0.3
        end
    end)
end
local function stopSnow() if snowConn then snowConn:Disconnect(); snowConn=nil end; snowContainer.Visible=false end

local function pushUiAboveBackground()
    for _, o in ipairs(main:GetDescendants()) do
        if o:IsA("GuiObject") and o~=bg and o~=snowContainer and o.ZIndex<=bg.ZIndex then o.ZIndex=bg.ZIndex+1 end
    end
end
pushUiAboveBackground()
main.DescendantAdded:Connect(function(o)
    if o:IsA("GuiObject") and o~=bg and o~=snowContainer and not o:IsDescendantOf(snowContainer) and o.ZIndex<=bg.ZIndex then o.ZIndex=bg.ZIndex+1 end
end)

local function applyPanelTransparency(value)
    value = math.clamp(value,0,0.9); main.BackgroundTransparency=1
    for _, o in ipairs(main:GetDescendants()) do
        if o~=bg and o~=snowContainer and not o:IsDescendantOf(snowContainer) and (o:IsA("Frame") or o:IsA("TextButton") or o:IsA("TextBox")) then
            if o.BackgroundTransparency<1 then o.BackgroundTransparency=value end
        end
    end
end

-- HEADER
local header = Instance.new("Frame", main)
header.Size = UDim2.new(1,0,0,56); header.BackgroundColor3=BG2; header.BorderSizePixel=0; corner(header,16)
header.BackgroundTransparency=START_PANEL_TRANSPARENCY
local hfix = Instance.new("Frame", header); hfix.Size=UDim2.new(1,0,0,16)
hfix.Position=UDim2.new(0,0,1,-16); hfix.BackgroundColor3=BG2; hfix.BorderSizePixel=0
hfix.BackgroundTransparency=START_PANEL_TRANSPARENCY

local logo = Instance.new("TextLabel", header); logo.Size=UDim2.fromOffset(40,40)
logo.Position=UDim2.fromOffset(14,8); logo.BackgroundTransparency=1
logo.Font=Enum.Font.GothamBold; logo.Text="👁️"; logo.TextSize=28

local titleC = Instance.new("TextLabel", header); titleC.Size=UDim2.fromOffset(200,22)
titleC.Position=UDim2.fromOffset(58,11); titleC.BackgroundTransparency=1
titleC.Font=Enum.Font.GothamBold; titleC.TextSize=19; titleC.TextColor3=TXT
titleC.Text="SM1LE HUB"; titleC.TextXAlignment=Enum.TextXAlignment.Left
gradient(titleC, currentTheme.TitleGrad1, currentTheme.TitleGrad2, 0)

local byLabel = Instance.new("TextLabel", header); byLabel.Size=UDim2.fromOffset(100,16)
byLabel.Position=UDim2.fromOffset(58,29); byLabel.BackgroundTransparency=1
byLabel.Font=Enum.Font.GothamBlack; byLabel.TextSize=11; byLabel.TextColor3=TXT
byLabel.Text="by SM1LER"; byLabel.TextXAlignment=Enum.TextXAlignment.Left
gradient(byLabel, currentTheme.ByGrad1, currentTheme.ByGrad2, 0)

local statusL = Instance.new("TextLabel", header); statusL.Size=UDim2.fromOffset(280,14)
statusL.Position=UDim2.fromOffset(58,44); statusL.BackgroundTransparency=1
statusL.Font=Enum.Font.GothamMedium; statusL.TextSize=9; statusL.TextColor3=SUB
statusL.Text="👹 Lurking Giants"; statusL.TextXAlignment=Enum.TextXAlignment.Left

local function hbtn(txt,x)
    local b=Instance.new("TextButton", header); b.Size=UDim2.fromOffset(28,28)
    b.Position=UDim2.new(1,x,0,14); b.BackgroundColor3=BG3; b.Text=txt; b.TextColor3=TXT
    b.Font=Enum.Font.GothamBold; b.TextSize=15; b.AutoButtonColor=true; corner(b,8); return b
end
local closeB=hbtn("✕",-40); local minB=hbtn("—",-74)

local body = Instance.new("Frame", main); body.Size=UDim2.new(1,0,1,-56)
body.Position=UDim2.fromOffset(0,56); body.BackgroundTransparency=1
local side = Instance.new("Frame", body); side.Size=UDim2.new(0,140,1,0)
side.BackgroundColor3=BG2; side.BorderSizePixel=0; pad(side,12,12,10,10)
side.BackgroundTransparency=START_PANEL_TRANSPARENCY
local sl = Instance.new("UIListLayout",side); sl.Padding=UDim.new(0,6); sl.SortOrder=Enum.SortOrder.LayoutOrder
local content = Instance.new("Frame", body); content.Size=UDim2.new(1,-140,1,0)
content.Position=UDim2.fromOffset(140,0); content.BackgroundTransparency=1

local tabs={}; local pages={}; local activeTab=nil

local function selectTab(name)
    activeTab=name
    for n,m in pairs(tabs) do
        local on=(n==name)
        TweenService:Create(m.btn,TweenInfo.new(0.18),{BackgroundColor3=on and BG3 or BG2}):Play()
        m.accent.Visible=on; m.lbl.TextColor3=on and TXT or SUB
    end
    for n,p in pairs(pages) do p.Visible=(n==name); if p.Visible then p.CanvasPosition=Vector2.new(0,0) end end
end

local tabOrder=0
local function makeTab(name,icon)
    tabOrder+=1; local b=Instance.new("TextButton", side); b.Size=UDim2.new(1,0,0,40)
    b.BackgroundColor3=BG2; b.AutoButtonColor=false; b.Text=""; b.LayoutOrder=tabOrder; corner(b,10)
    b.BackgroundTransparency=START_PANEL_TRANSPARENCY
    local acc=Instance.new("Frame", b); acc.Size=UDim2.fromOffset(3,20); acc.Position=UDim2.fromOffset(0,10)
    acc.BackgroundColor3=ACCENT; acc.BorderSizePixel=0; acc.Visible=false; corner(acc,2)
    local lbl=Instance.new("TextLabel", b); lbl.Size=UDim2.new(1,-16,1,0); lbl.Position=UDim2.fromOffset(14,0)
    lbl.BackgroundTransparency=1; lbl.Font=Enum.Font.GothamMedium; lbl.TextSize=13.5; lbl.TextColor3=SUB
    lbl.Text=icon.."  "..name; lbl.TextXAlignment=Enum.TextXAlignment.Left
    tabs[name]={btn=b,accent=acc,lbl=lbl}
    b.MouseEnter:Connect(function() if activeTab~=name then b.BackgroundColor3=BG3 end end)
    b.MouseLeave:Connect(function() if activeTab~=name then b.BackgroundColor3=BG2 end end)
    b.MouseButton1Click:Connect(function() selectTab(name) end)
    local page=Instance.new("ScrollingFrame", content); page.Size=UDim2.new(1,0,1,0)
    page.BackgroundTransparency=1; page.BorderSizePixel=0; page.ScrollBarThickness=3
    page.ScrollBarImageColor3=ACCENT; page.CanvasSize=UDim2.new(0,0,0,0)
    page.AutomaticCanvasSize=Enum.AutomaticSize.Y; page.ScrollingDirection=Enum.ScrollingDirection.Y
    page.Visible=false; pad(page,14,50,16,14); page.BottomImage=""; page.TopImage=""
    page.ScrollBarImageTransparency=0
    local pl=Instance.new("UIListLayout",page); pl.Padding=UDim.new(0,9); pl.SortOrder=Enum.SortOrder.LayoutOrder
    pages[name]=page; return page
end

local rowOrder=0; local allRows={}

local function makeToggle(page,label,desc,key,callback)
    rowOrder+=1; local row=Instance.new("Frame", page); row.Size=UDim2.new(1,0,0,46)
    row.BackgroundColor3=BG2; row.BorderSizePixel=0; row.LayoutOrder=rowOrder; corner(row,10)
    row.BackgroundTransparency=START_PANEL_TRANSPARENCY
    local st=Instance.new("UIStroke",row); st.Color=currentTheme.Stroke; st.Thickness=1; st.Transparency=0.3
    local t=Instance.new("TextLabel", row); t.Size=UDim2.new(1,-70,0,18); t.Position=UDim2.fromOffset(12,6)
    t.BackgroundTransparency=1; t.Font=Enum.Font.GothamMedium; t.TextSize=13.5; t.TextColor3=TXT
    t.Text=label; t.TextXAlignment=Enum.TextXAlignment.Left
    local d=Instance.new("TextLabel", row); d.Size=UDim2.new(1,-70,0,13); d.Position=UDim2.fromOffset(12,25)
    d.BackgroundTransparency=1; d.Font=Enum.Font.Gotham; d.TextSize=10.5; d.TextColor3=SUB
    d.Text=desc; d.TextXAlignment=Enum.TextXAlignment.Left
    local sw=Instance.new("Frame", row); sw.Size=UDim2.fromOffset(44,24)
    sw.Position=UDim2.new(1,-56,0.5,-12); sw.BackgroundColor3=currentTheme.SwitchOff
    sw.BorderSizePixel=0; corner(sw,12)
    local knob=Instance.new("Frame", sw); knob.Size=UDim2.fromOffset(18,18)
    knob.Position=UDim2.fromOffset(3,3); knob.BackgroundColor3=TXT; knob.BorderSizePixel=0; corner(knob,9)
    local btn=Instance.new("TextButton", row); btn.Size=UDim2.fromScale(1,1)
    btn.BackgroundTransparency=1; btn.Text=""
    local function render()
        local on=S[key]
        TweenService:Create(sw,TweenInfo.new(0.18),{BackgroundColor3=on and ACCENT or currentTheme.SwitchOff}):Play()
        TweenService:Create(knob,TweenInfo.new(0.18,Enum.EasingStyle.Back),{Position=on and UDim2.fromOffset(23,3) or UDim2.fromOffset(3,3)}):Play()
        TweenService:Create(st,TweenInfo.new(0.18),{Color=on and ACCENT or currentTheme.Stroke}):Play()
    end
    btn.MouseButton1Click:Connect(function() S[key]=not S[key]; render(); if callback then callback(S[key]) end end)
    render()
    table.insert(allRows, {type="toggle", row=row, st=st, t=t, d=d, sw=sw, knob=knob, key=key})
end

local function makeSlider(page,label,desc,key,min,max,default,callback)
    S[key]=S[key] or default; rowOrder+=1; local row=Instance.new("Frame", page)
    row.Size=UDim2.new(1,0,0,70); row.BackgroundColor3=BG2; row.BorderSizePixel=0
    row.LayoutOrder=rowOrder; corner(row,10); row.BackgroundTransparency=START_PANEL_TRANSPARENCY
    local t=Instance.new("TextLabel", row); t.Size=UDim2.new(1,-70,0,18); t.Position=UDim2.fromOffset(12,8)
    t.BackgroundTransparency=1; t.Font=Enum.Font.GothamMedium; t.TextSize=13.5; t.TextColor3=TXT
    t.Text=label; t.TextXAlignment=Enum.TextXAlignment.Left
    local valLabel=Instance.new("TextLabel", row); valLabel.Size=UDim2.fromOffset(60,18)
    valLabel.Position=UDim2.new(1,-72,0,8); valLabel.BackgroundTransparency=1
    valLabel.Font=Enum.Font.GothamBold; valLabel.TextSize=13; valLabel.TextColor3=ACCENT
    valLabel.Text=tostring(S[key] or default); valLabel.TextXAlignment=Enum.TextXAlignment.Right
    local d=Instance.new("TextLabel", row); d.Size=UDim2.new(1,-24,0,13); d.Position=UDim2.fromOffset(12,28)
    d.BackgroundTransparency=1; d.Font=Enum.Font.Gotham; d.TextSize=10.5; d.TextColor3=SUB
    d.Text=desc; d.TextXAlignment=Enum.TextXAlignment.Left
    local bar=Instance.new("Frame", row); bar.Size=UDim2.new(1,-24,0,8); bar.Position=UDim2.fromOffset(12,48)
    bar.BackgroundColor3=BG3; bar.BorderSizePixel=0; corner(bar,4)
    local ratio=((S[key] or default)-min)/(max-min)
    local fill=Instance.new("Frame", bar); fill.Size=UDim2.fromScale(ratio,1)
    fill.BackgroundColor3=ACCENT; fill.BorderSizePixel=0; corner(fill,4)
    local dot=Instance.new("TextButton", bar); dot.Size=UDim2.fromOffset(16,16)
    dot.Position=UDim2.new(ratio,-8,0.5,-8); dot.BackgroundColor3=TXT; dot.Text=""; corner(dot,8); dot.ZIndex=2
    local hitArea=Instance.new("TextButton", bar); hitArea.Size=UDim2.new(1,0,1,0)
    hitArea.BackgroundTransparency=1; hitArea.Text=""
    local dragging=false; local inputConnection
    local function updateSlider(input)
        local relX=math.clamp((input.Position.X-bar.AbsolutePosition.X)/bar.AbsoluteSize.X,0,1)
        local val=min+math.floor((max-min)*relX+0.5); S[key]=val
        fill.Size=UDim2.fromScale(relX,1); dot.Position=UDim2.new(relX,-8,0.5,-8)
        valLabel.Text=tostring(val); if callback then callback(val) end
    end
    local function startDrag(input)
        dragging=true; if inputConnection then inputConnection:Disconnect() end
        inputConnection=UserInputService.InputChanged:Connect(function(i2)
            if dragging and (i2.UserInputType==Enum.UserInputType.MouseMovement or i2.UserInputType==Enum.UserInputType.Touch) then updateSlider(i2) end
        end); updateSlider(input)
    end
    local function stopDrag() dragging=false; if inputConnection then inputConnection:Disconnect(); inputConnection=nil end end
    hitArea.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then startDrag(i) end end)
    hitArea.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then stopDrag() end end)
    dot.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then startDrag(i) end end)
    dot.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then stopDrag() end end)
    UserInputService.InputEnded:Connect(function(i) if (i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.TouchEnded) and dragging then stopDrag() end end)
    table.insert(allRows, {type="slider", row=row, t=t, valLabel=valLabel, d=d, bar=bar, fill=fill, dot=dot, key=key})
end

local function makeTextbox(page,label,desc,key,default)
    rowOrder+=1; local row=Instance.new("Frame", page); row.Size=UDim2.new(1,0,0,60)
    row.BackgroundColor3=BG2; row.BorderSizePixel=0; row.LayoutOrder=rowOrder; corner(row,10)
    row.BackgroundTransparency=START_PANEL_TRANSPARENCY
    local t=Instance.new("TextLabel", row); t.Size=UDim2.new(1,-24,0,18); t.Position=UDim2.fromOffset(12,6)
    t.BackgroundTransparency=1; t.Font=Enum.Font.GothamMedium; t.TextSize=13.5; t.TextColor3=TXT
    t.Text=label; t.TextXAlignment=Enum.TextXAlignment.Left
    local d=Instance.new("TextLabel", row); d.Size=UDim2.new(1,-24,0,13); d.Position=UDim2.fromOffset(12,24)
    d.BackgroundTransparency=1; d.Font=Enum.Font.Gotham; d.TextSize=10.5; d.TextColor3=SUB
    d.Text=desc; d.TextXAlignment=Enum.TextXAlignment.Left
    local box=Instance.new("TextBox", row); box.Size=UDim2.new(1,-24,0,24); box.Position=UDim2.fromOffset(12,38)
    box.BackgroundColor3=BG3; box.TextColor3=TXT; box.Font=Enum.Font.GothamBold; box.TextSize=12
    box.Text=S[key] or default; box.PlaceholderText="Enter text..."; box.PlaceholderColor3=SUB; corner(box,8)
    box.FocusLost:Connect(function(ep) S[key]=box.Text; if ep then box.Text=S[key] end end)
    table.insert(allRows, {type="textbox", row=row, t=t, d=d, box=box, key=key})
end

local function sectionInfo(page,text)
    rowOrder+=1; local l=Instance.new("TextLabel", page); l.Size=UDim2.new(1,0,0,0)
    l.AutomaticSize=Enum.AutomaticSize.Y; l.BackgroundTransparency=1; l.Font=Enum.Font.Gotham
    l.TextSize=11.5; l.TextColor3=SUB; l.TextWrapped=true; l.RichText=true
    l.TextXAlignment=Enum.TextXAlignment.Left; l.Text=text; l.LayoutOrder=rowOrder
end

local function applyTransparency(transp)
    applyPanelTransparency(transp); header.BackgroundTransparency=transp; hfix.BackgroundTransparency=transp
    side.BackgroundTransparency=transp
    for _, data in ipairs(allRows) do
        if data.type=="toggle" or data.type=="slider" or data.type=="textbox" then data.row.BackgroundTransparency=transp end
    end
    for _, tabData in pairs(tabs) do tabData.btn.BackgroundTransparency=transp end
end

local function applyTheme(themeName)
    S.theme=themeName; currentTheme=Themes[themeName]
    ACCENT=currentTheme.ACCENT; ACCENT2=currentTheme.ACCENT2
    BG=currentTheme.BG; BG2=currentTheme.BG2; BG3=currentTheme.BG3
    TXT=currentTheme.TXT; SUB=currentTheme.SUB
    local transp=S.bgTransparency/100
    main.BackgroundColor3=BG; main.BackgroundTransparency=1; mst.Color=currentTheme.Stroke
    header.BackgroundColor3=BG2; header.BackgroundTransparency=transp
    hfix.BackgroundColor3=BG2; hfix.BackgroundTransparency=transp
    side.BackgroundColor3=BG2; side.BackgroundTransparency=transp
    if titleC:FindFirstChildOfClass("UIGradient") then titleC:FindFirstChildOfClass("UIGradient"):Destroy() end
    gradient(titleC, currentTheme.TitleGrad1, currentTheme.TitleGrad2, 0); titleC.TextColor3=TXT
    if byLabel:FindFirstChildOfClass("UIGradient") then byLabel:FindFirstChildOfClass("UIGradient"):Destroy() end
    gradient(byLabel, currentTheme.ByGrad1, currentTheme.ByGrad2, 0); byLabel.TextColor3=TXT
    statusL.TextColor3=SUB; closeB.BackgroundColor3=BG3; closeB.TextColor3=TXT; minB.BackgroundColor3=BG3; minB.TextColor3=TXT
    for name, tabData in pairs(tabs) do
        local on=(activeTab==name)
        tabData.btn.BackgroundColor3=on and BG3 or BG2; tabData.btn.BackgroundTransparency=transp
        tabData.accent.BackgroundColor3=ACCENT; tabData.lbl.TextColor3=on and TXT or SUB
    end
    for _, page in pairs(pages) do page.ScrollBarImageColor3=ACCENT end
    for _, data in ipairs(allRows) do
        if data.type=="toggle" then
            data.row.BackgroundColor3=BG2; data.row.BackgroundTransparency=transp
            data.st.Color=currentTheme.Stroke; data.t.TextColor3=TXT; data.d.TextColor3=SUB
            data.sw.BackgroundColor3=S[data.key] and ACCENT or currentTheme.SwitchOff; data.knob.BackgroundColor3=TXT
        elseif data.type=="slider" then
            data.row.BackgroundColor3=BG2; data.row.BackgroundTransparency=transp
            data.t.TextColor3=TXT; data.valLabel.TextColor3=ACCENT; data.d.TextColor3=SUB
            data.bar.BackgroundColor3=BG3; data.fill.BackgroundColor3=ACCENT; data.dot.BackgroundColor3=TXT
        elseif data.type=="textbox" then
            data.row.BackgroundColor3=BG2; data.row.BackgroundTransparency=transp
            data.t.TextColor3=TXT; data.d.TextColor3=SUB
            data.box.BackgroundColor3=BG3; data.box.TextColor3=TXT; data.box.PlaceholderColor3=SUB
        end
    end
    applyPanelTransparency(transp)
end

applyTransparency(START_PANEL_TRANSPARENCY)
applyPanelTransparency(START_PANEL_TRANSPARENCY)

-- ==================== СТРАНИЦЫ ====================

-- HOME
local pHome = makeTab("Home","🏠")
sectionInfo(pHome,"<font size='14'><b>SM1LE HUB</b></font>")
sectionInfo(pHome,"Game: Lurking Giants")
sectionInfo(pHome,"Place: 6328880674")

local profileRow = Instance.new("Frame", pHome); profileRow.LayoutOrder=5; profileRow.Size=UDim2.new(1,0,0,80)
profileRow.BackgroundColor3=BG2; profileRow.BackgroundTransparency=START_PANEL_TRANSPARENCY
profileRow.BorderSizePixel=0; corner(profileRow,10)
local avatarImage = Instance.new("ImageLabel", profileRow)
avatarImage.Size=UDim2.fromOffset(60,60); avatarImage.Position=UDim2.fromOffset(12,10)
avatarImage.BackgroundColor3=BG3; avatarImage.BackgroundTransparency=START_PANEL_TRANSPARENCY
avatarImage.BorderSizePixel=0; corner(avatarImage,8)
avatarImage.Image = "rbxthumb://type=AvatarHeadShot&id="..lp.UserId.."&w=420&h=420"

local usernameLabel = Instance.new("TextLabel", profileRow); usernameLabel.Size=UDim2.new(1,-86,0,22)
usernameLabel.Position=UDim2.fromOffset(80,12); usernameLabel.BackgroundTransparency=1
usernameLabel.Font=Enum.Font.GothamBold; usernameLabel.TextSize=15; usernameLabel.TextColor3=TXT
usernameLabel.Text=lp.Name; usernameLabel.TextXAlignment=Enum.TextXAlignment.Left

local displayLabel = Instance.new("TextLabel", profileRow); displayLabel.Size=UDim2.new(1,-86,0,18)
displayLabel.Position=UDim2.fromOffset(80,34); displayLabel.BackgroundTransparency=1
displayLabel.Font=Enum.Font.Gotham; displayLabel.TextSize=11; displayLabel.TextColor3=SUB
displayLabel.Text="@"..(lp.DisplayName or lp.Name); displayLabel.TextXAlignment=Enum.TextXAlignment.Left

local idLabel = Instance.new("TextLabel", profileRow); idLabel.Size=UDim2.new(1,-86,0,16)
idLabel.Position=UDim2.fromOffset(80,52); idLabel.BackgroundTransparency=1
idLabel.Font=Enum.Font.Code; idLabel.TextSize=9; idLabel.TextColor3=SUB
idLabel.Text="ID: "..lp.UserId; idLabel.TextXAlignment=Enum.TextXAlignment.Left

local executor = "Unknown"
pcall(function() executor = identifyexecutor() end)
if executor=="Unknown" then pcall(function() executor = getexecutorname() end) end
if executor=="Unknown" then pcall(function() if _G.KRNL_LOADED then executor="Krnl" end end) end
if executor=="Unknown" then pcall(function() if Synapse then executor="Synapse X" end end) end
sectionInfo(pHome," ")
sectionInfo(pHome,"Executor: <font color='#"..string.format("%02X%02X%02X",ACCENT.R*255,ACCENT.G*255,ACCENT.B*255).."'>"..executor.."</font>")
sectionInfo(pHome,"Author: SM1LER")

-- PLAYER
local pPlayer = makeTab("Player","🏃")
makeToggle(pPlayer,"Speed Boost","Move faster than everyone","speed")
makeToggle(pPlayer,"Jump Power","Super high jumps","jumppower")
makeToggle(pPlayer,"Noclip","Walk through walls & obstacles","noclip")
makeToggle(pPlayer,"Fly","Soar through the air","fly")
makeToggle(pPlayer,"Anti Fling","No knockback from giants","antifling")
makeToggle(pPlayer,"Anti AFK","Never get kicked for idling","antiafk")
makeToggle(pPlayer,"Third Person","Third person view","thirdperson")
makeToggle(pPlayer,"Max Zoom","Remove zoom limits","maxzoom")
makeSlider(pPlayer,"Speed Value","Set walk speed","speedVal",16,200,50)
makeSlider(pPlayer,"Jump Height","Set custom jump power","jumpVal",50,300,100)

-- FARM
local pFarm = makeTab("Farm","🤖")
makeToggle(pFarm,"Auto Farm","Hide underground / chase survivors","autofarm")
makeToggle(pFarm,"Auto Win","Teleport all to you and kill","autowin")

-- VISUALS
local pVisuals = makeTab("Visuals","👁️")
sectionInfo(pVisuals,"<font color='#"..string.format("%02X%02X%02X",ACCENT.R*255,ACCENT.G*255,ACCENT.B*255).."'><b>ESP SETTINGS</b></font>")
makeToggle(pVisuals,"ESP Name","Show player names","espName")
makeToggle(pVisuals,"ESP Role","Show role (Giant/Survivor/Lobby)","espRole")
makeToggle(pVisuals,"ESP HP Bar","Health bar above targets","espHP")
makeToggle(pVisuals,"ESP Distance","Show distance in meters","espDistance")
sectionInfo(pVisuals,"<font color='#"..string.format("%02X%02X%02X",ACCENT.R*255,ACCENT.G*255,ACCENT.B*255).."'><b>ESP TARGETS</b></font>")
makeToggle(pVisuals,"ESP Players","Highlight all players","espPlayers")
makeToggle(pVisuals,"ESP Giants","Highlight monsters (red)","espGiants")
makeToggle(pVisuals,"Chams","See players through walls","chams")
makeToggle(pVisuals,"Rainbow ESP","Rainbow colored highlights","rainbowesp")
sectionInfo(pVisuals,"<font color='#"..string.format("%02X%02X%02X",ACCENT.R*255,ACCENT.G*255,ACCENT.B*255).."'><b>HUD</b></font>")
makeToggle(pVisuals,"⚠️ Risk Meter","Danger level (0-100%, up to 500m)","riskmeter")
makeToggle(pVisuals,"📍 Giant Arrow","Arrow pointing to nearest giant","giantarrow")
sectionInfo(pVisuals,"<font color='#"..string.format("%02X%02X%02X",ACCENT.R*255,ACCENT.G*255,ACCENT.B*255).."'><b>WORLD</b></font>")
makeToggle(pVisuals,"Fullbright","Full map brightness","fullbright")
makeToggle(pVisuals,"No Fog","Remove all fog","nofog")
makeToggle(pVisuals,"Hitbox Viewer","See giant attack hitboxes (red)","hitboxviewer")
sectionInfo(pVisuals,"<font color='#"..string.format("%02X%02X%02X",ACCENT.R*255,ACCENT.G*255,ACCENT.B*255).."'><b>CAMERA</b></font>")
makeToggle(pVisuals,"FOV Changer","Change field of view","fovchanger")
makeToggle(pVisuals,"No Screen Shake","Disable camera shake","noscreenshake")
makeSlider(pVisuals,"FOV Value","Set field of view","fovVal",30,150,70)

-- SPECTATE
local pSpectate = makeTab("Spectate","👁️‍🗨️")
makeToggle(pSpectate,"Spectate Giant","Watch nearest giant","spectate", function(on)
    if not on then
        if lp.Character and lp.Character:FindFirstChild("Humanoid") then
            workspace.CurrentCamera.CameraSubject = lp.Character.Humanoid
        end
    end
end)

-- TELEPORTS
local pTeleports = makeTab("Teleports","📍")

local tpGiantBtn = Instance.new("TextButton", pTeleports)
tpGiantBtn.LayoutOrder=1; tpGiantBtn.Size=UDim2.new(1,0,0,44)
tpGiantBtn.BackgroundColor3=BG3; tpGiantBtn.BackgroundTransparency=START_PANEL_TRANSPARENCY
tpGiantBtn.TextColor3=TXT; tpGiantBtn.Text="👹 TP to Giant"
tpGiantBtn.Font=Enum.Font.GothamBold; tpGiantBtn.TextSize=14; corner(tpGiantBtn,10)
tpGiantBtn.MouseButton1Click:Connect(function()
    local target = nil; local minDist = math.huge
    local myRoot = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
    local myPos = myRoot and myRoot.Position or Vector3.zero
    for _,p in ipairs(Players:GetPlayers()) do
        if p ~= lp and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local role = (p.Team and p.Team.Name) or p:GetAttribute("Team") or p:GetAttribute("Role") or ""
            if role:lower():find("giant") then
                local dist = (p.Character.HumanoidRootPart.Position - myPos).Magnitude
                if dist < minDist then minDist = dist; target = p end
            end
        end
    end
    if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
        local myChar = lp.Character
        if myChar and myChar:FindFirstChild("HumanoidRootPart") then
            myChar.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame + Vector3.new(0,2,0)
        end
    end
end)

local tpSurvBtn = Instance.new("TextButton", pTeleports)
tpSurvBtn.LayoutOrder=2; tpSurvBtn.Size=UDim2.new(1,0,0,44)
tpSurvBtn.BackgroundColor3=BG3; tpSurvBtn.BackgroundTransparency=START_PANEL_TRANSPARENCY
tpSurvBtn.TextColor3=TXT; tpSurvBtn.Text="🏃 TP to Survivor"
tpSurvBtn.Font=Enum.Font.GothamBold; tpSurvBtn.TextSize=14; corner(tpSurvBtn,10)
tpSurvBtn.MouseButton1Click:Connect(function()
    local target = nil; local minDist = math.huge
    local myRoot = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
    local myPos = myRoot and myRoot.Position or Vector3.zero
    for _,p in ipairs(Players:GetPlayers()) do
        if p ~= lp and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local role = (p.Team and p.Team.Name) or p:GetAttribute("Team") or p:GetAttribute("Role") or ""
            if role:lower():find("round") then
                local dist = (p.Character.HumanoidRootPart.Position - myPos).Magnitude
                if dist < minDist then minDist = dist; target = p end
            end
        end
    end
    if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
        local myChar = lp.Character
        if myChar and myChar:FindFirstChild("HumanoidRootPart") then
            myChar.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame + Vector3.new(0,2,0)
        end
    end
end)

-- FUN
local pFun = makeTab("Fun","🎵")
makeToggle(pFun,"Music Player","Play music in background","musicplayer")
makeTextbox(pFun,"Music ID","Roblox audio asset ID","musicID","rbxassetid://1842801835")
makeToggle(pFun,"Snow Effect","❄️ Falling snow inside the window","snowEffect",function(on) if on then startSnow() else stopSnow() end end)
makeToggle(pFun,"Notifications","Alert popups for events","notifications")

-- SETTINGS
local pSettings = makeTab("Settings","⚙️")
sectionInfo(pSettings,"<font color='#"..string.format("%02X%02X%02X",ACCENT.R*255,ACCENT.G*255,ACCENT.B*255).."'><b>THEMES</b></font>")
for themeName,_ in pairs(Themes) do
    makeToggle(pSettings, themeName, "Apply "..themeName.." theme", "theme_"..themeName:lower(), function(on)
        if on then
            applyTheme(themeName)
            for otherName,_ in pairs(Themes) do
                if otherName ~= themeName then S["theme_"..otherName:lower()] = false end
            end
        end
    end)
end

sectionInfo(pSettings,"<font color='#"..string.format("%02X%02X%02X",ACCENT.R*255,ACCENT.G*255,ACCENT.B*255).."'><b>BACKGROUND</b></font>")
local bgRow = Instance.new("Frame", pSettings); bgRow.LayoutOrder=900; bgRow.Size=UDim2.new(1,0,0,68)
bgRow.BackgroundColor3=BG2; bgRow.BackgroundTransparency=START_PANEL_TRANSPARENCY
bgRow.BorderSizePixel=0; corner(bgRow,10)
local bgLabel = Instance.new("TextLabel", bgRow); bgLabel.Size=UDim2.new(1,-24,0,16); bgLabel.Position=UDim2.fromOffset(12,6)
bgLabel.BackgroundTransparency=1; bgLabel.Font=Enum.Font.GothamMedium; bgLabel.TextSize=11; bgLabel.TextColor3=TXT
bgLabel.Text="Background Image ID/URL"
local bgBox = Instance.new("TextBox", bgRow); bgBox.Size=UDim2.new(1,-24,0,24); bgBox.Position=UDim2.fromOffset(12,26)
bgBox.BackgroundColor3=BG3; bgBox.BackgroundTransparency=START_PANEL_TRANSPARENCY; bgBox.TextColor3=TXT
bgBox.PlaceholderColor3=SUB; bgBox.Font=Enum.Font.Code; bgBox.TextSize=10
bgBox.ClearTextOnFocus=false; bgBox.Text=START_BACKGROUND; bgBox.PlaceholderText="Asset ID or Roblox link"; corner(bgBox,8)
bgBox.FocusLost:Connect(function() bg.Image = toImageContent(bgBox.Text) end)

local imgTranspRow = Instance.new("Frame", pSettings); imgTranspRow.LayoutOrder=901
imgTranspRow.Size=UDim2.new(1,0,0,70); imgTranspRow.BackgroundColor3=BG2
imgTranspRow.BackgroundTransparency=START_PANEL_TRANSPARENCY; imgTranspRow.BorderSizePixel=0; corner(imgTranspRow,10)
local imgTLabel = Instance.new("TextLabel", imgTranspRow); imgTLabel.Size=UDim2.new(1,-82,0,18); imgTLabel.Position=UDim2.fromOffset(12,8)
imgTLabel.BackgroundTransparency=1; imgTLabel.Font=Enum.Font.GothamMedium; imgTLabel.TextSize=12; imgTLabel.TextColor3=TXT
imgTLabel.Text="Image Transparency"; imgTLabel.TextXAlignment=Enum.TextXAlignment.Left
local imgPct = Instance.new("TextLabel", imgTranspRow); imgPct.Size=UDim2.fromOffset(58,18); imgPct.Position=UDim2.new(1,-70,0,8)
imgPct.BackgroundTransparency=1; imgPct.Font=Enum.Font.GothamBold; imgPct.TextSize=12; imgPct.TextColor3=ACCENT
imgPct.TextXAlignment=Enum.TextXAlignment.Right
local imgBar = Instance.new("Frame", imgTranspRow); imgBar.Size=UDim2.new(1,-24,0,8); imgBar.Position=UDim2.fromOffset(12,44)
imgBar.BackgroundColor3=BG3; imgBar.BorderSizePixel=0; corner(imgBar,4)
local imgFill = Instance.new("Frame", imgBar); imgFill.BackgroundColor3=ACCENT; imgFill.BorderSizePixel=0; corner(imgFill,4)
local imgKnob = Instance.new("TextButton", imgBar); imgKnob.Size=UDim2.fromOffset(16,16); imgKnob.BackgroundColor3=TXT; imgKnob.Text=""; corner(imgKnob,8)
local imgHit = Instance.new("TextButton", imgBar); imgHit.Size=UDim2.fromScale(1,1); imgHit.BackgroundTransparency=1; imgHit.Text=""
local imgDragging=false
local function setImgPercent(p)
    p=math.clamp(math.floor(p+0.5),0,90); local r=p/90
    imgFill.Size=UDim2.fromScale(r,1); imgKnob.Position=UDim2.new(r,-8,0.5,-8)
    imgPct.Text=tostring(p).."%"; bg.ImageTransparency=p/100
end
local function updateImg(input)
    local r=math.clamp((input.Position.X-imgBar.AbsolutePosition.X)/imgBar.AbsoluteSize.X,0,1); setImgPercent(r*90)
end
imgHit.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then imgDragging=true; updateImg(i) end end)
imgKnob.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then imgDragging=true; updateImg(i) end end)
UserInputService.InputChanged:Connect(function(i) if imgDragging and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then updateImg(i) end end)
UserInputService.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then imgDragging=false end end)
setImgPercent(math.floor(START_IMAGE_TRANSPARENCY*100))

makeSlider(pSettings,"Panel Transparency","0 = solid, 90 = transparent","bgTransparency",0,90,math.floor(START_PANEL_TRANSPARENCY*100), function(val) applyTransparency(val/100) end)

sectionInfo(pSettings,"<font color='#"..string.format("%02X%02X%02X",ACCENT.R*255,ACCENT.G*255,ACCENT.B*255).."'><b>CONFIG</b></font>")
local saveBtn = Instance.new("TextButton", pSettings); saveBtn.LayoutOrder=999; saveBtn.Size=UDim2.new(1,0,0,40)
saveBtn.BackgroundColor3=BG3; saveBtn.BackgroundTransparency=START_PANEL_TRANSPARENCY
saveBtn.TextColor3=TXT; saveBtn.Text="💾 Save Config"; saveBtn.Font=Enum.Font.GothamBold; saveBtn.TextSize=13; corner(saveBtn,10)
saveBtn.MouseButton1Click:Connect(function()
    local c={}; for k,v in pairs(S) do c[k]=v end; writefile("Sm1leHub_LG.json", HttpService:JSONEncode(c))
end)
local loadBtn = Instance.new("TextButton", pSettings); loadBtn.LayoutOrder=1000; loadBtn.Size=UDim2.new(1,0,0,40)
loadBtn.BackgroundColor3=BG3; loadBtn.BackgroundTransparency=START_PANEL_TRANSPARENCY
loadBtn.TextColor3=TXT; loadBtn.Text="📂 Load Config"; loadBtn.Font=Enum.Font.GothamBold; loadBtn.TextSize=13; corner(loadBtn,10)
loadBtn.MouseButton1Click:Connect(function()
    pcall(function() local c=HttpService:JSONDecode(readfile("Sm1leHub_LG.json")); for k,v in pairs(c) do S[k]=v end; applyTheme(S.theme) end)
end)

S["theme_cosmic"] = true

local stats = Instance.new("TextLabel", pVisuals)
stats.Size=UDim2.new(1,0,0,0); stats.AutomaticSize=Enum.AutomaticSize.Y; stats.BackgroundTransparency=1
stats.Font=Enum.Font.Code; stats.TextSize=12; stats.TextColor3=ACCENT
stats.TextXAlignment=Enum.TextXAlignment.Left; stats.RichText=true; stats.LayoutOrder=99
sectionInfo(pVisuals,"<font color='#B48C8C'>RightCtrl hides the menu  •  drag the header to move</font>")
selectTab("Home")

do local drag,sp,si; header.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then drag=true; sp=main.Position; si=i.Position; i.Changed:Connect(function() if i.UserInputState==Enum.UserInputState.End then drag=false end end) end end)
UserInputService.InputChanged:Connect(function(i) if drag and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then local dd=i.Position-si; main.Position=UDim2.new(sp.X.Scale,sp.X.Offset+dd.X,sp.Y.Scale,sp.Y.Offset+dd.Y) end end) end

local mini=false; minB.MouseButton1Click:Connect(function() mini=not mini; TweenService:Create(main,TweenInfo.new(0.2),{Size=mini and UDim2.fromOffset(520,56) or UDim2.fromOffset(520,440)}):Play(); body.Visible=not mini end)
UserInputService.InputBegan:Connect(function(i,gpe) if gpe then return end; if i.KeyCode==Enum.KeyCode.RightControl then main.Visible=not main.Visible end end)

-- ==================== ИГРОВЫЕ ФУНКЦИИ ====================
local alive = true; local savedOriginalPos = nil

local defaultsSaved = false
local function saveDefaults()
    if defaultsSaved then return end
    local hum = lp.Character and lp.Character:FindFirstChild("Humanoid")
    if hum then
        S.defaultWalkSpeed = hum.WalkSpeed
        S.defaultJumpPower = hum.JumpPower
        defaultsSaved = true
    end
end

local function restoreLighting()
    pcall(function()
        Lighting.Brightness = originalLighting.Brightness
        Lighting.ClockTime = originalLighting.ClockTime
        Lighting.FogEnd = originalLighting.FogEnd
        Lighting.FogStart = originalLighting.FogStart
        Lighting.GlobalShadows = originalLighting.GlobalShadows
        Lighting.OutdoorAmbient = originalLighting.OutdoorAmbient
        Lighting.Ambient = originalLighting.Ambient
        Lighting.Outlines = originalLighting.Outlines
        if originalLighting.Atmosphere then
            if not Lighting:FindFirstChild("Atmosphere") then Instance.new("Atmosphere", Lighting) end
            local at = Lighting.Atmosphere
            at.Density = originalLighting.Atmosphere.Density
            at.Offset = originalLighting.Atmosphere.Offset
            at.Haze = originalLighting.Atmosphere.Haze
            at.Glare = originalLighting.Atmosphere.Glare
        else
            if Lighting:FindFirstChild("Atmosphere") then Lighting.Atmosphere:Destroy() end
        end
        if originalLighting.Bloom then
            if not Lighting:FindFirstChild("Bloom") then Instance.new("Bloom", Lighting) end
            Lighting.Bloom.Intensity = originalLighting.Bloom.Intensity
        else
            if Lighting:FindFirstChild("Bloom") then Lighting.Bloom:Destroy() end
        end
        if originalLighting.ColorCorrection then
            if not Lighting:FindFirstChild("ColorCorrection") then Instance.new("ColorCorrection", Lighting) end
            Lighting.ColorCorrection.Brightness = originalLighting.ColorCorrection.Brightness
            Lighting.ColorCorrection.Contrast = originalLighting.ColorCorrection.Contrast
        else
            if Lighting:FindFirstChild("ColorCorrection") then Lighting.ColorCorrection:Destroy() end
        end
    end)
end

local function getPlayerRole(player)
    local team = player.Team; if team then return team.Name end
    local attr = player:GetAttribute("Team") or player:GetAttribute("team") or player:GetAttribute("Role")
    return attr or "Unknown"
end
local function isGiant(player) return getPlayerRole(player):lower():find("giant") ~= nil end
local function isSurvivor(player) return getPlayerRole(player):lower():find("round") ~= nil end
local function isLobby(player) return getPlayerRole(player):lower():find("lobby") ~= nil end

local function getNearestGiant()
    local nearest, minDist = nil, math.huge
    local root = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
    local myPos = root and root.Position or Vector3.zero
    for _,p in ipairs(Players:GetPlayers()) do
        if p ~= lp and isGiant(p) and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local dist = (p.Character.HumanoidRootPart.Position - myPos).Magnitude
            if dist < minDist then minDist = dist; nearest = p end
        end
    end
    return nearest, minDist
end

local function getNearestSurvivor()
    local nearest, minDist = nil, math.huge
    local root = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
    local myPos = root and root.Position or Vector3.zero
    for _,p in ipairs(Players:GetPlayers()) do
        if p ~= lp and isSurvivor(p) and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local dist = (p.Character.HumanoidRootPart.Position - myPos).Magnitude
            if dist < minDist then minDist = dist; nearest = p end
        end
    end
    return nearest, minDist
end

local espHighlights, espBillboards = {}, {}
local function clearESP()
    for _, v in pairs(espHighlights) do pcall(function() v:Destroy() end) end; table.clear(espHighlights)
    for _, v in pairs(espBillboards) do pcall(function() v:Destroy() end) end; table.clear(espBillboards)
end

local hitboxParts = {}
local function updateHitboxViewer()
    for _, p in ipairs(hitboxParts) do pcall(function() p:Destroy() end) end; table.clear(hitboxParts)
    if not S.hitboxviewer then return end
    for _, player in ipairs(Players:GetPlayers()) do
        if isGiant(player) and player.Character then
            for _, obj in ipairs(player.Character:GetDescendants()) do
                if obj:IsA("BasePart") and obj.CanCollide and obj.Transparency < 1 then
                    local clone = Instance.new("Part", workspace)
                    clone.Size = obj.Size; clone.CFrame = obj.CFrame; clone.Transparency = 0.6
                    clone.Color = Color3.fromRGB(255,0,0); clone.Material = Enum.Material.ForceField
                    clone.CanCollide = false; clone.Anchored = true; table.insert(hitboxParts, clone)
                end
            end
        end
    end
end

local riskMeterGUI, riskMeterBar, riskMeterLabel, riskFrame
local function createRiskMeter()
    if riskMeterGUI then riskMeterGUI:Destroy() end
    riskMeterGUI = Instance.new("ScreenGui"); riskMeterGUI.Name = "RiskMeter"; riskMeterGUI.ResetOnSpawn = false
    riskMeterGUI.Parent = (gethui and gethui()) or game:GetService("CoreGui")
    riskFrame = Instance.new("Frame", riskMeterGUI); riskFrame.Size = UDim2.fromOffset(80,80)
    riskFrame.Position = UDim2.fromScale(0.05,0.85); riskFrame.BackgroundColor3 = Color3.fromRGB(0,0,0)
    riskFrame.BackgroundTransparency = 0.5; riskFrame.BorderSizePixel = 0; corner(riskFrame,40)
    riskMeterBar = Instance.new("Frame", riskFrame); riskMeterBar.Size = UDim2.new(0,70,0,70)
    riskMeterBar.Position = UDim2.fromOffset(5,5); riskMeterBar.BackgroundColor3 = Color3.fromRGB(0,255,0)
    riskMeterBar.BorderSizePixel = 0; corner(riskMeterBar,35)
    riskMeterLabel = Instance.new("TextLabel", riskFrame); riskMeterLabel.Size = UDim2.new(1,0,1,0)
    riskMeterLabel.BackgroundTransparency = 1; riskMeterLabel.Text = "0%"; riskMeterLabel.Font = Enum.Font.GothamBlack
    riskMeterLabel.TextSize = 20; riskMeterLabel.TextColor3 = Color3.fromRGB(255,255,255)
    riskMeterLabel.TextStrokeTransparency = 0; Instance.new("UIStroke",riskMeterLabel).Color = Color3.fromRGB(0,0,0)
    riskMeterLabel:FindFirstChildOfClass("UIStroke").Thickness = 3
end
createRiskMeter(); riskMeterGUI.Enabled = false

local function updateRiskMeter(risk)
    if not riskMeterGUI then return end; riskMeterGUI.Enabled = S.riskmeter
    local color = risk < 25 and Color3.fromRGB(0,255,0) or risk < 50 and Color3.fromRGB(255,255,0) or risk < 75 and Color3.fromRGB(255,150,0) or Color3.fromRGB(255,0,0)
    riskMeterBar.BackgroundColor3 = color; riskMeterLabel.Text = math.floor(risk).."%"
    riskFrame.BackgroundTransparency = risk > 75 and (math.sin(tick()*5)*0.1+0.2) or 0.5
end

-- GIANT ARROW
local arrowGui, arrowFrame, arrowLabel
local function createArrow()
    if arrowGui then arrowGui:Destroy() end
    arrowGui = Instance.new("ScreenGui"); arrowGui.Name = "GiantArrow"; arrowGui.ResetOnSpawn = false
    arrowGui.Parent = (gethui and gethui()) or game:GetService("CoreGui")
    arrowFrame = Instance.new("Frame", arrowGui)
    arrowFrame.Size = UDim2.fromOffset(60, 60)
    arrowFrame.Position = UDim2.fromScale(0.5, 0.15)
    arrowFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    arrowFrame.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    arrowFrame.BackgroundTransparency = 0.4
    arrowFrame.BorderSizePixel = 0
    corner(arrowFrame, 30)
    local stroke = Instance.new("UIStroke", arrowFrame)
    stroke.Color = Color3.fromRGB(255, 50, 50)
    stroke.Thickness = 2
    arrowLabel = Instance.new("TextLabel", arrowFrame)
    arrowLabel.Size = UDim2.new(1, 0, 1, 0)
    arrowLabel.BackgroundTransparency = 1
    arrowLabel.Text = "▼"
    arrowLabel.Font = Enum.Font.GothamBold
    arrowLabel.TextSize = 30
    arrowLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    arrowLabel.TextStrokeTransparency = 0
    Instance.new("UIStroke", arrowLabel).Color = Color3.fromRGB(0, 0, 0)
end
createArrow()
arrowGui.Enabled = false

local function updateArrow(giantPos, myPos)
    if not arrowGui then return end
    arrowGui.Enabled = S.giantarrow
    if not S.giantarrow then return end
    
    local direction = (giantPos - myPos)
    local dist = direction.Magnitude
    
    if dist > 0 then
        local lookVector = workspace.CurrentCamera.CFrame.LookVector
        local flatLook = Vector3.new(lookVector.X, 0, lookVector.Z).Unit
        local flatDir = Vector3.new(direction.X, 0, direction.Z).Unit
        
        if flatLook.Magnitude > 0 and flatDir.Magnitude > 0 then
            local dot = flatLook:Dot(flatDir)
            local cross = flatLook:Cross(flatDir)
            local angle = math.atan2(cross.Y, dot)
            
            local radius = 150
            local arrowX = 0.5 + math.sin(angle) * 0.35
            local arrowY = 0.15 + math.cos(angle) * 0.1
            
            arrowFrame.Position = UDim2.fromScale(
                math.clamp(arrowX, 0.1, 0.9),
                math.clamp(arrowY, 0.05, 0.3)
            )
            arrowFrame.Rotation = math.deg(angle) + 180
            
            arrowLabel.Text = "▼"
            arrowFrame.BackgroundColor3 = dist < 50 and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(255, 150, 0)
            arrowFrame.Size = UDim2.fromOffset(dist < 50 and 80 or 60, dist < 50 and 80 or 60)
        end
    end
end

-- УВЕДОМЛЕНИЯ
local function sendNotification(title, text, duration)
    if S.notifications then
        pcall(function()
            StarterGui:SetCore("SendNotification", {
                Title = title,
                Text = text,
                Duration = duration or 5
            })
        end)
    end
end

local lastGiantDistance = nil
local function checkGiantAlert(dist)
    if not S.notifications then return end
    if dist and dist < 50 and (not lastGiantDistance or lastGiantDistance >= 50) then
        sendNotification("⚠️ WARNING", "Giant is very close! ("..math.floor(dist).."m)", 3)
    end
    lastGiantDistance = dist
end

-- ==================== ГЛАВНЫЙ ЦИКЛ ====================
local lastUpdate = 0
local fullbrightActive = false
local nofogActive = false
local defaultFOV = 70

RunService.Heartbeat:Connect(function()
    if not alive then return end
    if tick() - lastUpdate < 0.1 then return end
    lastUpdate = tick()
    
    -- FULLBRIGHT / NO FOG
    if S.fullbright then
        if not fullbrightActive then fullbrightActive = true end
        pcall(function()
            Lighting.Brightness = 3; Lighting.ClockTime = 14
            Lighting.FogEnd = 99999; Lighting.FogStart = 0
            Lighting.GlobalShadows = false
            Lighting.OutdoorAmbient = Color3.fromRGB(200, 200, 200)
            Lighting.Ambient = Color3.fromRGB(200, 200, 200)
            Lighting.Outlines = false
            if Lighting:FindFirstChild("Bloom") then Lighting.Bloom.Intensity = 0 end
            if Lighting:FindFirstChild("ColorCorrection") then
                Lighting.ColorCorrection.Brightness = 0.1
                Lighting.ColorCorrection.Contrast = 0.1
            end
            if Lighting:FindFirstChild("Atmosphere") then
                Lighting.Atmosphere.Density = 0
                Lighting.Atmosphere.Offset = 0
                Lighting.Atmosphere.Haze = 0
                Lighting.Atmosphere.Glare = 0
            end
        end)
    else
        if fullbrightActive then restoreLighting(); fullbrightActive = false end
    end
    
    if S.nofog then
        if not nofogActive then nofogActive = true end
        pcall(function()
            Lighting.FogEnd = 99999; Lighting.FogStart = 99998
            if Lighting:FindFirstChild("Atmosphere") then
                Lighting.Atmosphere.Density = 0
                Lighting.Atmosphere.Offset = 0
                Lighting.Atmosphere.Haze = 0
            end
        end)
    else
        if nofogActive then restoreLighting(); nofogActive = false end
    end
    
    local char = lp.Character
    if not char then
        if arrowGui then arrowGui.Enabled = false end
        return
    end
    local hum = char:FindFirstChild("Humanoid")
    if not hum then
        if arrowGui then arrowGui.Enabled = false end
        return
    end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then
        if arrowGui then arrowGui.Enabled = false end
        return
    end
    
    saveDefaults()
    
    if S.speed then hum.WalkSpeed = S.speedVal end
    if S.jumppower then hum.JumpPower = S.jumpVal end
    
    if S.noclip then
        for _, p in ipairs(char:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide = false end end
    end
    
    if S.antifling and root then
        if root.Velocity.Magnitude > 100 then root.Velocity = root.Velocity.Unit * 30 end
        if root.RotVelocity.Magnitude > 50 then root.RotVelocity = Vector3.zero end
        root.AssemblyLinearVelocity = root.Velocity
        root.AssemblyAngularVelocity = root.RotVelocity
    end
    
    if S.fly then
        hum.PlatformStand = true
        local moveDir = Vector3.zero
        local cam = workspace.CurrentCamera
        if cam then
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir += cam.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir -= cam.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir -= cam.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir += cam.CFrame.RightVector end
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDir += Vector3.new(0,1,0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then moveDir -= Vector3.new(0,1,0) end
        root.Velocity = moveDir.Magnitude > 0 and moveDir.Unit * 30 or Vector3.zero
    elseif not S.autofarm and not S.autowin then hum.PlatformStand = false end
    
    if S.thirdperson then pcall(function() lp.CameraMode = Enum.CameraMode.Classic end) end
    if S.maxzoom then pcall(function() lp.CameraMaxZoomDistance = 999 end) end
    
    -- FOV CHANGER
    if S.fovchanger and workspace.CurrentCamera then
        defaultFOV = workspace.CurrentCamera.FieldOfView
        workspace.CurrentCamera.FieldOfView = S.fovVal
    end
    
    -- NO SCREEN SHAKE
    if S.noscreenshake and workspace.CurrentCamera then
        workspace.CurrentCamera.CameraShake = 0
    end
    
    -- AUTO FARM
    if S.autofarm then
        local myRole = getPlayerRole(lp):lower()
        if myRole:find("round") or myRole:find("survivor") then
            if not savedOriginalPos then savedOriginalPos = root.Position end
            local ng = getNearestGiant()
            if ng and ng.Character and ng.Character:FindFirstChild("HumanoidRootPart") then
                local giantPos = ng.Character.HumanoidRootPart.Position
                root.CFrame = CFrame.new(Vector3.new(giantPos.X, giantPos.Y, giantPos.Z))
            end
            root.Velocity = Vector3.zero; root.RotVelocity = Vector3.zero
            root.AssemblyLinearVelocity = Vector3.zero; root.AssemblyAngularVelocity = Vector3.zero
            hum.PlatformStand = true
        elseif myRole:find("giant") then
            if not savedOriginalPos then savedOriginalPos = root.Position end
            local ns = getNearestSurvivor()
            if ns and ns.Character and ns.Character:FindFirstChild("HumanoidRootPart") then
                local targetPos = ns.Character.HumanoidRootPart.Position
                root.CFrame = CFrame.new(targetPos + Vector3.new(0, 2, 0))
            end
            root.Velocity = Vector3.zero
        else
            root.Velocity = Vector3.zero
        end
    elseif savedOriginalPos and not S.autowin then
        root.CFrame = CFrame.new(savedOriginalPos); savedOriginalPos = nil; hum.PlatformStand = false
    end
    
    -- AUTO WIN
    if S.autowin then
        local myRole = getPlayerRole(lp):lower()
        if myRole:find("giant") then
            if not savedOriginalPos then savedOriginalPos = root.Position end
            hum.PlatformStand = true
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= lp and isSurvivor(p) and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    local frontPos = root.Position + root.CFrame.LookVector * 3
                    p.Character.HumanoidRootPart.CFrame = CFrame.new(frontPos + Vector3.new(math.random(-2,2), 0, math.random(-2,2)))
                end
            end
            VIM:SendKeyEvent(true, Enum.KeyCode.Q, false, nil)
            task.wait(0.05)
            VIM:SendKeyEvent(false, Enum.KeyCode.Q, false, nil)
        end
    end
    
    -- GIANT ARROW
    if S.giantarrow then
        local ng, gd = getNearestGiant()
        if ng and ng.Character and ng.Character:FindFirstChild("HumanoidRootPart") then
            updateArrow(ng.Character.HumanoidRootPart.Position, root.Position)
        else
            if arrowGui then arrowGui.Enabled = false end
        end
        checkGiantAlert(gd)
    else
        if arrowGui then arrowGui.Enabled = false end
    end
    
    if S.espPlayers or S.espGiants then
        clearESP()
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= lp and player.Character then
                local pr = player.Character:FindFirstChild("HumanoidRootPart")
                if pr then
                    local dist = (pr.Position - root.Position).Magnitude
                    local isG, isS = isGiant(player), isSurvivor(player)
                    local pHum = player.Character:FindFirstChild("Humanoid")
                    local hp = pHum and math.floor(pHum.Health) or 0
                    local maxHP = pHum and math.floor(pHum.MaxHealth) or 100
                    
                    if S.espGiants and isG then
                        local color = S.rainbowesp and Color3.fromHSV(tick()%5/5,1,1) or Color3.fromRGB(255,50,50)
                        if S.chams and not espHighlights[player.Character] then
                            local hl = Instance.new("Highlight", player.Character)
                            hl.FillColor = color; hl.FillTransparency = 0.4
                            hl.OutlineColor = Color3.fromRGB(255,255,255); espHighlights[player.Character] = hl
                        end
                        if (S.espName or S.espRole or S.espHP or S.espDistance) and not espBillboards[player.Character] then
                            local bgUI = Instance.new("BillboardGui", player.Character)
                            bgUI.Size = UDim2.new(0,200,0,70); bgUI.StudsOffset = Vector3.new(0,3,0)
                            bgUI.Adornee = pr; bgUI.AlwaysOnTop = true
                            local f = Instance.new("Frame", bgUI); f.Size = UDim2.new(1,0,1,0); f.BackgroundTransparency = 1
                            local yOff = 0
                            if S.espName then local lbl = Instance.new("TextLabel", f); lbl.Size = UDim2.new(1,0,0,18); lbl.Position = UDim2.fromOffset(0,yOff); lbl.BackgroundTransparency = 1; lbl.Text = player.Name; lbl.Font = Enum.Font.GothamBold; lbl.TextSize = 13; lbl.TextColor3 = color; lbl.TextStrokeTransparency = 0; Instance.new("UIStroke",lbl).Color = Color3.fromRGB(0,0,0); lbl:FindFirstChildOfClass("UIStroke").Thickness = 2; yOff += 16 end
                            if S.espRole then local lbl = Instance.new("TextLabel", f); lbl.Size = UDim2.new(1,0,0,16); lbl.Position = UDim2.fromOffset(0,yOff); lbl.BackgroundTransparency = 1; lbl.Text = "GIANT"; lbl.Font = Enum.Font.Gotham; lbl.TextSize = 11; lbl.TextColor3 = Color3.fromRGB(200,200,200); lbl.TextStrokeTransparency = 0; Instance.new("UIStroke",lbl).Color = Color3.fromRGB(0,0,0); lbl:FindFirstChildOfClass("UIStroke").Thickness = 1.5; yOff += 14 end
                            if S.espHP then local lbl = Instance.new("TextLabel", f); lbl.Size = UDim2.new(1,0,0,16); lbl.Position = UDim2.fromOffset(0,yOff); lbl.BackgroundTransparency = 1; lbl.Text = "HP: "..hp.."/"..maxHP; lbl.Font = Enum.Font.Gotham; lbl.TextSize = 11; lbl.TextColor3 = Color3.fromRGB(255,100,100); lbl.TextStrokeTransparency = 0; Instance.new("UIStroke",lbl).Color = Color3.fromRGB(0,0,0); lbl:FindFirstChildOfClass("UIStroke").Thickness = 1.5; yOff += 14 end
                            if S.espDistance then local lbl = Instance.new("TextLabel", f); lbl.Size = UDim2.new(1,0,0,16); lbl.Position = UDim2.fromOffset(0,yOff); lbl.BackgroundTransparency = 1; lbl.Text = math.floor(dist).."m"; lbl.Font = Enum.Font.Gotham; lbl.TextSize = 11; lbl.TextColor3 = Color3.fromRGB(200,200,200); lbl.TextStrokeTransparency = 0; Instance.new("UIStroke",lbl).Color = Color3.fromRGB(0,0,0); lbl:FindFirstChildOfClass("UIStroke").Thickness = 1.5 end
                            espBillboards[player.Character] = bgUI
                        end
                    elseif S.espPlayers and isS then
                        local color = Color3.fromRGB(50,255,50)
                        if S.chams and not espHighlights[player.Character] then
                            local hl = Instance.new("Highlight", player.Character)
                            hl.FillColor = color; hl.FillTransparency = 0.4
                            hl.OutlineColor = Color3.fromRGB(255,255,255); espHighlights[player.Character] = hl
                        end
                        if (S.espName or S.espRole or S.espHP or S.espDistance) and not espBillboards[player.Character] then
                            local bgUI = Instance.new("BillboardGui", player.Character)
                            bgUI.Size = UDim2.new(0,200,0,70); bgUI.StudsOffset = Vector3.new(0,3,0)
                            bgUI.Adornee = pr; bgUI.AlwaysOnTop = true
                            local f = Instance.new("Frame", bgUI); f.Size = UDim2.new(1,0,1,0); f.BackgroundTransparency = 1
                            local yOff = 0
                            if S.espName then local lbl = Instance.new("TextLabel", f); lbl.Size = UDim2.new(1,0,0,18); lbl.Position = UDim2.fromOffset(0,yOff); lbl.BackgroundTransparency = 1; lbl.Text = player.Name; lbl.Font = Enum.Font.GothamBold; lbl.TextSize = 13; lbl.TextColor3 = color; lbl.TextStrokeTransparency = 0; Instance.new("UIStroke",lbl).Color = Color3.fromRGB(0,0,0); lbl:FindFirstChildOfClass("UIStroke").Thickness = 2; yOff += 16 end
                            if S.espRole then local lbl = Instance.new("TextLabel", f); lbl.Size = UDim2.new(1,0,0,16); lbl.Position = UDim2.fromOffset(0,yOff); lbl.BackgroundTransparency = 1; lbl.Text = "SURVIVOR"; lbl.Font = Enum.Font.Gotham; lbl.TextSize = 11; lbl.TextColor3 = Color3.fromRGB(200,200,200); lbl.TextStrokeTransparency = 0; Instance.new("UIStroke",lbl).Color = Color3.fromRGB(0,0,0); lbl:FindFirstChildOfClass("UIStroke").Thickness = 1.5; yOff += 14 end
                            if S.espHP then local lbl = Instance.new("TextLabel", f); lbl.Size = UDim2.new(1,0,0,16); lbl.Position = UDim2.fromOffset(0,yOff); lbl.BackgroundTransparency = 1; lbl.Text = "HP: "..hp.."/"..maxHP; lbl.Font = Enum.Font.Gotham; lbl.TextSize = 11; lbl.TextColor3 = Color3.fromRGB(100,255,100); lbl.TextStrokeTransparency = 0; Instance.new("UIStroke",lbl).Color = Color3.fromRGB(0,0,0); lbl:FindFirstChildOfClass("UIStroke").Thickness = 1.5; yOff += 14 end
                            if S.espDistance then local lbl = Instance.new("TextLabel", f); lbl.Size = UDim2.new(1,0,0,16); lbl.Position = UDim2.fromOffset(0,yOff); lbl.BackgroundTransparency = 1; lbl.Text = math.floor(dist).."m"; lbl.Font = Enum.Font.Gotham; lbl.TextSize = 11; lbl.TextColor3 = Color3.fromRGB(200,200,200); lbl.TextStrokeTransparency = 0; Instance.new("UIStroke",lbl).Color = Color3.fromRGB(0,0,0); lbl:FindFirstChildOfClass("UIStroke").Thickness = 1.5 end
                            espBillboards[player.Character] = bgUI
                        end
                    elseif S.espPlayers and isLobby(player) then
                        if S.chams and not espHighlights[player.Character] then
                            local hl = Instance.new("Highlight", player.Character)
                            hl.FillColor = Color3.fromRGB(128,128,128); hl.FillTransparency = 0.4; espHighlights[player.Character] = hl
                        end
                    end
                end
            end
        end
    else clearESP() end
    
    if S.hitboxviewer and math.random() < 0.3 then updateHitboxViewer() else
        for _, p in ipairs(hitboxParts) do pcall(function() p:Destroy() end) end; table.clear(hitboxParts)
    end
    
    if S.riskmeter then
        local _, gd = getNearestGiant()
        local risk = gd and math.clamp(500 - gd, 0, 500) / 5 or 0
        updateRiskMeter(risk)
    else riskMeterGUI.Enabled = false end
    
    local hp = math.floor(hum.Health)
    local ng, gd = getNearestGiant()
    stats.Text = string.format("HP: %d | Role: %s\nGiant: %s | Farm: %s | ❄️: %s",
        hp, getPlayerRole(lp), ng and (ng.Name.." "..math.floor(gd).."m") or "None",
        S.autofarm and "✅" or "❌", S.snowEffect and "✅" or "❌")
end)

-- SPECTATE
task.spawn(function()
    while alive do
        if S.spectate then
            local target = getNearestGiant()
            if target and target.Character and target.Character:FindFirstChild("Humanoid") then
                workspace.CurrentCamera.CameraSubject = target.Character.Humanoid
            end
        end
        task.wait(1)
    end
end)

lp.Idled:Connect(function() if S.antiafk then VirtualUser:CaptureController(); VirtualUser:ClickButton2(Vector2.new()) end end)

local musicSound
task.spawn(function()
    while alive do
        if S.musicplayer then
            if not musicSound or not musicSound.Parent then
                if musicSound then musicSound:Destroy() end
                musicSound = Instance.new("Sound", workspace); musicSound.SoundId = S.musicID
                musicSound.Looped = true; musicSound.Volume = 1; musicSound:Play()
            elseif musicSound.SoundId ~= S.musicID then musicSound.SoundId = S.musicID; musicSound:Play() end
        elseif musicSound then musicSound:Stop(); musicSound:Destroy(); musicSound = nil end
        task.wait(1)
    end
end)

closeB.MouseButton1Click:Connect(function() if _G.Sm1leHub then _G.Sm1leHub.Destroy() end end)

_G.Sm1leHub = {
    Destroy = function()
        alive = false
        for k in pairs(S) do if type(S[k]) == "boolean" then S[k] = false end end
        stopSnow(); clearESP()
        restoreLighting()
        if workspace.CurrentCamera then
            workspace.CurrentCamera.FieldOfView = defaultFOV
            workspace.CurrentCamera.CameraShake = 0
        end
        for _, p in ipairs(hitboxParts) do pcall(function() p:Destroy() end) end
        if riskMeterGUI then riskMeterGUI:Destroy() end
        if arrowGui then arrowGui:Destroy() end
        if gui then gui:Destroy() end
        if musicSound then musicSound:Stop(); musicSound:Destroy() end
        if lp.Character and lp.Character:FindFirstChild("Humanoid") then
            pcall(function() workspace.CurrentCamera.CameraSubject = lp.Character.Humanoid end)
        end
        _G.Sm1leHub = nil
    end
}

print("✅ SM1LE HUB — Lurking Giants LOADED")
print("👁️ RightCtrl — скрыть | ✕ — закрыть | — — свернуть")
print("📍 Giant Arrow | 🔍 FOV Changer | 📳 No Screen Shake | 🔔 Notifications")
