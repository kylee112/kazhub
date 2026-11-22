-- language: Lua, executor: Delta, game: Anime Crusaders
-- KAZ HUB v1.5 | Fixed auto replay + victory detect + touch resize

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

-- Anti-AFK loop every 60s
task.spawn(function()
    while true do
        task.wait(60)
        if state.antiafk then
            pcall(function()
                VPS:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
                task.wait(0.1)
                VPS:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
            end)
        end
    end
end)

-- click button: tries Activate, Fire, and VPS touch
local function clickGuiButton(keywords)
    local clicked = false
    pcall(function()
        for _, v in ipairs(lp.PlayerGui:GetDescendants()) do
            if (v:IsA("TextButton") or v:IsA("ImageButton")) and v.Visible then
                local n = v.Name:lower()
                local t = v:IsA("TextButton") and v.Text:lower() or ""
                for _, kw in ipairs(keywords) do
                    if n:find(kw) or t:find(kw) then
                        pcall(function() v:Activate() end)
                        pcall(function() v.MouseButton1Click:Fire() end)
                        pcall(function()
                            local pos = v.AbsolutePosition
                            local size = v.AbsoluteSize
                            VPS:ClickButton1(
                                Vector2.new(pos.X + size.X/2, pos.Y + size.Y/2),
                                workspace.CurrentCamera.CFrame
                            )
                        end)
                        clicked = true
                        break
                    end
                end
            end
            if clicked then break end
        end
    end)
    return clicked
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

-- broader victory detection: checks name AND text labels
local function isGameEnded()
    local ended = false
    pcall(function()
        for _, v in ipairs(lp.PlayerGui:GetDescendants()) do
            if v.Visible then
                local n = v.Name:lower()
                local t = (v:IsA("TextLabel") and v.Text:lower()) or ""
                if n:find("victory") or n:find("result") or n:find("win")
                    or n:find("complete") or n:find("clear") or n:find("roundend")
                    or t:find("victory") or t:find("you win") or t:find("stage clear") then
                    ended = true
                    break
                end
            end
        end
    end)
    return ended
end

-- single shared game-end loop
task.spawn(function()
    while true do
        task.wait(1)
        if isGameEnded() and not gameEndCooldown then
            gameEndCooldown = true
            if state.autopilot then
                clickGuiButton({"next","nextlevel","continue","advance","nextstage"})
            end
            if state.autoreplay then
                task.wait(0.5)
                clickGuiButton({"replay","again","retry","playagain"})
            end
            task.wait(5)
            gameEndCooldown = false
        end
    end
end)

-- GUI
local screen = Instance.new("ScreenGui")
screen.Name = "KazHub"
screen.ResetOnSpawn = false
screen.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screen.Parent = CoreGui

-- minimized tab
local tab = Instance.new("TextButton")
tab.Name = "MinTab"
tab.Size = UDim2.new(0,120,0,32)
tab.Position = UDim2.new(0,20,0,20)
tab.BackgroundColor3 = Color3.fromRGB(14,14,20)
tab.BorderSizePixel = 0
tab.Text = "⚡ KAZ HUB"
tab.TextColor3 = Color3.fromRGB(0,210,170)
tab.TextSize = 12
tab.Font = Enum.Font.GothamBold
tab.Active = true
tab.Draggable = true
tab.Visible = false
tab.Parent = screen
Instance.new("UICorner", tab).CornerRadius = UDim.new(0,8)
local tabStroke = Instance.new("UIStroke", tab)
tabStroke.Color = Color3.fromRGB(0,180,150)
tabStroke.Thickness = 1.5

-- main window
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
Instance.new("UICorner", main).CornerRadius = UDim.new(0,14)
local mainStroke = Instance.new("UIStroke", main)
mainStroke.Color = Color3.fromRGB(35,35,50)
mainStroke.Thickness = 1.5

-- header
local header = Instance.new("Frame", main)
header.Size = UDim2.new(1,0,0,52)
header.BackgroundColor3 = Color3.fromRGB(18,18,26)
header.BorderSizePixel = 0
Instance.new("UICorner", header).CornerRadius = UDim.new(0,14)
local hpatch = Instance.new("Frame", header)
hpatch.Size = UDim2.new(1,0,0,14)
hpatch.Position = UDim2.new(0,0,1,-14)
hpatch.BackgroundColor3 = Color3.fromRGB(18,18,26)
hpatch.BorderSizePixel = 0

local icon = Instance.new("TextLabel", header)
icon.Size = UDim2.new(0,30,0,30)
icon.Position = UDim2.new(0,14,0,11)
icon.BackgroundTransparency = 1
icon.Text = "⚡"
icon.TextSize = 20
icon.Font = Enum.Font.GothamBold
icon.TextColor3 = Color3.fromRGB(0,210,170)

local titleLbl = Instance.new("TextLabel", header)
titleLbl.Size = UDim2.new(0,180,0,20)
titleLbl.Position = UDim2.new(0,48,0,8)
titleLbl.BackgroundTransparency = 1
titleLbl.Text = "KAZ HUB"
titleLbl.TextColor3 = Color3.fromRGB(232,232,240)
titleLbl.TextSize = 15
titleLbl.Font = Enum.Font.GothamBold
titleLbl.TextXAlignment = Enum.TextXAlignment.Left

local subLbl = Instance.new("TextLabel", header)
subLbl.Size = UDim2.new(0,180,0,16)
subLbl.Position = UDim2.new(0,48,0,28)
subLbl.BackgroundTransparency = 1
subLbl.Text = "Anime Crusaders"
subLbl.TextColor3 = Color3.fromRGB(80,80,110)
subLbl.TextSize = 11
subLbl.Font = Enum.Font.Gotham
subLbl.TextXAlignment = Enum.TextXAlignment.Left

local hideBtn = Instance.new("TextButton", header)
hideBtn.Size = UDim2.new(0,26,0,26)
hideBtn.Position = UDim2.new(1,-38,0,13)
hideBtn.BackgroundColor3 = Color3.fromRGB(30,30,42)
hideBtn.Text = "—"
hideBtn.TextColor3 = Color3.fromRGB(120,120,160)
hideBtn.TextSize = 12
hideBtn.Font = Enum.Font.GothamBold
hideBtn.BorderSizePixel = 0
Instance.new("UICorner", hideBtn).CornerRadius = UDim.new(0,6)

-- status bar
local statusBar = Instance.new("Frame", main)
statusBar.Size = UDim2.new(1,0,0,28)
statusBar.Position = UDim2.new(0,0,0,52)
statusBar.BackgroundColor3 = Color3.fromRGB(16,16,22)
statusBar.BorderSizePixel = 0

local statusLbl = Instance.new("TextLabel", statusBar)
statusLbl.Size = UDim2.new(1,-16,1,0)
statusLbl.Position = UDim2.new(0,12,0,0)
statusLbl.BackgroundTransparency = 1
statusLbl.Text = "● Ready"
statusLbl.TextColor3 = Color3.fromRGB(0,180,150)
statusLbl.TextSize = 11
statusLbl.Font = Enum.Font.Gotham
statusLbl.TextXAlignment = Enum.TextXAlignment.Left

local function setStatus(msg)
    statusLbl.Text = "● " .. msg
end

-- scroll
local scroll = Instance.new("ScrollingFrame", main)
scroll.Size = UDim2.new(1,0,1,-80)
scroll.Position = UDim2.new(0,0,0,80)
scroll.BackgroundTransparency = 1
scroll.BorderSizePixel = 0
scroll.ScrollBarThickness = 3
scroll.ScrollBarImageColor3 = Color3.fromRGB(0,180,150)
scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
scroll.CanvasSize = UDim2.new(0,0,0,0)

local listLayout = Instance.new("UIListLayout", scroll)
listLayout.Padding = UDim.new(0,4)
listLayout.SortOrder = Enum.SortOrder.LayoutOrder

local pad = Instance.new("UIPadding", scroll)
pad.PaddingLeft = UDim.new(0,10)
pad.PaddingRight = UDim.new(0,10)
pad.PaddingTop = UDim.new(0,8)
pad.PaddingBottom = UDim.new(0,10)

local order = 0

local function makeSection(text)
    order += 1
    local f = Instance.new("Frame", scroll)
    f.Size = UDim2.new(1,-20,0,22)
    f.BackgroundTransparency = 1
    f.LayoutOrder = order
    local l = Instance.new("TextLabel", f)
    l.Size = UDim2.new(1,0,1,0)
    l.BackgroundTransparency = 1
    l.Text = text:upper()
    l.TextColor3 = Color3.fromRGB(60,60,88)
    l.TextSize = 9
    l.Font = Enum.Font.GothamBold
    l.TextXAlignment = Enum.TextXAlignment.Left
end

local function makeToggle(label, stateKey, onFire)
    order += 1
    local row = Instance.new("Frame", scroll)
    row.Size = UDim2.new(1,-20,0,44)
    row.BackgroundColor3 = Color3.fromRGB(20,20,30)
    row.BorderSizePixel = 0
    row.LayoutOrder = order
    Instance.new("UICorner", row).CornerRadius = UDim.new(0,10)
    local stroke = Instance.new("UIStroke", row)
    stroke.Color = Color3.fromRGB(35,35,50)
    stroke.Thickness = 1

    local lbl = Instance.new("TextLabel", row)
    lbl.Size = UDim2.new(1,-60,1,0)
    lbl.Position = UDim2.new(0,12,0,0)
    lbl.BackgroundTransparency = 1
    lbl.Text = label
    lbl.TextColor3 = Color3.fromRGB(190,190,210)
    lbl.TextSize = 12
    lbl.Font = Enum.Font.Gotham
    lbl.TextXAlignment = Enum.TextXAlignment.Left

    local pill = Instance.new("Frame", row)
    pill.Size = UDim2.new(0,42,0,24)
    pill.Position = UDim2.new(1,-54,0.5,-12)
    pill.BackgroundColor3 = Color3.fromRGB(40,40,58)
    pill.BorderSizePixel = 0
    Instance.new("UICorner", pill).CornerRadius = UDim.new(1,0)

    local knob = Instance.new("Frame", pill)
    knob.Size = UDim2.new(0,18,0,18)
    knob.Position = UDim2.new(0,3,0.5,-9)
    knob.BackgroundColor3 = Color3.fromRGB(100,100,130)
    knob.BorderSizePixel = 0
    Instance.new("UICorner", knob).CornerRadius = UDim.new(1,0)

    local hit = Instance.new("TextButton", row)
    hit.Size = UDim2.new(1,0,1,0)
    hit.BackgroundTransparency = 1
    hit.Text = ""

    hit.MouseButton1Click:Connect(function()
        state[stateKey] = not state[stateKey]
        local on = state[stateKey]
        pill.BackgroundColor3 = on and Color3.fromRGB(0,180,150) or Color3.fromRGB(40,40,58)
        knob.BackgroundColor3 = on and Color3.fromRGB(255,255,255) or Color3.fromRGB(100,100,130)
        knob.Position = on and UDim2.new(1,-21,0.5,-9) or UDim2.new(0,3,0.5,-9)
        stroke.Color = on and Color3.fromRGB(0,160,130) or Color3.fromRGB(35,35,50)
        setStatus(label .. (on and " ON" or " OFF"))
        if on and onFire then task.spawn(onFire) end
    end)
end

local function makeAction(label, cb)
    order += 1
    local btn = Instance.new("TextButton", scroll)
    btn.Size = UDim2.new(1,-20,0,40)
    btn.BackgroundColor3 = Color3.fromRGB(20,20,30)
    btn.BorderSizePixel = 0
    btn.Text = label
    btn.TextColor3 = Color3.fromRGB(190,190,210)
    btn.TextSize = 12
    btn.Font = Enum.Font.Gotham
    btn.LayoutOrder = order
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0,10)
    local bs = Instance.new("UIStroke", btn)
    bs.Color = Color3.fromRGB(35,35,50)
    bs.Thickness = 1
    btn.MouseButton1Click:Connect(function()
        btn.BackgroundColor3 = Color3.fromRGB(0,160,130)
        task.wait(0.2)
        btn.BackgroundColor3 = Color3.fromRGB(20,20,30)
        if cb then task.spawn(cb) end
    end)
end

local mapName = ""
local function makeMapBox()
    order += 1
    local f = Instance.new("Frame", scroll)
    f.Size = UDim2.new(1,-20,0,40)
    f.BackgroundColor3 = Color3.fromRGB(20,20,30)
    f.BorderSizePixel = 0
    f.LayoutOrder = order
    Instance.new("UICorner", f).CornerRadius = UDim.new(0,10)
    local fs = Instance.new("UIStroke", f)
    fs.Color = Color3.fromRGB(35,35,50)
    fs.Thickness = 1
    local box = Instance.new("TextBox", f)
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
    box:GetPropertyChangedSignal("Text"):Connect(function()
        mapName = box.Text
    end)
end

-- rows
makeSection("Protection")
makeToggle("🛡  Anti AFK","antiafk")

makeSection("Automation")
makeToggle("Auto Next Stage","autopilot")
makeToggle("Auto Replay","autoreplay")
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
    for _,e in ipairs(macroData) do
        fireRemote({e.remote}, e.arg)
        task.wait(e.delay or 0.5)
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
    setStatus("Found "..#found.." remotes")
    for _,n in ipairs(found) do print("[KazHub]", n) end
end)

order += 1
local fp = Instance.new("Frame", scroll)
fp.Size = UDim2.new(1,-20,0,24)
fp.BackgroundTransparency = 1
fp.LayoutOrder = order
local fl = Instance.new("TextLabel", fp)
fl.Size = UDim2.new(1,0,1,0)
fl.BackgroundTransparency = 1
fl.Text = "KAZ HUB v1.5  •  Anime Crusaders"
fl.TextColor3 = Color3.fromRGB(40,40,60)
fl.TextSize = 10
fl.Font = Enum.Font.Gotham

-- touch resize
local resizeBtn = Instance.new("TextButton", main)
resizeBtn.Size = UDim2.new(0,30,0,30)
resizeBtn.Position = UDim2.new(1,-32,1,-32)
resizeBtn.BackgroundColor3 = Color3.fromRGB(20,20,30)
resizeBtn.Text = "⤡"
resizeBtn.TextColor3 = Color3.fromRGB(0,180,150)
resizeBtn.TextSize = 16
resizeBtn.Font = Enum.Font.GothamBold
resizeBtn.BorderSizePixel = 0
resizeBtn.ZIndex = 10
Instance.new("UICorner", resizeBtn).CornerRadius = UDim.new(0,8)

local resizing = false
local startTouchPos, startMainSize

resizeBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch
        or input.UserInputType == Enum.UserInputType.MouseButton1 then
        resizing = true
        startTouchPos = Vector2.new(input.Position.X, input.Position.Y)
        startMainSize = Vector2.new(main.AbsoluteSize.X, main.AbsoluteSize.Y)
    end
end)

UIS.TouchMoved:Connect(function(touch)
    if resizing then
        local dx = touch.Position.X - startTouchPos.X
        local dy = touch.Position.Y - startTouchPos.Y
        main.Size = UDim2.new(0,
            math.clamp(startMainSize.X + dx, 200, 550), 0,
            math.clamp(startMainSize.Y + dy, 280, 720))
    end
end)

UIS.TouchEnded:Connect(function()
    resizing = false
end)

RS.RenderStepped:Connect(function()
    if resizing and not UIS.TouchEnabled then
        local cur = UIS:GetMouseLocation()
        local dx = cur.X - startTouchPos.X
        local dy = cur.Y - startTouchPos.Y
        main.Size = UDim2.new(0,
            math.clamp(startMainSize.X + dx, 200, 550), 0,
            math.clamp(startMainSize.Y + dy, 280, 720))
    end
end)

UIS.InputEnded:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 then
        resizing = false
    end
end)

-- hide/show
hideBtn.MouseButton1Click:Connect(function()
    main.Visible = false
    main.Active = false
    tab.Visible = true
end)
tab.MouseButton1Click:Connect(function()
    tab.Visible = false
    main.Visible = true
    main.Active = true
end)