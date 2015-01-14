local PLUGIN = PLUGIN
PLUGIN.name = "Perma Stash"
PLUGIN.author = "Black Tea"
PLUGIN.desc = "You save your stuffs in the stash."
PLUGIN.stashData = PLUGIN.stashData or {}

if (SERVER) then
	/*
		There is one big virtual inventory.
		Player has a table of stored item.
	*/

	/*
		When player requests the stash menu:
		1. Get player's stored item.
		2. Load all item data of stored item.
		3. Send all item data of stored item.
		4. Now he has, the stored item menu.
	*/

	/*
		Networking list.
		1. Sync stash items.
	*/
	local charMeta = FindMetaTable("Character")

	function charMeta:getStash()

	end

	function charMeta:stash()

	end

else
end