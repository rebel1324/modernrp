TYPE_GENERIC = 0
TYPE_SCAR = 1

ITEM.name = "Car"
ITEM.model = "models/buggy.mdl"
ITEM.width = 1
ITEM.height = 1
ITEM.maxGas = 1000
ITEM.price = 35000
ITEM.category = "Vehicles"
ITEM.physDesc = "An Object that has 4 wheels and rolls forward."
ITEM.noDrop = true
ITEM.vehicleData = {
	type = TYPE_GENERIC,
	model = "models/buggy.mdl",
	script = "scripts/vehicles/jeep_test.txt",
	name = ITEM.name,
	physDesc = ITEM.physDesc,
	maxGas = ITEM.maxGas,
}

function ITEM:getDesc()
	if (self.entity) then
		return "This is not supposed to happen."
	else
		return Format(
			[[%s
			Current Gas: %s%%]]
		, self.physDesc, math.Round(self:getData("gas", self.maxGas)/self.maxGas * 100))
	end
end

ITEM.functions._use = { 
	name = "Spawn",
	tip = "useTip",
	icon = "icon16/car_add.png",
	onRun = function(item)
		local client = item.player
		local char = client:getChar()
		local vehicle = char:getVar("curVehicle")

		-- If character's current vehicle is valid?
		if (vehicle and IsValid(vehicle)) then
			client:notify(L("vehicleExists", client))
			return false
		end
			
		-- Check if the player is outside or inside.
		local traceData = {}
		traceData.start = client:GetPos() + client:OBBCenter()
		traceData.endpos = traceData.start + Vector(0, 0, 65535)
		traceData.filter = {client}
		local trace = util.TraceLine(traceData)
		
		if (trace.HitSky == true) then
			-- Get the Vehicle Spawn position.
			traceData = {}
			traceData.start = client:GetShootPos()
			traceData.endpos = traceData.start + client:GetAimVector() * 512
			traceData.filter = client
			trace = util.TraceLine(traceData)

			local a, b = trace.HitPos + trace.HitNormal * 100, client:GetPos()
			a[3] = math.Clamp(a[3], b[3] - 16, b[3] + (item.vehicleData.type == TYPE_SCAR and 64 or 32))

			local itemTable = nut.item.list[item.uniqueID]
			local ent = NutSpawnVehicle(a, Angle(), itemTable.vehicleData, item)

			-- If the vehicle is successfully spawned
			if (ent and IsValid(ent)) then
				-- Set some initial variables for the vehicles.
				ent:setNetVar("gas", item:getData("gas", item.maxGas))
				ent:setNetVar("owner", char:getID())
				item:setData("spawned", true)
				char:setVar("curVehicle", ent, nil, client)

				if (item:getData("physDesc")) then
					ent:setNetVar("carPhysDesc", item:getData("physDesc"))
				end

				if (item.onVehicleSpawned) then
					item:onVehicleSpawned(ent, client)
				end

				hook.Run("OnPlayerSpawnedVehicle", ent, item, client)

				client:notify(L("vehicleSpawned", client))
			end
		else
			client:notify(L("notSky", client))
		end

		return false
	end,
	onCanRun = function(item)
		return (!item:getData("spawned"))
	end
}

ITEM.functions._store = { 
	name = "Store",
	tip = "useTip",
	icon = "icon16/car_delete.png",
	onRun = function(item)
		local client = item.player
		local char = client:getChar()

		if (client and char) then
			local vehicle = char:getVar("curVehicle")

			-- If character's current vehicle is valid?
			if (vehicle and IsValid(vehicle)) then
				local dist = vehicle:GetPos():Distance(client:GetPos())

				-- If player is near the vehicle.
				if (dist < 512) then
					-- Save variables of the car.
					if (vehicle:getNetVar("carPhysDesc") != item.vehicleData.physDesc) then
						item:setData("physDesc", vehicle:getNetVar("carPhysDesc"))	
					end

					item:setData("spawned", nil)
					item:setData("gas", vehicle:getNetVar("gas"))
					char:setVar("curVehicle", nil, nil, client)

					if (item.onVehicleStored) then
						item:onVehicleStored(vehicle, client)
					end

					hook.Run("OnPlayerStoredVehicle", vehicle, item, client)

					vehicle:Remove()
					client:notify(L("vehicleStored", client))
				else
					client:notify(L("vehicleCloser", client))
				end
			else
				--If vehicle is not valid, Set all item variables to zero or invalid. (For preventing exploit.)
				char:setVar("curVehicle", nil, nil, client)
				item:setData("spawned", nil)
				item:setData("gas", 0)
				client:notify(L("vehicleStoredDestroyed", client))
			end
		end

		return false
	end,
	onCanRun = function(item)
		return (item:getData("spawned") == true)
	end
}

ITEM.functions.sell = { 
	name = "Sell",
	tip = "useTip",
	icon = "icon16/bin.png",
	onRun = function(item)
		-- Sell vehicle and remove the vehicle.
		return true
	end,
	onCanRun = function(item)
		return (!item:getData("spawned"))
	end
}

-- Don't ever think about it.
function ITEM:onCanBeTransfered(oldInventory, newInventory)
	return (!newInventory or oldInventory:getID() == newInventory:getID())
end

-- Called when a new instance of this item has been made.
function ITEM:onInstanced(invID, x, y)
	self:setData("gas", self.maxGas)
end