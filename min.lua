-- [[ S7Hub v1.1.1 - HIGH PERFORMANCE & PROTECTED ]] --
local _S7 = "S7Hub v1.1.1"
local _0xG = game
local _0xP = _0xG:GetService("\80\108\97\121\101\114\115")
local _0xL = _0xP.LocalPlayer
local _0xM = _0xL:GetMouse()
local _0xR = _0xG:GetService("\82\117\110\83\101\114\118\105\99\101")
local _0xU = _0xG:GetService("\85\115\101\114\73\110\112\117\116\83\101\114\118\105\99\101")
local _0xT = _0xG:GetService("\84\101\108\101\112\111\114\116\83\101\114\118\105\99\101")
local _0xS = _0xG:GetService("\82\101\112\108\105\99\97\116\101\100\83\116\111\114\97\103\101")
local _CAM = workspace.CurrentCamera

-- Acesso rápido para otimização
local _V3 = Vector3.new
local _CF = CFrame.new
local _C3 = Color3.fromRGB
local _UD = UDim2.new

local _C = {2959681, 9216315975, 88189937} 
local _A = {1870899605, 7668266040}
local _V = {648989434, 9987756245}
local _G = 34157675
local _RL = {["Marketing"]="\82\101\100",["Social Mod"]="\82\101\100",["Helper"]="\82\101\100",["Supervisor"]="\82\101\100",["Manager"]="\82\101\100",["Developer"]="\82\101\100",["Owner"]="\82\101\100",["Influencer"]="\79\114\97\110\103\101",["Contributor"]="\79\114\97\110\103\101"}

if not (function(id) for _,v in pairs(_C) do if v==id then return true end end for _,v in pairs(_A) do if v==id then return true end end for _,v in pairs(_V) do if v==id then return true end end return false end)(_0xL.UserId) then return end

local _Gui = Instance.new("ScreenGui", _0xL:WaitForChild("PlayerGui"))
_Gui.Name = "S7_H_111"
_Gui.ResetOnSpawn = false

local function _DRAG(_f)
    local d, di, ds, sp
    _f.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then d = true ds = i.Position sp = _f.Position i.Changed:Connect(function() if i.UserInputState == Enum.UserInputState.End then d = false end end) end end)
    _f.InputChanged:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch then di = i end end)
    _0xU.InputChanged:Connect(function(i) if i == di and d then local dl = i.Position - ds _f.Position = _UD(sp.X.Scale, sp.X.Offset + dl.X, sp.Y.Scale, sp.Y.Offset + dl.Y) end end)
end

-- [[ SISTEMA DE TAGS FIX ]] --
local function _TAG(p, txt, md)
    task.spawn(function()
        local c = p.Character or p.CharacterAdded:Wait()
        local h = c:WaitForChild("Head", 10)
        if h then
            if h:FindFirstChild("S7x") then h.S7x:Destroy() end
            local b = Instance.new("BillboardGui", h)
            b.Name = "S7x" b.Size = _UD(0,150,0,70) b.StudsOffset = _V3(0,4,0) b.AlwaysOnTop = true
            local l = Instance.new("TextLabel", b)
            l.Size = _UD(1,0,1,0) l.BackgroundTransparency = 1 l.Text = txt l.Font = Enum.Font.GothamBold l.TextSize = 20
            if md == "RGB" then
                task.spawn(function() local hu = 0 while b and b.Parent do hu = hu + (1/200) l.TextColor3 = Color3.fromHSV(hu,1,1) _0xR.Heartbeat:Wait() end end)
            elseif md == "BW" then
                task.spawn(function() while b and b.Parent do l.TextColor3 = _C3(255,255,255) task.wait(1.5) l.TextColor3 = _C3(40,40,40) task.wait(1.5) end end)
            end
        end
    end)
end

local function _APL(p)
    local function s()
        task.wait(2)
        for _,id in pairs(_C) do if p.UserId == id then _TAG(p,"Criador","RGB") end end
        for _,id in pairs(_A) do if p.UserId == id then _TAG(p,"Admin","RGB") end end
        for _,id in pairs(_V) do if p.UserId == id then _TAG(p,"Vip","BW") end end
    end
    p.CharacterAdded:Connect(s) if p.Character then s() end
end
for _,v in pairs(_0xP:GetPlayers()) do _APL(v) end
_0xP.PlayerAdded:Connect(_APL)

-- [[ UI PRINCIPAL ]] --
local _Main = Instance.new("Frame", _Gui)
_Main.BackgroundColor3 = _C3(12,12,12) _Main.Size = _UD(0,200,0,380) _Main.Position = _UD(0.5,-100,0.5,-190) _Main.Visible = false
Instance.new("UICorner", _Main) _DRAG(_Main)

local _Title = Instance.new("TextLabel", _Main)
_Title.Text = _S7 _Title.Size = _UD(1,0,0,40) _Title.BackgroundTransparency = 1 _Title.TextColor3 = _C3(255,255,255) _Title.Font = Enum.Font.GothamBold _Title.TextSize = 22

local function _BTN(t, ps)
    local b = Instance.new("TextButton", _Main)
    b.Text = t b.Position = ps b.Size = _UD(0.85,0,0,35) b.BackgroundColor3 = _C3(28,28,28) b.TextColor3 = _C3(200,200,200) b.Font = Enum.Font.GothamSemibold b.TextSize = 13 Instance.new("UICorner", b) return b
end

local B1 = _BTN("SPAM OVO [OFF]", _UD(0.075,0,0.12,0))
local B2 = _BTN("PEGAR OVOS [OFF]", _UD(0.075,0,0.24,0))
local B3 = _BTN("ESP [OFF]", _UD(0.075,0,0.36,0))
local B4 = _BTN("ClickTP [OFF]", _UD(0.075,0,0.48,0))
local B5 = _BTN("REJOIN", _UD(0.075,0,0.60,0))
local B6 = _BTN("SPECT", _UD(0.075,0,0.72,0))
local B7 = _BTN("AntiADM [OFF]", _UD(0.075,0,0.84,0))

-- [[ LÓGICAS ]] --
local _S, _F, _E, _CT, _AA = false, false, false, false, false
local _SC = nil
local _EF = Instance.new("Folder", _Gui)

B1.Activated:Connect(function()
    _S = not _S B1.Text = _S and "SPAM OVO [ON]" or "SPAM OVO [OFF]" B1.BackgroundColor3 = _S and _C3(60,60,60) or _C3(28,28,28)
    if _S then _SC = _0xR.Heartbeat:Connect(function() pcall(function() _0xS.Modules.Events.RemoteEvent:FireServer("TryStoregg", workspace.Characters[_0xL.Name].Storegg, _0xM.Hit.Position) end) end)
    elseif _SC then _SC:Disconnect() end
end)

B2.Activated:Connect(function()
    _F = not _F B2.Text = _F and "PEGAR OVOS [ON]" or "PEGAR OVOS [OFF]" B2.BackgroundColor3 = _F and _C3(60,60,60) or _C3(28,28,28)
    if _F then task.spawn(function() while _F do pcall(function() for _,e in pairs(workspace.Eggs:GetChildren()) do if not _F then break end _0xL.Character.HumanoidRootPart.CFrame = e:GetModelCFrame() task.wait(0.3) end end) task.wait(0.1) end end) end
end)

B3.Activated:Connect(function() _E = not _E B3.Text = _E and "ESP [ON]" or "ESP [OFF]" B3.BackgroundColor3 = _E and _C3(60,60,60) or _C3(28,28,28) if not _E then _EF:ClearAllChildren() end end)
B4.Activated:Connect(function() _CT = not _CT B4.Text = _CT and "ClickTP [ON]" or "ClickTP [OFF]" B4.BackgroundColor3 = _CT and _C3(60,60,60) or _C3(28,28,28) end)
_0xU.InputBegan:Connect(function(i,p) if _CT and not p and (i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseButton1) then local r = _CAM:ScreenPointToRay(i.Position.X, i.Position.Y) local rs = workspace:Raycast(r.Origin, r.Direction * 1000) if rs then _0xL.Character.HumanoidRootPart.CFrame = _CF(rs.Position + _V3(0,3,0)) end end end)

-- [[ ESP & SPECTATE FIX ]] --
_0xR.RenderStepped:Connect(function()
    if _E then
        for _,v in pairs(_0xP:GetPlayers()) do
            if v ~= _0xL and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                local b = _EF:FindFirstChild(v.Name) or Instance.new("BillboardGui", _EF)
                b.Name = v.Name b.Adornee = v.Character.HumanoidRootPart b.Size = _UD(0,100,0,50) b.AlwaysOnTop = true
                local l = b:FindFirstChild("L") or Instance.new("TextLabel", b)
                l.Name = "L" l.Size = _UD(1,0,1,0) l.BackgroundTransparency = 1
                local s, r = pcall(function() return v:GetRoleInGroup(_G) end)
                if s and _RL[r] then l.TextColor3 = (_RL[r]=="Orange" and _C3(255,165,0) or _C3(255,0,0)) l.Text = "⚠️ "..v.DisplayName else l.TextColor3 = _C3(255,255,255) l.Text = v.DisplayName end
            end
        end
    end
end)

local _SpecF = Instance.new("Frame", _Gui)
_SpecF.Size = _UD(0,200,0,340) _SpecF.Position = _UD(0.5,110,0.5,-150) _SpecF.BackgroundColor3 = _C3(15,15,15) _SpecF.Visible = false
Instance.new("UICorner", _SpecF) _DRAG(_SpecF)

local _Scr = Instance.new("ScrollingFrame", _SpecF)
_Scr.Size = _UD(0.9,0,0.4,0) _Scr.Position = _UD(0.05,0,0.17,0) _Scr.BackgroundTransparency = 1 _Scr.ScrollBarThickness = 2
Instance.new("UIListLayout", _Scr)

local _target = nil
B6.Activated:Connect(function()
    _SpecF.Visible = not _SpecF.Visible
    if _SpecF.Visible then
        for _,c in pairs(_Scr:GetChildren()) do if c:IsA("TextButton") then c:Destroy() end end
        for _,p in pairs(_0xP:GetPlayers()) do
            if p ~= _0xL then
                local b = Instance.new("TextButton", _Scr)
                b.Size = _UD(1,-5,0,25) b.Text = p.DisplayName b.BackgroundColor3 = _C3(30,30,30) b.TextColor3 = _C3(255,255,255) b.TextSize = 10 Instance.new("UICorner", b)
                b.Activated:Connect(function() _target = p _CAM.CameraSubject = p.Character.Humanoid end)
            end
        end
    end
end)

local function _SBTN(t, ps, cl, f)
    local b = Instance.new("TextButton", _SpecF)
    b.Text = t b.Size = _UD(0.9,0,0,30) b.Position = ps b.BackgroundColor3 = cl b.TextColor3 = _C3(255,255,255) b.Font = Enum.Font.GothamBold Instance.new("UICorner", b) b.Activated:Connect(f)
end
_SBTN("TP AO ALVO", _UD(0.05,0,0.6,0), _C3(0,150,0), function() if _target then _0xL.Character.HumanoidRootPart.CFrame = _target.Character.HumanoidRootPart.CFrame end end)
_SBTN("PARAR", _UD(0.05,0,0.72,0), _C3(150,0,0), function() _target = nil _CAM.CameraSubject = _0xL.Character.Humanoid end)
_SBTN("FECHAR", _UD(0.05,0,0.84,0), _C3(40,40,40), function() _SpecF.Visible = false end)

-- [[ BOTÃO ABRIR & REJOIN ]] --
local _Open = Instance.new("TextButton", _Gui)
_Open.Size = _UD(0,55,0,55) _Open.Position = _UD(0,15,0.5,-27) _Open.BackgroundColor3 = _C3(0,0,0) _Open.Text = "S7" _Open.TextColor3 = _C3(255,255,255)
Instance.new("UICorner", _Open).CornerRadius = UDim.new(1,0) Instance.new("UIStroke", _Open).Color = _C3(170,0,255)
_Open.Activated:Connect(function() _Main.Visible = not _Main.Visible end)
B5.Activated:Connect(function() _0xT:Teleport(game.PlaceId, _0xL) end)
B7.Activated:Connect(function() _AA = not _AA B7.Text = _AA and "AntiADM [ON]" or "AntiADM [OFF]" B7.BackgroundColor3 = _AA and _C3(150,0,0) or _C3(28,28,28) end)
