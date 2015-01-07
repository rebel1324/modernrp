ITEM.name = "Money Printer"
ITEM.model = "models/props_c17/consolebox01a.mdl"
ITEM.width = 2
ITEM.height = 2
ITEM.amount = 200
ITEM.printSpeed = 50
ITEM.health = 100
ITEM.price = 300
ITEM.category = "Illegal"
ITEM.desc = "A Money Printer that you can print money"

ITEM.functions.use = { 
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

		if (trace.HitPos) then
			local printer = ents.Create("nut_moneyprinter")
			printer:SetPos(trace.HitPos + trace.HitNormal * 10)
			printer:Spawn()

			hook.Run("OnMoneyPrinterSpawned", printer, item)
			return true
		end

		return false
	end,
	onCanRun = function(item)
		local client = item.player or LocalPlayer()
		
		return (!IsValid(item.entity) and !nut.faction.indices[client:Team()].isPublic)
	end
}
