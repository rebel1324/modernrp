local PLUGIN = PLUGIN
PLUGIN.name = "Vehicle: Remastered"
PLUGIN.author = "Black Tea"
PLUGIN.desc = [[Vehicle Item Plugin with pretty good compatibility.
\nFollowing vehicle mods are supported:
\nDefault Source Vehicles, SCARS]]

-- Vehicle Plugin Development is pending until Chessnut Fix the Vehicle Problem.

-- Decleared Vehicle Type.
TYPE_GENERIC = 0
TYPE_SCAR = 1
TYPE_TDM = 2

if (SERVER) then
	-- If player disconnects from the server, remove all the vehicles on the server.
	function PLUGIN:PlayerDisconnected(client)
		local char = client:getChar()

		-- If disconnecting player's character is valid.
		if (char) then
			local vehicle = char:getVar("curVehicle")

			-- If the vehicle is spawned and player is disconnected, deplete gas.
			for k, v in ipairs(char:getInv():getItems()) do
				if (v.vehicleData) then
					if (v:getData("spawned")) then
						v:setData("spawned", nil)
						v:setData("gas", 0)
					end
				end
			end

			-- and remove vehicle safe.
			if (vehicle and IsValid(vehicle)) then
				vehicle:Remove()
			end
		end
	end

	-- If player changes the char, remove all the vehicles on the server.
	function PLUGIN:PlayerLoadedChar(client, curChar, prevChar)
		-- If player is changing the char and the character ID is differs from the current char ID.
		if (prevChar and curChar:getID() != prevChar:getID()) then
			local vehicle = curChar:getVar("curVehicle")

			-- If the vehicle is spawned and player is disconnected, deplete gas.
			for k, v in ipairs(curChar:getInv():getItems()) do
				if (v.vehicleData) then
					if (v:getData("spawned")) then
						v:setData("spawned", nil)
						v:setData("gas",  0)
					end
				end
			end

			-- and remove vehicle safe.
			if (vehicle and IsValid(vehicle)) then
				vehicle:Remove()
			end
		end
	end

	-- Spawn the vehicle with certain format.
	function NutSpawnVehicle(pos, ang, spawnInfo)
		if (spawnInfo.type == TYPE_GENERIC) then
			local solid, entIndex, color, physObj
			local vehicleEnt = ents.Create("prop_vehicle_jeep")

			vehicleEnt:SetModel(spawnInfo.model)
			vehicleEnt:SetKeyValue("vehiclescript", spawnInfo.script) 
			vehicleEnt:SetPos(pos)
			vehicleEnt:Spawn()
			vehicleEnt.preSpawn = true
			vehicleEnt:SetRenderMode(1)
			vehicleEnt:SetColor(spawnInfo.color or color_white)
			
			return vehicleEnt
		elseif (spawnInfo.type == TYPE_SCAR) then
			local vehicleEnt  = ents.Create("prop_vehicle_jeep")
			vehicleEnt:SetModel(spawnInfo.model)
			vehicleEnt:SetKeyValue("vehiclescript", spawnInfo.script) 
			vehicleEnt:SetPos(pos)
			vehicleEnt:Spawn()
			
			return vehicleEnt
		elseif (spawnInfo.type == TYPE_TDM) then
			
		else
			print("Tried call NutSpawnVehicle without vehicleType.")
		end

		return false
	end

	-- Calculate fuel.
	/*
		function PLUGIN:Think()
			for k, v in ipairs(player.GetAll()) do

			end
		end
	*/
end

function PLUGIN:VehicleMove(client, vehicle, moveData)
	if (client and client:getChar() and vehicle) then
		local gas = vehicle:getNetVar("gas")

		if (gas and gas <= 0) then
			moveData:SetForwardSpeed(0)
			moveData:SetSideSpeed(0)
		end
	end
end