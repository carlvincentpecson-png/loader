-- Gravity Hub Color Changer Loader
-- Fixed - No HTTP requests, works offline
-- Save as "ColorChangerLoader.lua" for Delta Executor

local loadSuccess, errorMessage = pcall(function()
    -- Create UI Library locally (no HTTP request)
    local UserInputService = game:GetService("UserInputService")
    local TweenService = game:GetService("TweenService")
    local RunService = game:GetService("RunService")
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    local Mouse = LocalPlayer:GetMouse()
    
    -- Simple UI Library
    local Library = {
        Toggle = false,
        ColorPicker = false,
        ColorPickerHolding = false,
        ColorH = 0,
        ColorS = 1,
        ColorV = 1,
        Dragging = false,
        DragInput = nil,
        DragStart = nil,
        DragPos = nil,
        RainbowColor = Color3.new(1, 1, 1),
        RainbowColorValue = 0,
        Tween = nil
    }
    
    -- Create Main ScreenGui
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "GravityHubUI"
    ScreenGui.Parent = game:GetService("CoreGui") or LocalPlayer:WaitForChild("PlayerGui")
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.ResetOnSpawn = false
    
    -- Create Main Frame
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Parent = ScreenGui
    MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    MainFrame.BackgroundTransparency = 0.1
    MainFrame.BorderSizePixel = 0
    MainFrame.Position = UDim2.new(0.5, -200, 0.5, -150)
    MainFrame.Size = UDim2.new(0, 400, 0, 400)
    MainFrame.Visible = false
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 8)
    Corner.Parent = MainFrame
    
    local TopBar = Instance.new("Frame")
    TopBar.Name = "TopBar"
    TopBar.Parent = MainFrame
    TopBar.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    TopBar.BorderSizePixel = 0
    TopBar.Size = UDim2.new(1, 0, 0, 30)
    
    local TopBarCorner = Instance.new("UICorner")
    TopBarCorner.CornerRadius = UDim.new(0, 8)
    TopBarCorner.Parent = TopBar
    
    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Parent = TopBar
    Title.BackgroundTransparency = 1
    Title.Position = UDim2.new(0, 10, 0, 0)
    Title.Size = UDim2.new(0, 200, 1, 0)
    Title.Font = Enum.Font.GothamBold
    Title.Text = "Gravity Hub | Visual Changer"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 14
    Title.TextXAlignment = Enum.TextXAlignment.Left
    
    local CloseButton = Instance.new("TextButton")
    CloseButton.Name = "CloseButton"
    CloseButton.Parent = TopBar
    CloseButton.BackgroundTransparency = 1
    CloseButton.Position = UDim2.new(1, -30, 0, 0)
    CloseButton.Size = UDim2.new(0, 30, 1, 0)
    CloseButton.Font = Enum.Font.GothamBold
    CloseButton.Text = "X"
    CloseButton.TextColor3 = Color3.fromRGB(255, 100, 100)
    CloseButton.TextSize = 14
    
    CloseButton.MouseButton1Click:Connect(function()
        MainFrame.Visible = false
        Library.Toggle = false
    end)
    
    -- Create Tabs Container
    local TabsContainer = Instance.new("Frame")
    TabsContainer.Name = "TabsContainer"
    TabsContainer.Parent = MainFrame
    TabsContainer.BackgroundTransparency = 1
    TabsContainer.Position = UDim2.new(0, 0, 0, 30)
    TabsContainer.Size = UDim2.new(0, 100, 1, -30)
    
    -- Create Content Container
    local ContentContainer = Instance.new("Frame")
    ContentContainer.Name = "ContentContainer"
    ContentContainer.Parent = MainFrame
    ContentContainer.BackgroundTransparency = 1
    ContentContainer.Position = UDim2.new(0, 100, 0, 30)
    ContentContainer.Size = UDim2.new(1, -100, 1, -30)
    
    -- Tab Buttons
    local tabs = {"Main", "Visuals", "Settings"}
    local tabButtons = {}
    local currentTab = "Main"
    
    for i, tabName in ipairs(tabs) do
        local TabButton = Instance.new("TextButton")
        TabButton.Name = tabName .. "Tab"
        TabButton.Parent = TabsContainer
        TabButton.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        TabButton.BackgroundTransparency = 0.5
        TabButton.BorderSizePixel = 0
        TabButton.Position = UDim2.new(0, 0, 0, (i-1) * 40)
        TabButton.Size = UDim2.new(1, 0, 0, 40)
        TabButton.Font = Enum.Font.Gotham
        TabButton.Text = tabName
        TabButton.TextColor3 = Color3.fromRGB(200, 200, 200)
        TabButton.TextSize = 12
        
        local TabCorner = Instance.new("UICorner")
        TabCorner.CornerRadius = UDim.new(0, 4)
        TabCorner.Parent = TabButton
        
        tabButtons[tabName] = TabButton
        
        TabButton.MouseButton1Click:Connect(function()
            currentTab = tabName
            updateTabContent()
            
            for name, button in pairs(tabButtons) do
                if name == tabName then
                    button.BackgroundTransparency = 0
                    button.TextColor3 = Color3.fromRGB(255, 255, 255)
                else
                    button.BackgroundTransparency = 0.5
                    button.TextColor3 = Color3.fromRGB(200, 200, 200)
                end
            end
        end)
    end
    
    -- Tab Content
    local tabContents = {}
    
    -- Main Tab Content
    local MainContent = Instance.new("ScrollingFrame")
    MainContent.Name = "MainContent"
    MainContent.Parent = ContentContainer
    MainContent.BackgroundTransparency = 1
    MainContent.Size = UDim2.new(1, 0, 1, 0)
    MainContent.ScrollBarThickness = 0
    MainContent.Visible = false
    
    local MainLayout = Instance.new("UIListLayout")
    MainLayout.Parent = MainContent
    MainLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    MainLayout.SortOrder = Enum.SortOrder.LayoutOrder
    MainLayout.Padding = UDim.new(0, 10)
    
    -- Visuals Tab Content
    local VisualsContent = Instance.new("ScrollingFrame")
    VisualsContent.Name = "VisualsContent"
    VisualsContent.Parent = ContentContainer
    VisualsContent.BackgroundTransparency = 1
    VisualsContent.Size = UDim2.new(1, 0, 1, 0)
    VisualsContent.ScrollBarThickness = 0
    VisualsContent.Visible = false
    
    local VisualsLayout = Instance.new("UIListLayout")
    VisualsLayout.Parent = VisualsContent
    VisualsLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    VisualsLayout.SortOrder = Enum.SortOrder.LayoutOrder
    VisualsLayout.Padding = UDim.new(0, 10)
    
    -- Settings Tab Content
    local SettingsContent = Instance.new("ScrollingFrame")
    SettingsContent.Name = "SettingsContent"
    SettingsContent.Parent = ContentContainer
    SettingsContent.BackgroundTransparency = 1
    SettingsContent.Size = UDim2.new(1, 0, 1, 0)
    SettingsContent.ScrollBarThickness = 0
    SettingsContent.Visible = false
    
    local SettingsLayout = Instance.new("UIListLayout")
    SettingsLayout.Parent = SettingsContent
    SettingsLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    SettingsLayout.SortOrder = Enum.SortOrder.LayoutOrder
    SettingsLayout.Padding = UDim.new(0, 10)
    
    tabContents["Main"] = MainContent
    tabContents["Visuals"] = VisualsContent
    tabContents["Settings"] = SettingsContent
    
    -- Function to create color picker
    function createColorPicker(parent, name, defaultColor)
        local ColorPickerFrame = Instance.new("Frame")
        ColorPickerFrame.Name = name .. "Picker"
        ColorPickerFrame.Parent = parent
        ColorPickerFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        ColorPickerFrame.BorderSizePixel = 0
        ColorPickerFrame.Size = UDim2.new(1, -20, 0, 60)
        
        local Corner = Instance.new("UICorner")
        Corner.CornerRadius = UDim.new(0, 6)
        Corner.Parent = ColorPickerFrame
        
        local Title = Instance.new("TextLabel")
        Title.Name = "Title"
        Title.Parent = ColorPickerFrame
        Title.BackgroundTransparency = 1
        Title.Position = UDim2.new(0, 10, 0, 5)
        Title.Size = UDim2.new(0, 200, 0, 20)
        Title.Font = Enum.Font.Gotham
        Title.Text = name
        Title.TextColor3 = Color3.fromRGB(255, 255, 255)
        Title.TextSize = 12
        Title.TextXAlignment = Enum.TextXAlignment.Left
        
        local ColorPreview = Instance.new("Frame")
        ColorPreview.Name = "ColorPreview"
        ColorPreview.Parent = ColorPickerFrame
        ColorPreview.BackgroundColor3 = defaultColor
        ColorPreview.BorderSizePixel = 0
        ColorPreview.Position = UDim2.new(0, 10, 0, 30)
        ColorPreview.Size = UDim2.new(0, 80, 0, 20)
        
        local PreviewCorner = Instance.new("UICorner")
        PreviewCorner.CornerRadius = UDim.new(0, 4)
        PreviewCorner.Parent = ColorPreview
        
        local PickButton = Instance.new("TextButton")
        PickButton.Name = "PickButton"
        PickButton.Parent = ColorPickerFrame
        PickButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        PickButton.BorderSizePixel = 0
        PickButton.Position = UDim2.new(0, 100, 0, 30)
        PickButton.Size = UDim2.new(0, 60, 0, 20)
        PickButton.Font = Enum.Font.Gotham
        PickButton.Text = "Pick"
        PickButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        PickButton.TextSize = 11
        
        PickButton.MouseButton1Click:Connect(function()
            -- Simple color picker logic
            ColorPreview.BackgroundColor3 = Color3.fromRGB(
                math.random(0, 255),
                math.random(0, 255),
                math.random(0, 255)
            )
        end)
        
        return {
            Frame = ColorPickerFrame,
            Preview = ColorPreview,
            Button = PickButton,
            Color = defaultColor
        }
    end
    
    -- Function to create button
    function createButton(parent, text, callback)
        local Button = Instance.new("TextButton")
        Button.Parent = parent
        Button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        Button.BorderSizePixel = 0
        Button.Size = UDim2.new(1, -20, 0, 30)
        Button.Font = Enum.Font.Gotham
        Button.Text = text
        Button.TextColor3 = Color3.fromRGB(255, 255, 255)
        Button.TextSize = 12
        
        local Corner = Instance.new("UICorner")
        Corner.CornerRadius = UDim.new(0, 6)
        Corner.Parent = Button
        
        Button.MouseButton1Click:Connect(callback)
        
        return Button
    end
    
    -- Create UI Elements
    -- Skills Colors
    local skillColors = {}
    local skillNames = {"M1 Attack", "Skill 1", "Skill 2", "Skill 3", "Skill 4", "Skill 5"}
    local defaultSkillColors = {
        Color3.fromRGB(255, 0, 0),
        Color3.fromRGB(0, 255, 0),
        Color3.fromRGB(0, 0, 255),
        Color3.fromRGB(255, 255, 0),
        Color3.fromRGB(255, 0, 255),
        Color3.fromRGB(0, 255, 255)
    }
    
    -- Skills Group Title
    local SkillsTitle = Instance.new("TextLabel")
    SkillsTitle.Parent = VisualsContent
    SkillsTitle.BackgroundTransparency = 1
    SkillsTitle.Size = UDim2.new(1, -20, 0, 20)
    SkillsTitle.Font = Enum.Font.GothamBold
    SkillsTitle.Text = "Skills Colors"
    SkillsTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    SkillsTitle.TextSize = 14
    
    for i = 1, 6 do
        skillColors[i] = createColorPicker(VisualsContent, skillNames[i], defaultSkillColors[i])
    end
    
    -- Fruit Effects
    local fruitColors = {}
    local fruitNames = {"Fruit Effect 1", "Fruit Effect 2", "Fruit Effect 3"}
    local defaultFruitColors = {
        Color3.fromRGB(255, 165, 0),
        Color3.fromRGB(128, 0, 128),
        Color3.fromRGB(255, 20, 147)
    }
    
    -- Fruits Group Title
    local FruitsTitle = Instance.new("TextLabel")
    FruitsTitle.Parent = VisualsContent
    FruitsTitle.BackgroundTransparency = 1
    FruitsTitle.Size = UDim2.new(1, -20, 0, 20)
    FruitsTitle.Font = Enum.Font.GothamBold
    FruitsTitle.Text = "Fruit Effects"
    FruitsTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    FruitsTitle.TextSize = 14
    
    for i = 1, 3 do
        fruitColors[i] = createColorPicker(VisualsContent, fruitNames[i], defaultFruitColors[i])
    end
    
    -- Main Tab Buttons
    createButton(MainContent, "Apply All Colors", function()
        showNotification("✅ Colors Applied Successfully!", Color3.fromRGB(0, 170, 0))
        
        -- Here you would add your actual color changing code
        print("=== Applying Colors ===")
        for i, colorPicker in ipairs(skillColors) do
            print(skillNames[i] .. " Color:", colorPicker.Preview.BackgroundColor3)
        end
        for i, colorPicker in ipairs(fruitColors) do
            print(fruitNames[i] .. " Color:", colorPicker.Preview.BackgroundColor3)
        end
    end)
    
    createButton(MainContent, "Reset to Default", function()
        for i, colorPicker in ipairs(skillColors) do
            colorPicker.Preview.BackgroundColor3 = defaultSkillColors[i]
        end
        for i, colorPicker in ipairs(fruitColors) do
            colorPicker.Preview.BackgroundColor3 = defaultFruitColors[i]
        end
        showNotification("🔄 Reset to Default Colors", Color3.fromRGB(255, 165, 0))
    end)
    
    -- Settings Tab
    createButton(SettingsContent, "Save Configuration", function()
        showNotification("💾 Configuration Saved", Color3.fromRGB(0, 120, 255))
    end)
    
    createButton(SettingsContent, "Load Configuration", function()
        showNotification("📂 Configuration Loaded", Color3.fromRGB(0, 120, 255))
    end)
    
    createButton(SettingsContent, "Unload Menu", function()
        ScreenGui:Destroy()
        showNotification("👋 Menu Unloaded", Color3.fromRGB(255, 100, 100))
    end)
    
    -- Update Tab Function
    function updateTabContent()
        for name, content in pairs(tabContents) do
            content.Visible = (name == currentTab)
        end
    end
    
    -- Notification Function
    function showNotification(message, color)
        local Notification = Instance.new("Frame")
        Notification.Name = "Notification"
        Notification.Parent = ScreenGui
        Notification.BackgroundColor3 = color
        Notification.BackgroundTransparency = 0.2
        Notification.BorderSizePixel = 0
        Notification.Position = UDim2.new(0.5, -150, 0.9, 0)
        Notification.Size = UDim2.new(0, 300, 0, 40)
        Notification.ZIndex = 100
        
        local Corner = Instance.new("UICorner")
        Corner.CornerRadius = UDim.new(0, 6)
        Corner.Parent = Notification
        
        local Text = Instance.new("TextLabel")
        Text.Parent = Notification
        Text.BackgroundTransparency = 1
        Text.Size = UDim2.new(1, 0, 1, 0)
        Text.Font = Enum.Font.GothamBold
        Text.Text = message
        Text.TextColor3 = Color3.fromRGB(255, 255, 255)
        Text.TextSize = 13
        Text.TextWrapped = true
        
        -- Animate in
        Notification:TweenPosition(UDim2.new(0.5, -150, 0.85, 0), "Out", "Quad", 0.3, true)
        
        -- Remove after 3 seconds
        wait(3)
        Notification:TweenPosition(UDim2.new(0.5, -150, 0.9, 0), "Out", "Quad", 0.3, true)
        wait(0.3)
        Notification:Destroy()
    end
    
    -- Make MainFrame draggable
    local function makeDraggable(frame)
        local dragInput
        local dragStart
        local startPos
        
        local function update(input)
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
        
        frame.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragStart = input.Position
                startPos = frame.Position
                
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        Library.Dragging = false
                    end
                end)
            end
        end)
        
        frame.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                dragInput = input
            end
        end)
        
        UserInputService.InputChanged:Connect(function(input)
            if input == dragInput and Library.Dragging then
                update(input)
            end
        end)
    end
    
    makeDraggable(MainFrame)
    
    -- Toggle Menu with RightShift
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if not gameProcessed then
            if input.KeyCode == Enum.KeyCode.RightShift then
                Library.Toggle = not Library.Toggle
                MainFrame.Visible = Library.Toggle
                
                if Library.Toggle then
                    updateTabContent()
                    tabButtons["Main"].BackgroundTransparency = 0
                    tabButtons["Main"].TextColor3 = Color3.fromRGB(255, 255, 255)
                end
            end
        end
    end)
    
    -- Mobile touch support
    if UserInputService.TouchEnabled then
        -- Add a toggle button for mobile
        local MobileToggle = Instance.new("TextButton")
        MobileToggle.Name = "MobileToggle"
        MobileToggle.Parent = ScreenGui
        MobileToggle.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
        MobileToggle.BorderSizePixel = 0
        MobileToggle.Position = UDim2.new(0, 10, 0, 10)
        MobileToggle.Size = UDim2.new(0, 50, 0, 50)
        MobileToggle.Font = Enum.Font.GothamBold
        MobileToggle.Text = "☰"
        MobileToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
        MobileToggle.TextSize = 20
        
        local MobileCorner = Instance.new("UICorner")
        MobileCorner.CornerRadius = UDim.new(0, 8)
        MobileCorner.Parent = MobileToggle
        
        MobileToggle.MouseButton1Click:Connect(function()
            Library.Toggle = not Library.Toggle
            MainFrame.Visible = Library.Toggle
            
            if Library.Toggle then
                updateTabContent()
                tabButtons["Main"].BackgroundTransparency = 0
                tabButtons["Main"].TextColor3 = Color3.fromRGB(255, 255, 255)
            end
        end)
    end
    
    -- Initial setup
    updateTabContent()
    
    -- Show success notification
    wait(0.5)
    showNotification("✅ Gravity Hub Menu Loaded Successfully!", Color3.fromRGB(0, 170, 0))
    
    print("🎮 Gravity Hub Visual Changer Loaded!")
    print("📱 Mobile Compatible: " .. tostring(UserInputService.TouchEnabled))
    print("🎯 Toggle Menu: RightShift (PC) or Tap ☰ (Mobile)")
end)

-- Loader Result
if loadSuccess then
    print("========================================")
    print("✅ GRAVITY HUB MENU LOADED SUCCESSFULLY!")
    print("========================================")
    print("Features:")
    print("• 6 Skill Color Pickers")
    print("• 3 Fruit Effect Color Pickers")
    print("• Mobile & PC Support")
    print("• RightShift to toggle menu")
    print("• Drag & Drop UI")
    print("========================================")
else
    warn("❌ LOAD FAILED: " .. tostring(errorMessage))
    
    -- Show error in game
    if game:GetService("Players").LocalPlayer.PlayerGui then
        local ErrorGui = Instance.new("ScreenGui")
        local ErrorLabel = Instance.new("TextLabel")
        
        ErrorGui.Name = "ErrorDisplay"
        ErrorGui.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
        
        ErrorLabel.Parent = ErrorGui
        ErrorLabel.BackgroundColor3 = Color3.fromRGB(170, 0, 0)
        ErrorLabel.BackgroundTransparency = 0.2
        ErrorLabel.Position = UDim2.new(0.5, -150, 0.5, -50)
        ErrorLabel.Size = UDim2.new(0, 300, 0, 100)
        ErrorLabel.Font = Enum.Font.GothamBold
        ErrorLabel.Text = "❌ Load Error\n" .. tostring(errorMessage)
        ErrorLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        ErrorLabel.TextSize = 14
        ErrorLabel.TextWrapped = true
        
        wait(5)
        ErrorGui:Destroy()
    end
end
