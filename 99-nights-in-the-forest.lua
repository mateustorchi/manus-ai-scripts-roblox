--[[ 
    Script para 99 Noites na Floresta - Versão Final
    Desenvolvido por Manus AI
    
    INSTRUÇÕES DE USO:
    1. Abra o Roblox Studio ou use um executor de scripts
    2. Cole este código em um LocalScript
    3. Execute o script no jogo "99 Noites na Floresta"
    4. Use a interface gráfica para ativar/desativar funcionalidades

    Funcionalidades:
    - Voar (Fly) - Permite voar pelo mapa
    - Pulo Infinito (Infinite Jump) - Pulos ilimitados
    - Velocidade (Speed) - Controle de velocidade de caminhada
    - Iluminação Total (Full Bright) - Remove escuridão do jogo
    - Puxar Itens (Item Puller) - Atrai itens automaticamente
    - Salvar Crianças (Child Saver) - Teleporta crianças para você
]]

-- Serviços do Roblox
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")

-- Variáveis Globais
local player = Players.LocalPlayer
local gui = Instance.new("ScreenGui")
gui.Parent = player:WaitForChild("PlayerGui")
gui.Name = "ManusScriptGUI"
gui.ResetOnSpawn = false

-- Estrutura da GUI Principal
local mainWindow = Instance.new("Frame")
mainWindow.Name = "MainWindow"
mainWindow.Parent = gui
mainWindow.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
mainWindow.BorderColor3 = Color3.fromRGB(100, 100, 100)
mainWindow.BorderSizePixel = 2
mainWindow.Position = UDim2.new(0.5, -200, 0.5, -175)
mainWindow.Size = UDim2.new(0, 400, 0, 350)
mainWindow.Draggable = true
mainWindow.Active = true

-- Adicionar cantos arredondados
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = mainWindow

-- Título da GUI
local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "TitleLabel"
titleLabel.Parent = mainWindow
titleLabel.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.Size = UDim2.new(1, 0, 0, 35)
titleLabel.Text = "🌙 99 Noites na Floresta - Manus AI"
titleLabel.Font = Enum.Font.SourceSansBold
titleLabel.TextSize = 18

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 8)
titleCorner.Parent = titleLabel

-- Botão de Fechar
local closeButton = Instance.new("TextButton")
closeButton.Name = "CloseButton"
closeButton.Parent = titleLabel
closeButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.Position = UDim2.new(1, -30, 0, 5)
closeButton.Size = UDim2.new(0, 25, 0, 25)
closeButton.Text = "X"
closeButton.Font = Enum.Font.SourceSansBold
closeButton.TextSize = 16

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 4)
closeCorner.Parent = closeButton

closeButton.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

-- Função para criar botões estilizados
local function createButton(parent, name, text, position, size)
    local button = Instance.new("TextButton")
    button.Name = name
    button.Parent = parent
    button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.Position = position
    button.Size = size
    button.Text = text
    button.Font = Enum.Font.SourceSans
    button.TextSize = 14
    
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 6)
    buttonCorner.Parent = button
    
    -- Efeito hover
    button.MouseEnter:Connect(function()
        button.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    end)
    
    button.MouseLeave:Connect(function()
        button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    end)
    
    return button
end

-- Botões da Interface
local flyButton = createButton(mainWindow, "FlyButton", "✈️ Voar (OFF)", 
    UDim2.new(0.05, 0, 0.15, 0), UDim2.new(0.4, 0, 0.12, 0))

local infiniteJumpButton = createButton(mainWindow, "InfiniteJumpButton", "🦘 Pulo Infinito (OFF)", 
    UDim2.new(0.55, 0, 0.15, 0), UDim2.new(0.4, 0, 0.12, 0))

local fullBrightButton = createButton(mainWindow, "FullBrightButton", "💡 Full Bright (OFF)", 
    UDim2.new(0.05, 0, 0.32, 0), UDim2.new(0.4, 0, 0.12, 0))

local itemPullerButton = createButton(mainWindow, "ItemPullerButton", "🧲 Puxar Itens (OFF)", 
    UDim2.new(0.55, 0, 0.32, 0), UDim2.new(0.4, 0, 0.12, 0))

local childSaverButton = createButton(mainWindow, "ChildSaverButton", "👶 Salvar Crianças (OFF)", 
    UDim2.new(0.05, 0, 0.75, 0), UDim2.new(0.9, 0, 0.12, 0))

-- Controle de Velocidade
local speedLabel = Instance.new("TextLabel")
speedLabel.Name = "SpeedLabel"
speedLabel.Parent = mainWindow
speedLabel.BackgroundTransparency = 1
speedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
speedLabel.Position = UDim2.new(0.05, 0, 0.49, 0)
speedLabel.Size = UDim2.new(0.9, 0, 0.08, 0)
speedLabel.Text = "🏃 Velocidade: 16"
speedLabel.Font = Enum.Font.SourceSans
speedLabel.TextSize = 16

local speedFrame = Instance.new("Frame")
speedFrame.Name = "SpeedFrame"
speedFrame.Parent = mainWindow
speedFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
speedFrame.Position = UDim2.new(0.05, 0, 0.57, 0)
speedFrame.Size = UDim2.new(0.9, 0, 0.08, 0)

local speedFrameCorner = Instance.new("UICorner")
speedFrameCorner.CornerRadius = UDim.new(0, 6)
speedFrameCorner.Parent = speedFrame

local decreaseSpeedButton = createButton(speedFrame, "DecreaseSpeedButton", "-", 
    UDim2.new(0, 5, 0, 5), UDim2.new(0, 30, 1, -10))

local increaseSpeedButton = createButton(speedFrame, "IncreaseSpeedButton", "+", 
    UDim2.new(1, -35, 0, 5), UDim2.new(0, 30, 1, -10))

-- Variáveis de Estado
local flying = false
local infiniteJump = false
local fullBright = false
local itemPuller = false
local childSaver = false
local speed = 16
local flySpeed = 50

-- Backup das configurações originais
local originalBrightness = Lighting.Brightness
local originalAmbient = Lighting.Ambient

-- Funcionalidade de Voo
flyButton.MouseButton1Click:Connect(function()
    flying = not flying
    if flying then
        flyButton.Text = "✈️ Voar (ON)"
        flyButton.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
    else
        flyButton.Text = "✈️ Voar (OFF)"
        flyButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    end
end)

-- Funcionalidade de Pulo Infinito
infiniteJumpButton.MouseButton1Click:Connect(function()
    infiniteJump = not infiniteJump
    if infiniteJump then
        infiniteJumpButton.Text = "🦘 Pulo Infinito (ON)"
        infiniteJumpButton.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
    else
        infiniteJumpButton.Text = "🦘 Pulo Infinito (OFF)"
        infiniteJumpButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    end
end)

-- Funcionalidade Full Bright
fullBrightButton.MouseButton1Click:Connect(function()
    fullBright = not fullBright
    if fullBright then
        fullBrightButton.Text = "💡 Full Bright (ON)"
        fullBrightButton.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
        Lighting.Brightness = 2
        Lighting.Ambient = Color3.fromRGB(255, 255, 255)
    else
        fullBrightButton.Text = "💡 Full Bright (OFF)"
        fullBrightButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        Lighting.Brightness = originalBrightness
        Lighting.Ambient = originalAmbient
    end
end)

-- Funcionalidade Puxar Itens
itemPullerButton.MouseButton1Click:Connect(function()
    itemPuller = not itemPuller
    if itemPuller then
        itemPullerButton.Text = "🧲 Puxar Itens (ON)"
        itemPullerButton.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
    else
        itemPullerButton.Text = "🧲 Puxar Itens (OFF)"
        itemPullerButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    end
end)

-- Funcionalidade Salvar Crianças
childSaverButton.MouseButton1Click:Connect(function()
    childSaver = not childSaver
    if childSaver then
        childSaverButton.Text = "👶 Salvar Crianças (ON)"
        childSaverButton.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
    else
        childSaverButton.Text = "👶 Salvar Crianças (OFF)"
        childSaverButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    end
end)

-- Controle de Velocidade
local function updateSpeed(newSpeed)
    speed = math.max(8, math.min(200, newSpeed))
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.WalkSpeed = speed
    end
    speedLabel.Text = "🏃 Velocidade: " .. tostring(speed)
end

increaseSpeedButton.MouseButton1Click:Connect(function()
    updateSpeed(speed + 8)
end)

decreaseSpeedButton.MouseButton1Click:Connect(function()
    updateSpeed(speed - 8)
end)

-- Lista de itens e crianças (baseado na pesquisa)
local itemNames = {
    "Wood", "Stone", "Berries", "Mushroom", "Meat", "Stick", "Rock", 
    "Apple", "Carrot", "Fish", "Coal", "Iron", "Gold"
}

local childNames = {
    "Dino Kid", "Kraken Kid", "Squid Kid", "Koala Kid"
}

-- Loop Principal do Script
RunService.RenderStepped:Connect(function()
    if not player.Character then return end
    
    local character = player.Character
    local humanoid = character:FindFirstChild("Humanoid")
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    
    if not humanoid or not rootPart then return end
    
    -- Funcionalidade de Voo
    if flying then
        local bodyVelocity = rootPart:FindFirstChild("BodyVelocity")
        if not bodyVelocity then
            bodyVelocity = Instance.new("BodyVelocity")
            bodyVelocity.MaxForce = Vector3.new(4000, 4000, 4000)
            bodyVelocity.Parent = rootPart
        end
        
        local moveVector = humanoid.MoveDirection
        bodyVelocity.Velocity = Vector3.new(moveVector.X * flySpeed, flySpeed, moveVector.Z * flySpeed)
        
        humanoid.PlatformStand = true
    else
        local bodyVelocity = rootPart:FindFirstChild("BodyVelocity")
        if bodyVelocity then
            bodyVelocity:Destroy()
        end
        humanoid.PlatformStand = false
    end
    
    -- Funcionalidade de Pulo Infinito
    if infiniteJump and humanoid.Jump then
        humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
    
    -- Funcionalidade Puxar Itens
    if itemPuller then
        for _, obj in pairs(workspace:GetChildren()) do
            if table.find(itemNames, obj.Name) and obj:IsA("Part") then
                obj.CFrame = rootPart.CFrame + Vector3.new(0, 2, 0)
            end
        end
    end
    
    -- Funcionalidade Salvar Crianças
    if childSaver then
        for _, obj in pairs(workspace:GetChildren()) do
            if table.find(childNames, obj.Name) and obj:FindFirstChild("HumanoidRootPart") then
                obj.HumanoidRootPart.CFrame = rootPart.CFrame + Vector3.new(0, 0, -3)
            end
        end
    end
end)

-- Aplicar velocidade inicial
player.CharacterAdded:Connect(function(character)
    local humanoid = character:WaitForChild("Humanoid")
    humanoid.WalkSpeed = speed
end)

-- Se o personagem já existe, aplicar velocidade
if player.Character and player.Character:FindFirstChild("Humanoid") then
    player.Character.Humanoid.WalkSpeed = speed
end

print("🌙 Script 99 Noites na Floresta carregado com sucesso!")
print("📱 Interface criada - Arraste a janela para mover")
print("🎮 Desenvolvido por Manus AI")
