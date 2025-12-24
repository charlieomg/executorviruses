local UIS = game:GetService("UserInputService")

local parentGui = gethui and gethui() or game.Players.LocalPlayer:WaitForChild("PlayerGui")

local gui = Instance.new("ScreenGui")
gui.Name = "XenoDecalGui"
gui.ResetOnSpawn = false
gui.Parent = parentGui

local img = Instance.new("ImageButton")
img.Size = UDim2.new(0, 150, 0, 150)
img.Position = UDim2.new(0, 10, 1, -160)
img.BackgroundTransparency = 1
img.Active = true
img.Image = "rbxthumb://type=Asset&id=59414130&w=420&h=420"
img.Parent = gui

local dragging = false
local dragOffset

img.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragOffset = input.Position - img.AbsolutePosition
	end
end)

img.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = false
	end
end)

UIS.InputChanged:Connect(function(input)
	if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
		img.Position = UDim2.fromOffset(
			input.Position.X - dragOffset.X,
			input.Position.Y - dragOffset.Y
		)
	end
end)
