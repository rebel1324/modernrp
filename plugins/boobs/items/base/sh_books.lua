ITEM.name = "Book"
ITEM.model = "models/props_lab/binderblue.mdl"
ITEM.width = 1
ITEM.height = 1
ITEM.desc = "This is something you can write a doodle on."
ITEM.price = 100

ITEM.isURL = false
ITEM.content = [[]]

// On player uneqipped the item, Removes a weapon from the player and keep the ammo in the item.
ITEM.functions.use = { -- sorry, for name order.
	name = "Use",
	tip = "useTip",
	icon = "icon16/world.png",
	onRun = function(item)
		if (item.player and IsValid(item.player)) then
			netstream.Start(item.player, "readBook", item.uniqueID)
		end

		return false
	end,
}
