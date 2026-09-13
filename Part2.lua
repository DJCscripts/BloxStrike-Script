--// BLOXSTRIKE v1.0 - PART 2 (Key Screen + Menu)
print("[BS-PART2] Loading menu...")

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local AUTHOR = _G.AUTHOR
local UNIVERSAL_KEY = _G.UNIVERSAL_KEY
local THEME = _G.THEME
local ESP = _G.ESP
local AIM = _G.AIM
local MISC = _G.MISC
local SKIN = _G.SKIN

local function corner(p, r)
    local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0, r or 8); c.Parent = p; return c
end
local function stroke(p, c, t, trans)
    local s = Instance.new("UIStroke"); s.Color = c or THEME.Stroke; s.Thickness = t or 1
    s.Transparency = trans or 0; s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border; s.Parent = p; return s
end
local function gradient(p, c1, c2, rot)
    local g = Instance.new("UIGradient"); g.Color = ColorSequence.new(c1, c2)
    g.Rotation = rot or 0; g.Parent = p; return g
end

local function buildMenu()
    local sg = Instance.new("ScreenGui")
    sg.Name="BloxStrikeMenu"; sg.ResetOnSpawn=false; sg.IgnoreGuiInset=true
    sg.ZIndexBehavior=Enum.ZIndexBehavior.Sibling
    sg.Parent=LocalPlayer:WaitForChild("PlayerGui")

    local SCREEN = Camera.ViewportSize
    local menuW = math.min(370, SCREEN.X - 30)
    local menuH = math.min(500, SCREEN.Y - 60)

    local main = Instance.new("Frame")
    main.Size=UDim2.new(0,menuW,0,menuH)
    main.Position=UDim2.new(0.5,-menuW/2,0.5,-menuH/2)
    main.BackgroundColor3=THEME.BG; main.BorderSizePixel=0
    main.Active=true; main.Draggable=true; main.ClipsDescendants=true
    main.Parent=sg; corner(main,16); stroke(main, THEME.Accent, 1.5, 0.3)

    local topBar = Instance.new("Frame")
    topBar.Size=UDim2.new(1,0,0,4); topBar.BackgroundColor3=THEME.Accent
    topBar.BorderSizePixel=0; topBar.Parent=main
    gradient(topBar, THEME.Accent, THEME.Accent2, 0)

    local header = Instance.new("Frame")
    header.Size=UDim2.new(1,0,0,60); header.BackgroundColor3=THEME.BGAlt
    header.BorderSizePixel=0; header.Parent=main

    local logo = Instance.new("Frame")
    logo.Size=UDim2.new(0,40,0,40); logo.Position=UDim2.new(0,12,0.5,-20)
    logo.BackgroundColor3=THEME.Accent; logo.Parent=header
    corner(logo,12); gradient(logo, THEME.Accent, THEME.Accent2, 45)

    local logoIcon = Instance.new("TextLabel")
    logoIcon.Size=UDim2.new(1,0,1,0); logoIcon.BackgroundTransparency=1
    logoIcon.Text="🎯"; logoIcon.TextColor3=Color3.fromRGB(255,255,255)
    logoIcon.Font=Enum.Font.GothamBold; logoIcon.TextSize=22; logoIcon.Parent=logo

    local title = Instance.new("TextLabel")
    title.Size=UDim2.new(1,-100,0,20); title.Position=UDim2.new(0,60,0,12)
    title.BackgroundTransparency=1; title.Text="BLOXSTRIKE MENU"
    title.TextColor3=THEME.Text; title.Font=Enum.Font.GothamBold
    title.TextSize=15; title.TextXAlignment=Enum.TextXAlignment.Left; title.Parent=header

    local subtitle = Instance.new("TextLabel")
    subtitle.Size=UDim2.new(1,-100,0,16); subtitle.Position=UDim2.new(0,60,0,32)
    subtitle.BackgroundTransparency=1; subtitle.Text="by "..AUTHOR.Name.." • "..AUTHOR.Telegram
    subtitle.TextColor3=THEME.Accent2; subtitle.Font=Enum.Font.Gotham
    subtitle.TextSize=10; subtitle.TextXAlignment=Enum.TextXAlignment.Left; subtitle.Parent=header

    local close = Instance.new("TextButton")
    close.Size=UDim2.new(0,44,0,44); close.Position=UDim2.new(1,-52,0.5,-22)
    close.BackgroundColor3=THEME.Danger; close.Text="✕"
    close.TextColor3=Color3.fromRGB(255,255,255); close.Font=Enum.Font.GothamBold
    close.TextSize=18; close.AutoButtonColor=false; close.Parent=header
    corner(close,12)

    local content = Instance.new("ScrollingFrame")
    content.Size=UDim2.new(1,-16,1,-76); content.Position=UDim2.new(0,8,0,68)
    content.BackgroundTransparency=1; content.BorderSizePixel=0
    content.ScrollBarThickness=6; content.ScrollBarImageColor3=THEME.Accent
    content.CanvasSize=UDim2.new(0,0,0,5000)
    content.ScrollingDirection=Enum.ScrollingDirection.Y
    content.Parent=main

    local layout = Instance.new("UIListLayout")
    layout.Padding=UDim.new(0,8); layout.SortOrder=Enum.SortOrder.LayoutOrder
    layout.Parent=content

    local pad = Instance.new("UIPadding")
    pad.PaddingTop=UDim.new(0,6); pad.PaddingBottom=UDim.new(0,12)
    pad.PaddingLeft=UDim.new(0,6); pad.PaddingRight=UDim.new(0,6); pad.Parent=content

    local function section(text, icon)
        local sec = Instance.new("Frame")
        sec.Size=UDim2.new(1,0,0,30); sec.BackgroundTransparency=1; sec.Parent=content
        local line = Instance.new("Frame")
        line.Size=UDim2.new(1,0,0,1); line.Position=UDim2.new(0,0,0.5,0)
        line.BackgroundColor3=THEME.Stroke; line.BorderSizePixel=0; line.Parent=sec
        local lbl = Instance.new("TextLabel")
        lbl.Size=UDim2.new(0,230,0,22); lbl.Position=UDim2.new(0,10,0.5,-11)
        lbl.BackgroundColor3=THEME.BGAlt
        lbl.Text="  "..(icon or "").." "..string.upper(text).."  "
        lbl.TextColor3=THEME.Accent2; lbl.Font=Enum.Font.GothamBold
        lbl.TextSize=11; lbl.TextXAlignment=Enum.TextXAlignment.Left; lbl.Parent=sec
        corner(lbl,6); stroke(lbl, THEME.Accent, 1, 0.7)
    end

    local function toggle(text, initial, cb)
        local state = initial
        local btn = Instance.new("TextButton")
        btn.Size=UDim2.new(1,0,0,52); btn.BackgroundColor3=THEME.Elem
        btn.Text=""; btn.AutoButtonColor=false; btn.Parent=content
        corner(btn,12); stroke(btn, THEME.Stroke, 1, 0.5)

        local lbl = Instance.new("TextLabel")
        lbl.Size=UDim2.new(1,-90,1,0); lbl.Position=UDim2.new(0,16,0,0)
        lbl.BackgroundTransparency=1; lbl.Text=text
        lbl.TextColor3=THEME.Text; lbl.Font=Enum.Font.GothamSemibold
        lbl.TextSize=14; lbl.TextXAlignment=Enum.TextXAlignment.Left; lbl.Parent=btn

        local sw = Instance.new("Frame")
        sw.Size=UDim2.new(0,54,0,30); sw.Position=UDim2.new(1,-68,0.5,-15)
        sw.BackgroundColor3=state and THEME.Success or Color3.fromRGB(50,50,70)
        sw.Parent=btn; corner(sw,15)

        local knob = Instance.new("Frame")
        knob.Size=UDim2.new(0,26,0,26)
        knob.Position=state and UDim2.new(1,-28,0.5,-13) or UDim2.new(0,2,0.5,-13)
        knob.BackgroundColor3=Color3.fromRGB(255,255,255); knob.Parent=sw; corner(knob,13)

        btn.MouseButton1Click:Connect(function()
            state = not state; if cb then cb(state) end
            TweenService:Create(sw, TweenInfo.new(0.25, Enum.EasingStyle.Quart), {
                BackgroundColor3 = state and THEME.Success or Color3.fromRGB(50,50,70)}):Play()
            TweenService:Create(knob, TweenInfo.new(0.25, Enum.EasingStyle.Quart), {
                Position = state and UDim2.new(1,-28,0.5,-13) or UDim2.new(0,2,0.5,-13)}):Play()
        end)
    end

    local function slider(text, min, max, init, isFloat, cb)
        local val = init
        local f = Instance.new("Frame")
        f.Size=UDim2.new(1,0,0,64); f.BackgroundColor3=THEME.Elem
        f.Parent=content; corner(f,12); stroke(f, THEME.Stroke, 1, 0.5)

        local lbl = Instance.new("TextLabel")
        lbl.Size=UDim2.new(1,-80,0,22); lbl.Position=UDim2.new(0,16,0,8)
        lbl.BackgroundTransparency=1; lbl.Text=text
        lbl.TextColor3=THEME.Text; lbl.Font=Enum.Font.GothamSemibold
        lbl.TextSize=13; lbl.TextXAlignment=Enum.TextXAlignment.Left; lbl.Parent=f

        local vl = Instance.new("TextLabel")
        vl.Size=UDim2.new(0,70,0,22); vl.Position=UDim2.new(1,-86,0,8)
        vl.BackgroundTransparency=1
        vl.Text=isFloat and string.format("%.2f", val) or tostring(val)
        vl.TextColor3=THEME.Accent2; vl.Font=Enum.Font.GothamBold
        vl.TextSize=13; vl.TextXAlignment=Enum.TextXAlignment.Right; vl.Parent=f

        local bar = Instance.new("Frame")
        bar.Size=UDim2.new(1,-32,0,12); bar.Position=UDim2.new(0,16,1,-22)
        bar.BackgroundColor3=Color3.fromRGB(45,45,65); bar.Parent=f; corner(bar,6)

        local pct = (val - min)/(max - min)
        local fill = Instance.new("Frame")
        fill.Size=UDim2.new(pct,0,1,0); fill.BackgroundColor3=THEME.Accent
        fill.BorderSizePixel=0; fill.Parent=bar; corner(fill,6)
        gradient(fill, THEME.Accent, THEME.Accent2, 0)

        local knob = Instance.new("Frame")
        knob.Size=UDim2.new(0,22,0,22); knob.AnchorPoint=Vector2.new(0.5,0.5)
        knob.Position=UDim2.new(pct,0,0.5,0); knob.BackgroundColor3=Color3.fromRGB(255,255,255)
        knob.Parent=bar; corner(knob,11); stroke(knob, THEME.Accent, 2, 0)

        local drag = false
        local function update(inp)
            local p = math.clamp((inp.Position.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
            fill.Size = UDim2.new(p,0,1,0); knob.Position = UDim2.new(p,0,0.5,0)
            local nv = min + (max - min) * p
            if isFloat then
                val = tonumber(string.format("%.2f", nv)); vl.Text = string.format("%.2f", val)
            else val = math.floor(nv); vl.Text = tostring(val) end
            if cb then cb(val) end
        end
        bar.InputBegan:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                drag = true; update(i) end
        end)
        UserInputService.InputChanged:Connect(function(i)
            if drag and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
                update(i) end
        end)
        UserInputService.InputEnded:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                drag = false end
        end)
    end

    local function button(text, callback, color)
        local btn = Instance.new("TextButton")
        btn.Size=UDim2.new(1,0,0,50); btn.BackgroundColor3=color or THEME.Accent
        btn.Text=text; btn.TextColor3=Color3.fromRGB(255,255,255)
        btn.Font=Enum.Font.GothamBold; btn.TextSize=13
        btn.AutoButtonColor=false; btn.Parent=content; corner(btn,12)
        btn.MouseButton1Click:Connect(function() if callback then callback() end end)
    end

    section("ESP", "👁")
    toggle("ESP Enabled", ESP.Enabled, function(v) ESP.Enabled = v end)
    toggle("Highlight", ESP.ShowHighlight, function(v) ESP.ShowHighlight = v end)
    toggle("Box", ESP.ShowBox, function(v) ESP.ShowBox = v end)
    toggle("Line (Tracer)", ESP.ShowLine, function(v) ESP.ShowLine = v end)
    toggle("Show Name", ESP.ShowName, function(v) ESP.ShowName = v end)
    toggle("Show Health", ESP.ShowHealth, function(v) ESP.ShowHealth = v end)
    toggle("Ignore Teammates", ESP.TeamCheck, function(v) ESP.TeamCheck = v end)
    slider("Max Distance", 50, 1000, ESP.MaxDistance, false, function(v) ESP.MaxDistance = v end)

    section("AIMBOT", "🎯")
    toggle("Aimbot Enabled (E)", AIM.Enabled, function(v) AIM.Enabled = v end)
    toggle("Trigger Bot", AIM.TriggerBot, function(v) AIM.TriggerBot = v end)
    toggle("Ignore Teammates", AIM.TeamCheck, function(v) AIM.TeamCheck = v end)
    slider("Smoothness (x100)", 1, 100, AIM.Smoothness * 100, false, function(v) AIM.Smoothness = v/100 end)
    slider("FOV Radius", 20, 300, AIM.FOV, false, function(v) AIM.FOV = v end)
    slider("Aim Distance", 50, 1000, AIM.MaxDistance, false, function(v) AIM.MaxDistance = v end)

    section("MISC", "⚙")
    toggle("No Recoil", MISC.NoRecoil, function(v) MISC.NoRecoil = v end)
    toggle("No Flash", MISC.NoFlash, function(v) MISC.NoFlash = v end)

    section("SKIN CHANGER", "🎨")
    toggle("Enable Skin Changer", SKIN.Enabled, function(v) SKIN.Enabled = v end)
    
    -- Выбор скина (кнопки)
    local skinBtnFrame = Instance.new("Frame")
    skinBtnFrame.Size=UDim2.new(1,0,0,40); skinBtnFrame.BackgroundTransparency=1
    skinBtnFrame.Parent=content
    
    local skins = {"Default", "Red", "Blue", "Gold", "Green"}
    for i, skinName in ipairs(skins) do
        local sb = Instance.new("TextButton")
        sb.Size=UDim2.new(0, 62, 0, 36)
        sb.Position=UDim2.new(0, (i-1) * 68, 0, 0)
        sb.BackgroundColor3 = THEME.Elem
        sb.Text = skinName
        sb.TextColor3 = THEME.Text
        sb.Font = Enum.Font.GothamSemibold
        sb.TextSize = 11
        sb.Parent = skinBtnFrame
        corner(sb, 8)
        sb.MouseButton1Click:Connect(function()
            SKIN.SelectedSkin = skinName
            for _, child in ipairs(skinBtnFrame:GetChildren()) do
                if child:IsA("TextButton") then
                    child.BackgroundColor3 = child.Text == skinName and THEME.Accent or THEME.Elem
                end
            end
        end)
    end

    section("Community", "📢")
    button("📢  JOIN TELEGRAM", function()
        pcall(function() game:GetService("GuiService"):OpenBrowserWindow(AUTHOR.TelegramURL) end)
        if setclipboard then pcall(function() setclipboard(AUTHOR.TelegramURL) end) end
    end, THEME.Telegram)

    local footer = Instance.new("TextLabel")
    footer.Size=UDim2.new(1,0,0,24); footer.BackgroundTransparency=1
    footer.Text="© "..AUTHOR.Name.." • v"..AUTHOR.Version
    footer.TextColor3=THEME.TextDim; footer.Font=Enum.Font.Gotham
    footer.TextSize=10; footer.Parent=content

    close.MouseButton1Click:Connect(function()
        sg:Destroy()
        local reopen = Instance.new("ScreenGui")
        reopen.Name="ReopenBtn"; reopen.ResetOnSpawn=false; reopen.IgnoreGuiInset=true
        reopen.Parent=LocalPlayer:WaitForChild("PlayerGui")
        local btn = Instance.new("TextButton")
        btn.Size=UDim2.new(0,64,0,64); btn.Position=UDim2.new(0,20,0.5,-32)
        btn.BackgroundColor3=THEME.Accent; btn.Text="🎯"
        btn.TextColor3=Color3.fromRGB(255,255,255); btn.Font=Enum.Font.GothamBold
        btn.TextSize=28; btn.AutoButtonColor=false; btn.Active=true; btn.Draggable=true
        btn.Parent=reopen; corner(btn,32); stroke(btn, THEME.Accent2, 2, 0)
        btn.MouseButton1Click:Connect(function() reopen:Destroy(); buildMenu() end)
    end)
end

local function keyScreen()
    local sg = Instance.new("ScreenGui")
    sg.Name="BS_KeyUI"; sg.ResetOnSpawn=false; sg.IgnoreGuiInset=true
    sg.ZIndexBehavior=Enum.ZIndexBehavior.Sibling
    sg.Parent=LocalPlayer:WaitForChild("PlayerGui")

    local bg = Instance.new("Frame")
    bg.Size=UDim2.new(1,0,1,0); bg.BackgroundColor3=Color3.new(0,0,0)
    bg.BackgroundTransparency=0.4; bg.BorderSizePixel=0; bg.Parent=sg

    local SCREEN = Camera.ViewportSize
    local w = math.min(370, SCREEN.X - 30); local h = 380

    local main = Instance.new("Frame")
    main.Size=UDim2.new(0,w,0,h); main.Position=UDim2.new(0.5,-w/2,0.5,-h/2)
    main.BackgroundColor3=THEME.BG; main.BorderSizePixel=0
    main.ClipsDescendants=true; main.Parent=sg
    corner(main,16); stroke(main, THEME.Accent, 1.5, 0.3)

    local topBar = Instance.new("Frame")
    topBar.Size=UDim2.new(1,0,0,4); topBar.BackgroundColor3=THEME.Accent
    topBar.BorderSizePixel=0; topBar.Parent=main
    gradient(topBar, THEME.Accent, THEME.Accent2, 0)

    local icon = Instance.new("TextLabel")
    icon.Size=UDim2.new(0,60,0,60); icon.Position=UDim2.new(0.5,-30,0,22)
    icon.BackgroundTransparency=1; icon.Text="🎯"; icon.TextSize=40; icon.Parent=main

    local title = Instance.new("TextLabel")
    title.Size=UDim2.new(1,0,0,24); title.Position=UDim2.new(0,0,0,94)
    title.BackgroundTransparency=1; title.Text="ENTER ACCESS KEY"
    title.TextColor3=THEME.Text; title.Font=Enum.Font.GothamBold
    title.TextSize=17; title.Parent=main

    local sub = Instance.new("TextLabel")
    sub.Size=UDim2.new(1,0,0,16); sub.Position=UDim2.new(0,0,0,120)
    sub.BackgroundTransparency=1; sub.Text="BLOXSTRIKE MENU v"..AUTHOR.Version
    sub.TextColor3=THEME.TextDim; sub.Font=Enum.Font.Gotham
    sub.TextSize=11; sub.Parent=main

    local input = Instance.new("TextBox")
    input.Size=UDim2.new(1,-50,0,50); input.Position=UDim2.new(0,25,0,156)
    input.BackgroundColor3=THEME.Elem; input.Text=""
    input.PlaceholderText="Enter key..."; input.PlaceholderColor3=THEME.TextDim
    input.TextColor3=THEME.Text; input.Font=Enum.Font.GothamSemibold
    input.TextSize=15; input.ClearTextOnFocus=false; input.Parent=main
    corner(input,12); local inpStroke = stroke(input, THEME.Stroke, 1, 0)

    local btn = Instance.new("TextButton")
    btn.Size=UDim2.new(1,-50,0,50); btn.Position=UDim2.new(0,25,0,216)
    btn.BackgroundColor3=THEME.Accent; btn.Text="🔓  ACTIVATE"
    btn.TextColor3=Color3.fromRGB(255,255,255); btn.Font=Enum.Font.GothamBold
    btn.TextSize=15; btn.AutoButtonColor=false; btn.Parent=main
    corner(btn,12); gradient(btn, THEME.Accent, THEME.Accent2, 0)

    local tg = Instance.new("TextButton")
    tg.Size=UDim2.new(1,-50,0,44); tg.Position=UDim2.new(0,25,0,276)
    tg.BackgroundColor3=THEME.Telegram; tg.Text="📢  JOIN TELEGRAM"
    tg.TextColor3=Color3.fromRGB(255,255,255); tg.Font=Enum.Font.GothamBold
    tg.TextSize=13; tg.AutoButtonColor=false; tg.Parent=main; corner(tg,12)
    tg.MouseButton1Click:Connect(function()
        pcall(function() game:GetService("GuiService"):OpenBrowserWindow(AUTHOR.TelegramURL) end)
        if setclipboard then pcall(function() setclipboard(AUTHOR.TelegramURL) end) end
    end)

    local status = Instance.new("TextLabel")
    status.Size=UDim2.new(1,-50,0,20); status.Position=UDim2.new(0,25,1,-46)
    status.BackgroundTransparency=1; status.Text=""
    status.TextColor3=THEME.Danger; status.Font=Enum.Font.Gotham
    status.TextSize=12; status.Parent=main

    local credit = Instance.new("TextLabel")
    credit.Size=UDim2.new(1,-50,0,16); credit.Position=UDim2.new(0,25,1,-24)
    credit.BackgroundTransparency=1; credit.Text="by "..AUTHOR.Name
    credit.TextColor3=THEME.TextDim; credit.Font=Enum.Font.Gotham
    credit.TextSize=10; credit.Parent=main

    local function activate()
        if input.Text == UNIVERSAL_KEY then
            status.Text="✅ Access granted!"; status.TextColor3=THEME.Success
            inpStroke.Color=THEME.Success
            task.wait(0.6); sg:Destroy(); buildMenu()
        else
            status.Text="❌ Invalid key"; status.TextColor3=THEME.Danger
            inpStroke.Color=THEME.Danger
            local orig = main.Position
            for i = 1, 4 do
                TweenService:Create(main, TweenInfo.new(0.05), {
                    Position = orig + UDim2.new(0, (i % 2 == 0 and 8 or -8), 0, 0)}):Play()
                task.wait(0.05)
            end
            TweenService:Create(main, TweenInfo.new(0.05), {Position = orig}):Play()
        end
    end
    btn.MouseButton1Click:Connect(activate)
    input.FocusLost:Connect(function(e) if e then activate() end end)
end

local ok, err = pcall(keyScreen)
if ok then
    print("[BS-PART2] Menu loaded successfully!")
else
    warn("[BS-PART2 ERROR] "..tostring(err))
end
