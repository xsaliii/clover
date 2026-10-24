local DevTools = {}
DevTools.Version = "1.0.2"
DevTools._instances = {}

function DevTools:LogConsole(level, message)
    for _, inst in ipairs(DevTools._instances) do
        if inst and inst.addLog then
            pcall(inst.addLog, level, message)
        end
    end
end

function DevTools.Install(CentrixUI, Window)
    if not CentrixUI or not Window or Window.Destroyed then return end
    if Window._DevToolsInstalled then return Window._DevToolsTab end
    Window._DevToolsInstalled = true

    local FONT = Font.new("rbxasset://fonts/families/GothamSSm.json")
    local FONT_CODE = Font.new("rbxasset://fonts/families/RobotoMono.json")

    local C = {
        BG = Color3.fromRGB(22, 22, 22),
        BG2 = Color3.fromRGB(30, 30, 30),
        BG3 = Color3.fromRGB(42, 42, 42),
        BG4 = Color3.fromRGB(55, 55, 55),
        TEXT = Color3.fromRGB(235, 235, 235),
        SUBTEXT = Color3.fromRGB(150, 150, 150),
        BORDER = Color3.fromRGB(60, 60, 60),
        ACCENT = Color3.fromRGB(120, 180, 255),
        SUCCESS = Color3.fromRGB(100, 200, 120),
        WARNING = Color3.fromRGB(240, 200, 80),
        ERROR = Color3.fromRGB(240, 100, 100),
    }

    local state = {
        tabs = {},
        activeTabId = nil,
        tabCounter = 0,
        consoleLines = {},
        consoleMax = 500,
        consoleFilter = "all",
        consoleHooked = false,
        consoleFrame = nil,
    }

    local function nextId()
        state.tabCounter = state.tabCounter + 1
        return state.tabCounter
    end

    local function getTab(id)
        for _, t in ipairs(state.tabs) do
            if t.id == id then return t end
        end
        return nil
    end

    local function getActiveTab()
        if not state.activeTabId then return nil end
        return getTab(state.activeTabId)
    end

    local devTab = Window:AddTab({ Title = "Developer", Icon = "lucide-code" })
    Window._DevToolsTab = devTab

    local editorSection = devTab:AddSection({ Title = "Code Editor" })
    local editorFrame = editorSection:AddFrame({
        Size = UDim2.new(1, 0, 0, 420),
        BackgroundColor3 = C.BG2,
        BackgroundTransparency = 0.15,
    })
    local editorRoot = editorFrame.Instance

    local rootCorner = Instance.new("UICorner")
    rootCorner.CornerRadius = UDim.new(0, 8)
    rootCorner.Parent = editorRoot

    local rootStroke = Instance.new("UIStroke")
    rootStroke.Color = C.BORDER
    rootStroke.Thickness = 1
    rootStroke.Transparency = 0.3
    rootStroke.Parent = editorRoot

    local tabBar = Instance.new("Frame")
    tabBar.Size = UDim2.new(1, 0, 0, 36)
    tabBar.BackgroundColor3 = C.BG3
    tabBar.BackgroundTransparency = 0.2
    tabBar.BorderSizePixel = 0
    tabBar.Parent = editorRoot

    local tabBarCorner = Instance.new("UICorner")
    tabBarCorner.CornerRadius = UDim.new(0, 8)
    tabBarCorner.Parent = tabBar

    local tabBarScroll = Instance.new("ScrollingFrame")
    tabBarScroll.Size = UDim2.new(1, -50, 1, 0)
    tabBarScroll.BackgroundTransparency = 1
    tabBarScroll.BorderSizePixel = 0
    tabBarScroll.ScrollBarThickness = 2
    tabBarScroll.ScrollBarImageTransparency = 0.5
    tabBarScroll.ScrollingDirection = Enum.ScrollingDirection.X
    tabBarScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    tabBarScroll.AutomaticCanvasSize = Enum.AutomaticSize.X
    tabBarScroll.Parent = tabBar

    local tabList = Instance.new("UIListLayout")
    tabList.FillDirection = Enum.FillDirection.Horizontal
    tabList.Padding = UDim.new(0, 4)
    tabList.SortOrder = Enum.SortOrder.LayoutOrder
    tabList.Parent = tabBarScroll

    local tabBarPad = Instance.new("UIPadding")
    tabBarPad.PaddingLeft = UDim.new(0, 4)
    tabBarPad.PaddingTop = UDim.new(0, 4)
    tabBarPad.PaddingBottom = UDim.new(0, 4)
    tabBarPad.Parent = tabBarScroll

    local addTabBtn = Instance.new("TextButton")
    addTabBtn.Size = UDim2.new(0, 32, 0, 28)
    addTabBtn.Position = UDim2.new(1, -36, 0, 4)
    addTabBtn.BackgroundColor3 = C.BG4
    addTabBtn.BackgroundTransparency = 0.3
    addTabBtn.Text = "+"
    addTabBtn.TextColor3 = C.TEXT
    addTabBtn.FontFace = FONT
    addTabBtn.TextSize = 18
    addTabBtn.BorderSizePixel = 0
    addTabBtn.AutoButtonColor = false
    addTabBtn.Parent = tabBar

    local addBtnCorner = Instance.new("UICorner")
    addBtnCorner.CornerRadius = UDim.new(0, 4)
    addBtnCorner.Parent = addTabBtn

    local editorHolder = Instance.new("Frame")
    editorHolder.Size = UDim2.new(1, -16, 1, -88)
    editorHolder.Position = UDim2.new(0, 8, 0, 44)
    editorHolder.BackgroundColor3 = C.BG
    editorHolder.BorderSizePixel = 0
    editorHolder.Parent = editorRoot

    local ehCorner = Instance.new("UICorner")
    ehCorner.CornerRadius = UDim.new(0, 4)
    ehCorner.Parent = editorHolder

    local editor = Instance.new("TextBox")
    editor.Size = UDim2.new(1, -16, 1, -16)
    editor.Position = UDim2.new(0, 8, 0, 8)
    editor.BackgroundTransparency = 1
    editor.MultiLine = true
    editor.TextWrapped = false
    editor.TextXAlignment = Enum.TextXAlignment.Left
    editor.TextYAlignment = Enum.TextYAlignment.Top
    editor.TextColor3 = C.TEXT
    editor.PlaceholderColor3 = C.SUBTEXT
    editor.PlaceholderText = "Write Lua code here..."
    editor.FontFace = FONT_CODE
    editor.TextSize = 13
    editor.ClearTextOnFocus = false
    editor.Text = ""
    editor.Parent = editorHolder

    local toolbar = Instance.new("Frame")
    toolbar.Size = UDim2.new(1, -16, 0, 36)
    toolbar.Position = UDim2.new(0, 8, 1, -44)
    toolbar.BackgroundTransparency = 1
    toolbar.Parent = editorRoot

    local toolbarList = Instance.new("UIListLayout")
    toolbarList.FillDirection = Enum.FillDirection.Horizontal
    toolbarList.HorizontalAlignment = Enum.HorizontalAlignment.Right
    toolbarList.VerticalAlignment = Enum.VerticalAlignment.Center
    toolbarList.Padding = UDim.new(0, 6)
    toolbarList.SortOrder = Enum.SortOrder.LayoutOrder
    toolbarList.Parent = toolbar

    local function makeToolbarBtn(text, color, order, callback)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, 90, 0, 28)
        btn.BackgroundColor3 = color
        btn.BackgroundTransparency = 0.15
        btn.Text = text
        btn.TextColor3 = C.TEXT
        btn.FontFace = FONT
        btn.TextSize = 13
        btn.BorderSizePixel = 0
        btn.AutoButtonColor = false
        btn.LayoutOrder = order
        btn.Parent = toolbar

        local c = Instance.new("UICorner")
        c.CornerRadius = UDim.new(0, 4)
        c.Parent = btn

        btn.MouseEnter:Connect(function()
            btn.BackgroundTransparency = 0
        end)
        btn.MouseLeave:Connect(function()
            btn.BackgroundTransparency = 0.15
        end)
        btn.MouseButton1Click:Connect(callback)
        return btn
    end

    local function saveCurrentTab()
        local tab = getActiveTab()
        if tab then
            tab.content = editor.Text or ""
        end
    end

    local function renderTabs()
        for _, c in ipairs(tabBarScroll:GetChildren()) do
            if c:IsA("TextButton") then c:Destroy() end
        end

        for i, tab in ipairs(state.tabs) do
            local isActive = tab.id == state.activeTabId

            local tabBtn = Instance.new("TextButton")
            tabBtn.Size = UDim2.new(0, 110, 1, 0)
            tabBtn.BackgroundColor3 = isActive and C.BG4 or C.BG3
            tabBtn.BackgroundTransparency = isActive and 0 or 0.4
            tabBtn.Text = ""
            tabBtn.BorderSizePixel = 0
            tabBtn.AutoButtonColor = false
            tabBtn.LayoutOrder = i
            tabBtn.Parent = tabBarScroll

            local c = Instance.new("UICorner")
            c.CornerRadius = UDim.new(0, 4)
            c.Parent = tabBtn

            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(1, -28, 1, 0)
            label.Position = UDim2.new(0, 8, 0, 0)
            label.BackgroundTransparency = 1
            label.Text = tab.name
            label.TextColor3 = C.TEXT
            label.FontFace = FONT
            label.TextSize = 12
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.TextTruncate = Enum.TextTruncate.AtEnd
            label.Parent = tabBtn

            local closeBtn = Instance.new("TextButton")
            closeBtn.Size = UDim2.new(0, 18, 0, 18)
            closeBtn.Position = UDim2.new(1, -22, 0.5, -9)
            closeBtn.BackgroundTransparency = 1
            closeBtn.Text = "x"
            closeBtn.TextColor3 = C.SUBTEXT
            closeBtn.FontFace = FONT
            closeBtn.TextSize = 13
            closeBtn.BorderSizePixel = 0
            closeBtn.AutoButtonColor = false
            closeBtn.Parent = tabBtn

            tabBtn.MouseButton1Click:Connect(function()
                if state.activeTabId == tab.id then return end
                saveCurrentTab()
                state.activeTabId = tab.id
                editor.Text = tab.content or ""
                renderTabs()
            end)

            closeBtn.MouseButton1Click:Connect(function()
                if #state.tabs <= 1 then
                    Window:Notify({ Title = "Cannot Close", Content = "At least one tab must remain.", Type = "warning", Duration = 2 })
                    return
                end
                for idx, t in ipairs(state.tabs) do
                    if t.id == tab.id then
                        table.remove(state.tabs, idx)
                        break
                    end
                end
                if state.activeTabId == tab.id then
                    local first = state.tabs[1]
                    state.activeTabId = first and first.id or nil
                    editor.Text = first and first.content or ""
                end
                renderTabs()
            end)
        end
    end

    local function addNewTab()
        saveCurrentTab()
        local id = nextId()
        local tab = { id = id, name = "Script " .. id, content = "" }
        table.insert(state.tabs, tab)
        state.activeTabId = id
        editor.Text = ""
        renderTabs()
    end

    local function executeCode()
        saveCurrentTab()
        local code = editor.Text or ""
        if code == "" then
            Window:Notify({ Title = "Nothing to Execute", Content = "Editor is empty.", Type = "info", Duration = 2 })
            return
        end
        local fn, err = loadstring(code)
        if not fn then
            DevTools:LogConsole("error", "Load error: " .. tostring(err))
            return
        end
        DevTools:LogConsole("info", "Executing " .. tostring(#code) .. " bytes...")
        local ok, runErr = pcall(fn)
        if not ok then
            DevTools:LogConsole("error", tostring(runErr))
        else
            DevTools:LogConsole("success", "Executed successfully.")
        end
    end

    local function clearEditor()
        editor.Text = ""
        saveCurrentTab()
    end

    makeToolbarBtn("Execute", C.SUCCESS, 1, executeCode)
    makeToolbarBtn("Clear", C.BG3, 2, clearEditor)

    addTabBtn.MouseButton1Click:Connect(addNewTab)
    editor:GetPropertyChangedSignal("Text"):Connect(saveCurrentTab)

    local consoleSection = devTab:AddSection({ Title = "Console", Collapsible = true })
    local consoleFrame = consoleSection:AddFrame({
        Size = UDim2.new(1, 0, 0, 300),
        BackgroundColor3 = C.BG2,
        BackgroundTransparency = 0.15,
    })
    local consoleRoot = consoleFrame.Instance
    state.consoleFrame = consoleRoot

    local cfCorner = Instance.new("UICorner")
    cfCorner.CornerRadius = UDim.new(0, 8)
    cfCorner.Parent = consoleRoot

    local cfStroke = Instance.new("UIStroke")
    cfStroke.Color = C.BORDER
    cfStroke.Thickness = 1
    cfStroke.Transparency = 0.3
    cfStroke.Parent = consoleRoot

    local header = Instance.new("Frame")
    header.Size = UDim2.new(1, 0, 0, 32)
    header.BackgroundColor3 = C.BG3
    header.BackgroundTransparency = 0.3
    header.BorderSizePixel = 0
    header.Parent = consoleRoot

    local headerCorner = Instance.new("UICorner")
    headerCorner.CornerRadius = UDim.new(0, 8)
    headerCorner.Parent = header

    local headerList = Instance.new("UIListLayout")
    headerList.FillDirection = Enum.FillDirection.Horizontal
    headerList.VerticalAlignment = Enum.VerticalAlignment.Center
    headerList.Padding = UDim.new(0, 4)
    headerList.SortOrder = Enum.SortOrder.LayoutOrder
    headerList.Parent = header

    local headerPad = Instance.new("UIPadding")
    headerPad.PaddingLeft = UDim.new(0, 8)
    headerPad.PaddingRight = UDim.new(0, 8)
    headerPad.Parent = header

    local consoleBody = Instance.new("ScrollingFrame")
    consoleBody.Size = UDim2.new(1, -16, 1, -48)
    consoleBody.Position = UDim2.new(0, 8, 0, 40)
    consoleBody.BackgroundTransparency = 1
    consoleBody.BorderSizePixel = 0
    consoleBody.ScrollBarThickness = 3
    consoleBody.ScrollBarImageTransparency = 0.5
    consoleBody.ScrollingDirection = Enum.ScrollingDirection.Y
    consoleBody.CanvasSize = UDim2.new(0, 0, 0, 0)
    consoleBody.AutomaticCanvasSize = Enum.AutomaticSize.Y
    consoleBody.Parent = consoleRoot

    local logList = Instance.new("UIListLayout")
    logList.Padding = UDim.new(0, 2)
    logList.SortOrder = Enum.SortOrder.LayoutOrder
    logList.Parent = consoleBody

    local logDepth = 0

    local function updateConsoleVisibility()
        for _, line in ipairs(state.consoleLines) do
            if line.Instance and line.Instance.Parent then
                line.Instance.Visible = (state.consoleFilter == "all" or state.consoleFilter == line.Level)
            end
        end
    end

    local function addLog(level, message)
        if not consoleBody or not consoleBody.Parent then return end
        if logDepth > 0 then return end
        logDepth = logDepth + 1
        pcall(function()
            local entry = Instance.new("Frame")
            entry.Size = UDim2.new(1, 0, 0, 0)
            entry.AutomaticSize = Enum.AutomaticSize.Y
            entry.BackgroundTransparency = 1
            entry.Parent = consoleBody

            local list = Instance.new("UIListLayout")
            list.FillDirection = Enum.FillDirection.Horizontal
            list.Padding = UDim.new(0, 6)
            list.VerticalAlignment = Enum.VerticalAlignment.Top
            list.SortOrder = Enum.SortOrder.LayoutOrder
            list.Parent = entry

            local time = os.date("%H:%M:%S")

            local timeLabel = Instance.new("TextLabel")
            timeLabel.Size = UDim2.new(0, 60, 0, 16)
            timeLabel.BackgroundTransparency = 1
            timeLabel.Text = time
            timeLabel.TextColor3 = C.SUBTEXT
            timeLabel.FontFace = FONT
            timeLabel.TextSize = 11
            timeLabel.TextXAlignment = Enum.TextXAlignment.Left
            timeLabel.LayoutOrder = 1
            timeLabel.Parent = entry

            local levelColors = {
                info = C.ACCENT,
                success = C.SUCCESS,
                warning = C.WARNING,
                error = C.ERROR,
            }

            local levelLabel = Instance.new("TextLabel")
            levelLabel.Size = UDim2.new(0, 55, 0, 16)
            levelLabel.BackgroundTransparency = 1
            levelLabel.Text = string.upper(level)
            levelLabel.TextColor3 = levelColors[level] or C.TEXT
            levelLabel.FontFace = FONT
            levelLabel.TextSize = 11
            levelLabel.TextXAlignment = Enum.TextXAlignment.Left
            levelLabel.LayoutOrder = 2
            levelLabel.Parent = entry

            local msgLabel = Instance.new("TextLabel")
            msgLabel.Size = UDim2.new(1, -135, 0, 0)
            msgLabel.AutomaticSize = Enum.AutomaticSize.Y
            msgLabel.BackgroundTransparency = 1
            msgLabel.Text = message
            msgLabel.TextColor3 = C.TEXT
            msgLabel.FontFace = FONT
            msgLabel.TextSize = 11
            msgLabel.TextXAlignment = Enum.TextXAlignment.Left
            msgLabel.TextYAlignment = Enum.TextYAlignment.Top
            msgLabel.TextWrapped = true
            msgLabel.LayoutOrder = 3
            msgLabel.Parent = entry

            local data = { Instance = entry, Level = level, Message = message }
            table.insert(state.consoleLines, data)

            if #state.consoleLines > state.consoleMax then
                local old = table.remove(state.consoleLines, 1)
                if old and old.Instance then
                    old.Instance:Destroy()
                end
            end

            if state.consoleFilter ~= "all" and state.consoleFilter ~= level then
                entry.Visible = false
            end

            task.defer(function()
                if consoleBody and consoleBody.Parent then
                    consoleBody.CanvasPosition = Vector2.new(0, consoleBody.AbsoluteCanvasSize.Y)
                end
            end)
        end)
        logDepth = logDepth - 1
    end

    table.insert(DevTools._instances, { addLog = addLog })

    local filterButtons = {}

    local function makeFilter(text, level, order)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, 55, 0, 22)
        btn.BackgroundColor3 = C.BG4
        btn.BackgroundTransparency = (level == "all") and 0 or 0.4
        btn.Text = text
        btn.TextColor3 = C.TEXT
        btn.FontFace = FONT
        btn.TextSize = 11
        btn.BorderSizePixel = 0
        btn.AutoButtonColor = false
        btn.LayoutOrder = order
        btn.Parent = header

        local c = Instance.new("UICorner")
        c.CornerRadius = UDim.new(0, 3)
        c.Parent = btn

        filterButtons[level] = btn

        btn.MouseButton1Click:Connect(function()
            state.consoleFilter = level
            for lvl, b in pairs(filterButtons) do
                b.BackgroundTransparency = (lvl == level) and 0 or 0.4
            end
            updateConsoleVisibility()
        end)

        return btn
    end

    makeFilter("All", "all", 1)
    makeFilter("Info", "info", 2)
    makeFilter("Warn", "warning", 3)
    makeFilter("Error", "error", 4)

    local clearConsoleBtn = Instance.new("TextButton")
    clearConsoleBtn.Size = UDim2.new(0, 55, 0, 22)
    clearConsoleBtn.Position = UDim2.new(1, -63, 0, 5)
    clearConsoleBtn.BackgroundColor3 = C.BG4
    clearConsoleBtn.BackgroundTransparency = 0.4
    clearConsoleBtn.Text = "Clear"
    clearConsoleBtn.TextColor3 = C.TEXT
    clearConsoleBtn.FontFace = FONT
    clearConsoleBtn.TextSize = 11
    clearConsoleBtn.BorderSizePixel = 0
    clearConsoleBtn.AutoButtonColor = false
    clearConsoleBtn.Parent = header

    local ccCorner = Instance.new("UICorner")
    ccCorner.CornerRadius = UDim.new(0, 3)
    ccCorner.Parent = clearConsoleBtn

    clearConsoleBtn.MouseButton1Click:Connect(function()
        for _, line in ipairs(state.consoleLines) do
            if line.Instance and line.Instance.Parent then
                line.Instance:Destroy()
            end
        end
        state.consoleLines = {}
    end)

    local function installHooks()
        if state.consoleHooked then return end
        state.consoleHooked = true

        local env = (getgenv and getgenv()) or _G
        if not env then return end

        local function hookFn(fnName, level)
            local original
            local ok1, v1 = pcall(function() return env[fnName] end)
            if ok1 and type(v1) == "function" then
                original = v1
            else
                local ok2, v2 = pcall(function() return _G[fnName] end)
                if ok2 and type(v2) == "function" then
                    original = v2
                end
            end
            if not original then return end

            local detour = original

            local newFn = function(...)
                local argc = select("#", ...)
                local args = { ... }

                pcall(function()
                    local parts = {}
                    for i = 1, argc do
                        local v = args[i]
                        local tv = typeof(v)
                        if tv == "string" then
                            parts[i] = v
                        elseif tv == "Instance" then
                            local fok, fname = pcall(function() return v:GetFullName() end)
                            parts[i] = fok and fname or "<Instance>"
                        else
                            parts[i] = tostring(v)
                        end
                    end
                    local text = table.concat(parts, " ")
                    DevTools:LogConsole(level, text)
                end)

                return detour(...)
            end

            if type(hookfunction) == "function" then
                local hok, hd = pcall(hookfunction, original, newFn)
                if hok and type(hd) == "function" then
                    detour = hd
                    return
                end
            end

            if type(replaceclosure) == "function" then
                local rok = pcall(replaceclosure, original, newFn)
                if rok then return end
            end

            pcall(function() env[fnName] = newFn end)
            pcall(function() _G[fnName] = newFn end)
        end

        hookFn("print", "info")
        hookFn("warn", "warning")
    end

    installHooks()

    addNewTab()

    return devTab
end

return DevTools
