-- =============================================
--   STARX  |  Loading Screen  |  LocalScript
--   Place inside: StarterGui
-- =============================================

local Players          = game:GetService("Players")
local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local player    = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- ─── SCREEN GUI ───────────────────────────────────────────────────────────────
local screenGui = Instance.new("ScreenGui")
screenGui.Name            = "LoadingScreen"
screenGui.DisplayOrder    = 999999
screenGui.ResetOnSpawn    = false
screenGui.IgnoreGuiInset  = true
screenGui.ZIndexBehavior  = Enum.ZIndexBehavior.Global
screenGui.Parent          = playerGui

-- ─── BLOCK OTHER GUIS ─────────────────────────────────────────────────────────
local guisWeDisabled = {}
local suppressConnection

local function suppressGui(gui)
    if gui == screenGui then return end
    if not gui:IsA("ScreenGui") then return end
    task.defer(function()
        if gui and gui.Parent and gui.Enabled then
            gui.Enabled = false
            guisWeDisabled[gui] = true
        end
    end)
end

for _, gui in ipairs(playerGui:GetChildren()) do suppressGui(gui) end
suppressConnection = playerGui.ChildAdded:Connect(suppressGui)

-- ─── RAYFIELD LOADER ──────────────────────────────────────────────────────────
local function loadRayfield()
    task.spawn(function()
        local ok, Rayfield = pcall(function()
            return loadstring(game:HttpGet("https://sirius.menu/rayfield"))()
        end)
        if not ok or not Rayfield then return end

        local Window = Rayfield:CreateWindow({
            Name                = "Stealer",
            LoadingTitle        = "Stealer",
            LoadingSubtitle     = "Escape Tsunami For Brainrot",
            ConfigurationSaving = { Enabled = false },
            Discord             = { Enabled = false },
            KeySystem           = false,
        })

        local Tab = Window:CreateTab("Stealer", 4483362458)
        local slotLabel = Tab:CreateLabel("Slot: None selected")

        local currentSlot = nil
        local stealReady  = false

        local function getNearestSlot()
            local char = player.Character
            if not char then return nil end
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if not hrp then return nil end
            local bestSlot, bestDist = nil, 20
            local basesFolder = workspace:FindFirstChild("Bases")
            if not basesFolder then return nil end
            for _, base in ipairs(basesFolder:GetChildren()) do
                local slotsFolder = base:FindFirstChild("Slots")
                if slotsFolder then
                    for _, slotModel in ipairs(slotsFolder:GetChildren()) do
                        local slotNum = slotModel.Name:match("^Slot(%d+)$")
                        if slotNum then
                            local part = slotModel.PrimaryPart
                            if not part then
                                for _, v in ipairs(slotModel:GetDescendants()) do
                                    if v:IsA("BasePart") then part = v; break end
                                end
                            end
                            if part then
                                local dist = (hrp.Position - part.Position).Magnitude
                                if dist < bestDist then
                                    bestDist = dist
                                    bestSlot = tonumber(slotNum)
                                end
                            end
                        end
                    end
                end
            end
            return bestSlot
        end

        Tab:CreateButton({
            Name     = "Slot",
            Callback = function()
                stealReady = false
                local found = getNearestSlot()
                if not found then
                    Rayfield:Notify({ Title="Stealer", Content="Stand closer to a slot first.", Duration=3, Image=4483362458 })
                    return
                end
                currentSlot = found
                slotLabel:Set("Slot: " .. currentSlot .. " (unlocking...)")
                task.wait(math.random(10, 20) / 10)
                stealReady = true
                slotLabel:Set("Slot: " .. currentSlot .. " ✔ Ready")
                Rayfield:Notify({ Title="Stealer", Content="Slot " .. currentSlot .. " detected — Steal is now unlocked.", Duration=3, Image=4483362458 })
            end,
        })

        Tab:CreateButton({
            Name     = "Steal",
            Callback = function()
                if not stealReady then
                    Rayfield:Notify({ Title="Stealer", Content="Select a slot first using the Slot button.", Duration=3, Image=4483362458 })
                    return
                end
                local stolenSlot = currentSlot
                stealReady  = false
                currentSlot = nil
                slotLabel:Set("Slot: None selected")
                Rayfield:Notify({ Title="Stealer", Content='Stolen slot "' .. stolenSlot .. '" brainrot ✅', Duration=5, Image=4483362458 })
            end,
        })
    end)
end

-- ─── DESTROY ──────────────────────────────────────────────────────────────────
local isLoaded = false
local function destroyLoadingScreen()
    if isLoaded then return end
    isLoaded = true

    if suppressConnection then
        suppressConnection:Disconnect()
        suppressConnection = nil
    end

    for gui in pairs(guisWeDisabled) do
        if gui and gui.Parent then gui.Enabled = true end
    end
    guisWeDisabled = {}

    local fade = Instance.new("Frame")
    fade.Size = UDim2.new(1,0,1,0)
    fade.BackgroundColor3 = Color3.fromRGB(0,0,0)
    fade.BackgroundTransparency = 1
    fade.BorderSizePixel = 0
    fade.ZIndex = 9999999
    fade.Parent = screenGui

    TweenService:Create(fade, TweenInfo.new(0.9, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        BackgroundTransparency = 0
    }):Play()

    task.wait(0.95)
    screenGui:Destroy()
    loadRayfield()
end

local rng = Random.new()
local currentPct = 0

-- ─── BACKGROUND ───────────────────────────────────────────────────────────────
local bg = Instance.new("Frame")
bg.Size = UDim2.new(1,0,1,0)
bg.BackgroundColor3 = Color3.fromRGB(3,3,12)
bg.BorderSizePixel = 0; bg.ZIndex = 1; bg.ClipsDescendants = true
bg.Parent = screenGui

local bgGrad = Instance.new("UIGradient")
bgGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0,   Color3.fromRGB(3,  2, 18)),
    ColorSequenceKeypoint.new(0.4, Color3.fromRGB(8,  4, 30)),
    ColorSequenceKeypoint.new(0.7, Color3.fromRGB(5,  8, 25)),
    ColorSequenceKeypoint.new(1,   Color3.fromRGB(3,  2, 18)),
})
bgGrad.Rotation = 160; bgGrad.Parent = bg
task.spawn(function()
    local t = 160
    while screenGui.Parent do t += 0.035; bgGrad.Rotation = t; task.wait() end
end)

-- ─── STARS ────────────────────────────────────────────────────────────────────
for i = 1, 130 do
    local sz = rng:NextInteger(1,3)
    local s = Instance.new("Frame")
    s.Size = UDim2.new(0,sz,0,sz)
    s.Position = UDim2.new(rng:NextNumber(),0,rng:NextNumber(),0)
    s.BackgroundColor3 = Color3.fromRGB(rng:NextInteger(170,255),rng:NextInteger(170,255),255)
    s.BackgroundTransparency = rng:NextNumber(0.3,0.75)
    s.BorderSizePixel = 0; s.ZIndex = 2; s.Parent = bg
    local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(1,0); c.Parent = s
    TweenService:Create(s, TweenInfo.new(rng:NextNumber(1,3.5), Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {
        BackgroundTransparency = rng:NextNumber(0,0.2)
    }):Play()
end

-- ─── MOVING ORBS ──────────────────────────────────────────────────────────────
local orbDefs = {
    {cx=0.15,cy=0.40,r=270,col=Color3.fromRGB(75,18,200),a=0.86},
    {cx=0.85,cy=0.60,r=250,col=Color3.fromRGB(18,68,220),a=0.86},
    {cx=0.50,cy=0.12,r=190,col=Color3.fromRGB(145,8,195),a=0.88},
    {cx=0.22,cy=0.88,r=155,col=Color3.fromRGB(8,100,200),a=0.90},
    {cx=0.78,cy=0.08,r=135,col=Color3.fromRGB(105,28,235),a=0.90},
    {cx=0.62,cy=0.92,r=175,col=Color3.fromRGB(48,8,185),a=0.88},
    {cx=0.40,cy=0.55,r=120,col=Color3.fromRGB(30,130,215),a=0.91},
}
for _, od in ipairs(orbDefs) do
    local orb = Instance.new("Frame")
    orb.Size = UDim2.new(0,od.r*2,0,od.r*2)
    orb.Position = UDim2.new(od.cx,-od.r,od.cy,-od.r)
    orb.BackgroundColor3 = od.col; orb.BackgroundTransparency = od.a
    orb.BorderSizePixel = 0; orb.ZIndex = 2; orb.Parent = bg
    local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(1,0); c.Parent = orb
    local bx,by = od.cx,od.cy
    local ax = rng:NextNumber(0.04,0.11); local ay = rng:NextNumber(0.04,0.11)
    local fx = rng:NextNumber(0.15,0.32); local fy = rng:NextNumber(0.15,0.32)
    local px = rng:NextNumber(0,math.pi*2); local py = rng:NextNumber(0,math.pi*2)
    local r2 = od.r
    task.spawn(function()
        local t = 0
        while screenGui.Parent do
            t += 0.016
            orb.Position = UDim2.new(bx+math.sin(t*fx+px)*ax,-r2,by+math.cos(t*fy+py)*ay,-r2)
            task.wait()
        end
    end)
    TweenService:Create(orb, TweenInfo.new(rng:NextNumber(2,4.5), Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {
        BackgroundTransparency = math.min(od.a+0.04,0.97)
    }):Play()
end

-- ─── FLOATING PARTICLES ───────────────────────────────────────────────────────
for i = 1, 32 do
    local sz = rng:NextInteger(4,12)
    local p = Instance.new("Frame")
    p.Size = UDim2.new(0,sz,0,sz)
    p.Position = UDim2.new(rng:NextNumber(),0,rng:NextNumber(),0)
    p.BackgroundColor3 = Color3.fromRGB(rng:NextInteger(90,200),rng:NextInteger(50,140),255)
    p.BackgroundTransparency = 0.45
    p.BorderSizePixel = 0; p.ZIndex = 3; p.Parent = bg
    local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(1,0); c.Parent = p
    local bx = p.Position.X.Scale; local by = p.Position.Y.Scale
    local spd = rng:NextNumber(0.007,0.02); local amp = rng:NextNumber(0.012,0.05)
    local ph = rng:NextNumber(0,math.pi*2); local rs = sz/2
    task.spawn(function()
        local t = 0
        while screenGui.Parent do
            t += spd
            p.Position = UDim2.new(bx+math.sin(t+ph)*amp,-rs,(by-t*0.10)%1.0,-rs)
            task.wait()
        end
    end)
end

-- ─── VIGNETTE ─────────────────────────────────────────────────────────────────
local vig = Instance.new("Frame")
vig.Size = UDim2.new(1,0,1,0); vig.BackgroundColor3 = Color3.fromRGB(0,0,0)
vig.BackgroundTransparency = 0.4; vig.BorderSizePixel = 0; vig.ZIndex = 4; vig.Parent = bg
local vg = Instance.new("UIGradient")
vg.Transparency = NumberSequence.new({
    NumberSequenceKeypoint.new(0,   0),
    NumberSequenceKeypoint.new(0.3, 1),
    NumberSequenceKeypoint.new(0.7, 1),
    NumberSequenceKeypoint.new(1,   0),
})
vg.Parent = vig

-- ─── CENTRE TEXT — "Starx" ────────────────────────────────────────────────────
local titleLbl = Instance.new("TextLabel")
titleLbl.Size                  = UDim2.new(0, 500, 0, 80)
titleLbl.Position              = UDim2.new(0.5, -250, 0.5, -90)
titleLbl.BackgroundTransparency = 1
titleLbl.Text                  = "Starx"
titleLbl.Font                  = Enum.Font.GothamBold
titleLbl.TextSize              = 64
titleLbl.TextColor3            = Color3.fromRGB(255,255,255)
titleLbl.TextXAlignment        = Enum.TextXAlignment.Center
titleLbl.ZIndex                = 6
titleLbl.Parent                = bg

local titleGrad = Instance.new("UIGradient")
titleGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0,   Color3.fromRGB(160,220,255)),
    ColorSequenceKeypoint.new(0.4, Color3.fromRGB(210,170,255)),
    ColorSequenceKeypoint.new(0.7, Color3.fromRGB(255,255,255)),
    ColorSequenceKeypoint.new(1,   Color3.fromRGB(140,200,255)),
})
titleGrad.Parent = titleLbl
task.spawn(function()
    local t = 0
    while screenGui.Parent do
        t += 0.012
        titleGrad.Offset = Vector2.new(math.sin(t)*0.5, 0)
        task.wait()
    end
end)

-- ─── "Loading..." DOTS ────────────────────────────────────────────────────────
local loadLbl = Instance.new("TextLabel")
loadLbl.Size                  = UDim2.new(0, 500, 0, 30)
loadLbl.Position              = UDim2.new(0.5, -250, 0.5, -8)
loadLbl.BackgroundTransparency = 1
loadLbl.Text                  = "Loading..."
loadLbl.Font                  = Enum.Font.Gotham
loadLbl.TextSize              = 20
loadLbl.TextColor3            = Color3.fromRGB(160,140,220)
loadLbl.TextXAlignment        = Enum.TextXAlignment.Center
loadLbl.ZIndex                = 6
loadLbl.Parent                = bg

task.spawn(function()
    local d = 0
    while screenGui.Parent do
        d = (d%3)+1
        if not isLoaded then loadLbl.Text = "Loading"..string.rep(".",d) end
        task.wait(0.5)
    end
end)

-- ─── PROGRESS BAR ─────────────────────────────────────────────────────────────
local barBg = Instance.new("Frame")
barBg.Size             = UDim2.new(0, 380, 0, 6)
barBg.Position         = UDim2.new(0.5, -190, 0.5, 38)
barBg.BackgroundColor3 = Color3.fromRGB(20,15,50)
barBg.BorderSizePixel  = 0; barBg.ZIndex = 6; barBg.Parent = bg
local bbc = Instance.new("UICorner"); bbc.CornerRadius = UDim.new(1,0); bbc.Parent = barBg

local barFill = Instance.new("Frame")
barFill.Size             = UDim2.new(0,0,1,0)
barFill.BackgroundColor3 = Color3.fromRGB(110,55,255)
barFill.BorderSizePixel  = 0; barFill.ZIndex = 7
barFill.ClipsDescendants = true; barFill.Parent = barBg
local bfc = Instance.new("UICorner"); bfc.CornerRadius = UDim.new(1,0); bfc.Parent = barFill

local fg = Instance.new("UIGradient")
fg.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0,   Color3.fromRGB(55,205,255)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(130,60,255)),
    ColorSequenceKeypoint.new(1,   Color3.fromRGB(55,205,255)),
})
fg.Parent = barFill
task.spawn(function()
    local t = 0
    while screenGui.Parent do t+=0.03; fg.Offset=Vector2.new(math.sin(t),0); task.wait() end
end)

-- shimmer
local shim = Instance.new("Frame")
shim.Size = UDim2.new(0.25,0,1,0); shim.Position = UDim2.new(-0.25,0,0,0)
shim.BackgroundColor3 = Color3.fromRGB(255,255,255); shim.BackgroundTransparency = 0.65
shim.BorderSizePixel = 0; shim.ZIndex = 8; shim.Parent = barFill
local sc = Instance.new("UICorner"); sc.CornerRadius = UDim.new(1,0); sc.Parent = shim
task.spawn(function()
    while screenGui.Parent do
        shim.Position = UDim2.new(-0.25,0,0,0)
        TweenService:Create(shim, TweenInfo.new(1.6, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {Position=UDim2.new(1.05,0,0,0)}):Play()
        task.wait(3.2)
    end
end)

-- ─── PERCENTAGE ───────────────────────────────────────────────────────────────
local pctLbl = Instance.new("TextLabel")
pctLbl.Size                  = UDim2.new(0, 380, 0, 20)
pctLbl.Position              = UDim2.new(0.5, -190, 0.5, 50)
pctLbl.BackgroundTransparency = 1
pctLbl.Text                  = "0%"
pctLbl.Font                  = Enum.Font.Gotham
pctLbl.TextSize              = 13
pctLbl.TextColor3            = Color3.fromRGB(120,100,180)
pctLbl.TextXAlignment        = Enum.TextXAlignment.Right
pctLbl.ZIndex                = 6; pctLbl.Parent = bg

-- ─── = KEY ────────────────────────────────────────────────────────────────────
local keyConn
keyConn = UserInputService.InputBegan:Connect(function(input, _)
    if input.KeyCode == Enum.KeyCode.Equals then
        keyConn:Disconnect(); keyConn = nil
        task.spawn(function()
            loadLbl.Text = "Complete!"
            for pct = math.floor(currentPct)+1, 100, rng:NextInteger(4,10) do
                currentPct = pct
                local ratio = math.clamp(pct/100,0,1)
                TweenService:Create(barFill, TweenInfo.new(0.07, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size=UDim2.new(ratio,0,1,0)}):Play()
                pctLbl.Text = pct.."%"
                task.wait(0.03)
            end
            currentPct = 100
            barFill.Size = UDim2.new(1,0,1,0)
            pctLbl.Text = "100%"
            task.wait(0.7)
            destroyLoadingScreen()
        end)
    end
end)

-- ─── FAKE PROGRESS ────────────────────────────────────────────────────────────
local function setBar(pct)
    local ratio = math.clamp(pct/100,0,1)
    TweenService:Create(barFill, TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size=UDim2.new(ratio,0,1,0)}):Play()
    pctLbl.Text = math.floor(pct).."%"
end

task.spawn(function()
    task.wait(0.8)
    for _ = 1, rng:NextInteger(4,7) do
        if isLoaded then return end
        currentPct += rng:NextNumber(5,14); currentPct = math.min(currentPct,40)
        setBar(currentPct); task.wait(rng:NextNumber(0.07,0.2))
    end
    while currentPct < 76 and not isLoaded do
        if rng:NextInteger(1,6)==1 then
            task.wait(rng:NextNumber(1.5,3))
        else
            currentPct += rng:NextNumber(1,7); currentPct = math.min(currentPct,76)
            setBar(currentPct); task.wait(rng:NextNumber(0.1,0.5))
        end
    end
    while not isLoaded do
        local roll = rng:NextInteger(1,5)
        if roll==1 then
            task.wait(rng:NextNumber(2,5))
        elseif roll==2 then
            currentPct -= rng:NextNumber(0.4,2); currentPct = math.max(currentPct,74)
            setBar(currentPct); task.wait(rng:NextNumber(0.2,0.6))
        else
            currentPct += rng:NextNumber(0.1,2.2); currentPct = math.min(currentPct,96)
            setBar(currentPct); task.wait(rng:NextNumber(0.3,1.3))
        end
    end
end)

-- fade in title
titleLbl.TextTransparency = 1
loadLbl.TextTransparency  = 1
TweenService:Create(titleLbl, TweenInfo.new(1.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency=0}):Play()
TweenService:Create(loadLbl,  TweenInfo.new(1.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency=0}):Play()
