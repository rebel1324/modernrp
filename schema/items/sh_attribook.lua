ITEM.name = "Book Base"
ITEM.model = "models/props_lab/binderblue.mdl"
ITEM.width = 1
ITEM.height = 1
ITEM.attribute = "stm"
ITEM.price = 100000
ITEM.category = "Education"
function ITEM:getDesc()
	local str
	
	if (!self.entity or !IsValid(self.entity)) then
		str = "A Magical Book.\nThis book boosts your %s."

		return Format(str, self.attribute)
	else
		local data = self.entity:getData()

		str = self.name .. ". This book boosts your %s."
		return Format(str, self.attribute)
	end
end

ITEM.functions.use = { 
	name = "Read",
	tip = "useTip",
	icon = "icon16/book.png",
	onRun = function(item)
		local attrib = item.attribute

		if (item.player and item:getData("read", false) == false) then
			if (attrib and nut.attribs.list[attrib]) then
				local char = item.player:getChar()

				char:updateAttrib(attrib, 1)
				return true
			end
		end

		return false
	end,
	onCanRun = function(item)
		local client = item.player or LocalPlayer()
		
		return (!IsValid(item.entity) and item:getData("read", false) == false)
	end
}
