local inmenu = false
local motor = true
local prefixes = {[0]="tl",[1]="tr",[2]="bl",[3]="br"}

Citizen.CreateThread(function()
	SetNuiFocus(false, false)
	while true do
		local ped = GetPlayerPed(-1)
		if IsControlJustPressed(0, 57) and IsPedInAnyVehicle(ped,false) then
			inmenu = true
			SetNuiFocus(true, true)
		end
		if inmenu and not IsPedInAnyVehicle(ped, false) then
			inmenu = false
			SendNUIMessage({type="toggle",state=false})
			SetNuiFocus(false, false)
		end
		if inmenu then
			local veh = GetVehiclePedIsIn(ped, false)
			local data = {}
			for i=0,GetNumberOfVehicleDoors(veh)-3 do
				data[prefixes[i].."door"]=GetVehicleDoorAngleRatio(veh,i)>0.0
			end
			for i=-1,GetNumberOfVehicleDoors(veh)-4 do
				data[prefixes[i+1].."seat"]=not IsVehicleSeatFree(veh,i)
			end
			data["hood"]=GetVehicleDoorAngleRatio(veh,4)>0.0
			data["trunk"]=GetVehicleDoorAngleRatio(veh,5)>0.0
			data["lights"]=IsVehicleInteriorLightOn(veh)
			data["engine"]=GetIsVehicleEngineRunning(veh)
			SendNUIMessage({type="toggle",state=inmenu,switches=data})
		end
		Citizen.Wait(inmenu and 100 or 3)
	end
end)

RegisterNUICallback("toggle", function(data,cb)
	inmenu = data.state
	SetNuiFocus(data.state, data.state)
end)

RegisterNUICallback("btn", function(data,cb)
	local ped = GetPlayerPed(-1)
	local veh = GetVehiclePedIsIn(ped,false)
	if data.btn=="engine" then
		if motor then
			motor = false
			SetVehicleEngineOn(veh, false, false, false)
		elseif not motor then
			motor = true
			SetVehicleEngineOn(veh, true, false, false)
		end
		while (motor == false) do
			SetVehicleUndriveable(veh,true)
			Citizen.Wait(0)
		end
	elseif data.btn=="hood" then
		if GetVehicleDoorAngleRatio(veh,4)>0.0 then
			SetVehicleDoorShut(veh, 4, false)
		else
			SetVehicleDoorOpen(veh, 4, false, false)
		end
	elseif data.btn=="trunk" then
		if GetVehicleDoorAngleRatio(veh,5)>0.0 then
			SetVehicleDoorShut(veh, 5, false)
		else
			SetVehicleDoorOpen(veh, 5, false, false)
		end
	elseif data.btn=="lights" then
		SetVehicleInteriorlight(veh, not IsVehicleInteriorLightOn(veh))
	else
		for k,v in pairs(prefixes) do
			if data.btn:sub(0,2)==v then
				if data.btn:match("door") then
					if GetVehicleDoorAngleRatio(veh,k)>0.0 then
						SetVehicleDoorShut(veh,k,false)
					else
						SetVehicleDoorOpen(veh,k,false,false)
					end
				else
					SetPedIntoVehicle(ped, veh, k-1)
				end
				return
			end
		end
	end
end)