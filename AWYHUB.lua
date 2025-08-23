local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

-- Status
local GodMode, AuraDamage = false, false
local AuraDamagePercent, AuraDamageRadius = 5, 40 -- valores máximos fixos

-- Funções
local function applyGodMode()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        local h = LocalPlayer.Character.Humanoid
        h.MaxHealth = math.huge
        h.Health = h.MaxHealth
    end
end

local function applyAuraDamage()
    if not LocalPlayer.Character then return end
    local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not root then return end
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Humanoid") then
            local hrp = p.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                local dist = (hrp.Position - root.Position).Magnitude
                if dist <= AuraDamageRadius then
                    local dmg = p.Character.Humanoid.MaxHealth * (AuraDamagePercent/100)
                    p.Character.Humanoid:TakeDamage(dmg)
                end
            end
        end
    end
end

-- Loop leve para AuraDamage
spawn(function()
    while true do
        if AuraDamage then
            applyAuraDamage()
        end
        wait(0.25) -- roda 4 vezes por segundo
    end
end)

-- GUI
local ScreenGui = Instance.new("ScreenGui", PlayerGui)
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 260, 0, 130)
MainFrame.Position = UDim2.new(0.5,0,0.5,0)
MainFrame.AnchorPoint = Vector2.new(0.5,0.5)
MainFrame.BackgroundColor3 = Color3.fromRGB(20,20,20)
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Visible = true

local UIStroke = Instance.new("UIStroke", MainFrame)
UIStroke.Color = Color3.fromRGB(255,255,255)
UIStroke.Thickness = 1

local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1,0,0,30)
Title.Position = UDim2.new(0,0,0,0)
Title.BackgroundTransparency = 1
Title.Text = "AWY SCRIPTS"
Title.TextColor3 = Color3.fromRGB(255,255,255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 20

local MinButton = Instance.new("TextButton", MainFrame)
MinButton.Size = UDim2.new(0,35,0,30)
MinButton.Position = UDim2.new(1,-40,0,0)
MinButton.Text = "_"
MinButton.TextColor3 = Color3.fromRGB(255,255,255)
MinButton.BackgroundColor3 = Color3.fromRGB(60,60,60)

local isMinimized = false
MinButton.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    local newSize = isMinimized and UDim2.new(0,160,0,40) or UDim2.new(0,260,0,130)
    TweenService:Create(MainFrame,TweenInfo.new(0.3,Enum.EasingStyle.Quad),{Size=newSize}):Play()
    Title.Text = isMinimized and "AWY SCRIPTS (Clique para Expandir)" or "AWY SCRIPTS"
end)

-- Função de arrastar
local function makeDraggable(frame)
    local dragging, dragInput, startPos, startMouse = false,nil,frame.Position,Vector2.new()
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
            dragging = true
            dragInput = input
            startPos = frame.Position
            startMouse = input.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging=false end
            end)
        end
    end)
    frame.InputChanged:Connect(function(input)
        if input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input==dragInput then
            local delta = input.Position - startMouse
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset+delta.X, startPos.Y.Scale, startPos.Y.Offset+delta.Y)
        end
    end)
end
makeDraggable(MainFrame)

-- Premium effect
local function applyPremiumEffect(uiElement)
    local glow = Instance.new("UIGradient", uiElement)
    glow.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(0,255,255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(0,180,255))
    }
    glow.Rotation = 45
    local shadow = Instance.new("UIPadding", uiElement)
    shadow.PaddingTop = UDim.new(0,2)
    shadow.PaddingBottom = UDim.new(0,2)
    shadow.PaddingLeft = UDim.new(0,2)
    shadow.PaddingRight = UDim.new(0,2)
    local uicorner = Instance.new("UICorner", uiElement)
    uicorner.CornerRadius = UDim.new(0,6)
end

-- Toggles
local function createToggle(name,posY,callback)
    local btn = Instance.new("TextButton",MainFrame)
    btn.Size = UDim2.new(0,220,0,35)
    btn.Position = UDim2.new(0,20,0,posY)
    btn.Text = name..": OFF"
    btn.BackgroundColor3 = Color3.fromRGB(150,0,0)
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 16
    btn.AutoButtonColor = false
    applyPremiumEffect(btn)
    local state=false
    local function updateColor()
        local color = state and Color3.fromRGB(0,180,0) or Color3.fromRGB(150,0,0)
        TweenService:Create(btn,TweenInfo.new(0.2),{BackgroundColor3=color}):Play()
    end
    btn.MouseEnter:Connect(function()
        TweenService:Create(btn,TweenInfo.new(0.15),{BackgroundColor3=Color3.fromRGB(180,30,30)}):Play()
    end)
    btn.MouseLeave:Connect(function() updateColor() end)
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.Text = name..(state and ": ON" or ": OFF")
        updateColor()
        callback(state)
    end)
end

createToggle("God Mode",50,function(s)
    GodMode=s
    if s then applyGodMode() end
end)

createToggle("Aura Damage",95,function(s)
    AuraDamage=s
end)