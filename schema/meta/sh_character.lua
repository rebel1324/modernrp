local CHAR = nut.meta.character

function CHAR:getReserve()
	return self:getData("reserve", 0)
end

function CHAR:addReserve(amt)
	self:setData("reserve", self:getReserve() + amt)
end

function CHAR:takeReserve(amt)
	self:addReserve(-amt)
end

function CHAR:hasReserve(amt)
	return (amt > 0 and self:getReserve() >= amt)
end