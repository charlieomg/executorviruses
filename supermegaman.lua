local allowedUsers = {
    DougTest0 = true,
    puff_948 = true
}

local player = game.Players.LocalPlayer
if not allowedUsers[player.Name] then return end

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local executeModuleEvent = ReplicatedStorage:FindFirstChild("ExecuteModule")
if not executeModuleEvent then
    executeModuleEvent = Instance.new("RemoteEvent")
    executeModuleEvent.Name = "ExecuteModule"
    executeModuleEvent.Parent = ReplicatedStorage
end

local UserInputService = game:GetService("UserInputService")

-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "SuperAdminPanelGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

-- Main Frame
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 300, 0, 180)
mainFrame.Position = UDim2.new(0.5, -150, 0.5, -90)
mainFrame.BackgroundColor3 = Color3.fromRGB(0,0,0)
mainFrame.BorderColor3 = Color3.fromRGB(255,255,255)
mainFrame.BorderSizePixel = 2
mainFrame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = mainFrame

-- Title Label
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -20, 0, 40)
title.Position = UDim2.new(0, 10, 0, 10)
title.BackgroundTransparency = 1
title.Text = "SSHub"
title.TextColor3 = Color3.fromRGB(255,255,255)
title.Font = Enum.Font.GothamBold
title.TextScaled = true
title.Parent = mainFrame

-- TextBox with working placeholder
local textBox = Instance.new("TextBox")
textBox.Size = UDim2.new(1, -40, 0, 40)
textBox.Position = UDim2.new(0, 20, 0, 60)
textBox.Text = ""
textBox.PlaceholderText = "Enter ModuleScript ID"
textBox.ClearTextOnFocus = false
textBox.BackgroundColor3 = Color3.fromRGB(0,0,0)
textBox.BorderColor3 = Color3.fromRGB(255,255,255)
textBox.BorderSizePixel = 2
textBox.TextColor3 = Color3.fromRGB(255,255,255)
textBox.Font = Enum.Font.Gotham
textBox.TextScaled = false
textBox.TextSize = 20
textBox.Parent = mainFrame

local textBoxCorner = Instance.new("UICorner")
textBoxCorner.CornerRadius = UDim.new(0, 6)
textBoxCorner.Parent = textBox

-- Run Button
local runButton = Instance.new("TextButton")
runButton.Size = UDim2.new(1, -40, 0, 40)
runButton.Position = UDim2.new(0, 20, 0, 115)
runButton.Text = "Run"
runButton.BackgroundColor3 = Color3.fromRGB(255,255,255)
runButton.BorderColor3 = Color3.fromRGB(255,255,255)
runButton.TextColor3 = Color3.fromRGB(0,0,0)
runButton.Font = Enum.Font.GothamBold
runButton.TextScaled = true
runButton.Parent = mainFrame

local buttonCorner = Instance.new("UICorner")
buttonCorner.CornerRadius = UDim.new(0, 6)
buttonCorner.Parent = runButton

-- Run button functionality
runButton.MouseButton1Click:Connect(function()
    local moduleId = tonumber(textBox.Text)
    if moduleId then
        executeModuleEvent:FireServer(moduleId)
    else
        warn("Invalid Module ID")
    end
end)

-- Make GUI draggable
local dragging
local dragInput
local dragStart
local startPos

local function update(input)
    local delta = input.Position - dragStart
    mainFrame.Position = UDim2.new(
        startPos.X.Scale,
        startPos.X.Offset + delta.X,
        startPos.Y.Scale,
        startPos.Y.Offset + delta.Y
    )
end

mainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or
       input.UserInputType == Enum.UserInputType.Touch then
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

mainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or
       input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)
