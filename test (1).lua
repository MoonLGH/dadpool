local MarewaUI = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- Detect mobile
local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled

local Theme = {
    Background = Color3.fromRGB(32, 32, 32),
    Secondary = Color3.fromRGB(45, 45, 45),
    Tertiary = Color3.fromRGB(55, 55, 55),
    Accent = Color3.fromRGB(96, 165, 250),
    AccentDark = Color3.fromRGB(59, 130, 246),
    Text = Color3.fromRGB(255, 255, 255),
    TextDark = Color3.fromRGB(180, 180, 180),
    Success = Color3.fromRGB(34, 197, 94),
    Error = Color3.fromRGB(239, 68, 68),
    Warning = Color3.fromRGB(234, 179, 8)
}

-- Size configs
local WindowSize = isMobile and UDim2.new(0, 340, 0, 280) or UDim2.new(0, 580, 0, 380)
local WindowPos = isMobile and UDim2.new(0.5, -170, 0, 10) or UDim2.new(0.5, -290, 0.5, -190)
local MinWindowSize = isMobile and UDim2.new(0, 340, 0, 36) or UDim2.new(0, 580, 0, 40)
local TabWidth = isMobile and 90 or 130

local function tween(obj, time, props)
    local t = TweenService:Create(obj, TweenInfo.new(time, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), props)
    t:Play()
    return t
end

local function createCorner(parent, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 8)
    corner.Parent = parent
    return corner
end

local function createStroke(parent, color, thickness)
    local stroke = Instance.new("UIStroke")
    stroke.Color = color or Color3.fromRGB(60, 60, 60)
    stroke.Thickness = thickness or 1
    stroke.Parent = parent
    return stroke
end

local function createPadding(parent, padding)
    local pad = Instance.new("UIPadding")
    pad.PaddingTop = UDim.new(0, padding)
    pad.PaddingBottom = UDim.new(0, padding)
    pad.PaddingLeft = UDim.new(0, padding)
    pad.PaddingRight = UDim.new(0, padding)
    pad.Parent = parent
    return pad
end

local notifyContainer
function MarewaUI:Notify(config)
    if not self._screenGui then return end
    if not notifyContainer then
        notifyContainer = Instance.new("Frame")
        notifyContainer.Name = "NotifyContainer"
        notifyContainer.Size = UDim2.new(0, 260, 0, 300)
        notifyContainer.Position = UDim2.new(1, -270, 1, -310)
        notifyContainer.BackgroundTransparency = 1
        notifyContainer.Parent = self._screenGui
        
        local list = Instance.new("UIListLayout")
        list.SortOrder = Enum.SortOrder.LayoutOrder
        list.VerticalAlignment = Enum.VerticalAlignment.Bottom
        list.Padding = UDim.new(0, 8)
        list.Parent = notifyContainer
    end
    
    local notif = Instance.new("Frame")
    notif.Size = UDim2.new(1, 0, 0, 60)
    notif.BackgroundColor3 = Theme.Secondary
    notif.BackgroundTransparency = 0.1
    notif.Parent = notifyContainer
    createCorner(notif, 8)
    createStroke(notif, Theme.Accent, 1)
    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -12, 0, 20)
    title.Position = UDim2.new(0, 6, 0, 6)
    title.BackgroundTransparency = 1
    title.Font = Enum.Font.GothamBold
    title.TextSize = 13
    title.TextColor3 = Theme.Text
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Text = config.Title or "Notification"
    title.Parent = notif
    
    local content = Instance.new("TextLabel")
    content.Size = UDim2.new(1, -12, 0, 28)
    content.Position = UDim2.new(0, 6, 0, 26)
    content.BackgroundTransparency = 1
    content.Font = Enum.Font.Gotham
    content.TextSize = 11
    content.TextColor3 = Theme.TextDark
    content.TextXAlignment = Enum.TextXAlignment.Left
    content.TextWrapped = true
    content.Text = config.Content or ""
    content.Parent = notif
    
    notif.Position = UDim2.new(1, 0, 0, 0)
    tween(notif, 0.3, {Position = UDim2.new(0, 0, 0, 0)})
    
    task.delay(config.Duration or 3, function()
        tween(notif, 0.3, {Position = UDim2.new(1, 0, 0, 0), BackgroundTransparency = 1})
        task.wait(0.35)
        notif:Destroy()
    end)
end

function MarewaUI:Destroy()
    if self._screenGui then
        self._screenGui:Destroy()
        self._screenGui = nil
    end
    notifyContainer = nil
end

function MarewaUI:CreateWindow(config)
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "MarewaG"
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.Parent = player:WaitForChild("PlayerGui")
    self._screenGui = screenGui
    
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainWindow"
    mainFrame.Size = WindowSize
    mainFrame.Position = WindowPos
    mainFrame.BackgroundColor3 = Theme.Background
    mainFrame.Active = true
    mainFrame.ClipsDescendants = true
    mainFrame.Parent = screenGui
    createCorner(mainFrame, 10)
    createStroke(mainFrame, Color3.fromRGB(60, 60, 60), 1)
    
    local mobileToggleBtn
    if isMobile then
        mobileToggleBtn = Instance.new("TextButton")
        mobileToggleBtn.Name = "MobileToggle"
        mobileToggleBtn.AnchorPoint = Vector2.new(0.5, 0)
        mobileToggleBtn.Size = UDim2.new(0, 150, 0, 32)
        mobileToggleBtn.Position = UDim2.new(0.5, 0, 0, 6)
        mobileToggleBtn.ZIndex = 10
        mobileToggleBtn.BackgroundColor3 = Theme.Secondary
        mobileToggleBtn.AutoButtonColor = false
        mobileToggleBtn.Font = Enum.Font.GothamBold
        mobileToggleBtn.TextSize = 13
        mobileToggleBtn.TextColor3 = Theme.Text
        mobileToggleBtn.Text = "Tampilkan UI"
        mobileToggleBtn.Parent = screenGui
        createCorner(mobileToggleBtn, 8)
        createStroke(mobileToggleBtn, Color3.fromRGB(70, 70, 70), 1)
    end
    
    local titleBar = Instance.new("TextButton")
    titleBar.Name = "TitleBar"
    titleBar.Size = UDim2.new(1, 0, 0, isMobile and 36 or 40)
    titleBar.BackgroundColor3 = Theme.Secondary
    titleBar.Text = ""
    titleBar.AutoButtonColor = false
    titleBar.Parent = mainFrame
    
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 10)
    titleCorner.Parent = titleBar
    
    local fix = Instance.new("Frame")
    fix.Size = UDim2.new(1, 0, 0, 10)
    fix.Position = UDim2.new(0, 0, 1, -10)
    fix.BackgroundColor3 = Theme.Secondary
    fix.BorderSizePixel = 0
    fix.Parent = titleBar
    
    local titleText = Instance.new("TextLabel")
    titleText.Size = UDim2.new(1, -80, 1, 0)
    titleText.Position = UDim2.new(0, 10, 0, 0)
    titleText.BackgroundTransparency = 1
    titleText.Font = Enum.Font.GothamBold
    titleText.TextSize = isMobile and 14 or 16
    titleText.TextColor3 = Theme.Text
    titleText.TextXAlignment = Enum.TextXAlignment.Left
    titleText.Text = config.Name or "MarewaUI"
    titleText.Parent = titleBar
    
    -- Drag
    local dragging, dragStart, startPos = false, nil, nil
    titleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = mainFrame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    
    -- Close button (hides UI)
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 26, 0, 26)
    closeBtn.Position = UDim2.new(1, -31, 0, isMobile and 5 or 7)
    closeBtn.BackgroundColor3 = Theme.Error
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.TextSize = 14
    closeBtn.TextColor3 = Theme.Text
    closeBtn.Text = "×"
    closeBtn.Parent = titleBar
    createCorner(closeBtn, 5)
    
    closeBtn.MouseButton1Click:Connect(function()
        mainFrame.Visible = false
        local hint = isMobile and "Click Unhide to toggle" or "Press K to toggle"
        MarewaUI:Notify({Title = "UI Hidden", Content = hint, Duration = 2})
    end)
    
    -- Minimize button
    local minBtn = Instance.new("TextButton")
    minBtn.Size = UDim2.new(0, 26, 0, 26)
    minBtn.Position = UDim2.new(1, -60, 0, isMobile and 5 or 7)
    minBtn.BackgroundColor3 = Theme.Warning
    minBtn.Font = Enum.Font.GothamBold
    minBtn.TextSize = 14
    minBtn.TextColor3 = Theme.Text
    minBtn.Text = "−"
    minBtn.Parent = titleBar
    createCorner(minBtn, 5)
    
    -- Tab Container
    local tabContainer = Instance.new("Frame")
    tabContainer.Name = "TabContainer"
    tabContainer.Size = UDim2.new(0, TabWidth, 1, isMobile and -42 or -48)
    tabContainer.Position = UDim2.new(0, 4, 0, isMobile and 38 or 44)
    tabContainer.BackgroundColor3 = Theme.Secondary
    tabContainer.Parent = mainFrame
    createCorner(tabContainer, 6)
    
    local tabList = Instance.new("UIListLayout")
    tabList.SortOrder = Enum.SortOrder.LayoutOrder
    tabList.Padding = UDim.new(0, 3)
    tabList.Parent = tabContainer
    createPadding(tabContainer, 4)
    
    -- Content Container
    local contentFrame = Instance.new("Frame")
    contentFrame.Name = "ContentFrame"
    contentFrame.Size = UDim2.new(1, -TabWidth - 10, 1, isMobile and -42 or -48)
    contentFrame.Position = UDim2.new(0, TabWidth + 8, 0, isMobile and 38 or 44)
    contentFrame.BackgroundTransparency = 1
    contentFrame.Parent = mainFrame
    
    -- Minimize logic
    local minimized = false
    minBtn.MouseButton1Click:Connect(function()
        minimized = not minimized
        tabContainer.Visible = not minimized
        contentFrame.Visible = not minimized
        tween(mainFrame, 0.2, {Size = minimized and MinWindowSize or WindowSize})
    end)
    
    -- Toggle keybind (K)
    UserInputService.InputBegan:Connect(function(input, gp)
        if gp then return end
        if input.KeyCode == Enum.KeyCode.K then
            mainFrame.Visible = not mainFrame.Visible
        end
    end)
    
    if mobileToggleBtn then
        local function updateMobileToggle()
            mobileToggleBtn.Text = mainFrame.Visible and "Hide GUI | Marewa" or "Unhide GUI | Marewa"
        end
        
        mobileToggleBtn.MouseButton1Click:Connect(function()
            mainFrame.Visible = not mainFrame.Visible
            updateMobileToggle()
        end)
        
        mainFrame:GetPropertyChangedSignal("Visible"):Connect(updateMobileToggle)
        updateMobileToggle()
    end
    
    local window = {tabs = {}, activeTab = nil}
    
    function window:CreateTab(name)
        local tabBtn = Instance.new("TextButton")
        tabBtn.Size = UDim2.new(1, 0, 0, isMobile and 28 or 32)
        tabBtn.BackgroundColor3 = Theme.Tertiary
        tabBtn.BackgroundTransparency = 1
        tabBtn.Font = Enum.Font.GothamMedium
        tabBtn.TextSize = isMobile and 11 or 13
        tabBtn.TextColor3 = Theme.TextDark
        tabBtn.Text = name
        tabBtn.Parent = tabContainer
        createCorner(tabBtn, 5)
        
        local tabContent = Instance.new("ScrollingFrame")
        tabContent.Size = UDim2.new(1, 0, 1, 0)
        tabContent.BackgroundTransparency = 1
        tabContent.ScrollBarThickness = 3
        tabContent.ScrollBarImageColor3 = Theme.Accent
        tabContent.Visible = false
        tabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
        tabContent.AutomaticCanvasSize = Enum.AutomaticSize.Y
        tabContent.Parent = contentFrame
        
        local contentList = Instance.new("UIListLayout")
        contentList.SortOrder = Enum.SortOrder.LayoutOrder
        contentList.Padding = UDim.new(0, 5)
        contentList.Parent = tabContent
        createPadding(tabContent, 3)
        
        local tab = {content = tabContent, btn = tabBtn}
        table.insert(self.tabs, tab)
        
        tabBtn.MouseButton1Click:Connect(function()
            for _, t in pairs(self.tabs) do
                t.content.Visible = false
                t.btn.BackgroundTransparency = 1
                t.btn.TextColor3 = Theme.TextDark
            end
            tabContent.Visible = true
            tabBtn.BackgroundTransparency = 0
            tabBtn.TextColor3 = Theme.Accent
            self.activeTab = tab
        end)
        
        if #self.tabs == 1 then
            tabBtn.BackgroundTransparency = 0
            tabBtn.TextColor3 = Theme.Accent
            tabContent.Visible = true
            self.activeTab = tab
        end
        
        function tab:CreateToggle(cfg)
            local holder = Instance.new("Frame")
            holder.Size = UDim2.new(1, -6, 0, isMobile and 32 or 36)
            holder.BackgroundColor3 = Theme.Tertiary
            holder.Parent = tabContent
            createCorner(holder, 5)
            
            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(1, -55, 1, 0)
            label.Position = UDim2.new(0, 8, 0, 0)
            label.BackgroundTransparency = 1
            label.Font = Enum.Font.Gotham
            label.TextSize = isMobile and 11 or 13
            label.TextColor3 = Theme.Text
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.Text = cfg.Name or "Toggle"
            label.Parent = holder
            
            local toggleBg = Instance.new("Frame")
            toggleBg.Size = UDim2.new(0, 40, 0, 20)
            toggleBg.Position = UDim2.new(1, -48, 0.5, -10)
            toggleBg.BackgroundColor3 = Theme.Secondary
            toggleBg.Parent = holder
            createCorner(toggleBg, 10)
            createStroke(toggleBg, Color3.fromRGB(70, 70, 70), 1)
            
            local toggleCircle = Instance.new("Frame")
            toggleCircle.Size = UDim2.new(0, 14, 0, 14)
            toggleCircle.Position = UDim2.new(0, 3, 0.5, -7)
            toggleCircle.BackgroundColor3 = Theme.TextDark
            toggleCircle.Parent = toggleBg
            createCorner(toggleCircle, 7)
            
            local enabled = cfg.CurrentValue or false
            local function updateToggle()
                if enabled then
                    tween(toggleCircle, 0.12, {Position = UDim2.new(0, 23, 0.5, -7), BackgroundColor3 = Theme.Accent})
                    tween(toggleBg, 0.12, {BackgroundColor3 = Theme.AccentDark})
                else
                    tween(toggleCircle, 0.12, {Position = UDim2.new(0, 3, 0.5, -7), BackgroundColor3 = Theme.TextDark})
                    tween(toggleBg, 0.12, {BackgroundColor3 = Theme.Secondary})
                end
            end
            updateToggle()
            
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, 0, 1, 0)
            btn.BackgroundTransparency = 1
            btn.Text = ""
            btn.Parent = holder
            
            btn.MouseButton1Click:Connect(function()
                enabled = not enabled
                updateToggle()
                if cfg.Callback then cfg.Callback(enabled) end
            end)
            
            return {Set = function(_, v) enabled = v; updateToggle() end}
        end
        
        function tab:CreateButton(cfg)
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, -6, 0, isMobile and 30 or 34)
            btn.BackgroundColor3 = Theme.Accent
            btn.Font = Enum.Font.GothamMedium
            btn.TextSize = isMobile and 11 or 13
            btn.TextColor3 = Theme.Text
            btn.Text = cfg.Name or "Button"
            btn.Parent = tabContent
            createCorner(btn, 5)
            
            btn.MouseEnter:Connect(function() tween(btn, 0.1, {BackgroundColor3 = Theme.AccentDark}) end)
            btn.MouseLeave:Connect(function() tween(btn, 0.1, {BackgroundColor3 = Theme.Accent}) end)
            btn.MouseButton1Click:Connect(function() if cfg.Callback then cfg.Callback() end end)
        end
        
        function tab:CreateSlider(cfg)
            local holder = Instance.new("Frame")
            holder.Size = UDim2.new(1, -6, 0, isMobile and 44 or 50)
            holder.BackgroundColor3 = Theme.Tertiary
            holder.Parent = tabContent
            createCorner(holder, 5)
            
            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(1, -55, 0, 18)
            label.Position = UDim2.new(0, 8, 0, 3)
            label.BackgroundTransparency = 1
            label.Font = Enum.Font.Gotham
            label.TextSize = isMobile and 10 or 12
            label.TextColor3 = Theme.Text
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.Text = cfg.Name or "Slider"
            label.Parent = holder
            
            local valueLabel = Instance.new("TextLabel")
            valueLabel.Size = UDim2.new(0, 45, 0, 18)
            valueLabel.Position = UDim2.new(1, -53, 0, 3)
            valueLabel.BackgroundTransparency = 1
            valueLabel.Font = Enum.Font.GothamMedium
            valueLabel.TextSize = isMobile and 10 or 12
            valueLabel.TextColor3 = Theme.Accent
            valueLabel.TextXAlignment = Enum.TextXAlignment.Right
            valueLabel.Parent = holder
            
            local sliderBg = Instance.new("TextButton")
            sliderBg.Size = UDim2.new(1, -16, 0, 6)
            sliderBg.Position = UDim2.new(0, 8, 0, isMobile and 28 or 34)
            sliderBg.BackgroundColor3 = Theme.Secondary
            sliderBg.Text = ""
            sliderBg.AutoButtonColor = false
            sliderBg.Parent = holder
            createCorner(sliderBg, 3)
            
            local sliderFill = Instance.new("Frame")
            sliderFill.Size = UDim2.new(0, 0, 1, 0)
            sliderFill.BackgroundColor3 = Theme.Accent
            sliderFill.Parent = sliderBg
            createCorner(sliderFill, 3)
            
            local min, max = cfg.Range[1], cfg.Range[2]
            local inc = cfg.Increment or 1
            local current = cfg.CurrentValue or min
            local suffix = cfg.Suffix or ""
            
            local function updateSlider(val, cb)
                current = math.clamp(math.floor(val / inc + 0.5) * inc, min, max)
                local pct = (current - min) / (max - min)
                sliderFill.Size = UDim2.new(pct, 0, 1, 0)
                valueLabel.Text = tostring(current) .. suffix
                if cb ~= false and cfg.Callback then cfg.Callback(current) end
            end
            updateSlider(current, false)
            
            local sliding = false
            sliderBg.MouseButton1Down:Connect(function() sliding = true end)
            UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then sliding = false end end)
            UserInputService.InputChanged:Connect(function(i)
                if sliding and i.UserInputType == Enum.UserInputType.MouseMovement then
                    local pct = math.clamp((i.Position.X - sliderBg.AbsolutePosition.X) / sliderBg.AbsoluteSize.X, 0, 1)
                    updateSlider(min + pct * (max - min), true)
                end
            end)
            sliderBg.MouseButton1Click:Connect(function()
                local m = player:GetMouse()
                local pct = math.clamp((m.X - sliderBg.AbsolutePosition.X) / sliderBg.AbsoluteSize.X, 0, 1)
                updateSlider(min + pct * (max - min), true)
            end)
        end
        
        function tab:CreateDropdown(cfg)
            local holder = Instance.new("Frame")
            holder.Size = UDim2.new(1, -6, 0, isMobile and 32 or 36)
            holder.BackgroundColor3 = Theme.Tertiary
            holder.ClipsDescendants = true
            holder.Parent = tabContent
            createCorner(holder, 5)
            
            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(0, 90, 0, isMobile and 32 or 36)
            label.Position = UDim2.new(0, 8, 0, 0)
            label.BackgroundTransparency = 1
            label.Font = Enum.Font.Gotham
            label.TextSize = isMobile and 11 or 13
            label.TextColor3 = Theme.Text
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.Text = cfg.Name or "Dropdown"
            label.Parent = holder
            
            -- Full width dropdown button
            local selectBtn = Instance.new("TextButton")
            selectBtn.Size = UDim2.new(1, -108, 0, isMobile and 24 or 28)
            selectBtn.Position = UDim2.new(0, 100, 0, 4)
            selectBtn.BackgroundColor3 = Theme.Secondary
            selectBtn.Font = Enum.Font.Gotham
            selectBtn.TextSize = isMobile and 10 or 11
            selectBtn.TextColor3 = Theme.TextDark
            selectBtn.TextTruncate = Enum.TextTruncate.AtEnd
            selectBtn.Parent = holder
            createCorner(selectBtn, 4)
            
            local optionsFrame = Instance.new("Frame")
            optionsFrame.Size = UDim2.new(1, -108, 0, 0)
            optionsFrame.Position = UDim2.new(0, 100, 0, isMobile and 32 or 36)
            optionsFrame.BackgroundColor3 = Theme.Secondary
            optionsFrame.Visible = false
            optionsFrame.Parent = holder
            createCorner(optionsFrame, 4)
            
            local optList = Instance.new("UIListLayout")
            optList.SortOrder = Enum.SortOrder.LayoutOrder
            optList.Parent = optionsFrame
            
            local expanded = false
            local options = cfg.Options or {}
            local isMultiSelect = cfg.MultiSelection or cfg.MultipleOptions or false
            local selectedOptions = {}
            
            -- Initialize selected options
            if cfg.CurrentOption then
                if isMultiSelect then
                    for _, opt in ipairs(cfg.CurrentOption) do
                        selectedOptions[opt] = true
                    end
                else
                    selectedOptions[cfg.CurrentOption[1]] = true
                end
            end
            
            local function getSelectedList()
                local list = {}
                for _, opt in ipairs(options) do
                    if selectedOptions[opt] then
                        table.insert(list, opt)
                    end
                end
                return list
            end
            
            local function updateDisplayText()
                local selected = getSelectedList()
                if #selected == 0 then
                    selectBtn.Text = "Select..."
                elseif #selected == 1 then
                    selectBtn.Text = selected[1]
                else
                    selectBtn.Text = table.concat(selected, ", ")
                end
            end
            updateDisplayText()
            
            local function buildOptions()
                for _, c in pairs(optionsFrame:GetChildren()) do
                    if c:IsA("TextButton") then c:Destroy() end
                end
                for _, opt in pairs(options) do
                    local optBtn = Instance.new("TextButton")
                    optBtn.Size = UDim2.new(1, 0, 0, isMobile and 22 or 24)
                    optBtn.BackgroundTransparency = 1
                    optBtn.Font = Enum.Font.Gotham
                    optBtn.TextSize = isMobile and 10 or 11
                    optBtn.TextXAlignment = Enum.TextXAlignment.Left
                    optBtn.Parent = optionsFrame
                    
                    local function updateOptText()
                        if isMultiSelect then
                            local check = selectedOptions[opt] and "[x] " or "[ ] "
                            optBtn.Text = check .. opt
                            optBtn.TextColor3 = selectedOptions[opt] and Theme.Accent or Theme.TextDark
                        else
                            optBtn.Text = opt
                            optBtn.TextColor3 = selectedOptions[opt] and Theme.Accent or Theme.TextDark
                        end
                    end
                    updateOptText()
                    
                    optBtn.MouseButton1Click:Connect(function()
                        if isMultiSelect then
                            -- Toggle selection
                            selectedOptions[opt] = not selectedOptions[opt]
                            updateOptText()
                            updateDisplayText()
                            if cfg.Callback then cfg.Callback(getSelectedList()) end
                        else
                            -- Single select - clear others and select this one
                            selectedOptions = {}
                            selectedOptions[opt] = true
                            selectBtn.Text = opt
                            expanded = false
                            optionsFrame.Visible = false
                            tween(holder, 0.12, {Size = UDim2.new(1, -6, 0, isMobile and 32 or 36)})
                            if cfg.Callback then cfg.Callback({opt}) end
                        end
                    end)
                end
            end
            buildOptions()
            
            selectBtn.MouseButton1Click:Connect(function()
                expanded = not expanded
                optionsFrame.Visible = expanded
                local optH = isMobile and 22 or 24
                local h = expanded and ((isMobile and 32 or 36) + #options * optH + 4) or (isMobile and 32 or 36)
                tween(holder, 0.12, {Size = UDim2.new(1, -6, 0, h)})
                optionsFrame.Size = UDim2.new(1, -108, 0, #options * optH)
            end)
            
            return {
                Refresh = function(_, newOpts)
                    options = newOpts or {}
                    selectedOptions = {}
                    if options[1] then selectedOptions[options[1]] = true end
                    updateDisplayText()
                    buildOptions()
                end,
                GetSelected = function()
                    return getSelectedList()
                end
            }
        end
        
        function tab:CreateInput(cfg)
            local holder = Instance.new("Frame")
            holder.Size = UDim2.new(1, -6, 0, isMobile and 32 or 36)
            holder.BackgroundColor3 = Theme.Tertiary
            holder.Parent = tabContent
            createCorner(holder, 5)
            
            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(0.35, -6, 1, 0)
            label.Position = UDim2.new(0, 8, 0, 0)
            label.BackgroundTransparency = 1
            label.Font = Enum.Font.Gotham
            label.TextSize = isMobile and 11 or 13
            label.TextColor3 = Theme.Text
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.Text = cfg.Name or "Input"
            label.Parent = holder
            
            local input = Instance.new("TextBox")
            input.Size = UDim2.new(0.6, -6, 0, isMobile and 22 or 26)
            input.Position = UDim2.new(0.4, 0, 0.5, isMobile and -11 or -13)
            input.BackgroundColor3 = Theme.Secondary
            input.Font = Enum.Font.Gotham
            input.TextSize = isMobile and 10 or 12
            input.TextColor3 = Theme.Text
            input.PlaceholderText = cfg.PlaceholderText or ""
            input.PlaceholderColor3 = Theme.TextDark
            input.Text = ""
            input.ClearTextOnFocus = false
            input.Parent = holder
            createCorner(input, 4)
            
            input.FocusLost:Connect(function()
                if cfg.Callback then cfg.Callback(input.Text) end
                if cfg.RemoveTextAfterFocusLost then input.Text = "" end
            end)
        end
        
        function tab:CreateParagraph(cfg)
            local holder = Instance.new("Frame")
            holder.Size = UDim2.new(1, -6, 0, isMobile and 42 or 50)
            holder.BackgroundColor3 = Theme.Tertiary
            holder.Parent = tabContent
            createCorner(holder, 5)
            
            local title = Instance.new("TextLabel")
            title.Size = UDim2.new(1, -12, 0, 16)
            title.Position = UDim2.new(0, 6, 0, 4)
            title.BackgroundTransparency = 1
            title.Font = Enum.Font.GothamBold
            title.TextSize = isMobile and 11 or 13
            title.TextColor3 = Theme.Accent
            title.TextXAlignment = Enum.TextXAlignment.Left
            title.Text = cfg.Title or ""
            title.Parent = holder
            
            local content = Instance.new("TextLabel")
            content.Size = UDim2.new(1, -12, 0, isMobile and 18 or 22)
            content.Position = UDim2.new(0, 6, 0, isMobile and 20 or 24)
            content.BackgroundTransparency = 1
            content.Font = Enum.Font.Gotham
            content.TextSize = isMobile and 9 or 11
            content.TextColor3 = Theme.TextDark
            content.TextXAlignment = Enum.TextXAlignment.Left
            content.TextWrapped = true
            content.Text = cfg.Content or ""
            content.Parent = holder
            
            return {
                Set = function(_, newCfg)
                    if newCfg.Title then title.Text = newCfg.Title end
                    if newCfg.Content then content.Text = newCfg.Content end
                end
            }
        end
        
        return tab
    end
    
    return window
end

return MarewaUI
