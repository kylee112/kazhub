local function clickGuiButton(keywords)
    local clicked = false
    pcall(function()
        for _, v in ipairs(lp.PlayerGui:GetDescendants()) do
            if (v:IsA("TextButton") or v:IsA("ImageButton")) and v.Visible then
                local n = v.Name:lower()
                local t = v:IsA("TextButton") and v.Text:lower() or ""
                for _, kw in ipairs(keywords) do
                    if n:find(kw) or t:find(kw) then
                        -- try all three methods
                        pcall(function() v:Activate() end)
                        pcall(function() v.MouseButton1Click:Fire() end)
                        pcall(function()
                            local pos = v.AbsolutePosition
                            local size = v.AbsoluteSize
                            VPS:ClickButton1(Vector2.new(
                                pos.X + size.X/2,
                                pos.Y + size.Y/2
                            ), workspace.CurrentCamera.CFrame)
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