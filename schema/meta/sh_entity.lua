local ENTITY = FindMetaTable("Entity")

function ENTITY:isBank()
	return (self:GetClass() == "nut_atm")
end