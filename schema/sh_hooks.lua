function SCHEMA:CanUseBank(client, atmEntity)
	if (!client or !atmEntity or IsValid(client) or IsValid(atmEntity)) then
		return false
	end

	local distance = client:GetPos():Distance(atmEntity:GetPos())

	return (distance < 128)
end

function SCHEMA:IsCharRecognised(char, id)
	-- All Public Faction should be known for all Citizens.
	-- if (faction.isPublic) then return true end

	return char:getData("rgn", ""):find(id..",")
end