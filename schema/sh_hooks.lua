-- This hook returns whether player can use bank or not.
function SCHEMA:CanUseBank(client, atmEntity)
	return true
end

-- This hook returns whether character is recognised or not.
function SCHEMA:IsCharRecognised(char, id)
	local character = nut.char.loaded[id]
	local client = character:getPlayer()
	print(client)
	if (client and character) then
		local faction = nut.faction.indices[client:Team()]

		if (faction and faction.isPublic) then
			return true
		end
	end
end