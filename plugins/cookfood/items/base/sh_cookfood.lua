ITEM.name = "Food Base"
ITEM.model = "models/props_junk/garbage_takeoutcarton001a.mdl"
ITEM.width = 1
ITEM.height = 1
ITEM.isFood = true
ITEM.cookable = true
ITEM.hungerAmount = 30
ITEM.foodDesc = "This is test food."
ITEM.category = "Consumeable"
ITEM.mustCooked = false
ITEM.quantity = 1

function ITEM:getDesc()
	local str = self.foodDesc

	if (self.mustCooked != false) then
		str = str .. "\nThis food must be cooked."
	end

	if (self.cookable != false) then
		str = str .. "\nFood Status: %s"
	end

	return Format(str, COOKLEVEL[(self:getData("cooked") or 1)][1])
end

if (CLIENT) then
	function ITEM:paintOver(item, w, h)
		local cooked = item:getData("cooked", 1)
		local quantity = item:getData("quantity", item.quantity)

		if (quantity > 1) then
			draw.SimpleText(quantity, "DermaDefault", 3, h - 3, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, color_black)
		end

		if (cooked > 1) then
			local col = COOKLEVEL[cooked][3]

			surface.SetDrawColor(col.r, col.g, col.b, 100)
			surface.DrawRect(w - 14, h - 14, 8, 8)
		end
	end
end

ITEM:hook("use", function(item)
	item.player:EmitSound("items/battery_pickup.wav")
end)

ITEM.functions.use = {
	name = "Eat",
	tip = "useTip",
	icon = "icon16/world.png",
	onRun = function(item)
		local cooked = item:getData("cooked", 1)
		local quantity = item:getData("quantity", item.quantity)
		local mul = COOKLEVEL[cooked][2]

		item.player:addHunger(item.hungerAmount * mul) 
		quantity = quantity - 1
		
		if (quantity >= 1) then
			item:setData("quantity", quantity)

			return false
		end

		return true
	end,
	onCanRun = function(item)
		if (item.mustCooked and item:getData("cooked", 1) == 1) then
			return false
		end

		return (!IsValid(item.entity))
	end
}