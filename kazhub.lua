-- language: Lua, executor: Delta, game: Anime Crusaders
-- KAZ HUB v1.0 | Main Menu UI

pcall(function()
    game:GetService("CoreGui"):FindFirstChild("KazHub"):Destroy()
end)

local running_autopilot = false
local stageCount = 0

-- SERVICES
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local lp = Players.LocalPlayer

-- ROOT GUI
local sg = Instance.new("ScreenGui")
sg.Name = "KazHub"
sg.ResetOnSpawn = false
sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
sg.Parent = CoreGui

-- MAIN FRAME
local main = Instance.new("Frame")
main.Size = UDim2.new(0, 280, 0, 380)
main.Position = UDim2.new(0.5, -140, 0.5, -190)
main.BackgroundColor3 = Color3.fromRGB(12, 12, 18)
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true
main.Parent = sg
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 12)

-- STROKE
local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(100, 60, 220)
stroke.Thickness = 1.5
stroke.Parent = main

-- HEADER
local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 52)
header.BackgroundColor3 = Color3.fromRGB(88, 50, 200)
header.BorderSizePixel = 0
header.Parent = main
Instance.new("UICorner", header).CornerRadius = UDim.new(0, 12)

local headerFix = Instance.new("Frame")
headerFix.Size = UDim2.new(1, 0, 0.5, 0)
headerFix.Position = UDim2.new(0, 0, 0.5, 0)
headerFix.BackgroundColor3 = Color3.fromRGB(88, 50, 200)
headerFix.BorderSizePixel = 0
headerFix.Parent = header

local logo = Instance.new("TextLabel")
logo.Size = UDim2.new(1, -50, 1, 0)
logo.Position = UDim2.new(0, 14, 0, 0)
logo.BackgroundTransparency = 1
logo.Text = "⚡ KAZ HUB"
logo.TextColor3 = Color3.fromRGB(255, 255, 255)
logo.Font = Enum.Font.GothamBold
logo.TextSize = 18
logo.TextXAlignment = Enum.TextXAlignment.Left
logo.Parent = header

local subtext = Instance.new("TextLabel")
subtext.Size = UDim2.new(1, -50, 0, 16)
subtext.Position = UDim2.new(0, 14, 0, 32)
subtext.BackgroundTransparency = 1
subtext.Text = "Anime Crusaders"
subtext.TextColor3 = Color3.fromRGB(200, 180, 255)
subtext.Font = Enum.Font.Gotham
subtext.TextSize = 11
subtext.TextXAlignment = Enum.TextXAlignment.Left
subtext.Parent = header

-- CLOSE BUTTON
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 28, 0, 28)
closeBtn.Position = UDim2.new(1, -36, 0, 12)
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeBtn.BorderSizePixel = 0
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 13
closeBtn.Parent = header
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 6)
closeBtn.MouseButton1Click:Connect(function() sg:Destroy() end)

-- STATUS BAR
local statusBar = Instance.new("Frame")
statusBar.Size = UDim2.new(1, -20, 0, 28)
statusBar.Position = UDim2.new(0, 10, 0, 60)
statusBar.BackgroundColor3 = Color3.fromRGB(22, 22, 32)
statusBar.BorderSizePixel = 0
statusBar.Parent = main
Instance.new("UICorner", statusBar).CornerRadius = UDim.new(0, 6)

local statusTxt = Instance.new("TextLabel")
statusTxt.Size = UDim2.new(1, -10, 1, 0)
statusTxt.Position = UDim2.new(0, 8, 0, 0)
statusTxt.BackgroundTransparency = 1
statusTxt.Text = "● Idle — select a feature"
statusTxt.TextColor3 = Color3.fromRGB(150, 150, 170)
statusTxt.Font = Enum.Font.Gotham
statusTxt.TextSize = 11
statusTxt.TextXAlignment = Enum.TextXAlignment.Left
statusTxt.Parent = statusBar

local function setStatus(msg, color)
    statusTxt.Text = "● " .. msg
    statusTxt.TextColor3 = color or Color3.fromRGB(150, 150, 170)
end

-- SECTION LABEL
local function makeSection(text, yPos)
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -20, 0, 18)
    lbl.Position = UDim2.new(0, 10, 0, yPos)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = Color3.fromRGB(100, 60, 220)
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 11
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = main
end

-- TOGGLE BUILDER
local function makeToggle(label, icon, yPos, onEnable, onDisable)
    local enabled = false

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -20, 0, 42)
    frame.Position = UDim2.new(0, 10, 0, yPos)
    frame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    frame.BorderSizePixel = 0
    frame.Parent = main
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -60, 1, 0)
    lbl.Position = UDim2.new(0, 12, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = icon .. "  " .. label
    lbl.TextColor3 = Color3.fromRGB(220, 220, 220)
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 13
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = frame

    local pill = Instance.new("TextButton")
    pill.Size = UDim2.new(0, 44, 0, 24)
    pill.Position = UDim2.new(1, -54, 0.5, -12)
    pill.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    pill.BorderSizePixel = 0
    pill.Text = "OFF"
    pill.TextColor3 = Color3.fromRGB(150, 150, 150)
    pill.Font = Enum.Font.GothamBold
    pill.TextSize = 11
    pill.Parent = frame
    Instance.new("UICorner", pill).CornerRadius = UDim.new(0, 12)

    local function toggle()
        enabled = not enabled
        if enabled then
            pill.BackgroundColor3 = Color3.fromRGB(88, 50, 200)
            pill.TextColor3 = Color3.fromRGB(255, 255, 255)
            pill.Text = "ON"
            frame.BackgroundColor3 = Color3.fromRGB(25, 20, 40)
            setStatus(label .. " ON", Color3.fromRGB(140, 100, 255))
            if onEnable then task.spawn(onEnable) end
        else
            pill.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
            pill.TextColor3 = Color3.fromRGB(150, 150, 150)
            pill.Text = "OFF"
            frame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
            setStatus("Idle — select a feature")
            if onDisable then onDisable() end
        end
    end

    pill.MouseButton1Click:Connect(toggle)
    frame.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.Touch then toggle() end
    end)

    return function() return enabled end
end

-- ACTION BUTTON
local function makeAction(label, icon, yPos, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -20, 0, 42)
    btn.Position = UDim2.new(0, 10, 0, yPos)
    btn.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    btn.BorderSizePixel = 0
    btn.Text = icon .. "  " .. label
    btn.TextColor3 = Color3.fromRGB(220, 220, 220)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 13
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.Parent = main
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)

    local pad = Instance.new("UIPadding")
    pad.PaddingLeft = UDim.new(0, 12)
    pad.Parent = btn

    btn.MouseButton1Click:Connect(function()
        setStatus("Running: " .. label, Color3.fromRGB(100, 200, 100))
        task.spawn(callback)
    end)
end

-- NEXT STAGE REMOTES
local nextKeywords = {
    "NextStage","Next","Continue","PlayAgain",
    "Replay","Restart","NextWave","Proceed","NextLevel"
}

local function fireNext()
    for _, keyword in ipairs(nextKeywords) do
        for _, v in ipairs(game:GetDescendants()) do
            if (v:IsA("RemoteEvent") or v:IsA("RemoteFunction"))
            and string.lower(v.Name):find(string.lower(keyword)) then
                pcall(function()
                    if v:IsA("RemoteFunction") then v:InvokeServer()
                    else v:FireServer() end
                end)
            end
        end
    end
end

-- FEATURES

makeSection("AUTOMATION", 96)

local getAutoPilot = makeToggle("Auto Next Stage", "▶", 116,
    function()
        running_autopilot = true
        local gui = lp:WaitForChild("PlayerGui")
        while running_autopilot do
            for _, obj in ipairs(gui:GetDescendants()) do
                if not obj.Visible then continue end
                local name = string.lower(obj.Name)
                local text = obj:IsA("TextButton") and string.lower(obj.Text or "") or ""
                if name:find("next") or name:find("victory") or name:find("complete")
                or text:find("next") or text:find("continue") then
                    if obj:IsA("TextButton") then
                        pcall(function() obj:Activate() end)
                        stageCount += 1
                        setStatus("Stages cleared: " .. stageCount, Color3.fromRGB(140, 100, 255))
                        task.wait(2)
                    end
                    fireNext()
                end
            end
            task.wait(0.5)
        end
    end,
    function() running_autopilot = false end
)

makeSection("QUICK ACTIONS", 168)

makeAction("Redeem All Codes", "🎁", 188, function()
    local codes = {
        "UPDATE10","SORRY","1MILLION","DISCORD","THANKYOU",
        "RELEASE","ANIME100","CRUSADER","FREEGEMS","UPD10"
    }
    for _, code in ipairs(codes) do
        for _, v in ipairs(game:GetDescendants()) do
            if (v:IsA("RemoteEvent") or v:IsA("RemoteFunction"))
            and string.lower(v.Name):find("code") then
                pcall(function()
                    if v:IsA("RemoteFunction") then v:InvokeServer(code)
                    else v:FireServer(code) end
                end)
            end
        end
        task.wait(1.2)
    end
    setStatus("All codes attempted", Color3.fromRGB(100, 200, 100))
end)

makeAction("Collect Rewards", "⭐", 240, function()
    for _, v in ipairs(game:GetDescendants()) do
        if v:IsA("RemoteEvent") or v:IsA("RemoteFunction") then
            local n = string.lower(v.Name)
            if n:find("reward") or n:find("claim") or n:find("daily") then
                pcall(function()
                    if v:IsA("RemoteFunction") then v:InvokeServer()
                    else v:FireServer() end
                end)
            end
        end
    end
    setStatus("Rewards collected", Color3.fromRGB(100, 200, 100))
end)

-- FOOTER
local footer = Instance.new("TextLabel")
footer.Size = UDim2.new(1, 0, 0, 20)
footer.Position = UDim2.new(0, 0, 1, -22)
footer.BackgroundTransparency = 1
footer.Text = "KAZ HUB v1.0  •  Anime Crusaders"
footer.TextColor3 = Color3.fromRGB(60, 60, 80)
footer.Font = Enum.Font.Gotham
footer.TextSize = 10
footer.Parent = main

setStatus("Ready", Color3.fromRGB(140, 100, 255))
