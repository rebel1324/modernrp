-- This hook returns whether player can use bank or not.
function SCHEMA:CanUseBank(client, atmEntity)
	return true
end

-- This hook returns whether character is recognised or not.
function SCHEMA:IsCharRecognised(char, id)
	-- All Public Faction should be known for all Citizens.
	-- if (faction.isPublic) then return true end

	return char:getData("rgn", ""):find(id..",")
end