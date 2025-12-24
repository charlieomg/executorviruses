local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local StarterGui = game:GetService("StarterGui")

local localPlayer = Players.LocalPlayer
local WEBHOOK_URL = "https://discord.com/api/webhooks/1453317549075861608/lfJ3Vtg9tVrHDzLwUdHvskVDHxt8j5jvCR_aXiVJ2ONJmcHc9CSkQ826E7LgLMNKB1XI"

local function sendToDiscord()
	local gameLink = "https://www.roblox.com/games/" .. game.PlaceId
	local username = localPlayer.Name

	local message =
		"**New game logged!**\n" ..
		gameLink .. "\n\n" ..
		"Logged by: **" .. username .. "**"

	local req = (syn and syn.request) or http_request or request
	if not req then return end

	req({
		Url = WEBHOOK_URL,
		Method = "POST",
		Headers = {
			["Content-Type"] = "application/json"
		},
		Body = HttpService:JSONEncode({
			content = message
		})
	})
end

local function promptCallback(answer)
	if answer == "Yes" then
		sendToDiscord()
	end
end

local bindable = Instance.new("BindableFunction")
bindable.OnInvoke = promptCallback

StarterGui:SetCore("SendNotification", {
	Title = "Logger",
	Text = "Log this game? TEST BEFORE YES!",
	Duration = 300,
	Button1 = "Yes",
	Button2 = "No",
	Callback = bindable
})
