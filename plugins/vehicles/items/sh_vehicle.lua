ITEM.name = "Car"
ITEM.model = "models/buggy.mdl"
ITEM.width = 1
ITEM.height = 1
ITEM.maxGas = 1000
ITEM.vehicleData = {
	type = TYPE_GENERIC,
	model = "models/buggy.mdl",
	script = "scripts/vehicles/jeep_test.txt",
}

function ITEM:getDesc()
	if (self.entity) then
		return "This is not supposed to happen."
	else
		return Format(
			[[A Jeep car.
			Current Gas: %s]]
		, math.Round(self:getData("gas", self.maxGas)))
	end
end

ITEM.functions = {}
ITEM.functions._use = { 
	name = "Spawn",
	tip = "useTip",
	icon = "icon16/car_add.png",
	onRun = function(item)
		local client = item.player
		local char = client:getChar()
			
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

			local a, b = trace.HitPos, client:GetPos()
			a[3] = math.Clamp(a[3], b[3] - 16, b[3] + 4)

			local ent = NutSpawnVehicle(a, Angle(), item.vehicleData)

			-- If the vehicle is successfully spawned
			if (ent) then
				-- Set some initial variables for the vehicles.
				ent:setNetVar("gas", item:getData("gas", item.maxGas))
				ent:setNetVar("owner", char:getID())
				char:setVar("curVehicle", ent, nil, client)
				item:setData("spawned", true)
				client:notify("You spawned the vehicle.")
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
					item:setData("spawned", nil)
					item:setData("gas", vehicle:getNetVar("gas"))
					char:setVar("curVehicle", nil, nil, client)
					vehicle:Remove()
					client:notify("You successfully stored your vehicle in virtual garage.")
				else
					client:notify("You need to be closer to your vehicle.")
				end
			else
				--If vehicle is not valid, Set all item variables to zero or invalid. (For preventing exploit.)
				char:setVar("curVehicle", nil, nil, client)
				item:setData("spawned", nil)
				item:setData("gas", 0)
				client:notify("Your vehicle is destoryed or removed. But stored successfully.")
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
