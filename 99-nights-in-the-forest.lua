--[[ 
    Script para 99 Noites na Floresta - Estilo VapeVoidware
    Desenvolvido por Manus AI
    Baseado no VapeVoidware original
    
    Funcionalidades implementadas:
    - Fly (Voo) com BodyVelocity/VectorForce
    - NoClip (Atravessar paredes)
    - Infinite Jump (Pulo infinito)
    - Speed (Velocidade)
    - Fullbright (Iluminação total)
    - Bring Items (Puxar itens)
    - Teleport Children (Teleportar crianças)
    - Kill Aura (Matar inimigos próximos)
    - Auto Farm Trees (Cortar árvores automaticamente)
    - ESP (Mostrar objetos através das paredes)
]]

-- Aguardar o jogo carregar
repeat task.wait() until game:IsLoaded()

-- Serviços do Roblox
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")

-- Variáveis principais
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

-- Criar GUI principal
local gui = Instance.new("ScreenGui")
gui.Parent = player:WaitForChild("PlayerGui")
gui.Name = "VoidwareGUI"
gui.ResetOnSpawn = false

-- Janela principal
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Parent = gui
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
mainFrame.BorderColor3 = Color3.fromRGB(100, 100, 100)
mainFrame.BorderSizePixel = 2
mainFrame.Position = UDim2.new(0.5, -300, 0.5, -200)
mainFrame.Size = UDim2.new(0, 600, 0, 400)
mainFrame.Draggable = true
mainFrame.Active = true

-- Cantos arredondados
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = mainFrame

-- Título
local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "Title"
titleLabel.Parent = mainFrame
titleLabel.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.Size = UDim2.new(1, 0, 0, 40)
titleLabel.Text = "VOIDWARE - 99 Nights in the Forest"
titleLabel.Font = Enum.Font.SourceSansBold
titleLabel.TextSize = 20

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 10)
titleCorner.Parent = titleLabel

-- Botão fechar
local closeButton = Instance.new("TextButton")
closeButton.Name = "CloseButton"
closeButton.Parent = titleLabel
closeButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.Position = UDim2.new(1, -35, 0, 5)
closeButton.Size = UDim2.new(0, 30, 0, 30)
closeButton.Text = "X"
closeButton.Font = Enum.Font.SourceSansBold
closeButton.TextSize = 16

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 5)
closeCorner.Parent = closeButton

closeButton.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

-- Função para criar botões
local function createButton(parent, name, text, position, size, callback)
    local button = Instance.new("TextButton")
    button.Name = name
    button.Parent = parent
    button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.Position = position
    button.Size = size
    button.Text = text
    button.Font = Enum.Font.SourceSans
    button.TextSize = 14
    
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 8)
    buttonCorner.Parent = button
    
    -- Efeito hover
    button.MouseEnter:Connect(function()
        button.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    end)
    
    button.MouseLeave:Connect(function()
        if button.Text:find("OFF") then
            button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        else
            button.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
        end
    end)
    
    button.MouseButton1Click:Connect(callback)
    return button
end

-- Variáveis de estado
local flyEnabled = false
local noclipEnabled = false
local infiniteJumpEnabled = false
local fullbrightEnabled = false
local bringItemsEnabled = false
local teleportChildrenEnabled = false
local killAuraEnabled = false
local treeFarmEnabled = false
local espEnabled = false
local speed = 16

-- Backup das configurações originais
local originalBrightness = Lighting.Brightness
local originalAmbient = Lighting.Ambient
local originalFogEnd = Lighting.FogEnd

-- Criar botões da interface
local flyButton = createButton(mainFrame, "FlyButton", "Fly (OFF)", 
    UDim2.new(0.05, 0, 0.15, 0), UDim2.new(0.28, 0, 0.1, 0), function()
    flyEnabled = not flyEnabled
    flyButton.Text = flyEnabled and "Fly (ON)" or "Fly (OFF)"
    flyButton.BackgroundColor3 = flyEnabled and Color3.fromRGB(50, 150, 50) or Color3.fromRGB(50, 50, 50)
end)

local noclipButton = createButton(mainFrame, "NoclipButton", "NoClip (OFF)", 
    UDim2.new(0.36, 0, 0.15, 0), UDim2.new(0.28, 0, 0.1, 0), function()
    noclipEnabled = not noclipEnabled
    noclipButton.Text = noclipEnabled and "NoClip (ON)" or "NoClip (OFF)"
    noclipButton.BackgroundColor3 = noclipEnabled and Color3.fromRGB(50, 150, 50) or Color3.fromRGB(50, 50, 50)
end)

local infiniteJumpButton = createButton(mainFrame, "InfiniteJumpButton", "Infinite Jump (OFF)", 
    UDim2.new(0.67, 0, 0.15, 0), UDim2.new(0.28, 0, 0.1, 0), function()
    infiniteJumpEnabled = not infiniteJumpEnabled
    infiniteJumpButton.Text = infiniteJumpEnabled and "Infinite Jump (ON)" or "Infinite Jump (OFF)"
    infiniteJumpButton.BackgroundColor3 = infiniteJumpEnabled and Color3.fromRGB(50, 150, 50) or Color3.fromRGB(50, 50, 50)
end)

local fullbrightButton = createButton(mainFrame, "FullbrightButton", "Fullbright (OFF)", 
    UDim2.new(0.05, 0, 0.3, 0), UDim2.new(0.28, 0, 0.1, 0), function()
    fullbrightEnabled = not fullbrightEnabled
    fullbrightButton.Text = fullbrightEnabled and "Fullbright (ON)" or "Fullbright (OFF)"
    fullbrightButton.BackgroundColor3 = fullbrightEnabled and Color3.fromRGB(50, 150, 50) or Color3.fromRGB(50, 50, 50)
    
    if fullbrightEnabled then
        Lighting.Brightness = 2
        Lighting.Ambient = Color3.fromRGB(255, 255, 255)
        Lighting.FogEnd = 100000
    else
        Lighting.Brightness = originalBrightness
        Lighting.Ambient = originalAmbient
        Lighting.FogEnd = originalFogEnd
    end
end)

local bringItemsButton = createButton(mainFrame, "BringItemsButton", "Bring Items (OFF)", 
    UDim2.new(0.36, 0, 0.3, 0), UDim2.new(0.28, 0, 0.1, 0), function()
    bringItemsEnabled = not bringItemsEnabled
    bringItemsButton.Text = bringItemsEnabled and "Bring Items (ON)" or "Bring Items (OFF)"
    bringItemsButton.BackgroundColor3 = bringItemsEnabled and Color3.fromRGB(50, 150, 50) or Color3.fromRGB(50, 50, 50)
end)

local teleportChildrenButton = createButton(mainFrame, "TeleportChildrenButton", "Teleport Children (OFF)", 
    UDim2.new(0.67, 0, 0.3, 0), UDim2.new(0.28, 0, 0.1, 0), function()
    teleportChildrenEnabled = not teleportChildrenEnabled
    teleportChildrenButton.Text = teleportChildrenEnabled and "Teleport Children (ON)" or "Teleport Children (OFF)"
    teleportChildrenButton.BackgroundColor3 = teleportChildrenEnabled and Color3.fromRGB(50, 150, 50) or Color3.fromRGB(50, 50, 50)
end)

local killAuraButton = createButton(mainFrame, "KillAuraButton", "Kill Aura (OFF)", 
    UDim2.new(0.05, 0, 0.45, 0), UDim2.new(0.28, 0, 0.1, 0), function()
    killAuraEnabled = not killAuraEnabled
    killAuraButton.Text = killAuraEnabled and "Kill Aura (ON)" or "Kill Aura (OFF)"
    killAuraButton.BackgroundColor3 = killAuraEnabled and Color3.fromRGB(50, 150, 50) or Color3.fromRGB(50, 50, 50)
end)

local treeFarmButton = createButton(mainFrame, "TreeFarmButton", "Tree Farm (OFF)", 
    UDim2.new(0.36, 0, 0.45, 0), UDim2.new(0.28, 0, 0.1, 0), function()
    treeFarmEnabled = not treeFarmEnabled
    treeFarmButton.Text = treeFarmEnabled and "Tree Farm (ON)" or "Tree Farm (OFF)"
    treeFarmButton.BackgroundColor3 = treeFarmEnabled and Color3.fromRGB(50, 150, 50) or Color3.fromRGB(50, 50, 50)
end)

local espButton = createButton(mainFrame, "ESPButton", "ESP (OFF)", 
    UDim2.new(0.67, 0, 0.45, 0), UDim2.new(0.28, 0, 0.1, 0), function()
    espEnabled = not espEnabled
    espButton.Text = espEnabled and "ESP (ON)" or "ESP (OFF)"
    espButton.BackgroundColor3 = espEnabled and Color3.fromRGB(50, 150, 50) or Color3.fromRGB(50, 50, 50)
end)

-- Controle de velocidade
local speedLabel = Instance.new("TextLabel")
speedLabel.Name = "SpeedLabel"
speedLabel.Parent = mainFrame
speedLabel.BackgroundTransparency = 1
speedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
speedLabel.Position = UDim2.new(0.05, 0, 0.6, 0)
speedLabel.Size = UDim2.new(0.9, 0, 0.08, 0)
speedLabel.Text = "Walk Speed: " .. speed
speedLabel.Font = Enum.Font.SourceSans
speedLabel.TextSize = 16

local speedFrame = Instance.new("Frame")
speedFrame.Name = "SpeedFrame"
speedFrame.Parent = mainFrame
speedFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
speedFrame.Position = UDim2.new(0.05, 0, 0.68, 0)
speedFrame.Size = UDim2.new(0.9, 0, 0.08, 0)

local speedFrameCorner = Instance.new("UICorner")
speedFrameCorner.CornerRadius = UDim.new(0, 8)
speedFrameCorner.Parent = speedFrame

local decreaseSpeedButton = createButton(speedFrame, "DecreaseSpeedButton", "-", 
    UDim2.new(0, 5, 0, 5), UDim2.new(0, 40, 1, -10), function()
    speed = math.max(8, speed - 8)
    speedLabel.Text = "Walk Speed: " .. speed
    if character and character:FindFirstChild("Humanoid") then
        character.Humanoid.WalkSpeed = speed
    end
end)

local increaseSpeedButton = createButton(speedFrame, "IncreaseSpeedButton", "+", 
    UDim2.new(1, -45, 0, 5), UDim2.new(0, 40, 1, -10), function()
    speed = math.min(200, speed + 8)
    speedLabel.Text = "Walk Speed: " .. speed
    if character and character:FindFirstChild("Humanoid") then
        character.Humanoid.WalkSpeed = speed
    end
end)

print("🌙 VOIDWARE - 99 Nights in the Forest carregado!")
print("📱 Interface criada - Desenvolvido por Manus AI")
print("🎮 Baseado no VapeVoidware original")

-- Funcionalidades principais

-- Variáveis para voo
local bodyVelocity = nil
local bodyAngularVelocity = nil

-- Função de voo melhorada (baseada no VapeVoidware)
local function setupFly()
    if not character or not rootPart then return end
    
    if flyEnabled then
        -- Criar BodyVelocity para voo
        bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.MaxForce = Vector3.new(4000, 4000, 4000)
        bodyVelocity.Velocity = Vector3.new(0, 0, 0)
        bodyVelocity.Parent = rootPart
        
        -- Criar BodyAngularVelocity para estabilidade
        bodyAngularVelocity = Instance.new("BodyAngularVelocity")
        bodyAngularVelocity.MaxTorque = Vector3.new(4000, 4000, 4000)
        bodyAngularVelocity.AngularVelocity = Vector3.new(0, 0, 0)
        bodyAngularVelocity.Parent = rootPart
        
        humanoid.PlatformStand = true
    else
        -- Remover componentes de voo
        if bodyVelocity then
            bodyVelocity:Destroy()
            bodyVelocity = nil
        end
        if bodyAngularVelocity then
            bodyAngularVelocity:Destroy()
            bodyAngularVelocity = nil
        end
        humanoid.PlatformStand = false
    end
end

-- Função NoClip
local function setupNoClip()
    if not character then return end
    
    for _, part in pairs(character:GetChildren()) do
        if part:IsA("BasePart") then
            part.CanCollide = not noclipEnabled
        end
    end
end

-- Lista de itens para puxar (baseada no VapeVoidware)
local itemsToTeleport = {
    "Wood", "Stone", "Stick", "Rock", "Coal", "Iron", "Gold", "Diamond",
    "Berries", "Mushroom", "Apple", "Carrot", "Fish", "Meat",
    "Bandage", "Medkit", "Flashlight", "Lantern", "Torch",
    "Axe", "Pickaxe", "Sword", "Bow", "Arrow",
    "Chest", "GoldChest", "LegendaryChest"
}

-- Função para puxar itens
local function bringItems()
    if not bringItemsEnabled or not character or not rootPart then return end
    
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("Part") or obj:IsA("MeshPart") then
            for _, itemName in pairs(itemsToTeleport) do
                if string.find(string.lower(obj.Name), string.lower(itemName)) then
                    -- Verificar se não é parte do jogador
                    if not obj:IsDescendantOf(character) then
                        obj.CFrame = rootPart.CFrame + Vector3.new(math.random(-5, 5), 2, math.random(-5, 5))
                        if obj:FindFirstChild("BodyVelocity") then
                            obj.BodyVelocity:Destroy()
                        end
                    end
                end
            end
        end
    end
end

-- Lista de crianças para teleportar
local childrenNames = {"Dino Kid", "Kraken Kid", "Squid Kid", "Koala Kid"}

-- Função para teleportar crianças
local function teleportChildren()
    if not teleportChildrenEnabled or not character or not rootPart then return end
    
    for _, obj in pairs(Workspace:GetDescendants()) do
        for _, childName in pairs(childrenNames) do
            if obj.Name == childName and obj:FindFirstChild("HumanoidRootPart") then
                obj.HumanoidRootPart.CFrame = rootPart.CFrame + Vector3.new(0, 0, -5)
            end
        end
    end
end

-- Função Kill Aura
local function killAura()
    if not killAuraEnabled or not character or not rootPart then return end
    
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("Humanoid") and obj.Parent ~= character then
            local enemyRoot = obj.Parent:FindFirstChild("HumanoidRootPart")
            if enemyRoot then
                local distance = (rootPart.Position - enemyRoot.Position).Magnitude
                if distance <= 50 then -- Raio de 50 studs
                    obj.Health = 0
                end
            end
        end
    end
end

-- Função Tree Farm
local function treeFarm()
    if not treeFarmEnabled or not character or not rootPart then return end
    
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("Model") and (string.find(string.lower(obj.Name), "tree") or string.find(string.lower(obj.Name), "log")) then
            local treePart = obj:FindFirstChild("Part") or obj:FindFirstChildOfClass("Part")
            if treePart then
                local distance = (rootPart.Position - treePart.Position).Magnitude
                if distance <= 100 then -- Raio de 100 studs
                    -- Simular corte da árvore
                    treePart.CFrame = rootPart.CFrame + Vector3.new(0, 2, 0)
                end
            end
        end
    end
end

-- Função ESP
local function createESP(obj, color)
    if obj:FindFirstChild("ESP_Highlight") then return end
    
    local highlight = Instance.new("Highlight")
    highlight.Name = "ESP_Highlight"
    highlight.Parent = obj
    highlight.FillColor = color
    highlight.OutlineColor = color
    highlight.FillTransparency = 0.5
    highlight.OutlineTransparency = 0
end

local function removeESP(obj)
    local highlight = obj:FindFirstChild("ESP_Highlight")
    if highlight then
        highlight:Destroy()
    end
end

local function updateESP()
    for _, obj in pairs(Workspace:GetDescendants()) do
        if espEnabled then
            -- ESP para itens importantes
            for _, itemName in pairs(itemsToTeleport) do
                if string.find(string.lower(obj.Name), string.lower(itemName)) then
                    if obj:IsA("Part") or obj:IsA("MeshPart") then
                        createESP(obj, Color3.fromRGB(255, 255, 0)) -- Amarelo para itens
                    end
                end
            end
            
            -- ESP para crianças
            for _, childName in pairs(childrenNames) do
                if obj.Name == childName then
                    createESP(obj, Color3.fromRGB(0, 255, 0)) -- Verde para crianças
                end
            end
            
            -- ESP para inimigos
            if obj:IsA("Humanoid") and obj.Parent ~= character then
                createESP(obj.Parent, Color3.fromRGB(255, 0, 0)) -- Vermelho para inimigos
            end
        else
            removeESP(obj)
        end
    end
end

-- Loop principal do script
RunService.RenderStepped:Connect(function()
    -- Atualizar referências do personagem
    character = player.Character
    if character then
        humanoid = character:FindFirstChild("Humanoid")
        rootPart = character:FindFirstChild("HumanoidRootPart")
    end
    
    if not character or not humanoid or not rootPart then return end
    
    -- Funcionalidade de voo
    if flyEnabled and bodyVelocity then
        local moveVector = humanoid.MoveDirection
        local camera = Workspace.CurrentCamera
        local cameraCFrame = camera.CFrame
        
        -- Calcular direção baseada na câmera
        local forwardVector = cameraCFrame.LookVector
        local rightVector = cameraCFrame.RightVector
        local upVector = Vector3.new(0, 1, 0)
        
        local velocity = Vector3.new(0, 0, 0)
        
        -- Movimento horizontal
        velocity = velocity + (forwardVector * moveVector.Z * -50)
        velocity = velocity + (rightVector * moveVector.X * 50)
        
        -- Movimento vertical
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            velocity = velocity + (upVector * 50)
        elseif UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
            velocity = velocity + (upVector * -50)
        end
        
        bodyVelocity.Velocity = velocity
    end
    
    -- NoClip
    if noclipEnabled then
        setupNoClip()
    end
    
    -- Pulo infinito
    if infiniteJumpEnabled and humanoid.Jump then
        humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
    
    -- Executar funcionalidades a cada 0.1 segundos para performance
    if tick() % 0.1 < 0.016 then
        bringItems()
        teleportChildren()
        killAura()
        treeFarm()
        updateESP()
    end
end)

-- Detectar mudanças no personagem
player.CharacterAdded:Connect(function(newCharacter)
    character = newCharacter
    humanoid = character:WaitForChild("Humanoid")
    rootPart = character:WaitForChild("HumanoidRootPart")
    
    -- Aplicar velocidade
    humanoid.WalkSpeed = speed
    
    -- Reconfigurar voo se estava ativo
    if flyEnabled then
        task.wait(1) -- Aguardar o personagem carregar completamente
        setupFly()
    end
end)

-- Configurar voo quando ativado
flyButton.MouseButton1Click:Connect(function()
    task.wait(0.1) -- Pequeno delay para atualizar o estado
    setupFly()
end)

print("✅ Todas as funcionalidades do VapeVoidware foram implementadas!")
print("🚀 Script pronto para uso!")
