--[[ 
    VOIDWARE - 99 Nights in the Forest
    Versão Otimizada por Manus AI
    Baseado no VapeVoidware original
]]

-- Aguardar carregamento
repeat task.wait() until game:IsLoaded()

-- Serviços
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")

-- Variáveis principais
local player = Players.LocalPlayer
local mouse = player:GetMouse()

-- Estados das funcionalidades
local states = {
    fly = false,
    noclip = false,
    infiniteJump = false,
    fullbright = false,
    bringItems = false,
    teleportChildren = false,
    killAura = false,
    treeFarm = false,
    esp = false,
    speed = 16
}

-- Backup das configurações originais
local originalSettings = {
    brightness = Lighting.Brightness,
    ambient = Lighting.Ambient,
    fogEnd = Lighting.FogEnd
}

-- Criar GUI
local gui = Instance.new("ScreenGui")
gui.Name = "VoidwareGUI"
gui.Parent = player:WaitForChild("PlayerGui")
gui.ResetOnSpawn = false

-- Frame principal
local main = Instance.new("Frame")
main.Name = "Main"
main.Parent = gui
main.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
main.BorderSizePixel = 0
main.Position = UDim2.new(0.5, -250, 0.5, -175)
main.Size = UDim2.new(0, 500, 0, 350)
main.Draggable = true
main.Active = true

-- Cantos arredondados
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = main

-- Título
local title = Instance.new("TextLabel")
title.Name = "Title"
title.Parent = main
title.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
title.Size = UDim2.new(1, 0, 0, 35)
title.Font = Enum.Font.SourceSansBold
title.Text = "VOIDWARE - 99 Nights in the Forest"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 16

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 8)
titleCorner.Parent = title

-- Botão fechar
local close = Instance.new("TextButton")
close.Name = "Close"
close.Parent = title
close.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
close.Position = UDim2.new(1, -30, 0, 2.5)
close.Size = UDim2.new(0, 25, 0, 25)
close.Font = Enum.Font.SourceSansBold
close.Text = "X"
close.TextColor3 = Color3.fromRGB(255, 255, 255)
close.TextSize = 14

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 4)
closeCorner.Parent = close

close.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

-- Função para criar botões
local function createButton(name, text, position, callback)
    local button = Instance.new("TextButton")
    button.Name = name
    button.Parent = main
    button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    button.Position = position
    button.Size = UDim2.new(0, 140, 0, 30)
    button.Font = Enum.Font.SourceSans
    button.Text = text
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextSize = 14
    
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 6)
    buttonCorner.Parent = button
    
    button.MouseButton1Click:Connect(callback)
    return button
end

-- Criar botões
local flyBtn = createButton("Fly", "Fly [OFF]", UDim2.new(0, 20, 0, 50), function()
    states.fly = not states.fly
    flyBtn.Text = "Fly [" .. (states.fly and "ON" or "OFF") .. "]"
    flyBtn.BackgroundColor3 = states.fly and Color3.fromRGB(50, 150, 50) or Color3.fromRGB(60, 60, 60)
end)

local noclipBtn = createButton("NoClip", "NoClip [OFF]", UDim2.new(0, 180, 0, 50), function()
    states.noclip = not states.noclip
    noclipBtn.Text = "NoClip [" .. (states.noclip and "ON" or "OFF") .. "]"
    noclipBtn.BackgroundColor3 = states.noclip and Color3.fromRGB(50, 150, 50) or Color3.fromRGB(60, 60, 60)
end)

local jumpBtn = createButton("InfJump", "Inf Jump [OFF]", UDim2.new(0, 340, 0, 50), function()
    states.infiniteJump = not states.infiniteJump
    jumpBtn.Text = "Inf Jump [" .. (states.infiniteJump and "ON" or "OFF") .. "]"
    jumpBtn.BackgroundColor3 = states.infiniteJump and Color3.fromRGB(50, 150, 50) or Color3.fromRGB(60, 60, 60)
end)

local brightBtn = createButton("Fullbright", "Fullbright [OFF]", UDim2.new(0, 20, 0, 90), function()
    states.fullbright = not states.fullbright
    brightBtn.Text = "Fullbright [" .. (states.fullbright and "ON" or "OFF") .. "]"
    brightBtn.BackgroundColor3 = states.fullbright and Color3.fromRGB(50, 150, 50) or Color3.fromRGB(60, 60, 60)
    
    if states.fullbright then
        Lighting.Brightness = 2
        Lighting.Ambient = Color3.fromRGB(255, 255, 255)
        Lighting.FogEnd = 100000
    else
        Lighting.Brightness = originalSettings.brightness
        Lighting.Ambient = originalSettings.ambient
        Lighting.FogEnd = originalSettings.fogEnd
    end
end)

local itemsBtn = createButton("BringItems", "Bring Items [OFF]", UDim2.new(0, 180, 0, 90), function()
    states.bringItems = not states.bringItems
    itemsBtn.Text = "Bring Items [" .. (states.bringItems and "ON" or "OFF") .. "]"
    itemsBtn.BackgroundColor3 = states.bringItems and Color3.fromRGB(50, 150, 50) or Color3.fromRGB(60, 60, 60)
end)

local childrenBtn = createButton("TpChildren", "Tp Children [OFF]", UDim2.new(0, 340, 0, 90), function()
    states.teleportChildren = not states.teleportChildren
    childrenBtn.Text = "Tp Children [" .. (states.teleportChildren and "ON" or "OFF") .. "]"
    childrenBtn.BackgroundColor3 = states.teleportChildren and Color3.fromRGB(50, 150, 50) or Color3.fromRGB(60, 60, 60)
end)

local killBtn = createButton("KillAura", "Kill Aura [OFF]", UDim2.new(0, 20, 0, 130), function()
    states.killAura = not states.killAura
    killBtn.Text = "Kill Aura [" .. (states.killAura and "ON" or "OFF") .. "]"
    killBtn.BackgroundColor3 = states.killAura and Color3.fromRGB(50, 150, 50) or Color3.fromRGB(60, 60, 60)
end)

local treeBtn = createButton("TreeFarm", "Tree Farm [OFF]", UDim2.new(0, 180, 0, 130), function()
    states.treeFarm = not states.treeFarm
    treeBtn.Text = "Tree Farm [" .. (states.treeFarm and "ON" or "OFF") .. "]"
    treeBtn.BackgroundColor3 = states.treeFarm and Color3.fromRGB(50, 150, 50) or Color3.fromRGB(60, 60, 60)
end)

local espBtn = createButton("ESP", "ESP [OFF]", UDim2.new(0, 340, 0, 130), function()
    states.esp = not states.esp
    espBtn.Text = "ESP [" .. (states.esp and "ON" or "OFF") .. "]"
    espBtn.BackgroundColor3 = states.esp and Color3.fromRGB(50, 150, 50) or Color3.fromRGB(60, 60, 60)
end)

-- Controle de velocidade
local speedLabel = Instance.new("TextLabel")
speedLabel.Parent = main
speedLabel.BackgroundTransparency = 1
speedLabel.Position = UDim2.new(0, 20, 0, 180)
speedLabel.Size = UDim2.new(0, 460, 0, 25)
speedLabel.Font = Enum.Font.SourceSans
speedLabel.Text = "Walk Speed: " .. states.speed
speedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
speedLabel.TextSize = 14

local speedDown = createButton("SpeedDown", "-", UDim2.new(0, 20, 0, 210), function()
    states.speed = math.max(8, states.speed - 8)
    speedLabel.Text = "Walk Speed: " .. states.speed
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.WalkSpeed = states.speed
    end
end)
speedDown.Size = UDim2.new(0, 40, 0, 30)

local speedUp = createButton("SpeedUp", "+", UDim2.new(0, 440, 0, 210), function()
    states.speed = math.min(200, states.speed + 8)
    speedLabel.Text = "Walk Speed: " .. states.speed
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.WalkSpeed = states.speed
    end
end)
speedUp.Size = UDim2.new(0, 40, 0, 30)

-- Lista otimizada de itens importantes
local importantItems = {
    "Wood", "Stone", "Coal", "Iron", "Gold", "Diamond",
    "Bandage", "Medkit", "Flashlight", "Axe", "Pickaxe"
}

-- Lista de crianças
local children = {"Dino Kid", "Kraken Kid", "Squid Kid", "Koala Kid"}

-- Variáveis para voo
local bodyVelocity = nil
local bodyAngularVelocity = nil

-- Função de voo otimizada
local function handleFly()
    local character = player.Character
    if not character then return end
    
    local humanoid = character:FindFirstChild("Humanoid")
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoid or not rootPart then return end
    
    if states.fly then
        if not bodyVelocity then
            bodyVelocity = Instance.new("BodyVelocity")
            bodyVelocity.MaxForce = Vector3.new(4000, 4000, 4000)
            bodyVelocity.Parent = rootPart
            
            bodyAngularVelocity = Instance.new("BodyAngularVelocity")
            bodyAngularVelocity.MaxTorque = Vector3.new(4000, 4000, 4000)
            bodyAngularVelocity.AngularVelocity = Vector3.new(0, 0, 0)
            bodyAngularVelocity.Parent = rootPart
            
            humanoid.PlatformStand = true
        end
        
        local camera = Workspace.CurrentCamera
        local moveVector = humanoid.MoveDirection
        local velocity = Vector3.new(0, 0, 0)
        
        -- Movimento baseado na câmera
        if moveVector.Magnitude > 0 then
            velocity = camera.CFrame.LookVector * moveVector.Z * -50
            velocity = velocity + camera.CFrame.RightVector * moveVector.X * 50
        end
        
        -- Controles verticais
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            velocity = velocity + Vector3.new(0, 50, 0)
        elseif UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
            velocity = velocity + Vector3.new(0, -50, 0)
        end
        
        bodyVelocity.Velocity = velocity
    else
        if bodyVelocity then
            bodyVelocity:Destroy()
            bodyVelocity = nil
        end
        if bodyAngularVelocity then
            bodyAngularVelocity:Destroy()
            bodyAngularVelocity = nil
        end
        if humanoid then
            humanoid.PlatformStand = false
        end
    end
end

-- Função NoClip otimizada
local function handleNoClip()
    local character = player.Character
    if not character then return end
    
    for _, part in pairs(character:GetChildren()) do
        if part:IsA("BasePart") then
            part.CanCollide = not states.noclip
        end
    end
end

-- Função para puxar itens (otimizada)
local function handleBringItems()
    if not states.bringItems then return end
    
    local character = player.Character
    if not character then return end
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return end
    
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("Part") and not obj:IsDescendantOf(character) then
            for _, itemName in pairs(importantItems) do
                if string.find(string.lower(obj.Name), string.lower(itemName)) then
                    local distance = (rootPart.Position - obj.Position).Magnitude
                    if distance < 200 then -- Só puxar itens próximos
                        obj.CFrame = rootPart.CFrame + Vector3.new(math.random(-3, 3), 2, math.random(-3, 3))
                    end
                    break
                end
            end
        end
    end
end

-- Função para teleportar crianças
local function handleTeleportChildren()
    if not states.teleportChildren then return end
    
    local character = player.Character
    if not character then return end
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return end
    
    for _, obj in pairs(Workspace:GetDescendants()) do
        for _, childName in pairs(children) do
            if obj.Name == childName and obj:FindFirstChild("HumanoidRootPart") then
                obj.HumanoidRootPart.CFrame = rootPart.CFrame + Vector3.new(0, 0, -5)
            end
        end
    end
end

-- Loop principal otimizado
local lastUpdate = 0
RunService.Heartbeat:Connect(function()
    local now = tick()
    
    -- Executar voo a cada frame para suavidade
    handleFly()
    
    -- Executar NoClip a cada frame
    if states.noclip then
        handleNoClip()
    end
    
    -- Pulo infinito
    if states.infiniteJump then
        local character = player.Character
        if character then
            local humanoid = character:FindFirstChild("Humanoid")
            if humanoid and humanoid.Jump then
                humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end
    end
    
    -- Executar outras funções a cada 0.5 segundos para performance
    if now - lastUpdate >= 0.5 then
        lastUpdate = now
        handleBringItems()
        handleTeleportChildren()
        
        -- Kill Aura simplificado
        if states.killAura then
            local character = player.Character
            if character then
                local rootPart = character:FindFirstChild("HumanoidRootPart")
                if rootPart then
                    for _, obj in pairs(Workspace:GetDescendants()) do
                        if obj:IsA("Humanoid") and obj.Parent ~= character then
                            local enemyRoot = obj.Parent:FindFirstChild("HumanoidRootPart")
                            if enemyRoot then
                                local distance = (rootPart.Position - enemyRoot.Position).Magnitude
                                if distance <= 30 then
                                    obj.Health = 0
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end)

-- Aplicar velocidade quando personagem spawnar
player.CharacterAdded:Connect(function(character)
    task.wait(1)
    local humanoid = character:FindFirstChild("Humanoid")
    if humanoid then
        humanoid.WalkSpeed = states.speed
    end
end)

print("✅ VOIDWARE carregado com sucesso!")
print("🎮 Versão otimizada - Desenvolvido por Manus AI")
