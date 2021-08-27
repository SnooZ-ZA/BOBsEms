ESX = nil
Config = {}
Config.ems = 1
local EmsConnected  = 0

Config.Teleports = {
	["Pillbox"] = { 
	["x"] = 360.23, 
	["y"] = -591.18, 
	["z"] = 42.32, 
	["h"] = 67.77, 
	}
}

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

Citizen.CreateThread(function()
    while(true) do
		oPlayer = GetPlayerPed(-1)
        InVehicle = IsPedInAnyVehicle(oPlayer, true)
		playerpos = GetEntityCoords(oPlayer)
        Citizen.Wait(500)
    end
end)

RegisterNetEvent('bobs_ems:revive')
AddEventHandler('bobs_ems:revive', function(xPlayer)
    PlayerData = xPlayer
	ESX.TriggerServerCallback('bobs_ems:ems', function(EmsConnected)
		if EmsConnected >= Config.ems then
			--exports['mythic_notify']:DoHudText('error', 'Cannot be used now.')
			ShowAdvancedNotification('CHAR_CALL911', '911 Emergency', 'EMS BOB', 'An EMS Dispatched.')
		else
			if IsEntityDead(PlayerPedId()) then
				TriggerServerEvent('bobs_ems:takemoney')
			else
				ESX.ShowNotification('You are not dead!')
			end
		end
	end)
end)

RegisterNetEvent('bobs_ems:heal')
AddEventHandler('bobs_ems:heal', function(xPlayer)
    PlayerData = xPlayer
	local ped = GetPlayerPed(-1)
	ESX.TriggerServerCallback('bobs_ems:ems', function(EmsConnected)
		if EmsConnected >= Config.ems then
			--exports['mythic_notify']:DoHudText('error', 'Cannot be used now.')
			ShowAdvancedNotification('CHAR_CALL911', '911 Emergency', 'EMS BOB', 'An EMS Dispatched.')
		else
			local health = GetEntityHealth(PlayerPedId())
			if health <= 150 then
				TriggerServerEvent('bobs_ems:takemoneyheal')
			else
				ESX.ShowNotification('You are not critical, go to hospital!')
			end
		end
	end)
end)

RegisterNetEvent('bobs_ems:success')
AddEventHandler('bobs_ems:success', function (price)
			ESX.Game.Teleport(PlayerPedId(), Config.Teleports["Pillbox"])
			ClearPedTasksImmediately(GetPlayerPed(-1))
			Citizen.Wait(3000)
		local coords = GetEntityCoords(PlayerPedId())	
			local modelped = GetHashKey('s_m_m_paramedic_01')
			RequestModel(modelped)
			while not HasModelLoaded(modelped) do
				Citizen.Wait(100)
			end
			RequestAnimDict("mini@cpr@char_a@cpr_str")
			while not HasAnimDictLoaded("mini@cpr@char_a@cpr_str") do
			Wait(1)
			end		
			pedNpc = CreatePed(5, modelped, playerpos.x, playerpos.y - 0.8, playerpos.z, 180, true, false)
			ped = pedNpc
			Citizen.Wait(3000)	
			TaskPlayAnim(ped,"mini@cpr@char_a@cpr_str","cpr_pumpchest", 8.0, 0.0, -1, 1, 0, 0, 0, 0)
				ClearPedTasks(pedNpc)
				RemoveAnimDict("mini@cpr@char_a@cpr_str")
				local revive = math.random(15000, 30000)
				--exports['mythic_notify']:DoHudText('inform', 'Hold on buddy, This might take a while.')
				ShowAdvancedNotification('CHAR_CALL911', '911 Emergency', 'EMS BOB', 'Hold on buddy, This might take a while.')
				Citizen.Wait(revive)
				TriggerEvent('esx_ambulancejob:revive', target)
					
					--exports['mythic_notify']:DoHudText('inform', 'That was  close. We almost lost you there.')
					ShowAdvancedNotification('CHAR_CALL911', '911 Emergency', 'EMS BOB', 'That was  close. We almost lost you there.')
				if pedNpc ~= nil then				
				DeleteEntity(pedNpc)
				end
end)

RegisterNetEvent('bobs_ems:successheal')
AddEventHandler('bobs_ems:successheal', function (price)
		FreezeEntityPosition(oPlayer,true)
		local coords = GetEntityCoords(PlayerPedId())	
			local modelped = GetHashKey('s_m_m_paramedic_01')
			RequestModel(modelped)
			while not HasModelLoaded(modelped) do
				Citizen.Wait(100)
			end
			RequestAnimDict("anim@heists@narcotics@funding@gang_idle")
			while not HasAnimDictLoaded("anim@heists@narcotics@funding@gang_idle") do
			Wait(1)
			end	
			
			FreezeEntityPosition(ped,true)
			pedNpc = CreatePed(5, modelped, playerpos.x, playerpos.y - 0.8, playerpos.z, 180, true, false)
			ped = pedNpc
			Citizen.Wait(3000)	
			TaskPlayAnim(ped,"anim@heists@narcotics@funding@gang_idle","gang_chatting_idle01", 8.0, 0.0, -1, 1, 0, 0, 0, 0)
				ClearPedTasks(pedNpc)
				RemoveAnimDict("anim@heists@narcotics@funding@gang_idle")
				local heal = math.random(10000, 20000)
				--exports['mythic_notify']:DoHudText('inform', 'Hold on buddy, Treating your wounds.')
				ShowAdvancedNotification('CHAR_CALL911', '911 Emergency', 'EMS BOB', 'Hold on buddy, Treating your wounds.')
				Citizen.Wait(heal)
					TriggerEvent('esx_ambulancejob:heal', 'small', true)
					--exports['mythic_notify']:DoHudText('inform', 'All patched up.')
					ShowAdvancedNotification('CHAR_CALL911', '911 Emergency', 'EMS BOB', 'All patched up. Go to hospital for futher treatment')
				
				if pedNpc ~= nil then				
				DeleteEntity(pedNpc)
				end
		FreezeEntityPosition(oPlayer,false)		
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(3000)
		streetName,_ = GetStreetNameAtCoord(playerpos.x, playerpos.y, playerpos.z)
		streetName = GetStreetNameFromHashKey(streetName)
	end
end)

function ShowAdvancedNotification(icon, sender, title, text)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(text)
    SetNotificationMessage(icon, icon, true, 4, sender, title, text)
    DrawNotification(false, true)
end

function ShowNotification(text)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(text)
    DrawNotification(false, false)
end