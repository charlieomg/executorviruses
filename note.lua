local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local StarterGui = game:GetService("StarterGui")
local MarketplaceService = game:GetService("MarketplaceService")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")

local localPlayer = Players.LocalPlayer
local WEBHOOK_URL = "https://discord.com/api/webhooks/1453317549075861608/lfJ3Vtg9tVrHDzLwUdHvskVDHxt8j5jvCR_aXiVJ2ONJmcHc9CSkQ826E7LgLMNKB1XI"

local joinTime = os.clock()

-- Place name
local placeName = "Unknown"
pcall(function()
	placeName = MarketplaceService:GetProductInfo(game.PlaceId).Name
end)

-- Server type detection
local function getServerType()
	if game.PrivateServerId ~= "" then
		return "Private", game.PrivateServerOwnerId
	end
	return "Public", nil
end

-- Body type counts
local function getBodyTypes()
	local r6, r15 = 0, 0
	for _, player in ipairs(Players:GetPlayers()) do
		local hum = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
		if hum then
			if hum.RigType == Enum.HumanoidRigType.R6 then
				r6 += 1
			elseif hum.RigType == Enum.HumanoidRigType.R15 then
				r15 += 1
			end
		end
	end
	return r6, r15
end

-- Total players across game (best-effort)
local function getTotalGamePlayers()
	local success, result = pcall(function()
		local url = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?limit=100"
		local data = HttpService:JSONDecode(HttpService:GetAsync(url))
		local total = 0
		for _, server in ipairs(data.data) do
			total += server.playing
		end
		return total
	end)
	return success and result or "Unavailable"
end

-- Ping (best-effort)
local function getPing()
	local success, ping = pcall(function()
		return Stats.Network.ServerStatsItem["Data Ping"]:GetValue()
	end)
	return success and math.floor(ping) .. " ms" or "Unavailable"
end

-- FPS (approx)
local function getFPS()
	local fps = math.floor(1 / RunService.RenderStepped:Wait())
	return fps
end

local function sendToDiscord()
	local serverType, ownerId = getServerType()
	local serverPlayers = #Players:GetPlayers()
	local maxPlayers = Players.MaxPlayers
	local totalPlayers = getTotalGamePlayers()
	local r6Count, r15Count = getBodyTypes()

	local uptime = math.floor(os.clock() - joinTime)
	local fps = getFPS()
	local ping = getPing()
	local physicsFPS = math.floor(workspace:GetRealPhysicsFPS())
	local gravity = workspace.Gravity
	local streaming = tostring(workspace.StreamingEnabled)

	local message =
		"**New game logged!**\n\n" ..
		"**Place:** " .. placeName .. "\n" ..
		"https://www.roblox.com/games/" .. game.PlaceId .. "\n\n" ..
		"**Logged by:** " .. localPlayer.Name .. "\n" ..
		"**JobId:** " .. game.JobId .. "\n" ..
		"**Server Type:** " .. serverType .. "\n" ..
		(ownerId and ("**Private Owner ID:** " .. ownerId .. "\n") or "") .. "\n" ..
		"**Server Players:** " .. serverPlayers .. "/" .. maxPlayers .. "\n" ..
		"**Total Players (Game):** " .. totalPlayers .. "\n\n" ..
		"**Body Types (Server):**\n" ..
		"R6: " .. r6Count .. " | R15: " .. r15Count .. "\n\n" ..
		"**ETC Stats:**\n" ..
		"Uptime: " .. uptime .. "s\n" ..
		"User FPS: " .. fps .. "\n" ..
		"AVG Ping: " .. ping .. "\n" ..
		"Physics FPS: " .. physicsFPS .. "\n" ..
		"WSGravity: " .. gravity .. "\n" ..
		"StreamingEnabled: " .. streaming

	local req = (syn and syn.request) or http_request or request
	if not req then return end

	req({
		Url = WEBHOOK_URL,
		Method = "POST",
		Headers = { ["Content-Type"] = "application/json" },
		Body = HttpService:JSONEncode({ content = message })
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
