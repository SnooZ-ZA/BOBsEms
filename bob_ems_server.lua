ESX = nil
Config = {}
Config.price = 250

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

function CountEms()
	local xPlayers = ESX.GetPlayers()
	EmsConnected = 0
	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		if xPlayer.job.name == 'ambulance' then
			EmsConnected = EmsConnected + 1
		end
	end
	SetTimeout(120 * 1000, CountEms)
end

CountEms()

ESX.RegisterServerCallback('bobs_ems:ems', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)

	cb(EmsConnected)
end)

--[[TriggerEvent('es:addCommand', 'ems', function(source)
    TriggerClientEvent('bobs_ems:revive', source)
end)

TriggerEvent('es:addCommand', 'bandage', function(source)
    TriggerClientEvent('bobs_ems:heal', source)
end)]]--


RegisterCommand("ems", function(source, args, rawCommand)
     TriggerClientEvent('bobs_ems:revive', source)
end)

RegisterCommand("bandage", function(source, args, rawCommand)
    TriggerClientEvent('bobs_ems:heal', source)
end)

RegisterServerEvent('bobs_ems:takemoney')
AddEventHandler('bobs_ems:takemoney', function ()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	if(xPlayer.getMoney() >= Config.price) then
		xPlayer.removeMoney(Config.price)
		TriggerClientEvent('bobs_ems:success', source)
		--TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'success', text = 'You paid $ 250 for medical services.' })
		TriggerClientEvent('esx:showNotification', _source, "You paid $ 250 for medical services.")	
	else
		--TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = 'You dont have enough money.' })
		TriggerClientEvent('esx:showNotification', _source, "~r~You dont have enough money.")
	end
end)

RegisterServerEvent('bobs_ems:takemoneyheal')
AddEventHandler('bobs_ems:takemoneyheal', function ()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	if(xPlayer.getMoney() >= Config.price) then
		xPlayer.removeMoney(Config.price)
		TriggerClientEvent('bobs_ems:successheal', source)
		--TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'success', text = 'You paid $ 250 for medical services.' })
		TriggerClientEvent('esx:showNotification', _source, "You paid $ 250 for medical services.")	
	else
		--TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = 'You dont have enough money.' })
		TriggerClientEvent('esx:showNotification', _source, "~r~You dont have enough money.")
	end
end)



