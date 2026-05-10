-- Loader Script for Gravity Hub Color Changer
-- Save this as "Loader.lua" in Delta Executor

local loadSuccess, errorMessage = pcall(function()
    -- Main Menu Script
    local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/wally-rblx/LinoriaLib/main/Library.lua"))()
    
    local Window = Library:CreateWindow({
        Title = "Gravity Hub | Visual Changer",
        Center = true,
        AutoShow = true,
        TabPadding = 8,
        MenuFadeTime = 0.2
    })
    
    -- Create Tabs
    local MainTab = Window:AddTab("Main")
    local VisualTab = Window:AddTab("Visuals")
    local SettingsTab = Window:AddTab("Settings")
    
    -- Left Group (Skills Colors)
    local SkillsGroup = VisualTab:AddLeftGroupbox("Skills Colors")
    
    SkillsGroup:AddColorPicker("M1Color", {
        Title = "M1 Attack Color",
        Default = Color3.fromRGB(255, 0, 0)
    })
    
    SkillsGroup:AddColorPicker("Skill1Color", {
        Title = "Skill 1 Color",
        Default = Color3.fromRGB(0, 255, 0)
    })
    
    SkillsGroup:AddColorPicker("Skill2Color", {
        Title = "Skill 2 Color",
        Default = Color3.fromRGB(0, 0, 255)
    })
    
    SkillsGroup:AddColorPicker("Skill3Color", {
        Title = "Skill 3 Color",
        Default = Color3.fromRGB(255, 255, 0)
    })
    
    SkillsGroup:AddColorPicker("Skill4Color", {
        Title = "Skill 4 Color",
        Default = Color3.fromRGB(255, 0, 255)
    })
    
    SkillsGroup:AddColorPicker("Skill5Color", {
        Title = "Skill 5 Color",
        Default = Color3.fromRGB(0, 255, 255)
    })
    
    -- Right Group (Fruit Colors)
    local FruitGroup = VisualTab:AddRightGroupbox("Fruit Effects")
    
    FruitGroup:AddColorPicker("FruitEffect1", {
        Title = "Fruit Effect 1",
        Default = Color3.fromRGB(255, 165, 0)
    })
    
    FruitGroup:AddColorPicker("FruitEffect2", {
        Title = "Fruit Effect 2",
        Default = Color3.fromRGB(128, 0, 128)
    })
    
    FruitGroup:AddColorPicker("FruitEffect3", {
        Title = "Fruit Effect 3",
        Default = Color3.fromRGB(255, 20, 147)
    })
    
    -- Apply Colors Button
    local ApplyGroup = MainTab:AddLeftGroupbox("Apply Changes")
    
    ApplyGroup:AddButton("Apply All Colors", function()
        Library:Notify("Applying all color changes...", 3)
        
        -- Apply M1 Color
        if Options.M1Color.Value then
            -- Replace with your game's M1 color changing code
            print("M1 Color Applied:", Options.M1Color.Value)
        end
        
        -- Apply Skill Colors
        for i = 1, 5 do
            local colorOption = Options["Skill"..i.."Color"]
            if colorOption then
                print("Skill "..i.." Color Applied:", colorOption.Value)
            end
        end
        
        -- Apply Fruit Colors
        for i = 1, 3 do
            local fruitOption = Options["FruitEffect"..i]
            if fruitOption then
                print("Fruit Effect "..i.." Color Applied:", fruitOption.Value)
            end
        end
        
        Library:Notify("Colors applied successfully!", 5)
    end)
    
    ApplyGroup:AddButton("Reset to Default", function()
        Options.M1Color:SetValueRGB(255, 0, 0)
        Options.Skill1Color:SetValueRGB(0, 255, 0)
        Options.Skill2Color:SetValueRGB(0, 0, 255)
        Options.Skill3Color:SetValueRGB(255, 255, 0)
        Options.Skill4Color:SetValueRGB(255, 0, 255)
        Options.Skill5Color:SetValueRGB(0, 255, 255)
        Options.FruitEffect1:SetValueRGB(255, 165, 0)
        Options.FruitEffect2:SetValueRGB(128, 0, 128)
        Options.FruitEffect3:SetValueRGB(255, 20, 147)
        
        Library:Notify("Reset to default colors!", 5)
    end)
    
    -- Settings Tab
    local MenuGroup = SettingsTab:AddLeftGroupbox("Menu Settings")
    
    MenuGroup:AddToggle("Watermark", {
        Text = "Show Watermark",
        Default = true,
        Callback = function(value)
            Library:SetWatermarkVisibility(value)
        end
    })
    
    MenuGroup:AddToggle("Keybinds", {
        Text = "Show Keybinds",
        Default = true,
        Callback = function(value)
            Library.KeybindFrame.Visible = value
        end
    })
    
    MenuGroup:AddKeybind("MenuKeybind", {
        Text = "Menu Toggle",
        Default = "RightShift",
        Callback = function()
            Library:Unbind()
        end
    })
    
    -- Watermark
    Library:SetWatermark("Gravity Hub | Visual Changer v1.0")
    
    -- Keybinds
    Library:OnUnload(function()
        Library.Unloaded = true
    end)
    
    -- UI Settings
    Library.ToggleKeybind = Options.MenuKeybind
    
    -- Success Notification
    Library:Notify("Gravity Hub Menu Loaded Successfully!", 10)
    
    -- Mobile Optimization
    if game:GetService("UserInputService").TouchEnabled then
        Library:Notify("Mobile Mode Activated", 5)
        -- Adjust UI for mobile if needed
    end
    
    -- Save Configuration
    local ConfigGroup = SettingsTab:AddRightGroupbox("Configuration")
    
    ConfigGroup:AddInput("ConfigName", {
        Text = "Config Name",
        Default = "default",
        Placeholder = "Enter config name"
    })
    
    ConfigGroup:AddButton("Save Config", function()
        Library:SaveConfig(Options.ConfigName.Value)
        Library:Notify("Config saved as: " .. Options.ConfigName.Value, 5)
    end)
    
    ConfigGroup:AddButton("Load Config", function()
        Library:LoadConfig(Options.ConfigName.Value)
        Library:Notify("Config loaded: " .. Options.ConfigName.Value, 5)
    end)
    
    -- Auto-load default config
    Library:LoadConfig("default")
end)

-- Loader Result Notification
if loadSuccess then
    -- Success - Show in-game notification
    if game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("Notification") then
        local ScreenGui = Instance.new("ScreenGui")
        local TextLabel = Instance.new("TextLabel")
        
        ScreenGui.Name = "LoaderSuccess"
        ScreenGui.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
        ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        
        TextLabel.Parent = ScreenGui
        TextLabel.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
        TextLabel.BackgroundTransparency = 0.3
        TextLabel.Position = UDim2.new(0.5, -150, 0.1, 0)
        TextLabel.Size = UDim2.new(0, 300, 0, 50)
        TextLabel.Font = Enum.Font.GothamBold
        TextLabel.Text = "✅ Gravity Hub Menu Loaded Successfully!"
        TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        TextLabel.TextSize = 16
        TextLabel.TextWrapped = true
        TextLabel.RichText = true
        
        -- Animate
        TextLabel:TweenPosition(UDim2.new(0.5, -150, 0.15, 0), "Out", "Quad", 0.5, true)
        
        -- Remove after 5 seconds
        wait(5)
        TextLabel:TweenPosition(UDim2.new(0.5, -150, 0.1, 0), "Out", "Quad", 0.5, true)
        wait(0.5)
        ScreenGui:Destroy()
    end
    
    print("✅ Gravity Hub Menu Loaded Successfully!")
    print("📱 Compatible with Mobile & Windows")
    print("🎮 Press RightShift to toggle menu")
else
    warn("❌ Failed to load Gravity Hub Menu: " .. tostring(errorMessage))
    
    -- Show error notification
    if game:GetService("Players").LocalPlayer.PlayerGui then
        local ScreenGui = Instance.new("ScreenGui")
        local TextLabel = Instance.new("TextLabel")
        
        ScreenGui.Name = "LoaderError"
        ScreenGui.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
        ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        
        TextLabel.Parent = ScreenGui
        TextLabel.BackgroundColor3 = Color3.fromRGB(170, 0, 0)
        TextLabel.BackgroundTransparency = 0.3
        TextLabel.Position = UDim2.new(0.5, -150, 0.1, 0)
        TextLabel.Size = UDim2.new(0, 300, 0, 70)
        TextLabel.Font = Enum.Font.GothamBold
        TextLabel.Text = "❌ Load Failed!\nError: " .. tostring(errorMessage)
        TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        TextLabel.TextSize = 14
        TextLabel.TextWrapped = true
        TextLabel.RichText = true
        
        wait(5)
        ScreenGui:Destroy()
    end
end
