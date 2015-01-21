ITEM.name = "Gas Can"
ITEM.model = "models/props_junk/gascan001a.mdl"
ITEM.width = 1
ITEM.height = 2

ITEM:hook("use", function(item)
	item.player:EmitSound("items/battery_pickup.wav")
end)

ITEM.functions._use = { 
	name = "Use",
	tip = "useTip",
	icon = "icon16/world.png",
	onRun = function(item)
		local client = item.player
		local data = {}
			data.start = client:GetShootPos()
			data.endpos = data.start + client:GetAimVector()*96
			data.filter = client
		local trace = util.TraceLine(data)
		local ent = trace.Entity

		if (ent and IsValid(ent) and ent.spawnedVehicle) then
			local percent = 0
			ent:fillGas(300)
			percent = (ent:getNetVar("gas") / ent.maxGas)*100

			client:notify(L("vehicleGasFilled", client, percent))

			return true
		else
			client:notify(L("vehicleGasLook", client))
		end

		return false
	end,
	onCanRun = function(item)
		return (!item:getData("spawned"))
	end
}