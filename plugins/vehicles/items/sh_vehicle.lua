ITEM.name = "Car"
ITEM.model = "models/buggy.mdl"
ITEM.width = 1
ITEM.height = 1
ITEM.maxGas = 1000
function ITEM:getDesc()
	return "It's vehicle mofo."
end

ITEM.functions = {}
ITEM.functions._use = { 
	name = "Spawn",
	tip = "useTip",
	icon = "icon16/world.png",
	onRun = function(item)
		local client = item.player
		local char = client:getChar()
			
		-- Check if the player is outside or inside.
		local traceData = {}
		traceData.start = client:GetPos() + client:OBBCenter()
		traceData.endpos = traceData.start + Vector(0, 0, 65535 )
		traceData.filter = {client}
		local trace = util.TraceLine(traceData)
		
		if (trace.HitSky == true) then
			-- Get the Vehicle Spawn position.
			traceData = {}
			traceData.start = client:GetShootPos()
			traceData.endpos = traceData.start + client:GetAimVector() * 256
			trace = util.TraceLine(traceData)

			local ent = NutSpawnVehicle(trace.HitPos, Angle(), {
				type = TYPE_GENERIC,
				model = "models/buggy.mdl",
				script = "scripts/vehicles/jeep_test.txt",
			})

			if (ent) then
				ent:setNetVar("owner", client)
				char:setVar("curVehicle", ent, nil, client)
			end
		else
			client:notify(L("notSky", client))
		end

		return false
	end,
}

ITEM.functions._use = { 
	name = "Store",
	tip = "useTip",
	icon = "icon16/world.png",
	onRun = function(item)
		local client = item.player
		local char = client:getChar()

		if (client and char) then
			local vehicle = char:getVar("curVehicle")

			-- If character's current vehicle is valid?
			if (vehicle and IsValid(vehicle)) then
				local dist = vehicle:GetPos():Distance(client:GetPos())
				if (dist < 512) then
					--item:setData("gas", vehicle:getNetVar("gas"))
					vehicle:Remove()
					char:setVar("curVehicle", nil, nil, client)
				end
			end
		end

		return false
	end,
}

ITEM.functions.sell = { 
	name = "Sell",
	tip = "useTip",
	icon = "icon16/world.png",
	onRun = function(item)
		-- Sell vehicle and remove the vehicle.
		return true
	end,
}

-- Don't ever think about it.
function ITEM:onCanBeTransfered(oldInventory, newInventory)
	return (!newInventory or oldInventory:getID() == newInventory:getID())
end

-- Called when a new instance of this item has been made.
function ITEM:onInstanced(invID, x, y)
	self:setData("gas", self.maxGas)
end
