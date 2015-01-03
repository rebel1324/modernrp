local PLUGIN = PLUGIN
PLUGIN.name = "Vehicle: Remastered"
PLUGIN.author = "Black Tea"
PLUGIN.desc = [[Vehicle Item Plugin with pretty good compatibility.
\nFollowing vehicle mods are supported:
\nDefault Source Vehicles, SCARS]]

-- Decleared Vehicle Type.
TYPE_GENERIC = 0
TYPE_SCAR = 1
TYPE_TDM = 2

if (SERVER) then
	function PLUGIN:PlayerDisconnected()

	end

	function PLUGIN:PlayerLoadedChar()

	end

	function NutSpawnVehicle(pos, ang, spawnInfo)
		if (spawnInfo.type == TYPE_GENERIC) then
			local vehicleEnt = ents.Create("prop_vehicle_jeep")
			vehicleEnt:SetModel(spawnInfo.model)
			vehicleEnt:SetKeyValue("vehiclescript", spawnInfo.script) 
			vehicleEnt:SetPos(pos)
			vehicleEnt:Spawn()

			return vehicleEnt
		elseif (spawnInfo.type == TYPE_SCAR) then
		
		elseif (spawnInfo.type == TYPE_TDM) then

		else
			print("Tried call NutSpawnVehicle without vehicleType.")
		end

		return false
	end
end