--// BLOXSTRIKE v1.0 - PART 1 (Core + ESP + Aimbot + Skin)
print("[BS-PART1] Loading...")

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

_G.AUTHOR = {Name = "DJCscript", Version = "1.0", Telegram = "@DeverJomdsCodeCC", TelegramURL = "https://t.me/DeverJomdsCodeCC"}
_G.UNIVERSAL_KEY = "bloxDJC"

_G.THEME = {
    BG = Color3.fromRGB(15, 15, 22),
    BGAlt = Color3.fromRGB(22, 22, 32),
    Elem = Color3.fromRGB(38, 38, 54),
    Accent = Color3.fromRGB(255, 70, 70), -- Красный акцент для CS-стиля
    Accent2 = Color3.fromRGB(255, 160, 60),
    Success = Color3.fromRGB(80, 230, 130),
    Danger = Color3.fromRGB(255, 75, 100),
    Telegram = Color3.fromRGB(0, 136, 204),
    Text = Color3.fromRGB(245, 245, 255),
    TextDim = Color3.fromRGB(140, 140, 165),
    Stroke = Color3.fromRGB(70, 70, 100),
}

_G.ESP = {Enabled=true, ShowHighlight=true, ShowBox=true, ShowLine=true, ShowName=true, ShowHealth=true, ShowDistance=false, TeamCheck=true, MaxDistance=300, BoxColor=Color3.fromRGB(255,70,70)}
_G.AIM = {Enabled=false, TriggerBot=false, TeamCheck=true, MaxDistance=300, Smoothness=0.2, FOV=100, Key=Enum.KeyCode.E}
_G.MISC = {NoRecoil=false, NoFlash=false}
_G.SKIN = {Enabled=false, CurrentSkin="Default", AllSkins={}, SelectedSkin="Default"}

local ESP = _G.ESP
local AIM = _G.AIM
local MISC = _G.MISC
local SKIN = _G.SKIN

--// ================== NO RECOIL ==================
-- Пытаемся найти и обнулить recoil (работает не везде)
RunService.RenderStepped:Connect(function()
    if not MISC.NoRecoil then return end
    local char = LocalPlayer.Character
    if not char then return end
    -- Ищем оружие и меняем recoil, если возможно
    for _, obj in ipairs(char:GetDescendants()) do
        if obj:IsA("Tool") or obj:IsA("Model") then
            local recoil = obj:FindFirstChild("Recoil") or obj:FindFirstChild("Kickback")
            if recoil and recoil:IsA("NumberValue") then
                recoil.Value = 0
            end
        end
    end
end)

--// ================== NO FLASH ==================
RunService.RenderStepped:Connect(function()
    if not MISC.NoFlash then return end
    -- Отключаем LightInfluence на экране если есть
    local lighting = game:GetService("Lighting")
    lighting.Brightness = 3
    lighting.ClockTime = 12
    lighting.FogEnd = 100000
end)

--// ================== ESP (FIXED FOR BLOXSTRIKE) ==================
local espData = {}

local function createESP(player)
    if player == LocalPlayer or espData[player] then return end
    local char = player.Character or player.CharacterAdded:Wait()
    if not char then return end

    -- Highlight
    local hl = Instance.new("Highlight")
    hl.Name = "BS_HL"
    hl.FillColor = ESP.BoxColor
    hl.FillTransparency = 0.6
    hl.OutlineTransparency = 0
    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    hl.Parent = char

    -- Billboard
    local bb = Instance.new("BillboardGui")
    bb.Size = UDim2.new(0, 200, 0, 50)
    bb.StudsOffset = Vector3.new(0, 3, 0)
    bb.AlwaysOnTop = true
    bb.Parent = char

    local nm = Instance.new("TextLabel")
    nm.Size = UDim2.new(1, 0, 0.34, 0)
    nm.BackgroundTransparency = 1
    nm.TextColor3 = Color3.fromRGB(255, 255, 255)
    nm.TextStrokeTransparency = 0.3
    nm.TextScaled = true
    nm.Font = Enum.Font.GothamBold
    nm.Text = player.Name
    nm.Parent = bb

    local hp = Instance.new("TextLabel")
    hp.Size = UDim2.new(1, 0, 0.33, 0)
    hp.Position = UDim2.new(0, 0, 0.34, 0)
    hp.BackgroundTransparency = 1
    hp.TextColor3 = Color3.fromRGB(80, 255, 80)
    hp.TextStrokeTransparency = 0.3
    hp.TextScaled = true
    hp.Font = Enum.Font.Gotham
    hp.Text = "100 HP"
    hp.Parent = bb

    espData[player] = {hl = hl, bb = bb, nm = nm, hp = hp}
end

local function removeESP(player)
    local d = espData[player]
    if d then
        for _, v in pairs(d) do v:Destroy() end
        espData[player] = nil
    end
end

RunService.RenderStepped:Connect(function()
    for p, d in pairs(espData) do
        local ch = p.Character
        if not ch then continue end
        local hum = ch:FindFirstChildOfClass("Humanoid")
        local rp = ch:FindFirstChild("HumanoidRootPart")
        if not hum or not rp then continue end
        
        local visible = ESP.Enabled
        local distValue = (Camera.CFrame.Position - rp.Position).Magnitude
        if distValue > ESP.MaxDistance then visible = false end
        if ESP.TeamCheck and p.Team == LocalPlayer.Team and p.Team ~= nil then visible = false end
        
        d.hp.Text = math.floor(hum.Health) .. " / " .. math.floor(hum.MaxHealth) .. " HP"
        d.nm.Text = p.Name
        
        d.hl.Enabled = visible and ESP.ShowHighlight
        d.bb.Enabled = visible and (ESP.ShowName or ESP.ShowHealth)
        d.nm.Visible = ESP.ShowName
        d.hp.Visible = ESP.ShowHealth
    end
end)

for _, p in ipairs(Players:GetPlayers()) do createESP(p) end
Players.PlayerAdded:Connect(function(p)
    p.CharacterAdded:Connect(function()
        task.wait(0.5) -- Ждём полной загрузки персонажа
        removeESP(p)
        createESP(p)
    end)
end)
Players.PlayerRemoving:Connect(removeESP)

--// ================== AIMBOT (FIXED FOR BLOXSTRIKE) ==================
RunService.RenderStepped:Connect(function()
    if not AIM.Enabled then return end
    local best, bestDist = nil, AIM.FOV
    local vp = Camera.ViewportSize
    -- В BloxStrike прицел всегда в ЦЕНТРЕ экрана, а не от курсора мыши
    local center = Vector2.new(vp.X / 2, vp.Y / 2)
    
    for _, p in ipairs(Players:GetPlayers()) do
        if p == LocalPlayer then continue end
        if AIM.TeamCheck and p.Team == LocalPlayer.Team and p.Team ~= nil then continue end
        local ch = p.Character
        if not ch then continue end
        local hum = ch:FindFirstChildOfClass("Humanoid")
        if not hum or hum.Health <= 0 then continue end
        local part = ch:FindFirstChild("Head")
        if not part then continue end
        if (Camera.CFrame.Position - part.Position).Magnitude > AIM.MaxDistance then continue end
        
        local sp, on = Camera:WorldToViewportPoint(part.Position)
        if not on then continue end
        
        -- Считаем расстояние от ЦЕНТРА экрана, а не от мыши
        local dist = (Vector2.new(sp.X, sp.Y) - center).Magnitude
        if dist < bestDist then
            bestDist = dist
            best = part
        end
    end
    
    if best then
        -- Наводим камеру на цель
        Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, best.Position), AIM.Smoothness)
    end
end)


--// ================== SKIN CHANGER (Локальный) ==================
-- Простая реализация: меняем цвет/текстуру на текущем оружии
-- ВАЖНО: работает только визуально для тебя
local function applySkinToWeapon()
    if not SKIN.Enabled then return end
    local char = LocalPlayer.Character; if not char then return end
    local tool = char:FindFirstChildOfClass("Tool")
    if not tool then return end
    -- Меняем цвет всех частей оружия
    for _, part in ipairs(tool:GetDescendants()) do
        if part:IsA("BasePart") then
            if SKIN.SelectedSkin == "Red" then
                part.Color = Color3.fromRGB(255, 0, 0)
            elseif SKIN.SelectedSkin == "Blue" then
                part.Color = Color3.fromRGB(0, 100, 255)
            elseif SKIN.SelectedSkin == "Gold" then
                part.Color = Color3.fromRGB(255, 200, 0)
            elseif SKIN.SelectedSkin == "Green" then
                part.Color = Color3.fromRGB(0, 255, 100)
            end
        end
    end
end

RunService.RenderStepped:Connect(applySkinToWeapon)

--// ================== GLOBALS ==================
_G.restoreFOV = function() pcall(function() Camera.FieldOfView = 70 end) end
_G.ESP = ESP
_G.AIM = AIM
_G.MISC = MISC
_G.SKIN = SKIN

print("[BS-PART1] Core + ESP + Aimbot + Skin loaded")

-- Загружаем Part2 (меню)
loadstring(game:HttpGet("https://raw.githubusercontent.com/DJCscripts/BloxStrike-Script/main/Part2.lua", true))()
