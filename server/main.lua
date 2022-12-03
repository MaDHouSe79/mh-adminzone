local QBCore = exports['qb-core']:GetCoreObject()
local zones = {}

local function sendToDiscord(title, message)
	if Config.UseWebHook then
		if Config.Webhook == "" then
			print("you have no webhook, create one on discord [https://discord.com/developers/applications] and place this in the config.lua (Config.Webhook)")
		else
			if message == nil or message == '' then return end
			LogArray = {
				{
					["color"] = "16711680",
					["title"] = "TEMPORARY ADMIN ZONE",
					["description"] = "Time: **"..os.date('%Y-%m-%d %H:%M:%S').."**",
					["fields"] = {
						{
							["name"] = "Message",
							["value"] = message
						}
					},
					["footer"] = {
						["text"] = "qb-adminzones re-edit by MaDHouSe",
						["icon_url"] = "https://icons.iconarchive.com/icons/iconarchive/red-orb-alphabet/128/Letter-M-icon.png",
					}
				}
			}
			PerformHttpRequest(Config.Webhook , function(err, text, headers) end, 'POST', json.encode({username = "Admin Zone", embeds = LogArray}), { ['Content-Type'] = 'application/json' })
		end
	end
end

QBCore.Commands.Add("setzone", Lang:t("chat.addzone"), {}, false, function(source)
	local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local zone = false
    for i, j in pairs(zones) do
        if j.license == Player.PlayerData.license then
            zone = true
        end
    end
	if not zone then
		sendToDiscord("ADD ADMIN ZONE", Player.PlayerData.charinfo.firstname .. " has set a temporary admin zone")
    	TriggerClientEvent("adminzone:getCoords", src, "setzone")
	end
end, "admin")


QBCore.Commands.Add("clearzone", Lang:t("commandTxt.clearzoneComand"), {}, false, function(source)
	local src = source
	local Player = QBCore.Functions.GetPlayer(src)
	for i, j in pairs(zones) do
		if j.license == Player.PlayerData.license then
			zones[i] = nil
		end
	end
	sendToDiscord("CLEAR ADMIN ZONE", Player.PlayerData.charinfo.firstname .. " remove the admin zone")
	TriggerClientEvent("adminzone:UpdateZones", -1, zones)
end, "admin")

AddEventHandler('playerDropped', function (reason)
	local src = source
	if QBCore.Players[src] then
		local Player = QBCore.Functions.GetPlayer(src)
		for i, j in pairs(zones) do
			if j.license == Player.PlayerData.license then
				zones[i] = nil
			end
		end
    end
end)

RegisterNetEvent('adminzone:sendCoords')
AddEventHandler('adminzone:sendCoords', function(command, coords)
	local src = source
	local Player = QBCore.Functions.GetPlayer(src)
	if IsPlayerAceAllowed(src, 'admin') or IsPlayerAceAllowed(src, 'god') or IsPlayerAceAllowed(src, 'command') then
	    if command == 'setzone' then
	        zones[#zones+1] = {license = Player.PlayerData.license, coord = coords}
		TriggerClientEvent("adminzone:UpdateZones", -1, zones)
	    end
	end
end)

RegisterNetEvent('adminzone:ServerUpdateZone')
AddEventHandler('adminzone:ServerUpdateZone', function()
	TriggerClientEvent('adminzone:UpdateZones', source, zones)
end)
