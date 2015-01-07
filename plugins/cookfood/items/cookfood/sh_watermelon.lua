ITEM.name = "Watermelon"
ITEM.model = "models/props_junk/watermelon01.mdl"
ITEM.hungerAmount = 60
ITEM.cookable = false
ITEM.foodDesc = "A Pretty big Watermeon."
ITEM.quantity = 3
ITEM.width = 2
ITEM.height = 2
ITEM.price = 7

ITEM:hook("use", function(item)
	item.player:EmitSound("physics/body/body_medium_break2.wav", 90, 150)
end)