-- language: Luau, executor: Delta, game: Anime Crusaders
-- KAZ HUB v2.0 | Sidebar UI

pcall(function()
    game:GetService("CoreGui"):FindFirstChild("KazHub"):Destroy()
end)

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")
local VPS = game:GetService("VirtualUser")
local TweenService = game:GetService("TweenService")
local lp = Players.LocalPlayer

local state = {
    antiafk = false,
    autopilot = false,
    autoreplay = false,
    autostart = false,
    autoskip = false,
    autoupgrade = false,
    autosell = false,
    autoquest = false,
}

local gameEndCooldown = false
local currentPage = "Home"

-- Anti-AFK
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

task.spawn(function()
    while true do
        task.wait(1)
        if isGameEnded() and not gameEndCooldown then
            gameEndCooldown = true
            if state.autopilot then
                clickGuiButton({"next","nextlevel","next level","continue","advance","nextstage"})
            end
            if state.autoreplay then
                task.wait(0.5)
                clickGuiButton({"replay","again","retry","playagain","play again"})
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
screen.IgnoreGuiInset = true
screen.Parent = CoreGui

-- main window
local main = Instance.new("Frame")
main.Name = "Main"
main.Size = UDim2.new(0, 580, 0, 420)
main.Position = UDim2.new(0.5, -290, 0.5, -210)
main.BackgroundColor3 = Color3.fromRGB(13, 13, 18)
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true
main.ClipsDescendants = true
main.Parent = screen
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 12)
local mainStroke = Instance.new("UIStroke", main)
mainStroke.Color = Color3.fromRGB(30, 30, 44)
mainStroke.Thickness = 1.5

-- title bar
local titleBar = Instance.new("Frame", main)
titleBar.Size = UDim2.new(1, 0, 0, 44)
titleBar.BackgroundColor3 = Color3.fromRGB(16, 16, 23)
titleBar.BorderSizePixel = 0
local tbCorner = Instance.new("UICorner", titleBar)
tbCorner.CornerRadius = UDim.new(0, 12)
local tbPatch = Instance.new("Frame", titleBar)
tbPatch.Size = UDim2.new(1, 0, 0, 12)
tbPatch.Position = UDim2.new(0, 0, 1, -12)
tbPatch.BackgroundColor3 = Color3.fromRGB(16, 16, 23)
tbPatch.BorderSizePixel = 0

local tbIcon = Instance.new("TextLabel", titleBar)
tbIcon.Size = UDim2.new(0, 24, 0, 24)
tbIcon.Position = UDim2.new(0, 14, 0.5, -12)
tbIcon.BackgroundTransparency = 1
tbIcon.Text = "⚡"
tbIcon.TextSize = 16
tbIcon.Font = Enum.Font.GothamBold
tbIcon.TextColor3 = Color3.fromRGB(0, 210, 170)

local tbTitle = Instance.new("TextLabel", titleBar)
tbTitle.Size = UDim2.new(0, 160, 0, 20)
tbTitle.Position = UDim2.new(0, 42, 0.5, -10)
tbTitle.BackgroundTransparency = 1
tbTitle.Text = "KAZ HUB"
tbTitle.TextColor3 = Color3.fromRGB(220, 220, 235)
tbTitle.TextSize = 13
tbTitle.Font = Enum.Font.GothamBold
tbTitle.TextXAlignment = Enum.TextXAlignment.Left

local tbSub = Instance.new("TextLabel", titleBar)
tbSub.Size = UDim2.new(0, 160, 0, 14)
tbSub.Position = UDim2.new(0, 42, 0.5, 4)
tbSub.BackgroundTransparency = 1
tbSub.Text = "by kaz"
tbSub.TextColor3 = Color3.fromRGB(60, 60, 90)
tbSub.TextSize = 10
tbSub.Font = Enum.Font.Gotham
tbSub.TextXAlignment = Enum.TextXAlignment.Left

local closeBtn = Instance.new("TextButton", titleBar)
closeBtn.Size = UDim2.new(0, 24, 0, 24)
closeBtn.Position = UDim2.new(1, -34, 0.5, -12)
closeBtn.BackgroundColor3 = Color3.fromRGB(50, 25, 30)
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(200, 80, 80)
closeBtn.TextSize = 11
closeBtn.Font = Enum.Font.GothamBold
closeBtn.BorderSizePixel = 0
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 6)

local minBtn = Instance.new("TextButton", titleBar)
minBtn.Size = UDim2.new(0, 24, 0, 24)
minBtn.Position = UDim2.new(1, -62, 0.5, -12)
minBtn.BackgroundColor3 = Color3.fromRGB(25, 35, 45)
minBtn.Text = "—"
minBtn.TextColor3 = Color3.fromRGB(100, 150, 200)
minBtn.TextSize = 11
minBtn.Font = Enum.Font.GothamBold
minBtn.BorderSizePixel = 0
Instance.new("UICorner", minBtn).CornerRadius = UDim.new(0, 6)

-- sidebar
local sidebar = Instance.new("Frame", main)
sidebar.Size = UDim2.new(0, 155, 1, -44)
sidebar.Position = UDim2.new(0, 0, 0, 44)
sidebar.BackgroundColor3 = Color3.fromRGB(11, 11, 16)
sidebar.BorderSizePixel = 0

local sideList = Instance.new("UIListLayout", sidebar)
sideList.Padding = UDim.new(0, 2)
sideList.SortOrder = Enum.SortOrder.LayoutOrder
local sidePad = Instance.new("UIPadding", sidebar)
sidePad.PaddingTop = UDim.new(0, 10)
sidePad.PaddingLeft = UDim.new(0, 8)
sidePad.PaddingRight = UDim.new(0, 8)

-- bottom user badge
local userBadge = Instance.new("Frame", sidebar)
userBadge.Size = UDim2.new(1, 0, 0, 40)
userBadge.Position = UDim2.new(0, 0, 1, -48)
userBadge.BackgroundColor3 = Color3.fromRGB(16, 16, 23)
userBadge.BorderSizePixel = 0
Instance.new("UICorner", userBadge).CornerRadius = UDim.new(0, 8)

local userDot = Instance.new("Frame", userBadge)
userDot.Size = UDim2.new(0, 8, 0, 8)
userDot.Position = UDim2.new(0, 10, 0.5, -4)
userDot.BackgroundColor3 = Color3.fromRGB(0, 200, 150)
userDot.BorderSizePixel = 0
Instance.new("UICorner", userDot).CornerRadius = UDim.new(1, 0)

local userLbl = Instance.new("TextLabel", userBadge)
userLbl.Size = UDim2.new(1, -26, 0, 14)
userLbl.Position = UDim2.new(0, 24, 0, 6)
userLbl.BackgroundTransparency = 1
userLbl.Text = lp.Name
userLbl.TextColor3 = Color3.fromRGB(180, 180, 200)
userLbl.TextSize = 11
userLbl.Font = Enum.Font.GothamBold
userLbl.TextXAlignment = Enum.TextXAlignment.Left

local userSub = Instance.new("TextLabel", userBadge)
userSub.Size = UDim2.new(1, -26, 0, 12)
userSub.Position = UDim2.new(0, 24, 0, 22)
userSub.BackgroundTransparency = 1
userSub.Text = "Anime Crusaders"
userSub.TextColor3 = Color3.fromRGB(50, 50, 75)
userSub.TextSize = 9
userSub.Font = Enum.Font.Gotham
userSub.TextXAlignment = Enum.TextXAlignment.Left

-- content area
local content = Instance.new("Frame", main)
content.Size = UDim2.new(1, -155, 1, -44)
content.Position = UDim2.new(0, 155, 0, 44)
content.BackgroundColor3 = Color3.fromRGB(13, 13, 18)
content.BorderSizePixel = 0
content.ClipsDescendants = true

-- divider line
local divider = Instance.new("Frame", main)
divider.Size = UDim2.new(0, 1, 1, -44)
divider.Position = UDim2.new(0, 155, 0, 44)
divider.BackgroundColor3 = Color3.fromRGB(25, 25, 38)
divider.BorderSizePixel = 0

-- status bar in content
local statusFrame = Instance.new("Frame", content)
statusFrame.Size = UDim2.new(1, 0, 0, 24)
statusFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
statusFrame.BorderSizePixel = 0

local statusLbl = Instance.new("TextLabel", statusFrame)
statusLbl.Size = UDim2.new(1, -16, 1, 0)
statusLbl.Position = UDim2.new(0, 12, 0, 0)
statusLbl.BackgroundTransparency = 1
statusLbl.Text = "● Ready"
statusLbl.TextColor3 = Color3.fromRGB(0, 180, 150)
statusLbl.TextSize = 10
statusLbl.Font = Enum.Font.Gotham
statusLbl.TextXAlignment = Enum.TextXAlignment.Left

local function setStatus(msg)
    statusLbl.Text = "● " .. msg
end

-- page frames
local pages = {}

local function makePage(name)
    local f = Instance.new("ScrollingFrame", content)
    f.Size = UDim2.new(1, 0, 1, -24)
    f.Position = UDim2.new(0, 0, 0, 24)
    f.BackgroundTransparency = 1
    f.BorderSizePixel = 0
    f.ScrollBarThickness = 3
    f.ScrollBarImageColor3 = Color3.fromRGB(0, 180, 150)
    f.AutomaticCanvasSize = Enum.AutomaticSize.Y
    f.CanvasSize = UDim2.new(0, 0, 0, 0)
    f.Visible = false
    local ll = Instance.new("UIListLayout", f)
    ll.Padding = UDim.new(0, 8)
    ll.SortOrder = Enum.SortOrder.LayoutOrder
    local pp = Instance.new("UIPadding", f)
    pp.PaddingLeft = UDim.new(0, 12)
    pp.PaddingRight = UDim.new(0, 12)
    pp.PaddingTop = UDim.new(0, 10)
    pp.PaddingBottom = UDim.new(0, 10)
    pages[name] = f
    return f
end

local function showPage(name)
    for k, v in pairs(pages) do
        v.Visible = k == name
    end
    currentPage = name
end

-- section card builder
local function makeCard(parent, title, order)
    local card = Instance.new("Frame", parent)
    card.Size = UDim2.new(1, 0, 0, 0)
    card.AutomaticSize = Enum.AutomaticSize.Y
    card.BackgroundColor3 = Color3.fromRGB(18, 18, 26)
    card.BorderSizePixel = 0
    card.LayoutOrder = order
    Instance.new("UICorner", card).CornerRadius = UDim.new(0, 10)
    local cs = Instance.new("UIStroke", card)
    cs.Color = Color3.fromRGB(28, 28, 42)
    cs.Thickness = 1

    local cardHeader = Instance.new("Frame", card)
    cardHeader.Size = UDim2.new(1, 0, 0, 36)
    cardHeader.BackgroundTransparency = 1

    local cardIcon = Instance.new("TextLabel", cardHeader)
    cardIcon.Size = UDim2.new(0, 24, 1, 0)
    cardIcon.Position = UDim2.new(0, 12, 0, 0)
    cardIcon.BackgroundTransparency = 1
    cardIcon.Text = "⚡"
    cardIcon.TextColor3 = Color3.fromRGB(0, 180, 150)
    cardIcon.TextSize = 13
    cardIcon.Font = Enum.Font.GothamBold

    local cardTitle = Instance.new("TextLabel", cardHeader)
    cardTitle.Size = UDim2.new(1, -50, 1, 0)
    cardTitle.Position = UDim2.new(0, 38, 0, 0)
    cardTitle.BackgroundTransparency = 1
    cardTitle.Text = title
    cardTitle.TextColor3 = Color3.fromRGB(180, 180, 200)
    cardTitle.TextSize = 12
    cardTitle.Font = Enum.Font.GothamBold
    cardTitle.TextXAlignment = Enum.TextXAlignment.Left

    local cardBody = Instance.new("Frame", card)
    cardBody.Size = UDim2.new(1, 0, 0, 0)
    cardBody.AutomaticSize = Enum.AutomaticSize.Y
    cardBody.Position = UDim2.new(0, 0, 0, 36)
    cardBody.BackgroundTransparency = 1
    local bodyList = Instance.new("UIListLayout", cardBody)
    bodyList.SortOrder = Enum.SortOrder.LayoutOrder
    local bodyPad = Instance.new("UIPadding", cardBody)
    bodyPad.PaddingLeft = UDim.new(0, 12)
    bodyPad.PaddingRight = UDim.new(0, 12)
    bodyPad.PaddingBottom = UDim.new(0, 10)

    return cardBody, cardIcon
end

local rowOrder = 0
local function makeToggleRow(parent, label, stateKey, onFire)
    rowOrder += 1
    local row = Instance.new("Frame", parent)
    row.Size = UDim2.new(1, 0, 0, 38)
    row.BackgroundTransparency = 1
    row.LayoutOrder = rowOrder

    -- separator line
    if rowOrder > 1 then
        local sep = Instance.new("Frame", row)
        sep.Size = UDim2.new(1, 0, 0, 1)
        sep.BackgroundColor3 = Color3.fromRGB(25, 25, 38)
        sep.BorderSizePixel = 0
        sep.ZIndex = 0
    end

    local lbl = Instance.new("TextLabel", row)
    lbl.Size = UDim2.new(1, -60, 1, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = label
    lbl.TextColor3 = Color3.fromRGB(160, 160, 185)
    lbl.TextSize = 12
    lbl.Font = Enum.Font.Gotham
    lbl.TextXAlignment = Enum.TextXAlignment.Left

    local pill = Instance.new("Frame", row)
    pill.Size = UDim2.new(0, 44, 0, 24)
    pill.Position = UDim2.new(1, -48, 0.5, -12)
    pill.BackgroundColor3 = Color3.fromRGB(32, 32, 48)
    pill.BorderSizePixel = 0
    Instance.new("UICorner", pill).CornerRadius = UDim.new(1, 0)

    local knob = Instance.new("Frame", pill)
    knob.Size = UDim2.new(0, 18, 0, 18)
    knob.Position = UDim2.new(0, 3, 0.5, -9)
    knob.BackgroundColor3 = Color3.fromRGB(80, 80, 110)
    knob.BorderSizePixel = 0
    Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)

    local hit = Instance.new("TextButton", row)
    hit.Size = UDim2.new(1, 0, 1, 0)
    hit.BackgroundTransparency = 1
    hit.Text = ""

    -- status text next to toggle
    local statusTag = Instance.new("TextLabel", row)
    statusTag.Size = UDim2.new(0, 40, 0, 16)
    statusTag.Position = UDim2.new(1, -96, 0.5, -8)
    statusTag.BackgroundTransparency = 1
    statusTag.Text = "OFF"
    statusTag.TextColor3 = Color3.fromRGB(60, 60, 88)
    statusTag.TextSize = 10
    statusTag.Font = Enum.Font.GothamBold
    statusTag.TextXAlignment = Enum.TextXAlignment.Right

    hit.MouseButton1Click:Connect(function()
        state[stateKey] = not state[stateKey]
        local on = state[stateKey]
        local tweenInfo = TweenInfo.new(0.15, Enum.EasingStyle.Quad)
        TweenService:Create(pill, tweenInfo, {
            BackgroundColor3 = on and Color3.fromRGB(0, 180, 150) or Color3.fromRGB(32, 32, 48)
        }):Play()
        TweenService:Create(knob, tweenInfo, {
            BackgroundColor3 = on and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(80, 80, 110),
            Position = on and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9)
        }):Play()
        statusTag.Text = on and "ON" or "OFF"
        statusTag.TextColor3 = on and Color3.fromRGB(0, 200, 160) or Color3.fromRGB(60, 60, 88)
        setStatus(label .. (on and " ON" or " OFF"))
        if on and onFire then task.spawn(onFire) end
    end)

    return row
end

local function makeActionRow(parent, label, cb)
    rowOrder += 1
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(1, 0, 0, 36)
    btn.BackgroundColor3 = Color3.fromRGB(13, 13, 18)
    btn.BorderSizePixel = 0
    btn.Text = label
    btn.TextColor3 = Color3.fromRGB(0, 190, 155)
    btn.TextSize = 12
    btn.Font = Enum.Font.GothamBold
    btn.LayoutOrder = rowOrder
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    local bs = Instance.new("UIStroke", btn)
    bs.Color = Color3.fromRGB(0, 150, 120)
    bs.Thickness = 1
    btn.MouseButton1Click:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.1), {
            BackgroundColor3 = Color3.fromRGB(0, 150, 120)
        }):Play()
        task.wait(0.15)
        TweenService:Create(btn, TweenInfo.new(0.1), {
            BackgroundColor3 = Color3.fromRGB(13, 13, 18)
        }):Play()
        if cb then task.spawn(cb) end
    end)
    return btn
end

-- sidebar nav builder
local navOrder = 0
local navButtons = {}

local function makeNav(icon, label, pageName)
    navOrder += 1
    local btn = Instance.new("TextButton", sidebar)
    btn.Size = UDim2.new(1, 0, 0, 36)
    btn.BackgroundColor3 = Color3.fromRGB(13, 13, 18)
    btn.BackgroundTransparency = 1
    btn.Text = ""
    btn.BorderSizePixel = 0
    btn.LayoutOrder = navOrder
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)

    local iconLbl = Instance.new("TextLabel", btn)
    iconLbl.Size = UDim2.new(0, 20, 1, 0)
    iconLbl.Position = UDim2.new(0, 10, 0, 0)
    iconLbl.BackgroundTransparency = 1
    iconLbl.Text = icon
    iconLbl.TextSize = 14
    iconLbl.Font = Enum.Font.GothamBold
    iconLbl.TextColor3 = Color3.fromRGB(80, 80, 110)

    local nameLbl = Instance.new("TextLabel", btn)
    nameLbl.Size = UDim2.new(1, -38, 1, 0)
    nameLbl.Position = UDim2.new(0, 34, 0, 0)
    nameLbl.BackgroundTransparency = 1
    nameLbl.Text = label
    nameLbl.TextSize = 12
    nameLbl.Font = Enum.Font.Gotham
    nameLbl.TextColor3 = Color3.fromRGB(80, 80, 110)
    nameLbl.TextXAlignment = Enum.TextXAlignment.Left

    local activeBar = Instance.new("Frame", btn)
    activeBar.Size = UDim2.new(0, 3, 0.6, 0)
    activeBar.Position = UDim2.new(0, 0, 0.2, 0)
    activeBar.BackgroundColor3 = Color3.fromRGB(0, 200, 160)
    activeBar.BorderSizePixel = 0
    activeBar.Visible = false
    Instance.new("UICorner", activeBar).CornerRadius = UDim.new(0, 2)

    navButtons[pageName] = {btn=btn, icon=iconLbl, name=nameLbl, bar=activeBar}

    btn.MouseButton1Click:Connect(function()
        -- reset all
        for _, nb in pairs(navButtons) do
            nb.btn.BackgroundTransparency = 1
            nb.icon.TextColor3 = Color3.fromRGB(80, 80, 110)
            nb.name.TextColor3 = Color3.fromRGB(80, 80, 110)
            nb.name.Font = Enum.Font.Gotham
            nb.bar.Visible = false
        end
        -- activate
        btn.BackgroundTransparency = 0
        btn.BackgroundColor3 = Color3.fromRGB(18, 18, 26)
        iconLbl.TextColor3 = Color3.fromRGB(0, 200, 160)
        nameLbl.TextColor3 = Color3.fromRGB(210, 210, 230)
        nameLbl.Font = Enum.Font.GothamBold
        activeBar.Visible = true
        showPage(pageName)
    end)

    return btn
end

-- BUILD PAGES
-- Home page
local homePage = makePage("Home")

local homeCard1, hc1Icon = makeCard(homePage, "Protection", 1)
hc1Icon.Text = "🛡"
rowOrder = 0
makeToggleRow(homeCard1, "Anti AFK", "antiafk")

local homeCard2, hc2Icon = makeCard(homePage, "Automation", 2)
hc2Icon.Text = "⚡"
rowOrder = 0
makeToggleRow(homeCard2, "Auto Next Stage", "autopilot")
makeToggleRow(homeCard2, "Auto Replay", "autoreplay")
makeToggleRow(homeCard2, "Auto Start", "autostart", function()
    task.spawn(function()
        while state.autostart do
            fireRemote({"start","begin","launch"})
            task.wait(3)
        end
    end)
end)
makeToggleRow(homeCard2, "Auto Skip Wave", "autoskip", function()
    task.spawn(function()
        while state.autoskip do
            fireRemote({"skip","wave","skipwave"})
            task.wait(2)
        end
    end)
end)
makeToggleRow(homeCard2, "Auto Upgrade Units", "autoupgrade", function()
    task.spawn(function()
        while state.autoupgrade do
            fireRemote({"upgrade","level","enhance"})
            task.wait(4)
        end
    end)
end)
makeToggleRow(homeCard2, "Auto Sell Excess", "autosell", function()
    task.spawn(function()
        while state.autosell do
            fireRemote({"sell","remove","excess"})
            task.wait(5)
        end
    end)
end)
makeToggleRow(homeCard2, "Auto Quest", "autoquest", function()
    task.spawn(function()
        while state.autoquest do
            fireRemote({"quest","claim","complete","daily"})
            task.wait(10)
        end
    end)
end)

-- Rewards page
local rewardsPage = makePage("Rewards")
local rewardCard, rcIcon = makeCard(rewardsPage, "Quick Actions", 1)
rcIcon.Text = "🎁"
rowOrder = 0
makeActionRow(rewardCard, "🎁  Redeem All Codes", function()
    fireRemote({"redeem","code","gift"})
    setStatus("Codes redeemed!")
end)
makeActionRow(rewardCard, "⭐  Collect Daily Rewards", function()
    fireRemote({"daily","reward","collect","claim"})
    setStatus("Daily rewards collected!")
end)
makeActionRow(rewardCard, "🌀  Auto Summon x10", function()
    for i=1,10 do
        fireRemote({"summon","pull","gacha","roll"})
        task.wait(0.3)
    end
    setStatus("Summoned x10!")
end)

-- Map page
local mapPage = makePage("Map")
local mapCard, mapIcon = makeCard(mapPage, "Map & Join", 1)
mapIcon.Text = "🗺"
rowOrder = 0

local mapName = ""
local mapBoxRow = Instance.new("Frame", mapCard)
mapBoxRow.Size = UDim2.new(1, 0, 0, 38)
mapBoxRow.BackgroundTransparency = 1
mapBoxRow.LayoutOrder = 1

local mapBox = Instance.new("TextBox", mapBoxRow)
mapBox.Size = UDim2.new(1, 0, 1, -8)
mapBox.Position = UDim2.new(0, 0, 0, 4)
mapBox.BackgroundColor3 = Color3.fromRGB(13, 13, 18)
mapBox.BorderSizePixel = 0
mapBox.PlaceholderText = "Enter map name..."
mapBox.PlaceholderColor3 = Color3.fromRGB(55, 55, 80)
mapBox.Text = ""
mapBox.TextColor3 = Color3.fromRGB(180, 180, 200)
mapBox.TextSize = 12
mapBox.Font = Enum.Font.Gotham
mapBox.TextXAlignment = Enum.TextXAlignment.Left
Instance.new("UICorner", mapBox).CornerRadius = UDim.new(0, 8)
local mapBoxPad = Instance.new("UIPadding", mapBox)
mapBoxPad.PaddingLeft = UDim.new(0, 10)
local mapBoxStroke = Instance.new("UIStroke", mapBox)
mapBoxStroke.Color = Color3.fromRGB(28, 28, 42)
mapBoxStroke.Thickness = 1
mapBox:GetPropertyChangedSignal("Text"):Connect(function()
    mapName = mapBox.Text
end)

makeActionRow(mapCard, "🗺  Auto Join Selected Map", function()
    if mapName ~= "" then
        fireRemote({"join","map","teleport","load"}, mapName)
        setStatus("Joining: "..mapName)
    else
        setStatus("Enter a map name first!")
    end
end)

-- Settings page
local settingsPage = makePage("Settings")
local settingsCard, settingsIcon = makeCard(settingsPage, "Tools", 1)
settingsIcon.Text = "🔧"
rowOrder = 0
makeActionRow(settingsCard, "🔍  Scan All Remotes", function()
    local found = {}
    for _, v in ipairs(game:GetDescendants()) do
        if v:IsA("RemoteEvent") or v:IsA("RemoteFunction") then
            table.insert(found, v.Name)
        end
    end
    setStatus("Found "..#found.." remotes")
    for _,n in ipairs(found) do print("[KazHub]", n) end
end)
makeActionRow(settingsCard, "🔍  Scan Victory Buttons", function()
    local found = {}
    for _, v in ipairs(lp.PlayerGui:GetDescendants()) do
        if (v:IsA("TextButton") or v:IsA("ImageButton")) and v.Visible then
            local t = v:IsA("TextButton") and v.Text or "ImageButton"
            table.insert(found, v.Name .. " | " .. t)
        end
    end
    setStatus("Found "..#found.." buttons — check console")
    for _,n in ipairs(found) do print("[KazHub Scan]", n) end
end)

local versionCard, verIcon = makeCard(settingsPage, "About", 2)
verIcon.Text = "ℹ"
local verLbl = Instance.new("TextLabel", versionCard)
verLbl.Size = UDim2.new(1, 0, 0, 32)
verLbl.BackgroundTransparency = 1
verLbl.Text = "KAZ HUB v2.0  •  Anime Crusaders"
verLbl.TextColor3 = Color3.fromRGB(50, 50, 75)
verLbl.TextSize = 11
verLbl.Font = Enum.Font.Gotham
verLbl.LayoutOrder = 1

-- BUILD SIDEBAR NAV
makeNav("🏠", "Home", "Home")
makeNav("🎁", "Rewards", "Rewards")
makeNav("🗺", "Map", "Map")
makeNav("⚙", "Settings", "Settings")

-- minimized tab
local tab = Instance.new("TextButton", screen)
tab.Name = "MinTab"
tab.Size = UDim2.new(0, 120, 0, 32)
tab.Position = UDim2.new(0, 20, 0, 20)
tab.BackgroundColor3 = Color3.fromRGB(13, 13, 18)
tab.BorderSizePixel = 0
tab.Text = "⚡ KAZ HUB"
tab.TextColor3 = Color3.fromRGB(0, 210, 170)
tab.TextSize = 12
tab.Font = Enum.Font.GothamBold
tab.Active = true
tab.Draggable = true
tab.Visible = false
tab.Parent = screen
Instance.new("UICorner", tab).CornerRadius = UDim.new(0, 8)
local tabStroke = Instance.new("UIStroke", tab)
tabStroke.Color = Color3.fromRGB(0, 180, 150)
tabStroke.Thickness = 1.5

-- hide / show
closeBtn.MouseButton1Click:Connect(function()
    main.Visible = false
    main.Active = false
    tab.Visible = true
end)
minBtn.MouseButton1Click:Connect(function()
    main.Visible = false
    main.Active = false
    tab.Visible = true
end)
tab.MouseButton1Click:Connect(function()
    tab.Visible = false
    main.Visible = true
    main.Active = true
end)

-- touch resize
local resizeBtn = Instance.new("TextButton", main)
resizeBtn.Size = UDim2.new(0, 28, 0, 28)
resizeBtn.Position = UDim2.new(1, -30, 1, -30)
resizeBtn.BackgroundColor3 = Color3.fromRGB(18, 18, 26)
resizeBtn.Text = "⤡"
resizeBtn.TextColor3 = Color3.fromRGB(0, 180, 150)
resizeBtn.TextSize = 14
resizeBtn.Font = Enum.Font.GothamBold
resizeBtn.BorderSizePixel = 0
resizeBtn.ZIndex = 10
Instance.new("UICorner", resizeBtn).CornerRadius = UDim.new(0, 6)

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
            math.clamp(startMainSize.X + dx, 300, 700), 0,
            math.clamp(startMainSize.Y + dy, 280, 600))
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
            math.clamp(startMainSize.X + dx, 300, 700), 0,
            math.clamp(startMainSize.Y + dy, 280, 600))
    end
end)

UIS.InputEnded:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 then
        resizing = false
    end
end)

-- default page
if navButtons["Home"] then
    navButtons["Home"].btn:MouseButton1Click()
    -- manual activate since click needs gui to be live
    navButtons["Home"].btn.BackgroundTransparency = 0
    navButtons["Home"].btn.BackgroundColor3 = Color3.fromRGB(18, 18, 26)
    navButtons["Home"].icon.TextColor3 = Color3.fromRGB(0, 200, 160)
    navButtons["Home"].name.TextColor3 = Color3.fromRGB(210, 210, 230)
    navButtons["Home"].name.Font = Enum.Font.GothamBold
    navButtons["Home"].bar.Visible = true
    showPage("Home")
end