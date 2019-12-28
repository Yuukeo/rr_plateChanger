ESX = nil

local LastVehicle = nil
local LicencePlate = {}
LicencePlate.Index = false
LicencePlate.Number = false


Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

-- This is the animation
function Animation()
    local pid = PlayerPedId()
    RequestAnimDict("mini")
    RequestAnimDict("mini@repair")
    while (not HasAnimDictLoaded("mini@repair")) do 
		Citizen.Wait(10) 
	end
    TaskPlayAnim(pid,"mini@repair","fixing_a_player",1.0,-1.0, 10000, 0, 1, true, true, true)
end


RegisterNetEvent("rr_platech:onChange")
AddEventHandler("rr_platech:onChange", function(source)
	Citizen.CreateThread(function()
		print("Du brukte et skilt")
		local PlayerPed = PlayerPedId()
        -- Client's coords
        local Coords = GetEntityCoords(PlayerPed)
        -- Closest vehicle
        local Vehicle = GetClosestVehicle(Coords.x, Coords.y, Coords.z, 3.5, 0, 70)
        -- Client's coords
        local VehicleCoords = GetEntityCoords(Vehicle)
        -- Distance between client's ped and closest vehicle
		local Distance = Vdist(VehicleCoords.x, VehicleCoords.y, VehicleCoords.z, Coords.x, Coords.y, Coords.z)
		if Distance < 3.5 and not IsPedInAnyVehicle(PlayerPed, false) then
			Animation()
		StopAnimTask(PlayerPedId(), "mini@repair", "fixing_a_player", 1.0)
		exports['mythic_progbar']:Progress({
		name = "unique_action_name",
		duration = 10000,
		label = 'Setter på falskt skilt',
		useWhileDead = true,
		canCancel = true,
		controlDisables = {
			disableMovement = true,
			disableCarMovement = true,
			disableMouse = false,
			disableCombat = true,
		}
	}, function(cancelled)
		if not cancelled then
			-- Do Something If Action Wasn't ncelled
		else
			-- Do Something If Action Was Cancelled
		end
		end)
		end
		Citizen.Wait(10000)
		SetVehicleNumberPlateText(Vehicle, "46CDH939")
	end)
	
end)




-- Command to remove plate
RegisterCommand("removeplate", function()
    -- Check if the player has plates stored
    if not LicencePlate.Index and not LicencePlate.Number then
        -- Client's ped
        local PlayerPed = PlayerPedId()
        -- Client's coords
        local Coords = GetEntityCoords(PlayerPed)
        -- Closest vehicle
        local Vehicle = GetClosestVehicle(Coords.x, Coords.y, Coords.z, 3.5, 0, 70)
        -- Client's coords
        local VehicleCoords = GetEntityCoords(Vehicle)
        -- Distance between client's ped and closest vehicle
        local Distance = Vdist(VehicleCoords.x, VehicleCoords.y, VehicleCoords.z, Coords.x, Coords.y, Coords.z)
        -- If within range and Ped is in a vehicle
        if Distance < 3.5 and not IsPedInAnyVehicle(PlayerPed, false) then
            --Saves the last vehicle
			LastVehicle = Vehicle
			-- Notification and animation
			exports['mythic_progbar']:Progress({
				name = "unique_action_name",
				duration = 10000,
				label = 'Tar av skilt',
				useWhileDead = true,
				canCancel = true,
				controlDisables = {
					disableMovement = true,
					disableCarMovement = true,
					disableMouse = false,
					disableCombat = true,
				}
			}, function(cancelled)
				if not cancelled then
					-- Do Something If Action Wasn't ncelled
				else
					-- Do Something If Action Was Cancelled
				end
			end)
            Animation()
			StopAnimTask(PlayerPedId(), "mini@repair", "fixing_a_player", 1.0)
            -- Wait 6 seconds
            Citizen.Wait(6000)
            -- Store plate index
            LicencePlate.Index = GetVehicleNumberPlateTextIndex--(Vehicle)
            -- Store plate number
            LicencePlate.Number = GetVehicleNumberPlateText--(Vehicle)
            -- Set the plate to nothing
			SetVehicleNumberPlateText(Vehicle, " ")
			TriggerServerEvent("rr_platech:addPlate")
        else
            -- Notification
			-- exports["mythic_notify"]:SendAlert("error", o --vehicle nearby.") Mythic_Notification
			TriggerEvent('esx:showNotification', '~r~ Ingen bil i nærheten.')
        end
    else
        -- Notification
		-- exports["mythic_notify"]:SendAlert("error", "You already have a licence plate on you.") Mythic_Notification
		TriggerEvent('esx:showNotification', '~r~ Du har ikke et skilt på deg.')
    end
end)

-- Command to put plate back
RegisterCommand("putplate", function()
    -- Check if the player has plates stored
    if LicencePlate.Index and LicencePlate.Number then
        -- Client's ped
        local PlayerPed = PlayerPedId()
        -- Client's coords
        local Coords = GetEntityCoords(PlayerPed)
        -- Closest vehicle
        local Vehicle = GetClosestVehicle(Coords.x, Coords.y, Coords.z, 3.5, 0, 70)
        -- Client's coords
        local VehicleCoords = GetEntityCoords(Vehicle)
        -- Distance between client's ped and closest vehicle
        local Distance = Vdist(VehicleCoords.x, VehicleCoords.y, VehicleCoords.z, Coords.x, Coords.y, Coords.z)
        -- If within range and Ped is in a vehicle
        if ( (Distance < 3.5) and not IsPedInAnyVehicle(PlayerPed, false) ) then
		if (Vehicle == LastVehicle) then
			--Cleans variable
				LastVehicle = nil
				exports['mythic_progbar']:Progress({
					name = "unique_action_name",
					duration = 10000,
					label = 'Tar av skilt',
					useWhileDead = true,
					canCancel = true,
					controlDisables = {
						disableMovement = true,
						disableCarMovement = true,
						disableMouse = false,
						disableCombat = true,
					}
				}, function(cancelled)
					if not cancelled then
						-- Do Something If Action Wasn't ncelled
					else
						-- Do Something If Action Was Cancelled
					end
				end)
				-- Notification and animation
				Animation()
				StopAnimTask(PlayerPedId(), "mini@repair", "fixing_a_player", 1.0)
			-- Wait 6 seconds
			Citizen.Wait(6000)
			-- Set plate index to stored index
			SetVehicleNumberPlateTextIndex(Vehicle, LicencePlate.Index)
			-- Set plate number to stored number
			SetVehicleNumberPlateText(Vehicle, LicencePlate.Number)
			-- Reset stored values
			LicencePlate.Index = false
			LicencePlate.Number = false
		else
			-- Notification
			-- exports["mythic_notify"]:SendAlert("error", "This plate does not belong here")
			TriggerEvent('esx:showNotification', '~r~ This plate does not belong here')
		end
        else
            -- Notification
			-- exports["mythic_notify"]:SendAlert("error", "No vehicle nearby.") Mythic_Notification
			TriggerEvent('esx:showNotification', '~r~ No vehicle nearby.')
        end
    else
        -- Notification
		-- exports["mythic_notify"]:SendAlert("error", "You already have a licence plate on you.") Mythic_Notification
		TriggerEvent('esx:showNotification', '~r~ You do not have a licence plate on you.')
    end
end)

