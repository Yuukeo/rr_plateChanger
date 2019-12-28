ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterUsableItem("plate", function(source)
	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem("plate", 1)
	
	TriggerClientEvent("rr_platech:onChange", source)
end)



RegisterServerEvent("rr_platech:removePlate")
AddEventHandler("rr_platech:removePlate", function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	xPlayer.removeInventoryItem("plate", 1)

	print("Dette gikk fkt!")
end)


RegisterServerEvent("rr_platech:addPlate")
AddEventHandler("rr_platech:addPlate", function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local itemName = "plate"
	local itemCount = 1

	if xPlayer.canCarryItem(itemName, itemCount) then
		xPlayer.addInventoryItem(itemName, itemCount)
	else
		xPlayer.showNotification('Target player could not hold all of that.')
	end
end)