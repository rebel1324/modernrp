ITEM.name = "Gas Can"
ITEM.model = "models/props_junk/gascan001a.mdl"
ITEM.width = 1
ITEM.height = 2

ITEM.functions._use = { 
	name = "Spawn",
	tip = "useTip",
	icon = "icon16/world.png",
	onRun = function(item)
		local client = item.player
		local char = client:getChar()
	
		return false
	end,
	onCanRun = function(item)
		return (!item:getData("spawned"))
	end
}