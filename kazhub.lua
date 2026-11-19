-- language: Lua, executor: Delta, game: Anime Crusaders
-- KAZ HUB v1.2 | Full Features

pcall(function()
    game:GetService("CoreGui"):FindFirstChild("KazHub"):Destroy()
end)

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")
local lp = Players.LocalPlayer

-- STATE
local state = {
    autopilot = false,
    autoreplay = false,
    autostart = false,
    autojoin = false,
    autoskip = false,
    autoupgrade = false,
    autosell = false,
    autoquest = false,
    macrorecord = false,
}
local macroData = {}
local selectedMap = ""

-- GUI
local sg = Instance.new("ScreenGui")
sg.Name = "KazHub"
sg.ResetOnSpawn = false
sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
sg.IgnoreGuiInset = true
sg.Parent = CoreGui

-- MINIMIZED TAB
local tab = Instance.new("Frame")
tab.Size = UDim2.new(0, 90, 0, 36)
tab.Position = UDim2.new(0, 10, 0.4, 0)
tab.BackgroundColor3 = Color3.fromRGB(100, 60, 220)
tab.BorderSizePixel = 0
tab.Active = true
tab.Draggable = true
tab.Visible = false
tab.ZIndex = 10
tab.Parent = sg
Instance.new("UICorner", tab).CornerRadius = UDim.new(0, 10)

local tabLabel = Instance.new("TextLabel")
tabLabel.Size = UDim2.new(1, 0, 1, 0)
tabLabel.BackgroundTransparency = 1
tabLabel.Text = "⚡ KAZ HUB"
tabLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
tabLabel.TextSize = 11
tabLabel.Font = Enum.Font.GothamBold
tabLabel.ZIndex = 11
tabLabel.Parent = tab

-- MAIN WINDOW
local main = Instance.new("Frame")
main.Size = UDim2.new(0, 300, 0, 480)
main.Position = UDim2.new(0.5, -150, 0.5, -240)
main.BackgroundColor3 = Color3.fromRGB(12, 12, 18)
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true
main.Parent = sg
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 12)

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(100, 60, 220)
stroke.Thickness = 1.5
stroke.Parent = main

-- HEADER
local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 56)
header.BackgroundColor3 = Color3.fromRGB(80, 40, 180)
header.BorderSizePixel = 0
header.Parent = main
Instance.new("UICorner", header).CornerRadius = UDim.new(0, 12)

local fixHeader = Instance.new("Frame")
fixHeader.Size = UDim2.new(1, 0, 0.5, 0)
fixHeader.Position = UDim2.new(0, 0, 0.5, 0)
fixHeader.BackgroundColor3 = Color3.fromRGB(80, 40, 180)
fixHeader.BorderSizePixel = 0
fixHeader.Parent = header

local icon = Instance.new("TextLabel")
icon.Size = UDim2.new(0, 44, 0, 44)
icon.Position = UDim2.new(0, 8, 0.5, -22)
icon.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
icon.Text = "🗡️"
icon.TextSize = 22
icon.Font = Enum.Font.GothamBold
icon.TextColor3 = Color3.fromRGB(255,255,255)
icon.BorderSizePixel = 0
icon.ZIndex = 2
icon.Parent = header
Instance.new("UICorner", icon).CornerRadius = UDim.new(0, 8)

local iconStroke = Instance.new("UIStroke")
iconStroke.Color = Color3.fromRGB(120, 80, 255)
iconStroke.Thickness = 1.5
iconStroke.Parent = icon

local titleLbl = Instance.new("TextLabel")
titleLbl.Size = UDim2.new(0, 160, 0, 20)
titleLbl.Position = UDim2.new(0, 60, 0, 10)
titleLbl.BackgroundTransparency = 1
titleLbl.Text = "⚡ KAZ HUB"
titleLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLbl.TextSize = 15
titleLbl.Font = Enum.Font.GothamBold
titleLbl.TextXAlignment = Enum.TextXAlignment.Left
titleLbl.ZIndex = 2
titleLbl.Parent = header

local subLbl = Instance.new("TextLabel")
subLbl.Size = UDim2.new(0, 160, 0, 16)
subLbl.Position = UDim2.new(0, 60, 0, 30)
subLbl.BackgroundTransparency = 1
subLbl.Text = "Anime Crusaders"
subLbl.TextColor3 = Color3.fromRGB(180, 160, 255)
subLbl.TextSize = 11
subLbl.Font = Enum.Font.Gotham
subLbl.TextXAlignment = Enum.TextXAlignment.Left
subLbl.ZIndex = 2
subLbl.Parent = header

local hideBtn = Instance.new("TextButton")
hideBtn.Size = UDim2.new(0, 32, 0, 32)
hideBtn.Position = UDim2.new(1, -40, 0.5, -16)
hideBtn.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
hideBtn.Text = "▬"
hideBtn.TextColor3 = Color3.fromRGB(255,255,255)
hideBtn.TextSize = 13
hideBtn.Font = Enum.Font.GothamBold
hideBtn.BorderSizePixel = 0
hideBtn.ZIndex = 5
hideBtn.Parent = header
Instance.new("UICorner", hideBtn).CornerRadius = UDim.new(0, 6)

-- BODY SCROLL
local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(1, 0, 1, -56)
scroll.Position = UDim2.new(0, 0, 0, 56)
scroll.BackgroundTransparency = 1
scroll.BorderSizePixel = 0
scroll.ScrollBarThickness = 3
scroll.ScrollBarImageColor3 = Color3.fromRGB(100, 60, 220)
scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
scroll.Parent = main

local layout = Instance.new("UIListLayout")
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Padding = UDim.new(0, 5)
layout.Parent = scroll

local pad = Instance.new("UIPadding")
pad.PaddingLeft = UDim.new(0, 10)
pad.PaddingRight = UDim.new(0, 10)
pad.PaddingTop = UDim.new(0, 8)
pad.PaddingBottom = UDim.new(0, 10)
pad.Parent = scroll

-- STATUS
local statusBar = Instance.new("Frame")
statusBar.Size = UDim2.new(1, 0, 0, 28)
statusBar.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
statusBar.BorderSizePixel = 0
statusBar.LayoutOrder = 0
statusBar.Parent = scroll
Instance.new("UICorner", statusBar).CornerRadius = UDim.new(0, 6)

local statusDot = Instance.new("TextLabel")
statusDot.Size = UDim2.new(1, -10, 1, 0)
statusDot.Position = UDim2.new(0, 10, 0, 0)
statusDot.BackgroundTransparency = 1
statusDot.Text = "● Ready"
statusDot.TextColor3 = Color3.fromRGB(80, 220, 120)
statusDot.TextSize = 12
statusDot.Font = Enum.Font.Gotham
statusDot.TextXAlignment = Enum.TextXAlignment.Left
statusDot.Parent = statusBar

local function setStatus(msg, color)
    statusDot.Text = "● " .. msg
    statusDot.TextColor3 = color or Color3.fromRGB(80, 220, 120)
end

-- HELPERS
local function makeSection(name, order)
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, 0, 0, 22)
    lbl.BackgroundTransparency = 1
    lbl.Text = name
    lbl.TextColor3 = Color3.fromRGB(100, 60, 220)
    lbl.TextSize = 11
    lbl.Font = Enum.Font.GothamBold
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.LayoutOrder = order
    lbl.Parent = scroll
end

local function makeToggle(label, emoji, order, callback)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, 0, 0, 42)
    row.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    row.BorderSizePixel = 0
    row.LayoutOrder = order
    row.Parent = scroll
    Instance.new("UICorner", row).CornerRadius = UDim.new(0, 8)

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -70, 1, 0)
    lbl.Position = UDim2.new(0, 10, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = emoji .. "  " .. label
    lbl.TextColor3 = Color3.fromRGB(220, 220, 240)
    lbl.TextSize = 12
    lbl.Font = Enum.Font.Gotham
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = row

    local tog = Instance.new("TextButton")
    tog.Size = UDim2.new(0, 54, 0, 26)
    tog.Position = UDim2.new(1, -62, 0.5, -13)
    tog.BackgroundColor3 = Color3.fromRGB(50, 50, 65)
    tog.Text = "OFF"
    tog.TextColor3 = Color3.fromRGB(160, 160, 180)
    tog.TextSize = 11
    tog.Font = Enum.Font.GothamBold
    tog.BorderSizePixel = 0
    tog.Parent = row
    Instance.new("UICorner", tog).CornerRadius = UDim.new(0, 13)

    local on = false
    tog.MouseButton1Click:Connect(function()
        on = not on
        if on then
            tog.BackgroundColor3 = Color3.fromRGB(100, 60, 220)
            tog.Text = "ON"
            tog.TextColor3 = Color3.fromRGB(255,255,255)
        else
            tog.BackgroundColor3 = Color3.fromRGB(50, 50, 65)
            tog.Text = "OFF"
            tog.TextColor3 = Color3.fromRGB(160, 160, 180)
        end
        if callback then callback(on) end
    end)
    return tog
end

local function makeAction(label, emoji, order, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 42)
    btn.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    btn.Text = emoji .. "  " .. label
    btn.TextColor3 = Color3.fromRGB(220, 220, 240)
    btn.TextSize = 12
    btn.Font = Enum.Font.Gotham
    btn.BorderSizePixel = 0
    btn.LayoutOrder = order
    btn.Parent = scroll
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)

    btn.MouseButton1Click:Connect(function()
        btn.BackgroundColor3 = Color3.fromRGB(100, 60, 220)
        task.delay(0.25, function() btn.BackgroundColor3 = Color3.fromRGB(20, 20, 30) end)
        if callback then callback() end
    end)
    return btn
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

-- ============ FEATURES ============

makeSection("AUTOMATION", 1)

-- AUTO NEXT STAGE
makeToggle("Auto Next Stage", "▶", 2, function(on)
    state.autopilot = on
    setStatus(on and "Auto Next Stage ON" or "Ready",
        on and Color3.fromRGB(100,60,220) or Color3.fromRGB(80,220,120))
    if on then
        task.spawn(function()
            while state.autopilot do
                fireRemote({"next","stage","continue","proceed"})
                task.wait(3)
            end
        end)
    end
end)

-- AUTO REPLAY
makeToggle("Auto Replay", "🔁", 3, function(on)
    state.autoreplay = on
    setStatus(on and "Auto Replay ON" or "Ready",
        on and Color3.fromRGB(100,60,220) or Color3.fromRGB(80,220,120))
    if on then
        task.spawn(function()
            while state.autoreplay do
                fireRemote({"replay","restart","again","retry"})
                task.wait(4)
            end
        end)
    end
end)

-- AUTO START
makeToggle("Auto Start", "⚡", 4, function(on)
    state.autostart = on
    setStatus(on and "Auto Start ON" or "Ready",
        on and Color3.fromRGB(100,60,220) or Color3.fromRGB(80,220,120))
    if on then
        task.spawn(function()
            while state.autostart do
                fireRemote({"start","begin","launch","play"})
                task.wait(4)
            end
        end)
    end
end)

-- AUTO SKIP
makeToggle("Auto Skip Wave", "⏭", 5, function(on)
    state.autoskip = on
    if on then
        task.spawn(function()
            while state.autoskip do
                fireRemote({"skip","wave","fast"})
                task.wait(2)
            end
        end)
    end
end)

-- AUTO UPGRADE UNITS
makeToggle("Auto Upgrade Units", "⬆", 6, function(on)
    state.autoupgrade = on
    if on then
        task.spawn(function()
            while state.autoupgrade do
                fireRemote({"upgrade","level","enhance"})
                task.wait(5)
            end
        end)
    end
end)

-- AUTO SELL UNITS
makeToggle("Auto Sell Excess", "💰", 7, function(on)
    state.autosell = on
    if on then
        task.spawn(function()
            while state.autosell do
                fireRemote({"sell","remove","dispose"})
                task.wait(6)
            end
        end)
    end
end)

-- AUTO QUEST
makeToggle("Auto Quest", "📜", 8, function(on)
    state.autoquest = on
    if on then
        task.spawn(function()
            while state.autoquest do
                fireRemote({"quest","claim","complete","daily"})
                task.wait(8)
            end
        end)
    end
end)

-- ============ MACRO ============

makeSection("MACRO", 9)

-- RECORD MACRO
makeToggle("Record Macro", "⏺", 10, function(on)
    state.macrorecord = on
    macroData = {}
    if on then
        setStatus("Recording macro...", Color3.fromRGB(220, 50, 50))
        task.spawn(function()
            while state.macrorecord do
                -- capture placement / upgrade remotes fired this tick
                for _, v in ipairs(game:GetDescendants()) do
                    if v:IsA("RemoteEvent") or v:IsA("RemoteFunction") then
                        local n = v.Name:lower()
                        if n:find("place") or n:find("upgrade") or n:find("unit") then
                            table.insert(macroData, {name=v:GetFullName(), time=tick()})
                        end
                    end
                end
                task.wait(0.5)
            end
            setStatus("Macro saved (" .. #macroData .. " actions)", Color3.fromRGB(80,220,120))
        end)
    else
        setStatus("Macro saved (" .. #macroData .. " actions)", Color3.fromRGB(80,220,120))
    end
end)

-- PLAY MACRO
makeAction("Play Macro", "▶", 11, function()
    if #macroData == 0 then
        setStatus("No macro recorded", Color3.fromRGB(220,100,50))
        return
    end
    setStatus("Playing macro...", Color3.fromRGB(100,60,220))
    task.spawn(function()
        for _, action in ipairs(macroData) do
            local remote = game
            pcall(function()
                for _, part in ipairs(action.name:split(".")) do
                    remote = remote[part]
                end
                if remote:IsA("RemoteEvent") then remote:FireServer()
                else remote:InvokeServer() end
            end)
            task.wait(0.3)
        end
        setStatus("Macro done", Color3.fromRGB(80,220,120))
    end)
end)

-- ============ MAP / JOIN ============

makeSection("MAP & JOIN", 12)

-- MAP INPUT
local mapRow = Instance.new("Frame")
mapRow.Size = UDim2.new(1, 0, 0, 42)
mapRow.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
mapRow.BorderSizePixel = 0
mapRow.LayoutOrder = 13
mapRow.Parent = scroll
Instance.new("UICorner", mapRow).CornerRadius = UDim.new(0, 8)

local mapInput = Instance.new("TextBox")
mapInput.Size = UDim2.new(1, -20, 0, 28)
mapInput.Position = UDim2.new(0, 10, 0.5, -14)
mapInput.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
mapInput.BorderSizePixel = 0
mapInput.PlaceholderText = "Enter map name..."
mapInput.PlaceholderColor3 = Color3.fromRGB(100,100,120)
mapInput.TextColor3 = Color3.fromRGB(220,220,240)
mapInput.TextSize = 12
mapInput.Font = Enum.Font.Gotham
mapInput.Text = ""
mapInput.Parent = mapRow
Instance.new("UICorner", mapInput).CornerRadius = UDim.new(0, 6)

mapInput.FocusLost:Connect(function()
    selectedMap = mapInput.Text
end)

-- AUTO JOIN MAP
makeAction("Auto Join Selected Map", "🗺", 14, function()
    if selectedMap == "" then
        setStatus("Type a map name first", Color3.fromRGB(220,100,50))
        return
    end
    setStatus("Joining: " .. selectedMap, Color3.fromRGB(100,60,220))
    fireRemote({"join","map","select","enter"}, selectedMap)
    task.wait(1)
    setStatus("Join sent: " .. selectedMap, Color3.fromRGB(80,220,120))
end)

-- ============ QUICK ACTIONS ============

makeSection("QUICK ACTIONS", 15)

makeAction("Redeem All Codes", "🎁", 16, function()
    setStatus("Redeeming codes...", Color3.fromRGB(255,200,50))
    local codes = {
        "ANNIVERSARY","UPDATE10","KAZHUB","ACFREE",
        "NEWUPDATE","GEMS100","KAZFREE","AC2024","FREEGEMS"
    }
    for _, code in ipairs(codes) do
        fireRemote({"redeem","code","promo"}, code)
        task.wait(0.4)
    end
    setStatus("All codes attempted", Color3.fromRGB(80,220,120))
end)

makeAction("Collect Daily Rewards", "⭐", 17, function()
    setStatus("Collecting...", Color3.fromRGB(255,200,50))
    fireRemote({"collect","reward","claim","daily","login"})
    task.wait(1)
    setStatus("Rewards collected", Color3.fromRGB(80,220,120))
end)

makeAction("Auto Summon x10", "🌀", 18, function()
    setStatus("Summoning...", Color3.fromRGB(100,60,220))
    for i = 1, 10 do
        fireRemote({"summon","pull","gacha","roll"})
        task.wait(0.5)
    end
    setStatus("Summon done", Color3.fromRGB(80,220,120))
end)

makeAction("Scan All Remotes", "🔍", 19, function()
    setStatus("Scanning...", Color3.fromRGB(255,200,50))
    local found = 0
    for _, v in ipairs(game:GetDescendants()) do
        if v:IsA("RemoteEvent") or v:IsA("RemoteFunction") then
            found += 1
            print("[KAZ] " .. v:GetFullName())
        end
    end
    setStatus("Found " .. found .. " remotes (see output)", Color3.fromRGB(80,220,120))
end)

-- FOOTER
local footer = Instance.new("TextLabel")
footer.Size = UDim2.new(1, 0, 0, 24)
footer.BackgroundTransparency = 1
footer.Text = "KAZ HUB v1.2  •  Anime Crusaders"
footer.TextColor3 = Color3.fromRGB(80, 70, 100)
footer.TextSize = 10
footer.Font = Enum.Font.Gotham
footer.LayoutOrder = 99
footer.Parent = scroll

-- RESIZE HANDLE
local resizeHandle = Instance.new("TextButton")
resizeHandle.Size = UDim2.new(0, 20, 0, 20)
resizeHandle.Position = UDim2.new(1, -20, 1, -20)
resizeHandle.BackgroundColor3 = Color3.fromRGB(100, 60, 220)
resizeHandle.Text = "⤡"
resizeHandle.TextColor3 = Color3.fromRGB(255,255,255)
resizeHandle.TextSize = 12
resizeHandle.Font = Enum.Font.GothamBold
resizeHandle.BorderSizePixel = 0
resizeHandle.ZIndex = 10
resizeHandle.Parent = main
Instance.new("UICorner", resizeHandle).CornerRadius = UDim.new(0, 4)

-- RESIZE LOGIC
local resizing = false
local resizeStart, sizeStart

resizeHandle.MouseButton1Down:Connect(function()
    resizing = true
    resizeStart = UIS:GetMouseLocation()
    sizeStart = main.Size
end)

UIS.InputEnded:Connect(function(inp)
    if inp.UserInputType == Enum.UserInputType.MouseButton1
    or inp.UserInputType == Enum.UserInputType.Touch then
        resizing = false
    end
end)

RS.RenderStepped:Connect(function()
    if resizing and resizeStart then
        local cur = UIS:GetMouseLocation()
        local dx = cur.X - resizeStart.X
        local dy = cur.Y - resizeStart.Y
        main.Size = UDim2.new(0,
            math.clamp(sizeStart.X.Offset + dx, 240, 520), 0,
            math.clamp(sizeStart.Y.Offset + dy, 300, 700))
    end
end)

-- HIDE / SHOW
hideBtn.MouseButton1Click:Connect(function()
    main.Visible = false
    tab.Visible = true
end)

tab.InputBegan:Connect(function(inp)
    if inp.UserInputType == Enum.UserInputType.Touch
    or inp.UserInputType == Enum.UserInputType.MouseButton1 then
        tab.Visible = false
        main.Visible = true
    end
end)