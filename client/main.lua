local QBCore = exports['qb-core']:GetCoreObject()
local blip = nil
local radiusBlip = nil
local inZone = nil                                                                     
local zones = {}
local ChangedRecently = false

AddEventHandler("adminzone:inZone", function (coords)
	inZone = coords
	RemoveBlip(blip)
	RemoveBlip(radiusBlip)
	blip = AddBlipForCoord(coords.x, coords.y, coords.z)
	radiusBlip = AddBlipForRadius(coords.x, coords.y, coords.z, Config.blipRadius)
	SetBlipSprite(blip, 487)
	SetBlipAsShortRange(blip, true)
	SetBlipColour(blip, Config.blipColor)
	SetBlipScale(blip, 1.0)
	AddTextEntry("adminzoneblip", Config.blipName)
	BeginTextCommandSetBlipName('adminzoneblip')
	EndTextCommandSetBlipName(blip)
	SetBlipAlpha(radiusBlip, 80)
	SetBlipColour(radiusBlip, Config.blipColor)
	Citizen.CreateThread(function()
		while inZone ~= nil do 
			Citizen.Wait(0)
			SetTextFont(0)
			SetTextCentre(true)
			SetTextProportional(1)
			SetTextScale(0.3, 0.3)
			SetTextColour(128, 128, 128, 255)
			SetTextDropshadow(0, 0, 0, 0, 255)
			SetTextEdge(1, 0, 0, 0, 255)
			SetTextDropShadow()
			SetTextOutline()
			AddTextEntry("adminzonenotif", Lang:t('zone.notification'))
			SetTextEntry("adminzonenotif")
			DrawText(Config.notificationLocx, Config.notificationLocy)
			if Config.disableViolence then
				SetPlayerCanDoDriveBy(PlayerPedId(), false)
				DisablePlayerFiring(PlayerPedId(), true)
				DisableControlAction(0, 140) -- Melee R
			end
			local veh = GetVehiclePedIsIn(PlayerPedId())
			if GetPedInVehicleSeat(veh, -1) == PlayerPedId() then
				if math.ceil(GetEntitySpeed(veh) * 2.23) > Config.maxSpeed then	
				end
			end
		end
		SetPlayerCanDoDriveBy(PlayerPedId(), true)
		DisablePlayerFiring(PlayerPedId(), false)
	end)
end)

function exitZone()
    RemoveBlip(blip)
    RemoveBlip(radiusBlip)
    ShowNotif(Lang:t('zone.exit'))
	inZone = nil
end

function ShowNotif(text)
	QBCore.Functions.Notify(text, 'primary')
end

function ZoneAdded()
	Citizen.CreateThread(function () 
		if #zones < 2 then
			while #zones > 0 do
				 for k,v in pairs(zones) do
					if GetDistanceBetweenCoords(v.coord, GetEntityCoords(PlayerPedId())) <= 100 then
						if inZone == nil then
							TriggerEvent('adminzone:inZone', v.coord)
							break
						end
					else
						if inZone == v.coord then
							exitZone()
							break
						end
					end
				end
				Citizen.Wait(100)
			end
			if inZone ~= nil then
			    RemoveBlip(blip)
				RemoveBlip(radiusBlip)
				ShowNotif(Lang:t('zone.clear'))
				inZone = nil
			end
		end
	end)
end

RegisterNetEvent('adminzone:UpdateZones')
AddEventHandler("adminzone:UpdateZones", function(zoneTable)
	zones = zoneTable
	ZoneAdded()
end)

RegisterNetEvent('adminzone:getCoords')
AddEventHandler("adminzone:getCoords", function(command)
	TriggerServerEvent('adminzone:sendCoords', command, GetEntityCoords(PlayerPedId()))
end)
    
RegisterNetEvent('QBCore:Client:OnPlayerLoaded')
AddEventHandler('QBCore:Client:OnPlayerLoaded', function(xPlayer)
	TriggerServerEvent('adminzone:ServerUpdateZone')
end)

Citizen.CreateThread(function()
	while true do
		if IsPedInAnyVehicle(PlayerPedId(),false) then
			local MaxSpeed = 250.0
			local NeedToChange = false
			local coords = GetEntityCoords(PlayerPedId(),true)
			for _,v in pairs(zones) do
				if #(coords - v.coord) < 100.0 then
					NeedToChange = true
					MaxSpeed = Config.maxSpeed / 3.6
				end
			end	
			if NeedToChange then
				SetEntityMaxSpeed(GetVehiclePedIsIn(PlayerPedId(), false),MaxSpeed)
				ChangedRecently = true
			elseif NeedToChange and ChangedRecently then 
				NotifyText(MaxSpeed)
			elseif ChangedRecently then 
				ChangedRecently = false
				SetEntityMaxSpeed(GetVehiclePedIsIn(PlayerPedId(), false), MaxSpeed)
			end
			if inZone == nil then
				SetEntityMaxSpeed(GetVehiclePedIsIn(PlayerPedId(), false), 250.0) 
			end
		end
		Wait(500)
	 end
end)

local function round(num, numDecimalPlaces)
    return tonumber(string.format("%." .. (numDecimalPlaces or 0) .. "f", num))
end

function NotifyText(speed)
	SetNotificationTextEntry('STRING')
	AddTextComponentString(Lang:t("notify.enter", {speed = tostring(round(speed, 2))}))
	DrawNotification(0,1)
end
