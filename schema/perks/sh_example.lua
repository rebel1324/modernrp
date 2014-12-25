PERK.name = "Example Perk"
local descText = "Die %s times"
function PERK:getDesc()
	return Format(descText, "10")
end

PERK_EXAMPLE = PERK.uniqueID