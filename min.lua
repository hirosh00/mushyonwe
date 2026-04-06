-- [[ SISTEMA DE SEGURANÇA S7xhud ]] --
local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- LISTAS DE PERMISSÃO (IDs Autorizados)
local CREATOR_IDS = {2959681, 9216315975, 88189937} 
local ADMIN_IDS_RGB = {1870899605, 7668266040}
local VIP_IDS_BW = {648989434, 9987756245}

local function checkAuth(id)
    for _, v in pairs(CREATOR_IDS) do if v == id then return true end end
    for _, v in pairs(ADMIN_IDS_RGB) do if v == id then return true end end
    for _, v in pairs(VIP_IDS_BW) do if v == id then return true end end
    return false
end

if not checkAuth(player.UserId) then return end

-- [[ SERVIÇOS ]] --
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TeleportService = game:GetService("TeleportService")
local TweenService = game:GetService("TweenService")
local camera = workspace.CurrentCamera
local remoteEvent = ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Events"):WaitForChild("RemoteEvent")

local targetParent = player:WaitForChild("PlayerGui")
local ScreenGui = Instance.new("ScreenGui", targetParent)
ScreenGui.Name = "S7xhud_MobileV33"
ScreenGui.ResetOnSpawn = false

-----------------------------------------
--- MENSAGEM DE CARREGAMENTO (20s)
-----------------------------------------
local LoadLabel = Instance.new("TextLabel", ScreenGui)
LoadLabel.Size = UDim2.new(0, 300, 0, 50)
LoadLabel.Position = UDim2.new(0.5, -150, 0.5, -25)
LoadLabel.BackgroundTransparency = 1
LoadLabel.Text = "CARREGANDO PAINEL, 20s"
LoadLabel.TextColor3 = Color3.fromRGB(170, 0, 255) -- Roxo
LoadLabel.Font = Enum.Font.GothamBold
LoadLabel.TextSize = 25
LoadLabel.ZIndex = 100

task.delay(20, function()
    LoadLabel:Destroy()
end)

-----------------------------------------
--- FUNÇÃO PARA MOVER PAINÉIS (DRAGGABLE)
-----------------------------------------
local function makeDraggable(frame)
    local dragging, dragInput, dragStart, startPos
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

-----------------------------------------
--- PAINEL PRINCIPAL (FLUTUANTE)
-----------------------------------------
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
MainFrame.Position = UDim2.new(0.5, -100, 0.5, -190)
MainFrame.Size = UDim2.new(0, 200, 0, 380)
MainFrame.Visible = false
MainFrame.Active = true
Instance.new("UICorner", MainFrame)
makeDraggable(MainFrame) -- Habilita o movimento

local Title = Instance.new("TextLabel", MainFrame)
Title.Text = "S7xhud"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.BackgroundTransparency = 1
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 22

local function createButton(text, pos)
    local btn = Instance.new("TextButton", MainFrame)
    btn.Text = text
    btn.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
    btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    btn.Position = pos
    btn.Size = UDim2.new(0.85, 0, 0, 35)
    btn.Font = Enum.Font.GothamSemibold
    btn.TextSize = 13
    Instance.new("UICorner", btn)
    return btn
end

-- Botões Originais (Sem alterações de funcionalidade)
local SpamBtn   = createButton("SPAM OVO [OFF]", UDim2.new(0.075, 0, 0.12, 0))
local FarmBtn   = createButton("PEGAR OVOS [OFF]", UDim2.new(0.075, 0, 0.24, 0))
local EspBtn    = createButton("ESP [OFF]", UDim2.new(0.075, 0, 0.36, 0))
local TpBtn     = createButton("ClickTP [OFF]", UDim2.new(0.075, 0, 0.48, 0))
local ReBtn     = createButton("REJOIN", UDim2.new(0.075, 0, 0.60, 0))
local SpectBtn  = createButton("SPECT", UDim2.new(0.075, 0, 0.72, 0))
local AntiAdmBtn = createButton("AntiADM: OFF", UDim2.new(0.075, 0, 0.84, 0))

-----------------------------------------
--- MENU SPECTATE (FLUTUANTE)
-----------------------------------------
local SpectateFrame = Instance.new("Frame", ScreenGui)
SpectateFrame.Size = UDim2.new(0, 200, 0, 340)
SpectateFrame.Position = UDim2.new(0.5, 110, 0.5, -150)
SpectateFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
SpectateFrame.Visible = false
SpectateFrame.Active = true
Instance.new("UICorner", SpectateFrame)
makeDraggable(SpectateFrame) -- Habilita o movimento

local spectatingPlayer = nil
local SearchBox = Instance.new("TextBox", SpectateFrame)
SearchBox.Size = UDim2.new(0.9, 0, 0, 30)
SearchBox.Position = UDim2.new(0.05, 0, 0.05, 0)
SearchBox.PlaceholderText = "Digitar Inicial ou Nome..."
SearchBox.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
SearchBox.TextColor3 = Color3.fromRGB(255,255,255)
Instance.new("UICorner", SearchBox)

local Scroll = Instance.new("ScrollingFrame", SpectateFrame)
Scroll.Size = UDim2.new(0.9, 0, 0.4, 0)
Scroll.Position = UDim2.new(0.05, 0, 0.17, 0)
Scroll.BackgroundTransparency = 1
Scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
local UIList = Instance.new("UIListLayout", Scroll)
UIList.Padding = UDim.new(0, 4)

-- Lógica do Spectate (Mantida conforme v32)
local function updateSpectList()
    for _, child in pairs(Scroll:GetChildren()) do if child:IsA("TextButton") then child:Destroy() end end
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= player then
            local pBtn = Instance.new("TextButton", Scroll)
            pBtn.Size = UDim2.new(1, -5, 0, 25)
            pBtn.Text = p.DisplayName.." (@"..p.Name..")"
            pBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            pBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            pBtn.TextSize = 10
            Instance.new("UICorner", pBtn)
            pBtn.Activated:Connect(function()
                spectatingPlayer = p
                camera.CameraSubject = p.Character:FindFirstChild("Humanoid")
            end)
        end
    end
    Scroll.CanvasSize = UDim2.new(0, 0, 0, UIList.AbsoluteContentSize.Y)
end

SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
    local t = SearchBox.Text:lower()
    if t == "" then return end
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= player and (p.Name:lower():sub(1, #t) == t or p.DisplayName:lower():sub(1, #t) == t) then
            spectatingPlayer = p
            camera.CameraSubject = p.Character:FindFirstChild("Humanoid")
            break
        end
    end
end)

local function createSpectControl(text, pos, color, func)
    local b = Instance.new("TextButton", SpectateFrame)
    b.Text = text b.Size = UDim2.new(0.9, 0, 0, 30) b.Position = pos
    b.BackgroundColor3 = color b.TextColor3 = Color3.fromRGB(255,255,255)
    b.Font = Enum.Font.GothamBold b.TextSize = 12
    Instance.new("UICorner", b) b.Activated:Connect(func)
end

createSpectControl("TP AO ALVO", UDim2.new(0.05,0,0.60,0), Color3.fromRGB(0,150,0), function()
    if spectatingPlayer and spectatingPlayer.Character then player.Character:MoveTo(spectatingPlayer.Character.HumanoidRootPart.Position) end
end)
createSpectControl("PARAR ASSISTIR", UDim2.new(0.05,0,0.72,0), Color3.fromRGB(150,0,0), function()
    spectatingPlayer = nil camera.CameraSubject = player.Character:FindFirstChild("Humanoid")
end)
createSpectControl("FECHAR MENU", UDim2.new(0.05,0,0.84,0), Color3.fromRGB(45,45,45), function() SpectateFrame.Visible = false end)

SpectBtn.Activated:Connect(function() 
    SpectateFrame.Visible = not SpectateFrame.Visible 
    if SpectateFrame.Visible then updateSpectList() end
end)

-----------------------------------------
--- FUNCIONALIDADES ORIGINAIS (MANTIDAS)
-----------------------------------------
local isSpamming = false
local spamConn = nil
SpamBtn.Activated:Connect(function()
    isSpamming = not isSpamming
    SpamBtn.Text = isSpamming and "SPAM OVO [ON]" or "SPAM OVO [OFF]"
    SpamBtn.BackgroundColor3 = isSpamming and Color3.fromRGB(60, 60, 60) or Color3.fromRGB(28, 28, 28)
    if isSpamming then
        spamConn = RunService.Heartbeat:Connect(function()
            local charFolder = workspace:FindFirstChild("Characters")
            local target = charFolder and charFolder:FindFirstChild(player.Name) and charFolder[player.Name]:FindFirstChild("Storegg")
            if target then pcall(function() remoteEvent:FireServer("TryStoregg", target, player:GetMouse().Hit.Position) end) end
        end)
    elseif spamConn then spamConn:Disconnect() spamConn = nil end
end)

local isFarming = false
FarmBtn.Activated:Connect(function()
    isFarming = not isFarming
    FarmBtn.Text = isFarming and "PEGAR OVOS [ON]" or "PEGAR OVOS [OFF]"
    FarmBtn.BackgroundColor3 = isFarming and Color3.fromRGB(60, 60, 60) or Color3.fromRGB(28, 28, 28)
    if isFarming then
        task.spawn(function()
            while isFarming do
                local eggs = workspace:FindFirstChild("Eggs")
                if eggs and player.Character then
                    for _, egg in pairs(eggs:GetChildren()) do
                        if not isFarming then break end
                        if egg:IsA("Model") then player.Character:MoveTo(egg:GetModelCFrame().p) task.wait(1.5) end
                    end
                end
                task.wait(1)
            end
        end)
    end
end)

local espEnabled = false
local espFolder = Instance.new("Folder", ScreenGui)
EspBtn.Activated:Connect(function()
    espEnabled = not espEnabled
    EspBtn.Text = espEnabled and "ESP [ON]" or "ESP [OFF]"
    EspBtn.BackgroundColor3 = espEnabled and Color3.fromRGB(60, 60, 60) or Color3.fromRGB(28, 28, 28)
    if not espEnabled then espFolder:ClearAllChildren() end
end)

local tpEnabled = false
TpBtn.Activated:Connect(function()
    tpEnabled = not tpEnabled
    TpBtn.Text = tpEnabled and "ClickTP [ON]" or "ClickTP [OFF]"
    TpBtn.BackgroundColor3 = tpEnabled and Color3.fromRGB(60, 60, 60) or Color3.fromRGB(28, 28, 28)
end)

UserInputService.InputBegan:Connect(function(input, processed)
    if tpEnabled and not processed and (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1) then
        local ray = camera:ScreenPointToRay(input.Position.X, input.Position.Y)
        local result = workspace:Raycast(ray.Origin, ray.Direction * 1000)
        if result and player.Character then player.Character.HumanoidRootPart.CFrame = CFrame.new(result.Position + Vector3.new(0,3,0)) end
    end
end)

local OpenBtn = Instance.new("TextButton", ScreenGui)
OpenBtn.Size = UDim2.new(0, 55, 0, 55)
OpenBtn.Position = UDim2.new(0, 15, 0.5, -27)
OpenBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
OpenBtn.Text = "S7"
OpenBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", OpenBtn).CornerRadius = UDim.new(1, 0)
Instance.new("UIStroke", OpenBtn).Color = Color3.fromRGB(170, 0, 255)
OpenBtn.Activated:Connect(function() MainFrame.Visible = not MainFrame.Visible end)

AntiAdmBtn.Activated:Connect(function()
    local antiAdmEnabled = (AntiAdmBtn.Text == "AntiADM: OFF")
    AntiAdmBtn.Text = antiAdmEnabled and "AntiADM: ON" or "AntiADM: OFF"
    AntiAdmBtn.BackgroundColor3 = antiAdmEnabled and Color3.fromRGB(150, 0, 0) or Color3.fromRGB(28, 28, 28)
end)

ReBtn.Activated:Connect(function() TeleportService:Teleport(game.PlaceId, player) end)

-- Tags (Mantidas conforme v32)
local function createOverheadTag(targetPlayer, text, color, mode)
    local char = targetPlayer.Character or targetPlayer.CharacterAdded:Wait()
    local head = char:WaitForChild("Head", 10)
    if not head then return end
    if head:FindFirstChild("S7xTag") then head.S7xTag:Destroy() end
    local billboard = Instance.new("BillboardGui", head)
    billboard.Name = "S7xTag"
    billboard.Size = UDim2.new(0, 150, 0, 70)
    billboard.StudsOffset = Vector3.new(0, 4, 0)
    billboard.AlwaysOnTop = true
    local label = Instance.new("TextLabel", billboard)
    label.BackgroundTransparency = 1
    label.Size = UDim2.new(1, 0, 1, 0)
    label.Text = text
    label.Font = Enum.Font.GothamBold
    label.TextSize = 20
    label.TextColor3 = color or Color3.fromRGB(255, 255, 255)
    if mode == "RGB" then
        task.spawn(function()
            local hue = 0
            while billboard and billboard.Parent do
                hue = hue + (1/200)
                label.TextColor3 = Color3.fromHSV(hue, 1, 1)
                task.wait()
            end
        end)
    elseif mode == "BW" then
        task.spawn(function()
            while billboard and billboard.Parent do
                label.TextColor3 = Color3.fromRGB(255, 255, 255)
                task.wait(1.5)
                label.TextColor3 = Color3.fromRGB(40, 40, 40)
                task.wait(1.5)
            end
        end)
    end
end

local function applyTags(p)
    local function setup()
        task.wait(2)
        for _, id in pairs(CREATOR_IDS) do if p.UserId == id then createOverheadTag(p, "Criador", nil, "RGB") end end
        for _, id in pairs(ADMIN_IDS_RGB) do if p.UserId == id then createOverheadTag(p, "Admin", nil, "RGB") end end
        for _, id in pairs(VIP_IDS_BW) do if p.UserId == id then createOverheadTag(p, "Vip", nil, "BW") end end
    end
    p.CharacterAdded:Connect(setup)
    if p.Character then setup() end
end
for _, v in pairs(Players:GetPlayers()) do applyTags(v) end
Players.PlayerAdded:Connect(applyTags)

RunService.RenderStepped:Connect(function()
    if espEnabled then
        for _, v in pairs(Players:GetPlayers()) do
            if v ~= player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                local b = espFolder:FindFirstChild(v.Name) or Instance.new("BillboardGui", espFolder)
                b.Name = v.Name b.Adornee = v.Character.HumanoidRootPart b.Size = UDim2.new(0,100,0,50) b.AlwaysOnTop = true
                local l = b:FindFirstChild("L") or Instance.new("TextLabel", b)
                l.Name = "L" l.Size = UDim2.new(1,0,1,0) l.BackgroundTransparency = 1 l.TextColor3 = Color3.fromRGB(255,255,255)
                l.TextSize = 14 l.Text = v.Name
            end
        end
    end
end)
