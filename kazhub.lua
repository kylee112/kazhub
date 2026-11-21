-- language: Lua, executor: Delta, game: Anime Crusaders
-- KAZ HUB v1.4 | Dark + Teal Toggle UI + Anti-AFK

pcall(function()
    game:GetService("CoreGui"):FindFirstChild("KazHub"):Destroy()
end)

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")
local VPS = game:GetService("VirtualUser")
local lp = Players.LocalPlayer

local state = {
    antiafk=false, autopilot=false, autoreplay=false, autostart=false,
    autoskip=false, autoupgrade=false, autosell=false,
    autoquest=false, macrorecord=false,
}
local macroData = {}
local gameEndCooldown = false

-- Anti-AFK (always active)
lp.Idled:Connect(function()
    VPS:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    task.wait(1)
    VPS:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
end)

local function onGameEnd(cb)
    task.spawn(function()
        while true do
            task.wait(1)
            local ended = false
            pcall(function()
                for _, v in ipairs(lp.PlayerGui:GetDescendants()) do
                    local n = v.Name:lower()
                    if (n:find("result") or n:find("end") or n:find("victory")
                        or n:find("complete") or n:find("next")) and v.Visible then
                        ended = true
                    end
                end
            end)
            if ended and not gameEndCooldown then
                gameEndCooldown = true
                cb()
                task.wait(5)
                gameEndCooldown = false
            end
        end
    end)
end

local function fireRemote(keywords, arg)
    for _, v in ipairs(game:GetDescendants()) do
        if v:IsA("RemoteEvent") or v:IsA("RemoteFunction") then
            local n = v.Name:lower()
            for _, kw in ipairs(keywords) do
                if n:find(kw) then
                    pcall(function()
                        if v:IsA("RemoteEvent") then
                            if arg then v:FireServer(arg) else v:FireServer() end
                        else
                            if arg then v:InvokeServer(arg) else v:InvokeServer() end
                        end
                    end)
                    break
                end
            end
        end
    end
end

-- GUI
local screen = Instance.new("ScreenGui")
screen.Name = "KazHub"
screen.ResetOnSpawn = false
screen.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screen.Parent = CoreGui

local tab = Instance.new("Frame")
tab.Name = "MinTab"
tab.Size = UDim2.new(0,120,0,32)
tab.Position = UDim2.new(0,20,0,20)
tab.BackgroundColor3 = Color3.fromRGB(14,14,20)
tab.BorderSizePixel = 0
tab.Active = true
tab.Draggable = true
tab.Visible = false
tab.Parent = screen
local tabStroke = Instance.new("UIStroke")
tabStroke.Color = Color3.fromRGB(0,180,150)
tabStroke.Thickness = 1.5
tabStroke.Parent = tab
local tabCorner = Instance.new("UICorner")
tabCorner.CornerRadius = UDim.new(0,8)
tabCorner.Parent = tab
local tabLabel = Instance.new("TextLabel")
tabLabel.Size = UDim2.new(1,0,1,0)
tabLabel.BackgroundTransparency = 1
tabLabel.Text = "⚡ KAZ HUB"
tabLabel.TextColor3 = Color3.fromRGB(0,210,170)
tabLabel.TextSize = 12
tabLabel.Font = Enum.Font.GothamBold
tabLabel.Parent = tab

local main = Instance.new("Frame")
main.Name = "Main"
main.Size = UDim2.new(0,320,0,500)
main.Position = UDim2.new(0.5,-160,0.5,-250)
main.BackgroundColor3 = Color3.fromRGB(14,14,20)
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true
main.ClipsDescendants = true
main.Parent = screen
local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0,14)
mainCorner.Parent = main
local mainStroke = Instance.new("UIStroke")
mainStroke.Color = Color3.fromRGB(35,35,50)
mainStroke.Thickness = 1.5
mainStroke.Parent = main

local header = Instance.new("Frame")
header.Size = UDim2.new(1,0,0,52)
header.BackgroundColor3 = Color3.fromRGB(18,18,26)
header.BorderSizePixel = 0
header.Parent = main
local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0,14)
headerCorner.Parent = header
local headerFix = Instance.new("Frame")
headerFix.Size = UDim2.new(1,0,0,14)
headerFix.Position = UDim2.new(0,0,1,-14)
headerFix.BackgroundColor3 = Color3.fromRGB(18,18,26)
headerFix.BorderSizePixel = 0
headerFix.Parent = header

local icon = Instance.new("TextLabel")
icon.Size = UDim2.new(0,30,0,30)
icon.Position = UDim2.new(0,14,0,11)
icon.BackgroundTransparency = 1
icon.Text = "⚡"
icon.TextSize = 20
icon.Font = Enum.Font.GothamBold
icon.TextColor3 = Color3.fromRGB(0,210,170)
icon.Parent = header

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(0,180,0,20)
titleLabel.Position = UDim2.new(0,48,0,8)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "KAZ HUB"
titleLabel.TextColor3 = Color3.fromRGB(232,232,240)
titleLabel.TextSize = 15
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = header

local subLabel = Instance.new("TextLabel")
subLabel.Size = UDim2.new(0,180,0,16)
subLabel.Position = UDim2.new(0,48,0,27)
subLabel.BackgroundTransparency = 1
subLabel.Text = "Anime Crusaders"
subLabel.TextColor3 = Color3.fromRGB(80,80,110)
subLabel.TextSize = 11
subLabel.Font = Enum.Font.Gotham
subLabel.TextXAlignment = Enum.TextXAlignment.Left
subLabel.Parent = header

local hideBtn = Instance.new("TextButton")
hideBtn.Size = UDim2.new(0,26,0,26)
hideBtn.Position = UDim2.new(1,-38,0,13)
hideBtn.BackgroundColor3 = Color3.fromRGB(30,30,42)
hideBtn.Text = "—"
hideBtn.TextColor3 = Color3.fromRGB(120,120,160)
hideBtn.TextSize = 12
hideBtn.Font = Enum.Font.GothamBold
hideBtn.BorderSizePixel = 0
hideBtn.Parent = header
local hideBtnCorner = Instance.new("UICorner")
hideBtnCorner.CornerRadius = UDim.new(0,6)
hideBtnCorner.Parent = hideBtn

local statusBar = Instance.new("Frame")
statusBar.Size = UDim2.new(1,0,0,28)
statusBar.Position = UDim2.new(0,0,0,52)
statusBar.BackgroundColor3 = Color3.fromRGB(16,16,22)
statusBar.BorderSizePixel = 0
statusBar.Parent = main
local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1,-16,1,0)
statusLabel.Position = UDim2.new(0,12,0,0)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "● Ready"
statusLabel.TextColor3 = Color3.fromRGB(0,180,150)
statusLabel.TextSize = 11
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextXAlignment = Enum.TextXAlignment.Left
statusLabel.Parent = statusBar

local function setStatus(msg)
    statusLabel.Text = "● " .. msg
end

local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(1,0,1,-108)
scroll.Position = UDim2.new(0,0,0,80)
scroll.BackgroundTransparency = 1
scroll.BorderSizePixel = 0
scroll.ScrollBarThickness = 3
scroll.ScrollBarImageColor3 = Color3.fromRGB(0,180,150)
scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
scroll.CanvasSize = UDim2.new(0,0,0,0)
scroll.Parent = main

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0,4)
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Parent = scroll

local bodyPad = Instance.new("UIPadding")
bodyPad.PaddingLeft = UDim.new(0,10)
bodyPad.PaddingRight = UDim.new(0,10)
bodyPad.PaddingTop = UDim.new(0,8)
bodyPad.PaddingBottom = UDim.new(0,10)
bodyPad.Parent = scroll

local rowOrder = 0

local function makeSection(text)
    rowOrder += 1
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1,-20,0,20)
    f.BackgroundTransparency = 1
    f.LayoutOrder = rowOrder
    f.Parent = scroll
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1,0,1,0)
    lbl.BackgroundTransparency = 1
    lbl.Text = text:upper()
    lbl.TextColor3 = Color3.fromRGB(60,60,88)
    lbl.TextSize = 9
    lbl.Font = Enum.Font.GothamBold
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.LetterSpacing = 2
    lbl.Parent = f
end

local function makeToggle(label, stateKey, onFire)
    rowOrder += 1
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1,-20,0,42)
    row.BackgroundColor3 = Color3.fromRGB(20,20,30)
    row.BorderSizePixel = 0
    row.LayoutOrder = rowOrder
    row.Parent = scroll
    local rc = Instance.new("UICorner")
    rc.CornerRadius = UDim.new(0,10)
    rc.Parent = row
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(35,35,50)
    stroke.Thickness = 1
    stroke.Parent = row

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1,-60,1,0)
    lbl.Position = UDim2.new(0,12,0,0)
    lbl.BackgroundTransparency = 1
    lbl.Text = label
    lbl.TextColor3 = Color3.fromRGB(190,190,210)
    lbl.TextSize = 12
    lbl.Font = Enum.Font.Gotham
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = row

    local pill = Instance.new("Frame")
    pill.Size = UDim2.new(0,42,0,24)
    pill.Position = UDim2.new(1,-54,0.5,-12)
    pill.BackgroundColor3 = Color3.fromRGB(40,40,58)
    pill.BorderSizePixel = 0
    pill.Parent = row
    local pc = Instance.new("UICorner")
    pc.CornerRadius = UDim.new(1,0)
    pc.Parent = pill

    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0,18,0,18)
    knob.Position = UDim2.new(0,3,0.5,-9)
    knob.BackgroundColor3 = Color3.fromRGB(100,100,130)
    knob.BorderSizePixel = 0
    knob.Parent = pill
    local kc = Instance.new("UICorner")
    kc.CornerRadius = UDim.new(1,0)
    kc.Parent = knob

    local hitbox = Instance.new("TextButton")
    hitbox.Size = UDim2.new(1,0,1,0)
    hitbox.BackgroundTransparency = 1
    hitbox.Text = ""
    hitbox.Parent = row

    hitbox.MouseButton1Click:Connect(function()
        state[stateKey] = not state[stateKey]
        local on = state[stateKey]
        pill.BackgroundColor3 = on and Color3.fromRGB(0,180,150) or Color3.fromRGB(40,40,58)
        knob.BackgroundColor3 = on and Color3.fromRGB(255,255,255) or Color3.fromRGB(100,100,130)
        knob.Position = on and UDim2.new(1,-21,0.5,-9) or UDim2.new(0,3,0.5,-9)
        stroke.Color = on and Color3.fromRGB(0,160,130) or Color3.fromRGB(35,35,50)
        if on then
            setStatus(label .. " ON")
            if onFire then task.spawn(onFire) end
        else
            setStatus(label .. " OFF")
        end
    end)
end

local function makeAction(label, cb)
    rowOrder += 1
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1,-20,0,38)
    btn.BackgroundColor3 = Color3.fromRGB(20,20,30)
    btn.BorderSizePixel = 0
    btn.Text = label
    btn.TextColor3 = Color3.fromRGB(190,190,210)
    btn.TextSize = 12
    btn.Font = Enum.Font.Gotham
    btn.LayoutOrder = rowOrder
    btn.Parent = scroll
    local bc = Instance.new("UICorner")
    bc.CornerRadius = UDim.new(0,10)
    bc.Parent = btn
    local bs = Instance.new("UIStroke")
    bs.Color = Color3.fromRGB(35,35,50)
    bs.Thickness = 1
    bs.Parent = btn

    btn.MouseButton1Click:Connect(function()
        btn.BackgroundColor3 = Color3.fromRGB(0,160,130)
        task.wait(0.2)
        btn.BackgroundColor3 = Color3.fromRGB(20,20,30)
        if cb then task.spawn(cb) end
    end)
end

local mapName = ""
local function makeMapBox()
    rowOrder += 1
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1,-20,0,38)
    f.BackgroundColor3 = Color3.fromRGB(20,20,30)
    f.BorderSizePixel = 0
    f.LayoutOrder = rowOrder
    f.Parent = scroll
    local fc = Instance.new("UICorner")
    fc.CornerRadius = UDim.new(0,10)
    fc.Parent = f
    local fs = Instance.new("UIStroke")
    fs.Color = Color3.fromRGB(35,35,50)
    fs.Thickness = 1
    fs.Parent = f
    local box = Instance.new("TextBox")
    box.Size = UDim2.new(1,-20,1,0)
    box.Position = UDim2.new(0,10,0,0)
    box.BackgroundTransparency = 1
    box.PlaceholderText = "Enter map name..."
    box.PlaceholderColor3 = Color3.fromRGB(60,60,88)
    box.Text = ""
    box.TextColor3 = Color3.fromRGB(190,190,210)
    box.TextSize = 12
    box.Font = Enum.Font.Gotham
    box.TextXAlignment = Enum.TextXAlignment.Left
    box.Parent = f
    box:GetPropertyChangedSignal("Text"):Connect(function()
        mapName = box.Text
    end)
end

-- build layout
makeSection("Protection")
makeToggle("🛡  Anti AFK","antiafk") -- VPS already hooked globally above

makeSection("Automation")
makeToggle("Auto Next Stage","autopilot",function()
    onGameEnd(function()
        fireRemote({"next","stage","advance","proceed"})
        setStatus("Next stage fired!")
    end)
end)
makeToggle("Auto Replay","autoreplay",function()
    onGameEnd(function()
        fireRemote({"replay","restart","again","retry"})
        setStatus("Replay fired!")
    end)
end)
makeToggle("Auto Start","autostart",function()
    task.spawn(function()
        while state.autostart do
            fireRemote({"start","begin","launch"})
            task.wait(3)
        end
    end)
end)
makeToggle("Auto Skip Wave","autoskip",function()
    task.spawn(function()
        while state.autoskip do
            fireRemote({"skip","wave","skipwave"})
            task.wait(2)
        end
    end)
end)
makeToggle("Auto Upgrade Units","autoupgrade",function()
    task.spawn(function()
        while state.autoupgrade do
            fireRemote({"upgrade","level","enhance"})
            task.wait(4)
        end
    end)
end)
makeToggle("Auto Sell Excess","autosell",function()
    task.spawn(function()
        while state.autosell do
            fireRemote({"sell","remove","excess"})
            task.wait(5)
        end
    end)
end)
makeToggle("Auto Quest","autoquest",function()
    task.spawn(function()
        while state.autoquest do
            fireRemote({"quest","claim","complete","daily"})
            task.wait(10)
        end
    end)
end)

makeSection("Macro")
makeToggle("⏺ Record Macro","macrorecord",function()
    macroData = {}
    setStatus("Recording...")
end)
makeAction("▶  Play Macro",function()
    setStatus("Playing macro...")
    for _,entry in ipairs(macroData) do
        fireRemote({entry.remote}, entry.arg)
        task.wait(entry.delay or 0.5)
    end
    setStatus("Macro done!")
end)

makeSection("Map & Join")
makeMapBox()
makeAction("🗺  Auto Join Selected Map",function()
    if mapName ~= "" then
        fireRemote({"join","map","teleport","load"}, mapName)
        setStatus("Joining: "..mapName)
    else
        setStatus("Enter a map name first!")
    end
end)

makeSection("Quick Actions")
makeAction("🎁  Redeem All Codes",function()
    fireRemote({"redeem","code","gift"})
    setStatus("Codes redeemed!")
end)
makeAction("⭐  Collect Daily Rewards",function()
    fireRemote({"daily","reward","collect","claim"})
    setStatus("Daily rewards collected!")
end)
makeAction("🌀  Auto Summon x10",function()
    for i=1,10 do
        fireRemote({"summon","pull","gacha","roll"})
        task.wait(0.3)
    end
    setStatus("Summoned x10!")
end)
makeAction("🔍  Scan All Remotes",function()
    local found = {}
    for _, v in ipairs(game:GetDescendants()) do
        if v:IsA("RemoteEvent") or v:IsA("RemoteFunction") then
            table.insert(found, v.Name)
        end
    end
    setStatus("Found "..#found.." remotes — check Output")
    for _,n in ipairs(found) do print("[KazHub Remote]", n) end
end)

rowOrder += 1
local footerPad = Instance.new("Frame")
footerPad.Size = UDim2.new(1,-20,0,24)
footerPad.BackgroundTransparency = 1
footerPad.LayoutOrder = rowOrder
footerPad.Parent = scroll
local footer = Instance.new("TextLabel")
footer.Size = UDim2.new(1,0,1,0)
footer.BackgroundTransparency = 1
footer.Text = "KAZ HUB v1.4  •  Anime Crusaders"
footer.TextColor3 = Color3.fromRGB(40,40,60)
footer.TextSize = 10
footer.Font = Enum.Font.Gotham
footer.Parent = footerPad

local resizeBtn = Instance.new("TextButton")
resizeBtn.Size = UDim2.new(0,22,0,22)
resizeBtn.Position = UDim2.new(1,-24,1,-24)
resizeBtn.BackgroundColor3 = Color3.fromRGB(20,20,30)
resizeBtn.Text = "⤡"
resizeBtn.TextColor3 = Color3.fromRGB(0,180,150)
resizeBtn.TextSize = 14
resizeBtn.Font = Enum.Font.GothamBold
resizeBtn.BorderSizePixel = 0
resizeBtn.ZIndex = 10
resizeBtn.Parent = main
local rc2 = Instance.new("UICorner")
rc2.CornerRadius = UDim.new(0,6)
rc2.Parent = resizeBtn

local resizing = false
local resizeStart, sizeStart

resizeBtn.MouseButton1Down:Connect(function()
    resizing = true
    resizeStart = UIS:GetMouseLocation()
    sizeStart = main.AbsoluteSize
end)
UIS.InputEnded:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 then
        resizing = false
    end
end)
RS.RenderStepped:Connect(function()
    if resizing then
        local cur = UIS:GetMouseLocation()
        local dx = cur.X - resizeStart.X
        local dy = cur.Y - resizeStart.Y
        local nw = math.clamp(sizeStart.X + dx, 220, 500)
        local nh = math.clamp(sizeStart.Y + dy, 300, 700)
        main.Size = UDim2.new(0, nw, 0, nh)
    end
end)

hideBtn.MouseButton1Click:Connect(function()
    main.Visible = false
    tab.Visible = true
end)
tab.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 then
        tab.Visible = false
        main.Visible = true
    end
end)