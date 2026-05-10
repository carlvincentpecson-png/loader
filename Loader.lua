-- Color Customization Menu Script
-- Compatible with Delta Executor (Mobile & Windows)
-- Created for Visual Skill Color Changes

-- Main Execution Check
if not game:IsLoaded() then
    game.Loaded:Wait()
end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local TextService = game:GetService("TextService")

local player = Players.LocalPlayer
local mouse = player:GetMouse()

-- Color Storage
local colorSettings = {
    M1Color = Color3.fromRGB(255, 255, 255),
    SkillColor = Color3.fromRGB(255, 255, 255),
    FruitEffectColor = Color3.fromRGB(255, 255, 255),
    AuraColor = Color3.fromRGB(255, 255, 255),
    TrailColor = Color3.fromRGB(255, 255, 255)
}

-- Save/Load System
local function saveColors()
    local data = {
        M1Color = {colorSettings.M1Color.R, colorSettings.M1Color.G, colorSettings.M1Color.B},
        SkillColor = {colorSettings.SkillColor.R, colorSettings.SkillColor.G, colorSettings.SkillColor.B},
        FruitEffectColor = {colorSettings.FruitEffectColor.R, colorSettings.FruitEffectColor.G, colorSettings.FruitEffectColor.B},
        AuraColor = {colorSettings.AuraColor.R, colorSettings.AuraColor.G, colorSettings.AuraColor.B},
        TrailColor = {colorSettings.TrailColor.R, colorSettings.TrailColor.G, colorSettings.TrailColor.B}
    }
    writefile("ColorMenuSettings.json", game:GetService("HttpService"):JSONEncode(data))
end

local function loadColors()
    if isfile("ColorMenuSettings.json") then
        local success, data = pcall(function()
            return game:GetService("HttpService"):JSONDecode(readfile("ColorMenuSettings.json"))
        end)
        
        if success and data then
            if data.M1Color then
                colorSettings.M1Color = Color3.new(data.M1Color[1], data.M1Color[2], data.M1Color[3])
            end
            if data.SkillColor then
                colorSettings.SkillColor = Color3.new(data.SkillColor[1], data.SkillColor[2], data.SkillColor[3])
            end
            if data.FruitEffectColor then
                colorSettings.FruitEffectColor = Color3.new(data.FruitEffectColor[1], data.FruitEffectColor[2], data.FruitEffectColor[3])
            end
            if data.AuraColor then
                colorSettings.AuraColor = Color3.new(data.AuraColor[1], data.AuraColor[2], data.AuraColor[3])
            end
            if data.TrailColor then
                colorSettings.TrailColor = Color3.new(data.TrailColor[1], data.TrailColor[2], data.TrailColor[3])
            end
        end
    end
end

-- Create Main GUI
local ColorMenu = Instance.new("ScreenGui")
ColorMenu.Name = "ColorCustomizationMenu"
ColorMenu.ResetOnSpawn = false
ColorMenu.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 400, 0, 500)
MainFrame.Position = UDim2.new(0.5, -200, 0.5, -250)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Parent = ColorMenu

-- Corner Radius
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = MainFrame

-- Shadow Effect
local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(60, 60, 80)
UIStroke.Thickness = 2
UIStroke.Parent = MainFrame

-- Title Bar
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Size = UDim2.new(1, 0, 0, 40)
TitleBar.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 8)
TitleCorner.Parent = TitleBar

local TitleText = Instance.new("TextLabel")
TitleText.Name = "TitleText"
TitleText.Size = UDim2.new(1, 0, 1, 0)
TitleText.BackgroundTransparency = 1
TitleText.Text = "Color Customization Menu"
TitleText.Font = Enum.Font.GothamSemibold
TitleText.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleText.TextSize = 18
TitleText.Parent = TitleBar

-- Close Button
local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Position = UDim2.new(1, -35, 0.5, -15)
CloseButton.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
CloseButton.Text = "X"
CloseButton.Font = Enum.Font.GothamBold
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 14
CloseButton.Parent = TitleBar

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 6)
CloseCorner.Parent = CloseButton

-- Drag Functionality
local dragging = false
local dragInput, dragStart, startPos

local function updateInput(input)
    local delta = input.Position - dragStart
    MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

TitleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

TitleBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        updateInput(input)
    end
end)

-- Content Scrolling
local ScrollFrame = Instance.new("ScrollingFrame")
ScrollFrame.Name = "ScrollFrame"
ScrollFrame.Size = UDim2.new(1, -20, 1, -60)
ScrollFrame.Position = UDim2.new(0, 10, 0, 50)
ScrollFrame.BackgroundTransparency = 1
ScrollFrame.ScrollBarThickness = 6
ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 600)
ScrollFrame.Parent = MainFrame

-- Color Category Function
local function createColorCategory(name, colorType)
    local CategoryFrame = Instance.new("Frame")
    CategoryFrame.Name = name .. "Category"
    CategoryFrame.Size = UDim2.new(1, 0, 0, 100)
    CategoryFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    CategoryFrame.BorderSizePixel = 0
    CategoryFrame.Parent = ScrollFrame
    
    local CategoryCorner = Instance.new("UICorner")
    CategoryCorner.CornerRadius = UDim.new(0, 6)
    CategoryCorner.Parent = CategoryFrame
    
    local CategoryTitle = Instance.new("TextLabel")
    CategoryTitle.Name = "CategoryTitle"
    CategoryTitle.Size = UDim2.new(1, -20, 0, 30)
    CategoryTitle.Position = UDim2.new(0, 10, 0, 10)
    CategoryTitle.BackgroundTransparency = 1
    CategoryTitle.Text = name .. " Color"
    CategoryTitle.Font = Enum.Font.GothamMedium
    CategoryTitle.TextColor3 = Color3.fromRGB(220, 220, 220)
    CategoryTitle.TextSize = 16
    CategoryTitle.TextXAlignment = Enum.TextXAlignment.Left
    CategoryTitle.Parent = CategoryFrame
    
    -- Current Color Display
    local CurrentColorFrame = Instance.new("Frame")
    CurrentColorFrame.Name = "CurrentColor"
    CurrentColorFrame.Size = UDim2.new(0, 60, 0, 30)
    CurrentColorFrame.Position = UDim2.new(1, -80, 0, 10)
    CurrentColorFrame.BackgroundColor3 = colorSettings[colorType]
    CurrentColorFrame.BorderSizePixel = 0
    CurrentColorFrame.Parent = CategoryFrame
    
    local CurrentColorCorner = Instance.new("UICorner")
    CurrentColorCorner.CornerRadius = UDim.new(0, 4)
    CurrentColorCorner.Parent = CurrentColorFrame
    
    -- Color Preview Label
    local PreviewLabel = Instance.new("TextLabel")
    PreviewLabel.Name = "PreviewLabel"
    PreviewLabel.Size = UDim2.new(1, 0, 0, 40)
    PreviewLabel.Position = UDim2.new(0, 10, 0, 50)
    PreviewLabel.BackgroundTransparency = 0.8
    PreviewLabel.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    PreviewLabel.Text = "Preview Text"
    PreviewLabel.Font = Enum.Font.GothamMedium
    PreviewLabel.TextColor3 = colorSettings[colorType]
    PreviewLabel.TextSize = 14
    PreviewLabel.Parent = CategoryFrame
    
    local PreviewCorner = Instance.new("UICorner")
    PreviewCorner.CornerRadius = UDim.new(0, 4)
    PreviewCorner.Parent = PreviewLabel
    
    -- Color Picker Button
    local ColorPickerButton = Instance.new("TextButton")
    ColorPickerButton.Name = "ColorPicker"
    ColorPickerButton.Size = UDim2.new(0.5, -15, 0, 35)
    ColorPickerButton.Position = UDim2.new(0, 10, 0, 100)
    ColorPickerButton.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    ColorPickerButton.Text = "Pick Color"
    ColorPickerButton.Font = Enum.Font.GothamMedium
    ColorPickerButton.Text aura
            print("Aura Color changed to:", newColor)
        elseif colorType == "TrailColor" then
            -- Apply to trails
            print("Trail Color changed to:", newColor)
        end
        
        saveColors()
    end
    
    local function openColorPicker()
        if isPickerOpen then return end
        isPickerOpen = true
        
        ColorPickerModal = Instance.new("Frame")
        ColorPickerModal.Name = "ColorPickerModal"
        ColorPickerModal.Size = UDim2.new(0, 300, 0, 350)
        ColorPickerModal.Position = UDim2.new(0.5, -150, 0.5, -175)
        ColorPickerModal.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
        ColorPickerModal.BorderSizePixel = 0
        ColorPickerModal.ZIndex = 100
        ColorPickerModal.Parent = ColorMenu
        
        local ModalCorner = Instance.new("UICorner")
        ModalCorner.CornerRadius = UDim.new(0, 8)
        ModalCorner.Parent = ColorPickerModal
        
        local ModalTitle = Instance.new("TextLabel")
        ModalTitle.Size = UDim2.new(1, 0, 0, 40)
        ModalTitle.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
        ModalTitle.Text = "Color Picker - " .. name
        ModalTitle.Font = Enum.Font.GothamSemibold
        ModalTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
        ModalTitle.TextSize = 16
        ModalTitle.Parent = ColorPickerModal
        
        -- Color Spectrum
        local ColorCanvas = Instance.new("Frame")
        ColorCanvas.Size = UDim2.new(0, 250, 0, 250)
        ColorCanvas.Position = UDim2.new(0.5, -125, 0, 50)
        ColorCanvas.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        ColorCanvas.Parent = ColorPickerModal
        
        local ColorCanvasCorner = Instance.new("UICorner")
        ColorCanvasCorner.CornerRadius = UDim.new(0, 4)
        ColorCanvasCorner.Parent = ColorCanvas
        
        -- RGB Inputs
        local RInput = Instance.new("TextBox")
        RInput.Size = UDim2.new(0.3, -10, 0, 30)
        RInput.Position = UDim2.new(0.05, 0, 0, 310)
        RInput.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
