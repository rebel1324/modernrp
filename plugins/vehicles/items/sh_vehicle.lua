ITEM.name = "Car"
ITEM.model = "models/buggy.mdl"
ITEM.width = 1
ITEM.height = 1
function ITEM:getDesc()
	return "It's vehicle mofo."
end

ITEM.functions = {}
ITEM.functions._use = { 
	name = "Spawn",
	tip = "useTip",
	icon = "icon16/world.png",
	onRun = function(item)
		local traceData = {}
		traceData.start = item.player:GetPos() + item.player:OBBCenter()
		traceData.endpos = traceData.start + Vector(0, 0, 65535 )
		traceData.filter = {item.player}
		trace = util.TraceLine(traceData)
		
		if (trace.HitSky == true) then
			local ent = NutSpawnVehicle(item.player:GetPos(), Angle(), {
				type = TYPE_GENERIC,
				model = "models/buggy.mdl",
				script = "scripts/vehicles/jeep_test.txt",
			})
			if (ent) then
				
			end
		else
			item.player:notify(L("notSky", item.player))
		end

		return false
	end,
}

ITEM.functions.sell = { 
	name = "Sell",
	tip = "useTip",
	icon = "icon16/world.png",
	onRun = function(item)
		return true
	end,
}

-- Don't ever think about it.
function ITEM:onCanBeTransfered(oldInventory, newInventory)
	return (!newInventory or oldInventory:getID() == newInventory:getID())
end
