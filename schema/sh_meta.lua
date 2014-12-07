local CHAR = FindMetaTable("Character")
local PLAYER = FindMetaTable("Player")
local ENTITY = FindMetaTable("Entity")

function CHAR:setHandcuffed(bool)
	/*
	local client = self.client
	if (client and client:IsValid()) then
		if (bool == true) then
			client:Give("weapon_handcuffs")
		else
			client:StripWeapon("weapon_handcuffs")
		end
	end
	
	self:setData("handcuffed", bool)
	*/
end

function CHAR:isHandcuffed()
	/*
	return self:getData("handcuffed", false)
	*/
end