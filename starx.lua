-- ======================================================
--  TOKEN MULTIPLIER GUI (VISUAL ONLY - LOCAL PLAYER)
-- ======================================================

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Get ClientGlobals module
local ClientGlobals = require(ReplicatedStorage.Client.Modules.ClientGlobals)
local PlayerData = ClientGlobals.PlayerData

-- Store token values
local realTokens = 0
local displayTokens = 0

print("[TOKEN MULTIPLIER] Starting visual multiplier...")

-- Function to format numbers with commas
local function formatCommas(num)
    local formatted = tostring(math.floor(num))
    while true do  
        formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
        if k == 0 then
            break
        end
    end
    return formatted
end

-- Track the real token value from server
PlayerData:Observe({"TradeTokens"}, function(tokens)
    realTokens = tokens or 0
    if displayTokens == 0 then
        displayTokens = realTokens
    end
    print(string.format("[TOKEN MULTIPLIER] Current tokens: %d", realTokens))
end)

-- ======================================================
-- CREATE GUI
-- ======================================================
local function createGUI()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "TokenMultiplierGUI"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.Parent = PlayerGui
    
    -- Main Frame (Draggable)
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 380, 0, 340)
    MainFrame.Position = UDim2.new(0.5, -190, 0.5, -170)
    MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    MainFrame.BorderSizePixel = 0
    MainFrame.Active = true
    MainFrame.Draggable = true
    MainFrame.Parent = ScreenGui
    
    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 15)
    MainCorner.Parent = MainFrame
    
    -- Gradient
    local Gradient = Instance.new("UIGradient")
    Gradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(25, 25, 40)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(15, 15, 25))
    }
    Gradient.Rotation = 45
    Gradient.Parent = MainFrame
    
    -- Top Bar
    local TopBar = Instance.new("Frame")
    TopBar.Size = UDim2.new(1, 0, 0, 50)
    TopBar.BackgroundColor3 = Color3.fromRGB(100, 200, 255)
    TopBar.BorderSizePixel = 0
    TopBar.Parent = MainFrame
    
    local TopBarCorner = Instance.new("UICorner")
    TopBarCorner.CornerRadius = UDim.new(0, 15)
    TopBarCorner.Parent = TopBar
    
    local TopBarBottom = Instance.new("Frame")
    TopBarBottom.Size = UDim2.new(1, 0, 0, 15)
    TopBarBottom.Position = UDim2.new(0, 0, 1, -15)
    TopBarBottom.BackgroundColor3 = Color3.fromRGB(100, 200, 255)
    TopBarBottom.BorderSizePixel = 0
    TopBarBottom.Parent = TopBar
    
    -- Icon
    local Icon = Instance.new("TextLabel")
    Icon.Size = UDim2.new(0, 40, 0, 40)
    Icon.Position = UDim2.new(0, 10, 0.5, -20)
    Icon.BackgroundTransparency = 1
    Icon.Text = "💰"
    Icon.TextSize = 28
    Icon.Parent = TopBar
    
    -- Title
    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, -110, 1, 0)
    Title.Position = UDim2.new(0, 55, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = "Token Multiplier"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 20
    Title.Font = Enum.Font.GothamBold
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = TopBar
    
    -- Close Button
    local CloseButton = Instance.new("TextButton")
    CloseButton.Size = UDim2.new(0, 40, 0, 40)
    CloseButton.Position = UDim2.new(1, -50, 0, 5)
    CloseButton.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
    CloseButton.BorderSizePixel = 0
    CloseButton.Text = "X"
    CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseButton.TextSize = 20
    CloseButton.Font = Enum.Font.GothamBold
    CloseButton.Parent = TopBar
    
    local CloseCorner = Instance.new("UICorner")
    CloseCorner.CornerRadius = UDim.new(0, 8)
    CloseCorner.Parent = CloseButton
    
    CloseButton.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)
    
    -- Content Container
    local Content = Instance.new("Frame")
    Content.Size = UDim2.new(1, -40, 1, -70)
    Content.Position = UDim2.new(0, 20, 0, 60)
    Content.BackgroundTransparency = 1
    Content.Parent = MainFrame
    
    -- Current Tokens Display Panel
    local TokenPanel = Instance.new("Frame")
    TokenPanel.Size = UDim2.new(1, 0, 0, 70)
    TokenPanel.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
    TokenPanel.BorderSizePixel = 0
    TokenPanel.Parent = Content
    
    local TokenCorner = Instance.new("UICorner")
    TokenCorner.CornerRadius = UDim.new(0, 10)
    TokenCorner.Parent = TokenPanel
    
    local TokenLabel = Instance.new("TextLabel")
    TokenLabel.Size = UDim2.new(1, -20, 0, 25)
    TokenLabel.Position = UDim2.new(0, 10, 0, 8)
    TokenLabel.BackgroundTransparency = 1
    TokenLabel.Text = "Current Tokens"
    TokenLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
    TokenLabel.TextSize = 14
    TokenLabel.Font = Enum.Font.Gotham
    TokenLabel.TextXAlignment = Enum.TextXAlignment.Left
    TokenLabel.Parent = TokenPanel
    
    local TokenValue = Instance.new("TextLabel")
    TokenValue.Name = "TokenValue"
    TokenValue.Size = UDim2.new(1, -20, 0, 32)
    TokenValue.Position = UDim2.new(0, 10, 0, 33)
    TokenValue.BackgroundTransparency = 1
    TokenValue.Text = "0"
    TokenValue.TextColor3 = Color3.fromRGB(100, 255, 100)
    TokenValue.TextSize = 26
    TokenValue.Font = Enum.Font.GothamBold
    TokenValue.TextXAlignment = Enum.TextXAlignment.Left
    TokenValue.Parent = TokenPanel
    
    -- Status Label
    local StatusLabel = Instance.new("TextLabel")
    StatusLabel.Name = "StatusLabel"
    StatusLabel.Size = UDim2.new(1, 0, 0, 25)
    StatusLabel.Position = UDim2.new(0, 0, 0, 80)
    StatusLabel.BackgroundTransparency = 1
    StatusLabel.Text = "Select a multiplier below"
    StatusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    StatusLabel.TextSize = 12
    StatusLabel.Font = Enum.Font.Gotham
    StatusLabel.TextXAlignment = Enum.TextXAlignment.Center
    StatusLabel.Parent = Content
    
    -- Buttons Container
    local ButtonContainer = Instance.new("Frame")
    ButtonContainer.Size = UDim2.new(1, 0, 0, 160)
    ButtonContainer.Position = UDim2.new(0, 0, 0, 110)
    ButtonContainer.BackgroundTransparency = 1
    ButtonContainer.Parent = Content
    
    local GridLayout = Instance.new("UIGridLayout")
    GridLayout.CellSize = UDim2.new(0.48, 0, 0, 70)
    GridLayout.CellPadding = UDim2.new(0.04, 0, 0, 15)
    GridLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    GridLayout.Parent = ButtonContainer
    
    -- Multiplier configurations - BRIGHTER COLORS
    local multipliers = {
        {mult = 2, time = 5, color = Color3.fromRGB(80, 180, 255)},
        {mult = 4, time = 20, color = Color3.fromRGB(120, 200, 255)},
        {mult = 10, time = 60, color = Color3.fromRGB(180, 150, 255)},
        {mult = 100, time = 300, color = Color3.fromRGB(255, 120, 200)}
    }
    
    local cooldowns = {}
    local isProcessing = false
    
    -- Status messages
    local statusMessages = {
        "Initializing multiplier...",
        "Connecting to token system...",
        "Hooking into the token system...",
        "Bypassing security checks...",
        "Multiplying your tokens...",
        "Applying multiplier effect...",
        "Finalizing changes...",
        "Almost done..."
    }
    
    -- Animate status messages
    local function animateStatus(duration)
        local startTime = tick()
        local messageIndex = 1
        
        task.spawn(function()
            while tick() - startTime < duration do
                StatusLabel.Text = statusMessages[messageIndex]
                messageIndex = messageIndex + 1
                if messageIndex > #statusMessages then
                    messageIndex = 1
                end
                task.wait(duration / #statusMessages)
            end
        end)
    end
    
    -- Format time
    local function formatTime(seconds)
        if seconds >= 60 then
            local mins = math.floor(seconds / 60)
            local secs = seconds % 60
            return string.format("%dm %ds", mins, secs)
        else
            return string.format("%ds", seconds)
        end
    end
    
    -- Create multiplier button
    local function createButton(config)
        local Button = Instance.new("TextButton")
        Button.Size = UDim2.new(0, 170, 0, 70)
        Button.BackgroundColor3 = config.color
        Button.BorderSizePixel = 0
        Button.AutoButtonColor = false
        Button.Text = ""
        Button.Parent = ButtonContainer
        
        local BtnCorner = Instance.new("UICorner")
        BtnCorner.CornerRadius = UDim.new(0, 12)
        BtnCorner.Parent = Button
        
        -- Thick white border/stroke for visibility
        local UIStroke = Instance.new("UIStroke")
        UIStroke.Color = Color3.fromRGB(255, 255, 255)
        UIStroke.Thickness = 3
        UIStroke.Transparency = 0.3
        UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        UIStroke.Parent = Button
        
        -- Brighter gradient
        local BtnGradient = Instance.new("UIGradient")
        BtnGradient.Color = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.fromRGB(1.3, 1.3, 1.3)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(1, 1, 1))
        }
        BtnGradient.Rotation = 90
        BtnGradient.Parent = Button
        
        -- Container for text (centered layout)
        local TextContainer = Instance.new("Frame")
        TextContainer.Size = UDim2.new(1, 0, 1, 0)
        TextContainer.BackgroundTransparency = 1
        TextContainer.Parent = Button
        
        local MultText = Instance.new("TextLabel")
        MultText.Size = UDim2.new(1, 0, 0, 35)
        MultText.Position = UDim2.new(0, 0, 0, 8)
        MultText.BackgroundTransparency = 1
        MultText.Text = config.mult .. "x"
        MultText.TextColor3 = Color3.fromRGB(255, 255, 255)
        MultText.TextSize = 28
        MultText.Font = Enum.Font.GothamBold
        MultText.TextStrokeTransparency = 0.3
        MultText.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        MultText.Parent = TextContainer
        
        local TimeText = Instance.new("TextLabel")
        TimeText.Size = UDim2.new(1, 0, 0, 20)
        TimeText.Position = UDim2.new(0, 0, 1, -28)
        TimeText.BackgroundTransparency = 1
        TimeText.Text = formatTime(config.time)
        TimeText.TextColor3 = Color3.fromRGB(255, 255, 255)
        TimeText.TextSize = 16
        TimeText.Font = Enum.Font.GothamBold
        TimeText.TextStrokeTransparency = 0.5
        TimeText.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        TimeText.Parent = TextContainer
        
        -- Hover effect
        Button.MouseEnter:Connect(function()
            TweenService:Create(Button, TweenInfo.new(0.15), {
                Size = UDim2.new(0, 180, 0, 75)
            }):Play()
            TweenService:Create(UIStroke, TweenInfo.new(0.15), {
                Thickness = 4,
                Transparency = 0
            }):Play()
            TweenService:Create(BtnGradient, TweenInfo.new(0.15), {
                Rotation = 45
            }):Play()
        end)
        
        Button.MouseLeave:Connect(function()
            TweenService:Create(Button, TweenInfo.new(0.15), {
                Size = UDim2.new(0, 170, 0, 70)
            }):Play()
            TweenService:Create(UIStroke, TweenInfo.new(0.15), {
                Thickness = 3,
                Transparency = 0.3
            }):Play()
            TweenService:Create(BtnGradient, TweenInfo.new(0.15), {
                Rotation = 90
            }):Play()
        end)
        
        -- Cooldown overlay
        local Cooldown = Instance.new("Frame")
        Cooldown.Size = UDim2.new(0, 0, 1, 0)
        Cooldown.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        Cooldown.BackgroundTransparency = 0.6
        Cooldown.BorderSizePixel = 0
        Cooldown.Visible = false
        Cooldown.ZIndex = 2
        Cooldown.Parent = Button
        
        local CooldownCorner = Instance.new("UICorner")
        CooldownCorner.CornerRadius = UDim.new(0, 10)
        CooldownCorner.Parent = Cooldown
        
        local CooldownText = Instance.new("TextLabel")
        CooldownText.Size = UDim2.new(1, 0, 1, 0)
        CooldownText.BackgroundTransparency = 1
        CooldownText.Text = "0s"
        CooldownText.TextColor3 = Color3.fromRGB(255, 255, 255)
        CooldownText.TextSize = 16
        CooldownText.Font = Enum.Font.GothamBold
        CooldownText.ZIndex = 3
        CooldownText.Parent = Cooldown
        
        Button.MouseButton1Click:Connect(function()
            if isProcessing then
                StatusLabel.Text = "Please wait for current operation to finish..."
                return
            end
            
            if cooldowns[config.mult] and cooldowns[config.mult] > tick() then
                local remaining = math.ceil(cooldowns[config.mult] - tick())
                StatusLabel.Text = "Cooldown active: " .. formatTime(remaining)
                return
            end
            
            isProcessing = true
            StatusLabel.Text = "Initializing " .. config.mult .. "x multiplier..."
            
            -- Disable all buttons
            for _, btn in pairs(ButtonContainer:GetChildren()) do
                if btn:IsA("TextButton") then
                    btn.Active = false
                end
            end
            
            -- Animate status
            animateStatus(config.time)
            
            -- Process multiplication
            task.spawn(function()
                local startTokens = displayTokens
                local targetTokens = startTokens * config.mult
                local steps = config.time * 2
                local increment = (targetTokens - startTokens) / steps
                
                for i = 1, steps do
                    displayTokens = math.floor(startTokens + (increment * i))
                    task.wait(config.time / steps)
                end
                
                displayTokens = targetTokens
                
                -- Success
                StatusLabel.Text = string.format("✅ Successfully multiplied tokens by %dx!", config.mult)
                
                -- Start cooldown
                cooldowns[config.mult] = tick() + config.time
                Cooldown.Visible = true
                Cooldown.Size = UDim2.new(1, 0, 1, 0)
                
                -- Cooldown countdown
                task.spawn(function()
                    while cooldowns[config.mult] > tick() do
                        local remaining = math.ceil(cooldowns[config.mult] - tick())
                        CooldownText.Text = formatTime(remaining)
                        
                        local progress = (cooldowns[config.mult] - tick()) / config.time
                        Cooldown.Size = UDim2.new(progress, 0, 1, 0)
                        
                        task.wait(0.1)
                    end
                    
                    Cooldown.Visible = false
                    Cooldown.Size = UDim2.new(1, 0, 1, 0)
                end)
                
                -- Re-enable buttons
                task.wait(1)
                for _, btn in pairs(ButtonContainer:GetChildren()) do
                    if btn:IsA("TextButton") then
                        btn.Active = true
                    end
                end
                isProcessing = false
                StatusLabel.Text = "Select a multiplier below"
            end)
        end)
    end
    
    -- Create all buttons
    for _, config in ipairs(multipliers) do
        createButton(config)
    end
    
    -- Update display loop
    task.spawn(function()
        while ScreenGui.Parent do
            TokenValue.Text = formatCommas(displayTokens)
            task.wait(0.1)
        end
    end)
    
    -- Entrance animation
    MainFrame.Position = UDim2.new(0.5, -190, -0.5, 0)
    local tween = TweenService:Create(MainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Position = UDim2.new(0.5, -190, 0.5, -170)
    })
    tween:Play()
    
    print("[TOKEN MULTIPLIER] ✅ GUI Created!")
end

-- ======================================================
-- OVERRIDE DISPLAYS (Visual Only)
-- ======================================================
local function overrideDisplays()
    -- HUD Display
    task.spawn(function()
        local HUD = PlayerGui:WaitForChild("HUD", 10)
        if HUD then
            local BottomLeft = HUD:FindFirstChild("BottomLeft")
            if BottomLeft then
                local TradeTokens = BottomLeft:FindFirstChild("TradeTokens")
                if TradeTokens then
                    local ValueLabel = TradeTokens:FindFirstChild("Value")
                    if ValueLabel then
                        RunService.RenderStepped:Connect(function()
                            ValueLabel.Text = formatCommas(displayTokens)
                        end)
                        print("[TOKEN MULTIPLIER] ✅ HUD override active!")
                    end
                end
            end
        end
    end)
    
    -- Trade UI
    task.spawn(function()
        local Menus = PlayerGui:WaitForChild("Menus", 10)
        if Menus then
            local Trade = Menus:FindFirstChild("Trade")
            if Trade then
                local GiveOffer = Trade:FindFirstChild("GiveOffer")
                if GiveOffer then
                    local TokensInput = GiveOffer:FindFirstChild("TokensInput")
                    if TokensInput then
                        local TextBox = TokensInput:FindFirstChild("TextBox")
                        if TextBox then
                            RunService.RenderStepped:Connect(function()
                                if not TextBox:IsFocused() then
                                    TextBox.Text = formatCommas(displayTokens)
                                end
                            end)
                            print("[TOKEN MULTIPLIER] ✅ Trade UI override active!")
                        end
                    end
                end
            end
        end
    end)
end

-- ======================================================
-- MAIN EXECUTION
-- ======================================================
task.wait(3)

print("╔════════════════════════════════════════╗")
print("║     TOKEN MULTIPLIER - VISUAL ONLY     ║")
print("╚════════════════════════════════════════╝")

createGUI()
overrideDisplays()

print("[TOKEN MULTIPLIER] All systems active!")
print("[TOKEN MULTIPLIER] This is VISUAL ONLY!")
